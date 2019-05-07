Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9326F161FF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEGKbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 06:31:50 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:41418 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbfEGKbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 06:31:49 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 06:31:48 EDT
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id C114020318;
        Tue,  7 May 2019 12:23:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1557224586; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X50mZEtUkHu4nljd78CE48MvDSsDCx/W93Ql/G26gDU=;
        b=GYtjTSvDK62O2hrHSDE8J7WErMELUFgL3GCh4rG1v6eUG8wO7kGt+JTDrPBq4nkZuVp8cv
        Afjho3CWCppoZdGchhQbetX4AAOseIHV8tpDmutdULDdGkaTZl6sm99MKnnmz+8bSCIVG7
        90Jiu3JjyCnXcrmMurOdEDQkcnRhNKU346CN+ReEDTeDmFCtvvA/9x7+xfttW3jIb+rkRq
        XByeiu5rA3NDKK50tOM8zS9kHDEB/QQRA0mzEapNy/utdw9cDE50u2SeI/r1tJ4EOXzDuv
        w2mdWayA1JW0460n2oRff20hV0DfrdJf/OwQI82yBxMxN8dUbYMulE7SVq9A3Q==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id 3299BBEEBD;
        Tue,  7 May 2019 12:23:05 +0200 (CEST)
Message-ID: <5CD15C87.3040006@bfs.de>
Date:   Tue, 07 May 2019 12:23:03 +0200
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Colin Ian King <colin.king@canonical.com>
CC:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: fix comparisons against uninitialized
 status fields
References: <20190507084458.22520-1-colin.king@canonical.com> <20190507092012.GL2269@kadam> <a8931feb-c11a-3833-0a14-2585e70c9114@canonical.com>
In-Reply-To: <a8931feb-c11a-3833-0a14-2585e70c9114@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 07.05.2019 11:29, schrieb Colin Ian King:
> On 07/05/2019 10:20, Dan Carpenter wrote:
>> On Tue, May 07, 2019 at 09:44:58AM +0100, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> The call to sja1105_status_get to set various fields in the status
>>> structure can potentially be skipped in a while-loop because of a couple
>>> of prior continuation jump paths. This can potientially lead to checking
>>> be checking against an uninitialized fields in the structure which may
>>> lead to unexpected results.  Fix this by ensuring all the fields in status
>>> are initialized to zero to be safe.
>>>
>>> Addresses-Coverity: ("Uninitialized scalar variable")
>>> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  drivers/net/dsa/sja1105/sja1105_spi.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
>>> index 244a94ccfc18..76f6a51e10d9 100644
>>> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
>>> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
>>> @@ -394,7 +394,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>>>  	struct sja1105_static_config *config = &priv->static_config;
>>>  	const struct sja1105_regs *regs = priv->info->regs;
>>>  	struct device *dev = &priv->spidev->dev;
>>> -	struct sja1105_status status;
>>> +	struct sja1105_status status = {};
>>
>> The exit condition isn't right.  It should continue if ret is negative
>> or the CRC stuff is invalid but right now it's ignoring ret.  It would
>> be better could just add a break statement at the very end and remove
>> the status checks.  Like so:
>>
>> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
>> index 244a94ccfc18..3af3b0f3cc44 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
>> @@ -466,8 +466,9 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>>  				"invalid, retrying...\n");
>>  			continue;
>>  		}
>> -	} while (--retries && (status.crcchkl == 1 || status.crcchkg == 1 ||
>> -		 status.configs == 0 || status.ids == 1));
>> +		/* Success! */
>> +		break;
>> +	} while (--retries);
> 
> Good point, I'll send a V2 for that. Thanks Dan for your keen eyes.
> 

please do not put everything into the while condition.
It make that hard to read, just add if () break to detangle that.

re,
 wh

> Colin
> 
>>  
>>  	if (!retries) {
>>  		rc = -EIO;
>>
> 
> 
