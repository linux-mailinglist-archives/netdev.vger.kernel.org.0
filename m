Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC404BEFE5
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiBVDJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:09:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiBVDJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:09:39 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FBAB851;
        Mon, 21 Feb 2022 19:09:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5AaMP-_1645499350;
Received: from 30.225.140.29(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5AaMP-_1645499350)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Feb 2022 11:09:11 +0800
Message-ID: <51f5b7a7-330f-6b3c-253d-10e45cdb6805@linux.alibaba.com>
Date:   Tue, 22 Feb 2022 11:09:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [Issue report] drivers/ftgmac100: DHCP occasionally fails during
 boot up or link down/up
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
 <YgwSAjGN2eWUpamo@lunn.ch>
 <4964f8c3-8349-4fad-e176-8c26840d1a08@linux.alibaba.com>
 <YhE2wl7XcTUQvEd4@lunn.ch>
 <1a7e74b4-8827-c14b-7371-9656a643d03c@linux.alibaba.com>
 <YhQNkQDwqUag1UmA@lunn.ch>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <YhQNkQDwqUag1UmA@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your advice. Let me take a try again :)

Heyi

在 2022/2/22 上午6:09, Andrew Lunn 写道:
>> [   16.872475]  Possible unsafe locking scenario:
>> [   16.872475]
>> [   16.872478]        CPU0                    CPU1
>> [   16.872482]        ----                    ----
>> [   16.872485]   lock(&dev->lock);
>> [   16.872495]                                lock(rtnl_mutex);
>> [   16.872505] lock(&dev->lock);
> It looks like the whitespace got messed up here, and it should
> actually be:
>> [   16.872505]                                lock(&dev->lock);
>> [   16.872513]   lock(rtnl_mutex);
> So if up calls open() which first takes rtnl and then the
> phydev->lock.
>
> adjust link is called with phydev->lock already held and it then takes
> the rtnl. Deadlock.
>
> During the adjust_list callback, the phydev lock is held so the
> contents of phydev are consistent. What you could do is make a copy of
> what you need and then release phydev lock. You can then take rtnl and
> do the reset. Once the reset is finished, program MAC with the copy
> you took from phydev. Then lock phydev again, and return.
>
>      Andrew
