Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA30F1E2508
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgEZPJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgEZPJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:09:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24229C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:09:18 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x6so7123972wrm.13
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ANJGgbl+4BOk6wSgQbcBdUObBpt8o4dWG/dFH1sxbP0=;
        b=AIuG53HU/nC9SpEsRhv1r44dTqXHstKGOxzKUXlgcu9tvDtVtPYncbXR+/nvKKLOyf
         EYHC4U+ROw9+hcxmXKFl1xqsJKmn5rLlHuT6vd3rwwvH4KKo1sQ7t1ZpHNJ+dwhpiTwH
         WLYqBl0kkq3mADnmThSLWUsLbDIfLnh+1TPb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ANJGgbl+4BOk6wSgQbcBdUObBpt8o4dWG/dFH1sxbP0=;
        b=nP6s8VXVfsNLvq1lXX8UW4CURSwFY0IO5zrBUQfsXH/rXBT0Ibwn1xHbLNKGgFkuNW
         r1z4+8hKW/kpH+XrQPpF71SpG8fy+224bdF9gwyvDCRGBVN5t2sGq/xEhsGC6mItYQNi
         JDyCXHVyin8VCwuof1ZIv/s4bCfTi6t0o8RqOd/Cop24G+f1iK2C+FBKOgCxEDhLsqsk
         SqmPY34hPNTIu2HdPn+jNN8ntpUEzs9sLvGrgE0HEvBim3cV9zZO9SpbFx/vd5TIwFNE
         OvJSwN79IIlA2ykcIcSUk+c350crXumwB6HnV43GEEBsnjY6TYcyoHaYnlrm+1vjIwJk
         OVYA==
X-Gm-Message-State: AOAM533/LmbymfdFj5iEtehqGkXLT91ZXP7yKuLGu+d4LqjotuAai4uw
        RlfouVeKpFh9k74oCEcZu37arg==
X-Google-Smtp-Source: ABdhPJyfbFSEx8+HTi6xhYNDoIJGqfNYQR6tINqr+/ldKByFNrkwlsPCDttLVhCvSz1IBKNEsvwLSg==
X-Received: by 2002:adf:e84c:: with SMTP id d12mr5172730wrn.284.1590505756889;
        Tue, 26 May 2020 08:09:16 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u7sm155009wrm.23.2020.05.26.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:09:15 -0700 (PDT)
Subject: Re: [PATCH net 4/5] ipv4: Refactor nhc evaluation in fib_table_lookup
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526150114.41687-5-dsahern@kernel.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b1f5fdb2-70a7-1391-19ba-5cdd6e0023dc@cumulusnetworks.com>
Date:   Tue, 26 May 2020 18:09:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200526150114.41687-5-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2020 18:01, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> FIB lookups can return an entry that references an external nexthop.
> While walking the nexthop struct we do not want to make multiple calls
> into the nexthop code which can result in 2 different structs getting
> accessed - one returning the number of paths the rest of the loop
> seeing a different nh_grp struct. If the nexthop group shrunk, the
> result is an attempt to access a fib_nh_common that does not exist for
> the new nh_grp struct but did for the old one.
> 
> To fix that move the device evaluation code to a helper that can be
> used for inline fib_nh path as well as external nexthops.
> 
> Update the existing check for fi->nh in fib_table_lookup to call a
> new helper, nexthop_get_nhc_lookup, which walks the external nexthop
> with a single rcu dereference.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/net/ip_fib.h  |  2 ++
>  include/net/nexthop.h | 33 ++++++++++++++++++++++++++++
>  net/ipv4/fib_trie.c   | 51 ++++++++++++++++++++++++++++++-------------
>  3 files changed, 71 insertions(+), 15 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 59e0d4e99f94..1f1dd22980e4 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -480,6 +480,8 @@ void fib_nh_common_release(struct fib_nh_common *nhc);
>  void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri);
>  void fib_trie_init(void);
>  struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
> +bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
> +			 const struct flowi4 *flp);
>  
>  static inline void fib_combine_itag(u32 *itag, const struct fib_result *res)
>  {
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index f09e8d7d9886..9414ae46fc1c 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -233,6 +233,39 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
>  	return &nhi->fib_nhc;
>  }
>  
> +/* called from fib_table_lookup with rcu_lock */
> +static inline
> +struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
> +					     int fib_flags,
> +					     const struct flowi4 *flp,
> +					     int *nhsel)
> +{
> +	struct nh_info *nhi;
> +
> +	if (nh->is_group) {
> +		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
> +		int i;
> +
> +		for (i = 0; i < nhg->num_nh; i++) {
> +			struct nexthop *nhe = nhg->nh_entries[i].nh;
> +
> +			nhi = rcu_dereference(nhe->nh_info);
> +			if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
> +				*nhsel = i;
> +				return &nhi->fib_nhc;
> +			}
> +		}
> +	} else {
> +		nhi = rcu_dereference(nh->nh_info);
> +		if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
> +			*nhsel = 0;
> +			return &nhi->fib_nhc;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>  static inline unsigned int fib_info_num_path(const struct fib_info *fi)
>  {
>  	if (unlikely(fi->nh))
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 4f334b425538..248f1c1959a6 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1371,6 +1371,26 @@ static inline t_key prefix_mismatch(t_key key, struct key_vector *n)
>  	return (key ^ prefix) & (prefix | -prefix);
>  }
>  
> +bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
> +			 const struct flowi4 *flp)
> +{
> +	if (nhc->nhc_flags & RTNH_F_DEAD)
> +		return false;
> +
> +	if (ip_ignore_linkdown(nhc->nhc_dev) &&
> +	    nhc->nhc_flags & RTNH_F_LINKDOWN &&
> +	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
> +		return false;
> +
> +	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
> +		if (flp->flowi4_oif &&
> +		    flp->flowi4_oif != nhc->nhc_oif)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /* should be called with rcu_read_lock */
>  int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
>  		     struct fib_result *res, int fib_flags)
> @@ -1503,6 +1523,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
>  	/* Step 3: Process the leaf, if that fails fall back to backtracing */
>  	hlist_for_each_entry_rcu(fa, &n->leaf, fa_list) {
>  		struct fib_info *fi = fa->fa_info;
> +		struct fib_nh_common *nhc;
>  		int nhsel, err;
>  
>  		if ((BITS_PER_LONG > KEYLENGTH) || (fa->fa_slen < KEYLENGTH)) {
> @@ -1528,26 +1549,25 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
>  		if (fi->fib_flags & RTNH_F_DEAD)
>  			continue;
>  
> -		if (unlikely(fi->nh && nexthop_is_blackhole(fi->nh))) {
> -			err = fib_props[RTN_BLACKHOLE].error;
> -			goto out_reject;
> +		if (unlikely(fi->nh)) {
> +			if (nexthop_is_blackhole(fi->nh)) {
> +				err = fib_props[RTN_BLACKHOLE].error;
> +				goto out_reject;
> +			}
> +
> +			nhc = nexthop_get_nhc_lookup(fi->nh, fib_flags, flp,
> +						     &nhsel);
> +			if (nhc)
> +				goto set_result;
> +			goto miss;
>  		}
>  
>  		for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
> -			struct fib_nh_common *nhc = fib_info_nhc(fi, nhsel);
> +			nhc = fib_info_nhc(fi, nhsel);
>  
> -			if (nhc->nhc_flags & RTNH_F_DEAD)
> +			if (!fib_lookup_good_nhc(nhc, fib_flags, flp))
>  				continue;
> -			if (ip_ignore_linkdown(nhc->nhc_dev) &&
> -			    nhc->nhc_flags & RTNH_F_LINKDOWN &&
> -			    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
> -				continue;
> -			if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
> -				if (flp->flowi4_oif &&
> -				    flp->flowi4_oif != nhc->nhc_oif)
> -					continue;
> -			}
> -
> +set_result:
>  			if (!(fib_flags & FIB_LOOKUP_NOREF))
>  				refcount_inc(&fi->fib_clntref);
>  
> @@ -1568,6 +1588,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
>  			return err;
>  		}
>  	}
> +miss:
>  #ifdef CONFIG_IP_FIB_TRIE_STATS
>  	this_cpu_inc(stats->semantic_match_miss);
>  #endif
> 

