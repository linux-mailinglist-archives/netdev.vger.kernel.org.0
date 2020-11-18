Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436732B75E2
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgKRFWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:22:37 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:10201 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgKRFWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:22:37 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfFvM-000Pvy-Tr; Wed, 18 Nov 2020 06:22:32 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfFvM-000TPg-7R; Wed, 18 Nov 2020 06:22:32 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E1322240041;
        Wed, 18 Nov 2020 06:22:31 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 8009F240040;
        Wed, 18 Nov 2020 06:22:31 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 25B0E204F6;
        Wed, 18 Nov 2020 06:22:31 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 06:22:31 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/tun: Call netdev notifiers
Organization: TDT AG
In-Reply-To: <20201117163245.4ff522ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201116104121.20884-1-ms@dev.tdt.de>
 <20201117163245.4ff522ef@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <dcb57be8465c1aa21b21b8478290999f@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1605676952-000035B9-463974AD/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 01:32, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 11:41:21 +0100 Martin Schiller wrote:
>> Call netdev notifiers before and after changing the device type.
>> 
>> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
>> ---
>> 
>> Change from v2:
>> use subject_prefix 'net-next' to fix 'fixes_present' issue
>> 
>> Change from v1:
>> fix 'subject_prefix' and 'checkpatch' warnings
>> 
>> ---
>>  drivers/net/tun.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 3d45d56172cb..2d9a00f41023 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -3071,9 +3071,13 @@ static long __tun_chr_ioctl(struct file *file, 
>> unsigned int cmd,
>>  				   "Linktype set failed because interface is up\n");
>>  			ret = -EBUSY;
>>  		} else {
>> +			call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
>> +						 tun->dev);
> 
> This call may return an error (which has to be unpacked with
> notifier_to_errno()).

OK, I'll fix that and send a v3 patch.

> 
>>  			tun->dev->type = (int) arg;
>>  			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
>>  				   tun->dev->type);
>> +			call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE,
>> +						 tun->dev);
>>  			ret = 0;
>>  		}
>>  		break;
