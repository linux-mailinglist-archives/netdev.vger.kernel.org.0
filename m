Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B254B63B0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiBOGjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:39:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBOGjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:39:06 -0500
Received: from out199-17.us.a.mail.aliyun.com (out199-17.us.a.mail.aliyun.com [47.90.199.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B901AF1F6;
        Mon, 14 Feb 2022 22:38:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4X5tnu_1644907131;
Received: from 30.225.139.251(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V4X5tnu_1644907131)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 14:38:52 +0800
Message-ID: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
Date:   Tue, 15 Feb 2022 14:38:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Heyi Guo <guoheyi@linux.alibaba.com>
Subject: [Issue report] drivers/ftgmac100: DHCP occasionally fails during boot
 up or link down/up
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We are using Aspeed 2600 and found DHCP occasionally fails during boot 
up or link down/up. The DHCP client is systemd 247.6 networkd. Our 
network device is 2600 MAC4 connected to a RGMII PHY module.

Current investigation shows the first DHCP discovery packet sent by 
systemd-networkd might be corrupted, and sysmtemd-networkd will continue 
to send DHCP discovery packets with the same XID, but no other packets, 
as there is no IP obtained at the moment. However the server side will 
not respond with this serial of DHCP requests, until it receives some 
other packets. This situation can be recovered by another link down/up, 
or a "ping -I eth0 xxx.xxx.xxx.xxx" command to insert some other TX packets.

Navigating the driver code ftgmac.c, I've some question about the work 
flow from link down to link up. I think the flow is as below:

1. ftgmac100_open() will enable net interface with ftgmac100_init_all(), 
and then call phy_start()

2. When PHY is link up, it will call netif_carrier_on() and then 
adjust_link interface, which is ftgmac100_adjust_link() for ftgmac100

3. In ftgmac100_adjust_link(), it will schedule the reset work 
(ftgmac100_reset_task)

4. ftgmac100_reset_task() will then reset the MAC

I found networkd will start to send DHCP request immediately after 
netif_carrier_on() called in step 2, but step 4 will reset the MAC, 
which may potentially corrupt the sending packet.

Is there anything wrong in this flow? Or do I miss something?

Thanks,

Heyi

