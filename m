Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB8D4DA994
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240988AbiCPFSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbiCPFSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:18:13 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C15F5BE5C
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:16:56 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef39.dynamic.kabel-deutschland.de [95.90.239.57])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2978861EA1928;
        Wed, 16 Mar 2022 06:16:53 +0100 (CET)
Message-ID: <db796473-69cf-122e-ec40-de62659517b0@molgen.mpg.de>
Date:   Wed, 16 Mar 2022 06:16:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: bnx2x: ppc64le: Unable to set message level greater than 0x7fff
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <0497a560-8c7b-7cf8-84ee-bde1470ae360@molgen.mpg.de>
 <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220315183529.255f2795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,


Am 16.03.22 um 02:35 schrieb Jakub Kicinski:
> On Tue, 15 Mar 2022 22:58:57 +0100 Paul Menzel wrote:
>> On the POWER8 server IBM S822LC (ppc64le), I am unable to set the
>> message level for the network device to 0x0100000 but it fails.
>>
>>       $ sudo ethtool -s enP1p1s0f2 msglvl 0x0100000
>>       netlink error: cannot modify bits past kernel bitset size (offset 56)
>>       netlink error: Invalid argument
>>
>> Below is more information. 0x7fff is the largest value I am able to set.
>>
>> ```
>> $ sudo ethtool -i enP1p1s0f2
>> driver: bnx2x
>> version: 5.17.0-rc7+
>> firmware-version: bc 7.10.4
>> expansion-rom-version:
>> bus-info: 0001:01:00.2
>> supports-statistics: yes
>> supports-test: yes
>> supports-eeprom-access: yes
>> supports-register-dump: yes
>> supports-priv-flags: yes
>> $ sudo ethtool -s enP1p1s0f2 msglvl 0x7fff
>> $ sudo ethtool enP1p1s0f2
>> Settings for enP1p1s0f2:
>>           Supported ports: [ TP ]
>>           Supported link modes:   10baseT/Half 10baseT/Full
>>                                   100baseT/Half 100baseT/Full
>>                                   1000baseT/Full
>>           Supported pause frame use: Symmetric Receive-only
>>           Supports auto-negotiation: Yes
>>           Supported FEC modes: Not reported
>>           Advertised link modes:  10baseT/Half 10baseT/Full
>>                                   100baseT/Half 100baseT/Full
>>                                   1000baseT/Full
>>           Advertised pause frame use: Symmetric Receive-only
>>           Advertised auto-negotiation: Yes
>>           Advertised FEC modes: Not reported
>>           Speed: Unknown!
>>           Duplex: Unknown! (255)
>>           Auto-negotiation: on
>>           Port: Twisted Pair
>>           PHYAD: 17
>>           Transceiver: internal
>>           MDI-X: Unknown
>>           Supports Wake-on: g
>>           Wake-on: d
>>           Current message level: 0x00007fff (32767)
>>                                  drv probe link timer ifdown ifup rx_err tx_err tx_queued intr tx_done rx_status pktdata hw wol
>>           Link detected: no
>> $ sudo ethtool -s enP1p1s0f2 msglvl 0x8000
>> netlink error: cannot modify bits past kernel bitset size (offset 56)
>> netlink error: Invalid argument
>> ```
> 
> The new ethtool-over-netlink API limits the msg levels to the ones
> officially defined by the kernel (NETIF_MSG_CLASS_COUNT).
> 
> CC: Michal

Thank you for the prompt reply. So, it’s unrelated to the architecture, 
and to the Linux kernel version, as it works on x86_64 with Linux 5.10.x.

Michal, how do I turn on certain bnx2x messages?

     $ git grep BNX2X_MSG_SP drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
     drivers/net/ethernet/broadcom/bnx2x/bnx2x.h:#define BNX2X_MSG_SP 
                      0x0100000 /* was: NETIF_MSG_INTR */


Kind regards,

Paul
