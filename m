Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5449BC83
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiAYTz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiAYTzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:55:25 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4DEC06173B;
        Tue, 25 Jan 2022 11:55:25 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id w5so13573677ilo.2;
        Tue, 25 Jan 2022 11:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mwx4R51tDde945NwTITMzneq7WCyFOACKE0rm7tkswc=;
        b=jqLyFOBxbBXhtPgKrMFF+1wcWKHCyNfChGoR8WkBZxbYbQW0a0tsiYuzZG77QMF7wd
         phetNVLJcRps5G0f9jc8sMPmklJziKbtlIprJ7i/p2Fc5lCS85zTSvCQVJuTfLrxaAuI
         uh8I0qTmDmnr4lP5wU4Zv7/VOkwWugko98SEd5h4TfE5fO3p7tdByH3+sWN6H2ptgM6H
         oAaZT+GYQ4bQIEEjVE2oZaPa1RszBkK7V0af2g6FBLI8Pv2OcO47fgqWKi+cNqzEiEt3
         3hDzwjjT3uNE/ajqs+WuWWvWi4JzJO2aGMzhPQiZJ9C+yyeMSWvngdqNnV+XGmzBQllL
         m+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mwx4R51tDde945NwTITMzneq7WCyFOACKE0rm7tkswc=;
        b=a0gHJyUN1mqFsGJbOmItJFSjHjPqUBgMaUC0qa5gcSSFtAo5HyYDQtgZbNDNA6P8Ae
         xcPAtenkNqbeiP6+68Td6WjgubcGShyDCZuw/m5Jpz4gnBUUgm/hbNPvMs5gLIuUOPi+
         uvNDusd//l5i8CTv172hbktkMIVWWbgT00gtIlTVlKmCYK1KTqpj2SiEkasFfYP/EFep
         r8+gWJh/vQJJ+FTIQXaP+NjTltOpVTI1+2we2b41k58Tt2JdXTf4VJ/YBCnlL2UWow7o
         xPOnZFk01oEug3qky0G40ds3XfasBrxReZSLERlM7F1co8CwAIbd0R9zT6DjPR56HmGc
         QBSQ==
X-Gm-Message-State: AOAM530KKkrNLRXOHlrteGXVijeL8ZMVZnB53e6Rv5B79MLT2SHOnZs9
        7+GmKKCbxPycfa8ohkxcBDs=
X-Google-Smtp-Source: ABdhPJywhrD1lQyMvj4JDiOC9v80DY/8AHWvMwZslYWooJ6fPjdqAtqc8LGvmtNi/mDQmrvTfR9sZA==
X-Received: by 2002:a05:6e02:1786:: with SMTP id y6mr12777811ilu.99.1643140524520;
        Tue, 25 Jan 2022 11:55:24 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id q14sm2803192iow.1.2022.01.25.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:55:24 -0800 (PST)
Date:   Tue, 25 Jan 2022 11:55:16 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     He Fengqing <hefengqing@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com
Cc:     songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <61f055a4b6451_2e4c520871@john.notmuch>
In-Reply-To: <20220122102936.1219518-1-hefengqing@huawei.com>
References: <20220122102936.1219518-1-hefengqing@huawei.com>
Subject: RE: [bpf-next] bpf: Fix possible race in inc_misses_counter
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

He Fengqing wrote:
> It seems inc_misses_counter() suffers from same issue fixed in
> the commit d979617aa84d ("bpf: Fixes possible race in update_prog_stats()
> for 32bit arches"):
> As it can run while interrupts are enabled, it could
> be re-entered and the u64_stats syncp could be mangled.
> 
> Fixes: 9ed9e9ba2337 ("bpf: Count the number of times recursion was prevented")
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  kernel/bpf/trampoline.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Appears possible through sleepable progs.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 4b6974a195c1..5e7edf913060 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -550,11 +550,12 @@ static __always_inline u64 notrace bpf_prog_start_time(void)
>  static void notrace inc_misses_counter(struct bpf_prog *prog)
>  {
>  	struct bpf_prog_stats *stats;
> +	unsigned int flags;
>  
>  	stats = this_cpu_ptr(prog->stats);
> -	u64_stats_update_begin(&stats->syncp);
> +	flags = u64_stats_update_begin_irqsave(&stats->syncp);
>  	u64_stats_inc(&stats->misses);
> -	u64_stats_update_end(&stats->syncp);
> +	u64_stats_update_end_irqrestore(&stats->syncp, flags);
>  }
>  
>  /* The logic is similar to bpf_prog_run(), but with an explicit
> -- 
> 2.25.1
> 


