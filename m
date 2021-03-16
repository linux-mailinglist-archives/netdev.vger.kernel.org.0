Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F8F33E211
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhCPXZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhCPXYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 19:24:36 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C47CC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 16:24:36 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t85so9858640pfc.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 16:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jvzrNGCSfBIg72knuT8L0lntlXh7dAG0nwZCdJHuJOE=;
        b=c7IMKTT0wYx3gxmLXPefKeFzX1N8/K7mGLCg87vS2ZOawMasaUSr0lrphew+CsAgmo
         uqapXzDDcyNzMLwNDWPTTCj4sAg9+MV44VBwZ88TO82b+56CQj7LhZpmyOREtL9RkwL7
         hdwMTzaRMX1C+R1Dsc6tiw8iSByCKszsO2NdOfZj71Z6/UovtJ8mipXt2FtJja6KW2xz
         AJ/bWKFpfG6/0QCTId2Wx/+VDXjbwyGEgFpY/Y8ZPxpHJrSpiYCKNVclTOo7eGEn2wSa
         wpfYVeADwY5oIActN8YxMOL860oKAdSfVjjD8RhQOUx2gcQvd2cAe4shQCMTC8/xXNQi
         ghOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jvzrNGCSfBIg72knuT8L0lntlXh7dAG0nwZCdJHuJOE=;
        b=qGBJ3JStOMWDNYKhDWg1RxMXwpkCanYwKmj3np4UEqzQ+t6cfDeqBoZSAoGPHEHSvb
         JVCbU0KXkkFCh5RKLVLQc1gm4z9EkEdhpm6Sb/ApmQbd4/e6VNRfkIjNCMSZq57ekOHl
         a2cok33g3hN6i2OhpkjipU7yIDOFrYtBYvUNUuvb/fJ7q/sHgtqWWcVUrjsbI0jQPeEU
         H/q0GXSLg9De5II3VdLW4ioQMbta0uLSVK1KK8Aw1jXwvckiEhQjqfM335xRwSUAJEG7
         OcTxM6SL/Elpc3X8ynC5Z0TOPT5a33AhrgMWYoUfvcjDij9vDUbWbwRJu9c8alxJdS9Z
         wT2Q==
X-Gm-Message-State: AOAM533UYTTalWxdzVtXTOAH1LJJuv3Tnlg5NXckuL5E0Wxe4OSA3zxY
        yunr1nay69evTo3LZKzYWKRd7w==
X-Google-Smtp-Source: ABdhPJxIZ3AQWivX3oXkXxXHbbLfF6Zmc2hMOJAbdzZqyfSlI9FRYNlhuRo4VJsb605h7GhigHpBwQ==
X-Received: by 2002:aa7:9a94:0:b029:1f4:ec7:fd2 with SMTP id w20-20020aa79a940000b02901f40ec70fd2mr1547447pfi.48.1615937075864;
        Tue, 16 Mar 2021 16:24:35 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c1sm2321480pfn.131.2021.03.16.16.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 16:24:35 -0700 (PDT)
Subject: Re: [PATCH net] ionic: linearize tso skb with too many frags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
References: <20210316185243.30053-1-snelson@pensando.io>
 <20210316145431.232672d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <567bc95f-568a-4413-b559-a1ec309f34af@pensando.io>
Date:   Tue, 16 Mar 2021 16:24:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316145431.232672d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 2:54 PM, Jakub Kicinski wrote:
> On Tue, 16 Mar 2021 11:52:43 -0700 Shannon Nelson wrote:
>> We were linearizing non-TSO skbs that had too many frags, but
>> we weren't checking number of frags on TSO skbs.  This could
>> lead to a bad page reference when we received a TSO skb with
>> more frags than the Tx descriptor could support.
>>
>> Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_txrx.c  | 28 ++++++++++---------
>>   1 file changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> index 162a1ff1e9d2..462b0d106be4 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> @@ -1079,25 +1079,27 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
>>   {
>>   	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
>>   	struct ionic_tx_stats *stats = q_to_tx_stats(q);
>> +	int ndescs;
>>   	int err;
>>   
>> -	/* If TSO, need roundup(skb->len/mss) descs */
>> +	/* If TSO, need roundup(skb->len/mss) descs
>> +	 * If non-TSO, just need 1 desc and nr_frags sg elems
>> +	 */
>>   	if (skb_is_gso(skb))
>> -		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
>> +		ndescs = (skb->len / skb_shinfo(skb)->gso_size) + 1;
> Slightly unrelated but why not gso_segs? len / gso_size + 1 could be
> over counting, not to mention that div is expensive.

Good catch - we can probably do that.

>
> Are you segmenting in the driver? Why do you need #segs descriptors?

The device needs each descriptor to be no more than mss length, so there 
might be a number of descriptors for a large packet.

>
>> +	else
>> +		ndescs = 1;
>>   
>> -	/* If non-TSO, just need 1 desc and nr_frags sg elems */
>> -	if (skb_shinfo(skb)->nr_frags <= sg_elems)
>> -		return 1;
>> +	/* If too many frags, linearize */
>> +	if (skb_shinfo(skb)->nr_frags > sg_elems) {
>> +		err = skb_linearize(skb);
>> +		if (err)
>> +			return err;
>>   
>> -	/* Too many frags, so linearize */
>> -	err = skb_linearize(skb);
>> -	if (err)
>> -		return err;
>> -
>> -	stats->linearize++;
>> +		stats->linearize++;
>> +	}
>>   
>> -	/* Need 1 desc and zero sg elems */
>> -	return 1;
>> +	return ndescs;
> I'd be tempted to push back on the refactoring here, you could've
> just replaced return 1;s with return ndescs;s without changing
> the indentation.. this will give all backporters a pause. But
> not the end of the world, I guess.

I can tweak that a little.

I'll send a v2.

sln

>
>>   }
>>   
>>   static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)

