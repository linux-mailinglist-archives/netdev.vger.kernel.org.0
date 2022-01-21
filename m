Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7A4962A5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381776AbiAUQNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381769AbiAUQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:13:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D533C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:13:15 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u10so4750550pfg.10
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nHlCwPmMEn/YiZ8pnMummdA5yNnFdGTRy0EIU8YdvTA=;
        b=j18/byAixcHkXvKnOv7VC4/Y2d9aV08L1GVVPzBjxLYBIIHbKUlxvwPmijzVbngZZz
         gpS6HqqYgA0pcbKspza9e169IUNkKqVfUylDaJ+qI4/kD/nqxe4VpSic6bW/Cxf0VJse
         O1R+UDI77rMDLmGTEKAgI0uLZR1J6jLinw6Elv1zBa4UF++90doM40XtDUh4gTvBOWYQ
         j8aDRdju6ShyKEy2e7cp7O4k7vy8qS9TS37IilaM9Lp5AdNrRr5O78uoUSg9bINxP1j3
         q5Qm4qfC087EZp7SQcbXUPwMDVBgodlx2QUF9TgeV0K39yf7pi/f2e7pBZ+0+eSF/4As
         wSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHlCwPmMEn/YiZ8pnMummdA5yNnFdGTRy0EIU8YdvTA=;
        b=zQZlK7fTnKfoLL151liyPsSrzLl4gxNjmJ4J9QcrQbbZwafCXyPbSSO36lUq9bJRTW
         +nHzGRO/hmEdUNvmS1t0kO4u/jqKS4J4GM3pcFMLLwt3JcBkOayjls/cNDeasyMe2D0L
         r/C3rn/GivYuHdkgLRsU0bprFMLHWfgfe1PyYuqTHoO2yLfmT7J3Qkbx3P1D/vmBycr3
         bvsa1RMWPssQyA28cbb3sdEtVXT49B1lAfh813smDgec8uO8/DdMlFKsrCUn4UbnbDKh
         CAkHKaLnbrA5yklreE++Dmu5kPYPcKNMVN7APpq8LZfiDhKlXCBskfC2EKBc2E/q7yV7
         h8kQ==
X-Gm-Message-State: AOAM530Ut8+bvV90EWfdDlmskx80rDW9aSiEHEvq5ES4day4FfKQzFfA
        YtnNM5/PzT3gGf9wV+T0Y48oHg==
X-Google-Smtp-Source: ABdhPJyWEkgLOGmK9rQ1mELG6RVy7ZTD8COqzNFBIlJbG6n9fvNba4MzsEPV6Svv4uyxRLU756Ktnw==
X-Received: by 2002:a63:bf0f:: with SMTP id v15mr3452250pgf.528.1642781595042;
        Fri, 21 Jan 2022 08:13:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g18sm5380152pgh.45.2022.01.21.08.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 08:13:14 -0800 (PST)
Date:   Fri, 21 Jan 2022 08:13:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     ycaibb <ycaibb@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: missing lock releases in ipmr_base.c
Message-ID: <20220121081311.2518068f@hermes.local>
In-Reply-To: <20220121032210.5829-1-ycaibb@gmail.com>
References: <20220121032210.5829-1-ycaibb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 11:22:10 +0800
ycaibb <ycaibb@gmail.com> wrote:

> From: Ryan Cai <ycaibb@gmail.com>
> 
> In method mr_mfc_seq_idx, the lock it->lock and rcu_read_lock are not released when pos-- == 0 is true.
> 
> Signed-off-by: Ryan Cai <ycaibb@gmail.com>
> ---
>  net/ipv4/ipmr_base.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
> index aa8738a91210..c4a247024c85 100644
> --- a/net/ipv4/ipmr_base.c
> +++ b/net/ipv4/ipmr_base.c
> @@ -154,6 +154,7 @@ void *mr_mfc_seq_idx(struct net *net,
>  	it->cache = &mrt->mfc_cache_list;
>  	list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list)
>  		if (pos-- == 0)
> +			rcu_read_unlock();
>  			return mfc;
>  	rcu_read_unlock();
>  
> @@ -161,6 +162,7 @@ void *mr_mfc_seq_idx(struct net *net,
>  	it->cache = &mrt->mfc_unres_queue;
>  	list_for_each_entry(mfc, it->cache, list)
>  		if (pos-- == 0)
> +			spin_unlock_bh(it->lock);
>  			return mfc;
>  	spin_unlock_bh(it->lock);
>  

Another buggy patch, perhaps you write python or research papers?
