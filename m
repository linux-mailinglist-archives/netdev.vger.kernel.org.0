Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B592D0983
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgLGDlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgLGDlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 22:41:50 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FDFC0613D0
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 19:41:10 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id f14so6564239pju.4
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 19:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dxyVgq9wir+Vt+l/aYhT1fh3gohCtzVJwY55PsYwhXQ=;
        b=cpBMuL8d3aNWORrYrc8Ke1Emtw7kNtKm8C2LV1nJSk1l0qXyaRC6gHj0Z90oGQ8J5l
         +fRxxdoUNWAyxI9U1OJWteMN6pw7Xm3G5Kh6TNMPCsNs/05TRo1SV+xcTHsRyJs5n5XC
         3vCIkUJfGGKjuVZm+jonCOLS4Gek9Jx804wgNj6NLsydAej90RDZIvXEMJVXcYQErRGE
         gEV0/+Q3NgcPy1AOzCOpMS3VF8AI3tmiD3sHXOcHp7UNmC1W8tVbWl6RpfyWuXn48Prr
         Ecp45VrFX5rIB+5nrhh9K1zP1Pq+Z64QI56tyCgHk0lOJkjteP7xS1d0Avl8gsyonE0y
         9krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dxyVgq9wir+Vt+l/aYhT1fh3gohCtzVJwY55PsYwhXQ=;
        b=kRtaLbh7Z3C4e6EiMe0p/2gpOX81xrXBzuqjw6hxqdrwaKX85rXjA22uONT2dXHtn+
         e6dZdG8waCpoxcOU4UqyPQ1PJYZidRPxQIJJmvWld52hWhQbQru4P2aiZyjx+VUk7npK
         8MDdtjaCHSTkR10yaX1WGuQTz0g3OXuibEaK+donHklk1nupKVtoTzyFY7kwfH9w1QoP
         X4mBa9Gto38D0gt6IrIb/7CbvdLS67N4BeE68Zz+XIKxhtedOaIARJj4eZ+IyxC03ew+
         dEzEh9+jRsdHHRiuqjcWaiGEk/D+nbcOqxKBwY3gqHf5r6g6P6gSioA0Wg5868HZkXfc
         mGRw==
X-Gm-Message-State: AOAM533Wm0FBiJwlg8klQZ2X+QZYqSfWaB5ODa86Do4rbMGKZX99N2ib
        DF1OwCfQ53pviQ9oeJg3zy5QgA==
X-Google-Smtp-Source: ABdhPJx/Oqm+T1Mhytc8big0M5Rh8llLWWixOjXO0eqEYBECBJExJ0y3EQJL9HR+O+2zqWO6n9v39Q==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr2704798pjp.206.1607312470088;
        Sun, 06 Dec 2020 19:41:10 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m4sm13485068pfd.203.2020.12.06.19.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 19:41:09 -0800 (PST)
Subject: Re: [PATCH 1/1] ionic: fix array overflow on receiving too many
 fragments for a packet
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201206133537.30135-1-ruc_zhangxiaohui@163.com>
 <20201206175157.0000170d@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <4ddd5457-3cbb-9a5b-90ef-3557452cd854@pensando.io>
Date:   Sun, 6 Dec 2020 19:41:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201206175157.0000170d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/20 5:51 PM, Jesse Brandeburg wrote:
> Xiaohui Zhang wrote:
>
>> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>>
>> If the hardware receives an oversized packet with too many rx fragments,
>> skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
>> This becomes especially visible if it corrupts the freelist pointer of
>> a slab page.
>>
>> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> Hi, thanks for your patch.
>
> It appears this is a part of a series of patches (at least this one and
> one to the ice driver) - please send as one series, with a cover letter
> explanation.
>
> Please justify how this is a bug and how this is found / reproduced.
>
> I'll respond separately to the ice driver patch as I don't know this
> hardware and it's limits, but I suspect that you've tried to fix a bug
> where there was none. (It seems like something a code scanner might find
> and be confused about)
>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> index 169ac4f54..a3e274c65 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> @@ -102,8 +102,12 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>>   
>>   		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>>   			       PAGE_SIZE, DMA_FROM_DEVICE);
>> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> +		struct skb_shared_info *shinfo = skb_shinfo(skb);
> you can't declare variables in the middle of a code flow in C, did you
> compile this?
>
>> +
>> +		if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
>> +			skb_add_rx_frag(skb, shinfo->nr_frags,
>>   				page_info->page, 0, frag_len, PAGE_SIZE);
>> +		}

Is this just dropping the remaining frags without dropping the rest of 
the skb?  Is this going to leave an incorrect length in the skb?

A single statement after the 'if' doesn't need {}'s

This might be better handled by making sure ahead of time in 
configuration that the HW doesn't do this, rather than add a test into 
the fast path.  As it is, between the definitions of shinfo->frags[] and 
the ionic's rx sg list, I don't think this is a possible error.

As Jesse suggests, I'd like to see the test case so i can add it to our 
internal testing.

Thanks,
sln

>>   		page_info->page = NULL;
>>   		page_info++;
>>   		i--;
>

