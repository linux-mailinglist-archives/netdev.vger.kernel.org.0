Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33F84C1185
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbiBWLk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240059AbiBWLkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:40:53 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0292E9680E;
        Wed, 23 Feb 2022 03:40:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V5JES-R_1645616419;
Received: from 30.225.139.254(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5JES-R_1645616419)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 19:40:19 +0800
Message-ID: <f2223288-ef86-1712-6b24-087d7e741b8b@linux.alibaba.com>
Date:   Wed, 23 Feb 2022 19:40:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
 <YhYQ6jGQv39rSsDU@lunn.ch>
From:   Heyi Guo <guoheyi@linux.alibaba.com>
In-Reply-To: <YhYQ6jGQv39rSsDU@lunn.ch>
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


在 2022/2/23 下午6:48, Andrew Lunn 写道:
>> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
>> index c1deb6e5d26c5..d5356db7539a4 100644
>> --- a/drivers/net/ethernet/faraday/ftgmac100.c
>> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
>> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>>   	/* Disable all interrupts */
>>   	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>>   
>> -	/* Reset the adapter asynchronously */
>> -	schedule_work(&priv->reset_task);
>> +	/* Release phy lock to allow ftgmac100_reset to aquire it, keeping lock
>> +	 * order consistent to prevent dead lock.
>> +	 */
>> +	if (netdev->phydev)
>> +		mutex_unlock(&netdev->phydev->lock);
> No need to do this test. The fact that adjust_link is being called
> indicates there must be a PHY.

OK, will remove the check in v2.

Thanks,

Heyi

>
>      Andrew
