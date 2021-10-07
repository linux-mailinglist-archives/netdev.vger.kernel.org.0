Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D00425CB4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhJGT7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 15:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhJGT7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 15:59:08 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5981C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 12:57:14 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g184so828103pgc.6
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 12:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=juivLWC7mTvK0BO0t6/CHSHKudhoMfxjRvB6yI//Utk=;
        b=LsJUFzkgmvIzunKFuAVeOuuEgYzysoWS7QH0KaywzH0f5tIUSGHG2pAvZg+noLbqxT
         vpLb59jur+GSIOkGaTxH6vTz4s3GD2NilsndGITYk2wz66FwwtqXOIcaaXOl3uaLJQt+
         WG5eO+I5qg3wo56TIyX/SjTvl+VT1F7IloU0tHCyJH4prGmCW9ipwV6OwlKkUyzRYT5S
         Zuql4m3vaML9djf4lhMT9/SwiT9zkW+BnbtgvhGg+Bz8i7z5lsZCrUzjQPqP7jB79w6H
         qAC6K4KmHHQC5iYY4C8njrGiUGJ0mKw/MdofnbwmYralXJOj6sarpSrSoKQ0pLsyShQf
         we+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=juivLWC7mTvK0BO0t6/CHSHKudhoMfxjRvB6yI//Utk=;
        b=ctEBbB6Tt2AkbD6PebU1PmdF7IcI/HaDSc9MjjUsUHvhndnJZbZp4kt2YV07WIhmfI
         DMT9jgB5T3jisV0v+YTjRchJbr7ugvzJ1WPqFMW2Cf6s+z4lmWSnqJoypWpviJC6p/5/
         /lGVes5ACVSdkPx5rU4OgpImy++GjtYxzDhiL9Lu0b2HmksMHj6QV/s6hH4HV+nSLJMu
         CzGz4Kh1C++4PfEm3QtJwePXCpyLmpXZElB2O8aKb/kyyuyahDAhhMZ9ppkFCccKD2Us
         4AmrQs57wbgrYbdJBSgBrh4KjKm5s1xT+9tjZ4WD6vHYWohUMSMcSEHe4ZRwWAxWMnBb
         yRAA==
X-Gm-Message-State: AOAM531BEjRN4/UAPTX4TMcKPqXRRiN1y0jzF4Np+JSNLTRsjvG4/IKf
        HY+T66HtqKosaOi7Xcwltb4j4brpyYQ=
X-Google-Smtp-Source: ABdhPJy+kCoTdq8c3xR0+HcgwzU1WpjQ/vNjhvyjo4HS2bJahYrVHaAQMtrj60ztkoB2Hj2vkde3+w==
X-Received: by 2002:a62:30c7:0:b0:44c:1ec3:bc31 with SMTP id w190-20020a6230c7000000b0044c1ec3bc31mr5935455pfw.21.1633636634308;
        Thu, 07 Oct 2021 12:57:14 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id m5sm126180pfc.105.2021.10.07.12.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 12:57:13 -0700 (PDT)
Subject: Re: [PATCH net-next 3/7] gve: Do lazy cleanup in TX path
To:     Jeroen de Borst <jeroendb@google.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Tao Liu <xliutaox@google.com>,
        Catherine Sullivan <csully@google.com>
References: <20211007162534.1502578-1-jeroendb@google.com>
 <20211007162534.1502578-3-jeroendb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e53792f1-3084-aee9-43eb-9d16cb063a3a@gmail.com>
Date:   Thu, 7 Oct 2021 12:57:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211007162534.1502578-3-jeroendb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/21 9:25 AM, Jeroen de Borst wrote:
> From: Tao Liu <xliutaox@google.com>
> 
> When TX queue is full, attemt to process enough TX completions
> to avoid stalling the queue.
> 
> Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
> Signed-off-by: Tao Liu <xliutaox@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h         |  9 +-
>  drivers/net/ethernet/google/gve/gve_ethtool.c |  3 +-
>  drivers/net/ethernet/google/gve/gve_main.c    |  6 +-
>  drivers/net/ethernet/google/gve/gve_tx.c      | 94 +++++++++++--------
>  4 files changed, 62 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 59c525800e5d..003b30b91c6d 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -341,8 +341,8 @@ struct gve_tx_ring {
>  	union {
>  		/* GQI fields */
>  		struct {
> -			/* NIC tail pointer */
> -			__be32 last_nic_done;
> +			/* Spinlock for when cleanup in progress */
> +			spinlock_t clean_lock;
>  		};
>

This is adding yet another spinlock in tx completion path.

Normally, BQL should kick and you should not fill the queue completely.

Something is not right.

tx completion can take a lot of time, it seems odd to block an
innocent thread in ndo_start_xmit().

Please provide more details in your changelog ?
