Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC774C117A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiBWLkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiBWLkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:40:14 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FDC93192;
        Wed, 23 Feb 2022 03:39:45 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5JJLMD_1645616380;
Received: from 30.225.139.254(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5JJLMD_1645616380)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 19:39:41 +0800
Message-ID: <5cdf5d09-9b32-ec98-cbd1-c05365ec01fa@linux.alibaba.com>
Date:   Wed, 23 Feb 2022 19:39:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
 <1675a52d-a270-d768-5ccc-35b1e82e56d2@gmail.com>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <1675a52d-a270-d768-5ccc-35b1e82e56d2@gmail.com>
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

Hi Florian,

在 2022/2/23 下午1:00, Florian Fainelli 写道:
>
>
> On 2/22/2022 7:14 PM, Heyi Guo wrote:
>> DHCP failures were observed with systemd 247.6. The issue could be
>> reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
>> down/up.
>>
>> It is caused by below procedures in the driver:
>>
>> 1. ftgmac100_open() enables net interface and call phy_start()
>> 2. When PHY is link up, it calls netif_carrier_on() and then
>> adjust_link callback
>> 3. ftgmac100_adjust_link() will schedule the reset task
>> 4. ftgmac100_reset_task() will then reset the MAC in another schedule
>>
>> After step 2, systemd will be notified to send DHCP discover packet,
>> while the packet might be corrupted by MAC reset operation in step 4.
>>
>> Call ftgmac100_reset() directly instead of scheduling task to fix the
>> issue.
>>
>> Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
>> ---
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Joel Stanley <joel@jms.id.au>
>> Cc: Guangbin Huang <huangguangbin2@huawei.com>
>> Cc: Hao Chen <chenhao288@hisilicon.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Dylan Hung <dylan_hung@aspeedtech.com>
>> Cc: netdev@vger.kernel.org
>>
>>
>> ---
>>   drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c 
>> b/drivers/net/ethernet/faraday/ftgmac100.c
>> index c1deb6e5d26c5..d5356db7539a4 100644
>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct 
>> net_device *netdev)
>>       /* Disable all interrupts */
>>       iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>>   -    /* Reset the adapter asynchronously */
>> -    schedule_work(&priv->reset_task);
>> +    /* Release phy lock to allow ftgmac100_reset to aquire it, 
>> keeping lock
>
> typo: acquire
>
Thanks for the catch :)
>> +     * order consistent to prevent dead lock.
>> +     */
>> +    if (netdev->phydev)
>> +        mutex_unlock(&netdev->phydev->lock);
>> +
>> +    ftgmac100_reset(priv);
>> +
>> +    if (netdev->phydev)
>> +        mutex_lock(&netdev->phydev->lock);
>
> Do you really need to perform a full MAC reset whenever the link goes 
> up or down? Instead cannot you just extract the maccr configuration 
> which adjusts the speed and be done with it?

This is the original behavior and not changed in this patch set, and I'm 
not familiar with the hardware design of ftgmac100, so I'd like to limit 
the changes to the code which really causes practical issues.

Thanks,

Heyi

>
> What kind of Ethernet MAC design is this seriously.
