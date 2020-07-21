Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1723F22745B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGUBFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGUBFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:05:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17001C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:05:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so9928758pfu.1
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yfYe7Y+aojr3SaaDdG2/7748AxbWPY9JFPBv8OtAOx8=;
        b=bYeiQVuZ8O5DkyXmttlk6NAbqW9lf7OsQVg/Y0muBNvlo8OMGddNBCqZDgXaB5Vhhd
         LatnjpUrOcQH6p4uBGg2IbbTWP+dKh2ZmU56NW58VcfX2IsylDHBeloBZkzWUABgRpZu
         DGxP/O57i85EWIdwwrN2N2bvpL28Tv+WRA3q9qCGQDG+nwBnj/IPl5HiY0ts3jkRMbM+
         aZmgxNnsJcXuFHNVc3+jhr5LU+HSfbaiChiYcyhpFjG+2Bh803xJDPwTtDOfT6CS6Rcj
         JW7Wn5SnATUFANNPJPf4ZzZI9WTiqswJ1di0qbgSw/u2MFVjoP3l98BchoMNCR3BXj5Z
         NlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yfYe7Y+aojr3SaaDdG2/7748AxbWPY9JFPBv8OtAOx8=;
        b=XQbG6ZR3PL8j4nEqbtGceH/1WfRbEMb8aVanb2O8odNizSEEi8/l+ya54ej4KBdWLn
         ftuYlEsFKM6LVlTX6awLgdSCSOKqho7xuUdQWWy6Spbx7Goo2LpdL76G2UWjvOyUm5mC
         8eBOYhJGz2HswRDRHLAXip9adtGi39Mit8NFh3HzOC5vjZdqpLxq76vDkfB67vhPCoto
         Xaa1zoIvfXzmL68abDE+sMYRB8sYIMtsCHjRxIiruMbQLkHiKU0NqCGzJugfAVl82BOM
         MsV/3KQI0HVBJym9/GdkkErDYWS5sQBnz9vX/MkjI42WVQ5UBDrmFSz3e3Tsf53v2Puc
         RsDA==
X-Gm-Message-State: AOAM531zEdS+bxWYq/Rm9ccoLGSLdtbKJDds7Kt7tQRULBbFYx055KVB
        yJOwnsw6WsOaNlrGmp+nhASupQ==
X-Google-Smtp-Source: ABdhPJyDSXf0N3YqiEUwNvytSWdWES9pG8f3NhYGA3BEcuFGrLsBbqWmCRCk0RlSAwzybKqQPYuh4g==
X-Received: by 2002:a62:8608:: with SMTP id x8mr20941564pfd.96.1595293541438;
        Mon, 20 Jul 2020 18:05:41 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id k64sm355978pfd.132.2020.07.20.18.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:05:40 -0700 (PDT)
Subject: Re: [PATCH net 2/5] ionic: fix up filter locks and debug msgs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200720230017.20419-1-snelson@pensando.io>
 <20200720230017.20419-3-snelson@pensando.io>
 <20200720170325.6c24303d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <467e2e54-5adf-3f0d-0a65-4d8ab1d409d7@pensando.io>
Date:   Mon, 20 Jul 2020 18:05:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720170325.6c24303d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 5:03 PM, Jakub Kicinski wrote:
> On Mon, 20 Jul 2020 16:00:14 -0700 Shannon Nelson wrote:
>> Add in a couple of forgotten spinlocks and fix up some of
>> the debug messages around filter management.
> Aren't these independent changes?

They can be... they went together in my head as a cleanup that was done 
before the filter_id patch that follows.

>
>> Fixes: c1e329ebec8d ("ionic: Add management of rx filters")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
>> index 80eeb7696e01..fb9d828812bd 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
>> @@ -69,10 +69,12 @@ int ionic_rx_filters_init(struct ionic_lif *lif)
>>   
>>   	spin_lock_init(&lif->rx_filters.lock);
>>   
>> +	spin_lock_bh(&lif->rx_filters.lock);
>>   	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
>>   		INIT_HLIST_HEAD(&lif->rx_filters.by_hash[i]);
>>   		INIT_HLIST_HEAD(&lif->rx_filters.by_id[i]);
>>   	}
>> +	spin_unlock_bh(&lif->rx_filters.lock);
>>   
>>   	return 0;
>>   }
>> @@ -84,11 +86,13 @@ void ionic_rx_filters_deinit(struct ionic_lif *lif)
>>   	struct hlist_node *tmp;
>>   	unsigned int i;
>>   
>> +	spin_lock_bh(&lif->rx_filters.lock);
>>   	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
>>   		head = &lif->rx_filters.by_id[i];
>>   		hlist_for_each_entry_safe(f, tmp, head, by_id)
>>   			ionic_rx_filter_free(lif, f);
>>   	}
>> +	spin_unlock_bh(&lif->rx_filters.lock);
>>   }
> Taking a lock around init/deinit is a little strange, is this fixing
> a possible issue or just for "completeness"? If the like head can be
> modified before it's initialized or after its flushed - that's a more
> serious problem to address..

Yes, this is a completeness thing.

sln


