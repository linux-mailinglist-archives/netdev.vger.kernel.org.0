Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1583A1157A8
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLFTSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:18:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41941 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFTSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:18:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so3804889pfd.8;
        Fri, 06 Dec 2019 11:18:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=EfuiC5g9uwuyk/XA/r2lQbj8CwOw/7zBQtIMHV2LGGg=;
        b=dMFiAtmTLczQtk+CUYCSLNJ9VFaQv3JnOST7BH1Y7RfuihLmS44xq6qkXxurFp2qaE
         DpJzatqPrfRFo2CnbHMzfGP8eDTQXza8/dDotgLlaRdIWh44jdN97HtxyCb/6VSi7wVx
         dJPrTALmiFoYaQHsEfp5EUzUO0K9czMeANSlTXrnZswuIdXqat9Byca9vy+GrzbIBAfs
         3vgHenHIAE2IAefIX7BmbRKpd4+RdY4hFN7b4u0RFwRQ4GIS9LYfe8B9/poA7ywu/G+3
         WTe6mMx5tyH+RVVwSTr9TjvgNTobMa2CAnaFG8rMcGwxI4FgpdAL57cM88lP72fs5POe
         ZvzA==
X-Gm-Message-State: APjAAAVbjQK/9uA/iakeq6pfc/tpHiJBOkCqHsHWvDqUd+l/+jc6H+Sm
        4fl1PUVU2ACPZRm1P9S+vA8=
X-Google-Smtp-Source: APXvYqxC3rbCY2YzRS2G6XX19XoD+mFGP85/kEnW2NtNt2Ur2w+SKrkYWBZhVNsmhZeQfFgt7mHK9A==
X-Received: by 2002:a63:e14a:: with SMTP id h10mr5174663pgk.74.1575659925557;
        Fri, 06 Dec 2019 11:18:45 -0800 (PST)
Received: from localhost (MIPS-TECHNO.ear1.SanJose1.Level3.net. [4.15.122.74])
        by smtp.gmail.com with ESMTPSA id n188sm7984307pga.84.2019.12.06.11.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 11:18:44 -0800 (PST)
Message-ID: <5deaa994.1c69fb81.97561.647e@mx.google.com>
Date:   Fri, 06 Dec 2019 11:18:44 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Paul Burton <paulburton@kernel.org>
CC:     linux-mips@vger.kernel.org
CC:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Tony Ambardar <itugrok@yahoo.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH] MIPS: BPF: Restore MIPS32 cBPF JIT; disable MIPS32 eBPF JIT
References:  <20191205182318.2761605-1-paulburton@kernel.org>
In-Reply-To:  <20191205182318.2761605-1-paulburton@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Paul Burton wrote:
> Commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
> architecture.") enabled our eBPF JIT for MIPS32 kernels, whereas it has
> previously only been availailable for MIPS64. It was my understanding at
> the time that the BPF test suite was passing & JITing a comparable
> number of tests to our cBPF JIT [1], but it turns out that was not the
> case.
> 
> The eBPF JIT has a number of problems on MIPS32:
> 
> - Most notably various code paths still result in emission of MIPS64
>   instructions which will cause reserved instruction exceptions & kernel
>   panics when run on MIPS32 CPUs.
> 
> - The eBPF JIT doesn't account for differences between the O32 ABI used
>   by MIPS32 kernels versus the N64 ABI used by MIPS64 kernels. Notably
>   arguments beyond the first 4 are passed on the stack in O32, and this
>   is entirely unhandled when JITing a BPF_CALL instruction. Stack space
>   must be reserved for arguments even if they all fit in registers, and
>   the callee is free to assume that stack space has been reserved for
>   its use - with the eBPF JIT this is not the case, so calling any
>   function can result in clobbering values on the stack & unpredictable
>   behaviour. Function arguments in eBPF are always 64-bit values which
>   is also entirely unhandled - the JIT still uses a single (32-bit)
>   register per argument. As a result all function arguments are always
>   passed incorrectly when JITing a BPF_CALL instruction, leading to
>   kernel crashes or strange behavior.
> 
> - The JIT attempts to bail our on use of ALU64 instructions or 64-bit
>   memory access instructions. The code doing this at the start of
>   build_one_insn() incorrectly checks whether BPF_OP() equals BPF_DW,
>   when it should really be checking BPF_SIZE() & only doing so when
>   BPF_CLASS() is one of BPF_{LD,LDX,ST,STX}. This results in false
>   positives that cause more bailouts than intended, and that in turns
>   hides some of the problems described above.
> 
> - The kernel's cBPF->eBPF translation makes heavy use of 64-bit eBPF
>   instructions that the MIPS32 eBPF JIT bails out on, leading to most
>   cBPF programs not being JITed at all.
> 
> Until these problems are resolved, revert the removal of the cBPF JIT &
> the enabling of the eBPF JIT on MIPS32 done by commit 716850ab104d
> ("MIPS: eBPF: Initial eBPF support for MIPS32 architecture.").
> 
> Note that this does not undo the changes made to the eBPF JIT by that
> commit, since they are a useful starting point to providing MIPS32
> support - they're just not nearly complete.
> 
> [1] https://lore.kernel.org/linux-mips/MWHPR2201MB13583388481F01A422CE7D66D4410@MWHPR2201MB1358.namprd22.prod.outlook.com/

Applied to mips-fixes.

> commit c409cd05ab7f
> https://git.kernel.org/mips/c/c409cd05ab7f
> 
> Signed-off-by: Paul Burton <paulburton@kernel.org>
> Fixes: 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32 architecture.")

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
