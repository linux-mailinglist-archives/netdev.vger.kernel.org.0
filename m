Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D417111470E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfLESn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:43:59 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36787 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLESn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 13:43:59 -0500
Received: by mail-pl1-f194.google.com with SMTP id k20so1605071pls.3;
        Thu, 05 Dec 2019 10:43:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FCp49Ui27dydwY8694hG4UdI57V9y5xaYI+0ibAx9Mc=;
        b=EwfdDzeJebLnKRGKcgosgHey0wK42t0sQk9CWjBY+NVVlAlon+T2fEoqLBaEy1HPlm
         1Ri4tZacXbJy/6Se+pXlXRSyqyWISZlgfR0tYvZ9YFMrX29wvt4WUYNhjD0W5PL+puhg
         upOMLVdycTmy3Et4J8+t2i/FldEusxTr3XIc1oWKFvAe03nrUey9uUzzCGc3K8UHL74A
         8tQyIuYY7AOM3R/4/xX7pkDg7SZc5Eq75AX8LQnnJcJRg/gXQt+L4EAV83L8BDsFr9IK
         hZTSQBqtUo3mDpHYt1Gxzkmq+CYURP3lukQHxSyYOZ94cUsHr1cNNEAak2GN1yUWt+QL
         iHNw==
X-Gm-Message-State: APjAAAVYeWv45aEyP5zMaEMhQqYoSorxaTokpTjGi+9kI59PAJRo7FxO
        fxmMQtYFF4BgAAIqT8QHxms=
X-Google-Smtp-Source: APXvYqxEGWkHqf3SoqS5JfOUeYQylUakgL3ONZFsTaapa4Y7GVYOM+MlCU3V6fpr61txQqIa5+ArzQ==
X-Received: by 2002:a17:90a:23a9:: with SMTP id g38mr11278130pje.128.1575571438433;
        Thu, 05 Dec 2019 10:43:58 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id p68sm13748345pfp.149.2019.12.05.10.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 10:43:57 -0800 (PST)
Date:   Thu, 5 Dec 2019 10:44:50 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Paul Burton <paul.burton@mips.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: MIPS eBPF JIT support on pre-32R2
Message-ID: <20191205184450.lbrkenmursz4zpdm@lantea.localdomain>
References: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <09d713a59665d745e21d021deeaebe0a@dlink.ru>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Thu, Dec 05, 2019 at 03:45:27PM +0300, Alexander Lobakin wrote:
> Hey all,
> 
> I'm writing about lines arch/mips/net/ebpf_jit.c:1806-1807:
> 
> 	if (!prog->jit_requested || MIPS_ISA_REV < 2)
> 		return prog;
> 
> Do pre-32R2 architectures (32R1, maybe even R3000-like) actually support
> this eBPF JIT code?

No, they don't; the eBPF JIT makes unconditional use of at least the
(d)ins & (d)ext instructions which were added in MIPSr2, so it would
result in reserved instruction exceptions & panics if enabled on
pre-MIPSr2 CPUs.

> If they do, then the condition 'MIPS_ISA_REV < 2'
> should be removed as it is always true for them and tells CC to remove
> JIT completely.
> 
> If they don't support instructions from this JIT, then the line
> arch/mips/Kconfig:50:
> 
> 	select HAVE_EBPF_JIT if (!CPU_MICROMIPS)
> 
> should be changed to something like:
> 
> 	select HAVE_EBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV >= 2
> 
> (and then the mentioned 'if' condition would become redundant)

Good spot; I agree entirely, this dependency should be reflected in
Kconfig.

> At the moment it is possible to build a kernel without both JIT and
> interpreter, but with CONFIG_BPF_SYSCALL=y (what should not be allowed
> I suppose?) within the following configuration:
> 
> - select any pre-32R2 CPU (e.g. CONFIG_CPU_MIPS32_R1);
> - enable CONFIG_BPF_JIT (CONFIG_MIPS_EBPF_JIT will be autoselected);
> - enable CONFIG_BPF_JIT_ALWAYS_ON (this removes BPF interpreter from
>   the system).
> 
> I may prepare a proper patch by myself if needed (after clarification).

That would be great, thanks!

One thing to note is that I hope we'll restore the cBPF JIT with this
patch:

https://lore.kernel.org/linux-mips/20191205182318.2761605-1-paulburton@kernel.org/T/#u

The cBPF JIT looks like it should work on older pre-MIPSr2 CPUs, so the
only way this is relevant is that your patch might have a minor
conflict. But I thought I'd mention it anyway :)

Thanks,
    Paul
