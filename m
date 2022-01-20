Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13265494650
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358409AbiATEK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiATEK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:10:28 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE711C061574;
        Wed, 19 Jan 2022 20:10:28 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y28so921298pff.2;
        Wed, 19 Jan 2022 20:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mGAPyUYBIV3DCXe8fTnatZkJXHHhQIJu+aokgtouN8I=;
        b=BT4wFhaCh+wCDEB820c6gaF9MOj3OjJJr1pyj9JwIeSDwXzAnMy+URzlRtKPN3zWvU
         rYhOOglEvQgUyXeY5eXCay5SPXiVXzQ4KF2zdp61NpdSpLecOsYRSiAh1UT39lNFLmfm
         yT0SFsYmYoR9fbTGsc3TqOr5R1vFByiNPVhWjkV4U1HoFV586Cj8nJNm1OjNyAnSBBha
         kQ1yqGiBDUU6rzlZiUFKyHOP6LVTT7B0Y/jSvv+QnK9Qn1kmZwAj5vzTp9/BsbLpAadn
         VI40X214ztj68/V7hZN7fsUGpJMMw4JJyCYl3FAYScjGimnFTiCslAfcuwD1UeQSnMAp
         FSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mGAPyUYBIV3DCXe8fTnatZkJXHHhQIJu+aokgtouN8I=;
        b=FfwnuynPegq8PtR5ftAYS0etGeLZ5WPjcDZ7QLc2JT542ZHjWOyIuJ89K834RCVbrb
         tBu55QmZPLw3mEDn8VzBNt3kAgGL7JCEz75/5Fck84ovn7kSo2Mw/8yh3iR8cjGPVt6G
         6mzCZm4FL36EmDwOAk5zFxXTlGoqnHXz5o0jiNe55o/Afch77Ty1GMMG+DbcVAEV+/Gi
         pFXptRyW15cnCTeXrfdQ1932pAh/bFmPXmzdkWf+HQ/ayX8YQcFyIYI8e87v6AppRlON
         uHj6PQM7A+QUHqHdXu8EOvPMWPUAym/zZ3+1RJ6rrDn5yJK/VQNsg9r8MnnOmuEmhof5
         ledg==
X-Gm-Message-State: AOAM5307wSbK64oOCgRKkY+lgij7mEmGtuKzJfjFmZME0UZq/FwjmOtl
        ia8Diyg9+66SQajw5jbxXIc=
X-Google-Smtp-Source: ABdhPJzO++zv+TW/BAXAfipNx5tbmOfU5E4CGLNAb6yQJFeh3y8FUeHh6bdVpDJdeicRQwIwJJpjuQ==
X-Received: by 2002:a63:9809:: with SMTP id q9mr29992863pgd.509.1642651827944;
        Wed, 19 Jan 2022 20:10:27 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9dc9])
        by smtp.gmail.com with ESMTPSA id b22sm1097155pfl.121.2022.01.19.20.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 20:10:27 -0800 (PST)
Date:   Wed, 19 Jan 2022 20:10:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, peterz@infradead.org,
        x86@kernel.org, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Message-ID: <20220120041025.uhg2mgpgl32mnjtq@ast-mbp.dhcp.thefacebook.com>
References: <20220119230620.3137425-1-song@kernel.org>
 <20220119230620.3137425-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119230620.3137425-3-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 03:06:15PM -0800, Song Liu wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> This enables sub-page memory charge and allocation.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h     |  4 ++--
>  kernel/bpf/core.c       | 19 +++++++++----------
>  kernel/bpf/trampoline.c |  6 +++---
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6d7346c54d83..920940f7be22 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -827,8 +827,8 @@ void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
>  void bpf_image_ksym_del(struct bpf_ksym *ksym);
>  void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
> -int bpf_jit_charge_modmem(u32 pages);
> -void bpf_jit_uncharge_modmem(u32 pages);
> +int bpf_jit_charge_modmem(u32 size);
> +void bpf_jit_uncharge_modmem(u32 size);
>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
>  #else
>  static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index de3e5bc6781f..495e3b2c36ff 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -808,7 +808,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>  	return slot;
>  }
>  
> -static atomic_long_t bpf_jit_current;
> +static atomic64_t bpf_jit_current;

I don't understand the motivation for this change.
bpf_jit_limit is type "long" and it's counting in bytes.
So why change jit_current to atomic64?
atomic_long will be fine even on 32-bit arch.
What did I miss?
