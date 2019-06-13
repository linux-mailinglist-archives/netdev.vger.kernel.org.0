Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8537644ED3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfFMV6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:58:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40477 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfFMV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:58:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so92389pla.7;
        Thu, 13 Jun 2019 14:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UgX/twFRvWeH3GOio6+WgkRLrlXF1WlNpv4jZgJXeN4=;
        b=iWMgkqUtLROkrabF/g8NyTx6+PxfvDT4al+AvzYnirt8OFYTAHZ7DGd0EL0xU9WUX8
         niJa2m/EpWdjOaaJMjv1yBARfXIV4tP74lELKvoFddDHa+WYuqNIBksCs8DlSt9WUNkk
         qGWwp1jJ+0PGO+LkI/RgtBnmy6nD0GEMah/pZRJchpdlC8b8UufXDCj9yc5v/i9dn4AR
         tfDRByjHm55StncPfXVqphTDPip4aq/AxQlQr/ZAq1IMDvWfXBqitYFgEryQsGlOgCJN
         hxKejuzc+3dWEeZoIeTEf/vRAAbYSjOaeGL2XZASmxJhphWcOeYnpIsQDLB9Sz3/czFP
         IR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UgX/twFRvWeH3GOio6+WgkRLrlXF1WlNpv4jZgJXeN4=;
        b=qEC39tZqeLAt2KiuTRzubspgO1MiZyhnWYI6tv8fbuNe7Gij8QCblkR/9/vL5+fORD
         vEQMHpmm721w9LuOTAaW5USmXTk6D5tBIKDtxARYKfRzXiD9kxVoikF2hzIS68ZUV7m1
         /4Ap+24plkSJkdp14E/VECKg7FMnqt9VVwRA1DLfs+ZiigMol+P6i3byRDct81qLmuo2
         q1a95LdQbu5qfY2dCRwvTf6Gym4vTURrTUk94s3bTT4ZT56dPU1QsIKxhWCAMdEZd8iM
         V7yVN8/HMJ0Tw1g7D7A+ybwSiwKD79LCtK0Y0Uw0li/zBblyZp1QyraHfKvK2IcQsTHD
         wI/A==
X-Gm-Message-State: APjAAAW7pD1VvceHAd3vhtPkUUMkPvsyPgnCxJidofJO8tZUO1qqWghx
        HKYuWbdG6D6DkUGy7aIdoac=
X-Google-Smtp-Source: APXvYqyCot9boqYe3zZh8zf9o7E8QgZclmSm+JdTGJT6yfBNMz2PM0EDuRtr1EmljLaYdC+4MnjyMA==
X-Received: by 2002:a17:902:830c:: with SMTP id bd12mr12011539plb.237.1560463091883;
        Thu, 13 Jun 2019 14:58:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id j7sm595663pfa.184.2019.06.13.14.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 14:58:11 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:58:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Message-ID: <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:21:03AM -0500, Josh Poimboeuf wrote:
> The BPF JIT code clobbers RBP.  This breaks frame pointer convention and
> thus prevents the FP unwinder from unwinding through JIT generated code.
> 
> RBP is currently used as the BPF stack frame pointer register.  The
> actual register used is opaque to the user, as long as it's a
> callee-saved register.  Change it to use R12 instead.
> 
> Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> Reported-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 43 +++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index e649f977f8e1..bb1968fea50a 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -100,9 +100,8 @@ static int bpf_size_to_x86_bytes(int bpf_size)
>  /*
>   * The following table maps BPF registers to x86-64 registers.
>   *
> - * x86-64 register R12 is unused, since if used as base address
> - * register in load/store instructions, it always needs an
> - * extra byte of encoding and is callee saved.
> + * RBP isn't used; it needs to be preserved to allow the unwinder to move
> + * through generated code stacks.

Extra register save/restore is kinda annoying just to fix ORC.
Also every stack access from bpf prog will be encoded via r12 and consume
extra byte of encoding. I really don't like this approach.
Can you teach ORC to understand JIT-ed frames instead?

