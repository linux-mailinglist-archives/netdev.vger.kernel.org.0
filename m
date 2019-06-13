Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2544DE9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfFMU5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:57:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35946 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:57:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so25047pfl.3;
        Thu, 13 Jun 2019 13:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BtC4BilPXcpmyt5suyyuknm5yJ5dekLmfPkwrs0lDyo=;
        b=l7h3UqwPRUzXunatj9GeXQPagkIYS3fwPOzBdCg/FeZym4FFgbeee+e49LZY/o05i1
         66vKspp5NxgejbL0BNJe8VkcyIxSqUiU66casxh9LHTF8qVAe0HFMZfWf6WLKMQ0PRYk
         h4pmMm3xDISqXvKKJWliqCs44hikm5sdOD/8tuqVdfIAtZJNNsSOyTR9JU6tC3sZ1qfS
         cJclzg8aeltLnXtRe0DIKLqIJpBOEqFnrqc4TiJk1sYgkI8n9lW7763/VgY1XHzpActZ
         Lap0/XwdCjvlRl6gtWrcLN1s2f4wkEnert1VB4eGE1K5lgPYGppzkV1pom0dsy7KwLUQ
         KgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BtC4BilPXcpmyt5suyyuknm5yJ5dekLmfPkwrs0lDyo=;
        b=uTEU2+4N9DUOTWM6n4e3/VE+McahGYvqCJ+WuBMxx6tqvh1yad2OHpljqzEleQwY2d
         aYGVxnNRmqQhaYWr2UUDAHI0AZoaUAqK0gakJMW3dWCMzu/b1tO77y82BimvH9/3s7gH
         tnv6T1Ncjpcxf3yHKIS+WgSEFtgSEBFfEWY+7Jtycf3Hl4fLAs2NSo8Q2aDriOsi7gCE
         m0c16qAsdcy0ikG20eKkffi8bycgo5SrFNPc79Aq/LGB00Rafx3k7XHFaz8nHd/UGNDV
         VFBVIcAKS04JHbM71GTnZDkIdJYAM9ZLRu4uEK7Jj/pb1r5WWl+cg1xYdQtqiJPTqQ2z
         9wdA==
X-Gm-Message-State: APjAAAUV3BlMmpH4kGAa3WF2tfMZus3gsFGUOlSV8EBSovHihxV4LF1k
        RMndW/vrrmQTWpY6odh+90U=
X-Google-Smtp-Source: APXvYqy93JdU6sSS6VvlFU4kJ7BzPMps3N225NBRvnJzsev5WERcIO26vy82EyoAiVeTvxaQiUPAmg==
X-Received: by 2002:a63:6b07:: with SMTP id g7mr33523317pgc.325.1560459433726;
        Thu, 13 Jun 2019 13:57:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id m2sm620992pgq.48.2019.06.13.13.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 13:57:12 -0700 (PDT)
Date:   Thu, 13 Jun 2019 13:57:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:20:59AM -0500, Josh Poimboeuf wrote:
> Objtool currently ignores ___bpf_prog_run() because it doesn't
> understand the jump table.  This results in the ORC unwinder not being
> able to unwind through non-JIT BPF code.
> 
> Luckily, the BPF jump table resembles a GCC switch jump table, which
> objtool already knows how to read.
> 
> Add generic support for reading any static local jump table array named
> "jump_table", and rename the BPF variable accordingly, so objtool can
> generate ORC data for ___bpf_prog_run().
> 
> Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> Reported-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  kernel/bpf/core.c     |  5 ++---
>  tools/objtool/check.c | 16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 7c473f208a10..aa546ef7dbdc 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>  {
>  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
>  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> -	static const void *jumptable[256] = {
> +	static const void *jump_table[256] = {

Nack to the change like above and to patches 8 and 9.
Everyone has different stylistic preferences.
My preference is to keep things as they are.

Please respin the rest. We'll take it via bpf tree.

