Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB73155816
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGNHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 08:07:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35586 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGNHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 08:07:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so2740795wmb.0;
        Fri, 07 Feb 2020 05:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1DWOjsllMyvI82cWegKZSrNeW9XqPcjVhaRoHm5X/Gs=;
        b=DDj/I3fopFPUnfWP0KmWGbkT3us1tdgFumYwbnxnkUFLg6F92Y9pQUPE9rvCYcQ7yH
         +Ce71X/Hbio3T9nP4Y1A59BkH54b06v6DkZ6HeLqgrK6IyA3+izsGHTQD2/GMMM2cuDF
         o4egd+4x1InKMXGNTEvBvrn0ssabhRjEjSMmKN1yl6XVUcYUc8hO25s2V9slRwQpuunL
         R2vNQVrvmgJBSyDMdNSt25tcB7MD0a2LlNuD9Zn4NCh1qMUTk60v1CHHkctxhHArcAHc
         ghlccEURAznqlaNEzxbH4n87yE2kcM5XVf/mwAuItJdYV6MddOoo88qn1bssyK9Irfuu
         0y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1DWOjsllMyvI82cWegKZSrNeW9XqPcjVhaRoHm5X/Gs=;
        b=i48qpRuGDPBDraq0KtnAX2E39u3zcBgU2lvsKZc03cajGQgC9VRuvE3lHOQJvTJFbr
         qFmn95unQeM8hlemwSbBzQ49LTTlRruubIko39yzYGLINKeEM7cwrIcm8SlYSrMJIMuo
         KBtnD0aDMmbAek8x2AFmJMxcZeaNzNjHJq1UudKwZLMk0ZTzZu0A59i4VA+g+Vv2zSm9
         zYw3ZC6l5s+nue802+ZN5WQ3lRzvjdMLEwE6PLpnXrht+W91X3+7ciInC84vLE3dSQsu
         2XzfxQqEJyPoA6/HhvBolgu6oiRTMTkJkPlzD+SaAKzNmCRt/YzAxpA+pNWXWr+aetzu
         OZng==
X-Gm-Message-State: APjAAAUMaOjZ7hXBQ27E/Ozt5+90jk/M0gCxhaAmXhvAiFkUkku1MtNn
        cRsU57Z5TEtRhCBGDuYtpeXDiy1DAQ4=
X-Google-Smtp-Source: APXvYqxtf3QehcyIiuV1qmalCcPH+As1mDGsTBNUJoO2dM6Rc8WBgIEdyGwiG8ZxuNwOYKOS5vP8gA==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr4396971wmk.172.1581080843097;
        Fri, 07 Feb 2020 05:07:23 -0800 (PST)
Received: from ltop.local ([2a02:a03f:4017:df00:527:d70f:e855:bf1])
        by smtp.gmail.com with ESMTPSA id t13sm3243597wrw.19.2020.02.07.05.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 05:07:22 -0800 (PST)
Date:   Fri, 7 Feb 2020 14:07:21 +0100
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH bpf] bpf: Improve bucket_log calculation logic
Message-ID: <20200207130721.pitlvbxcx656c7ur@ltop.local>
References: <20200207081810.3918919-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207081810.3918919-1-kafai@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 12:18:10AM -0800, Martin KaFai Lau wrote:
> 
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index 458be6b3eda9..3ab23f698221 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -643,9 +643,10 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
>  		return ERR_PTR(-ENOMEM);
>  	bpf_map_init_from_attr(&smap->map, attr);
>  
> +	nbuckets = roundup_pow_of_two(num_possible_cpus());
>  	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
> -	smap->bucket_log = max_t(u32, 1, ilog2(roundup_pow_of_two(num_possible_cpus())));
> -	nbuckets = 1U << smap->bucket_log;
> +	nbuckets = max_t(u32, 2, nbuckets);
> +	smap->bucket_log = ilog2(nbuckets);
>  	cost = sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
>  
>  	ret = bpf_map_charge_init(&smap->map.memory, cost);
> -- 

Yes, that's much nicer to read. Feel free to add my

Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

-- Luc
