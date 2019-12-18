Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708921243CF
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfLRJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:58:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40554 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRJ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:58:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so1552308wrn.7;
        Wed, 18 Dec 2019 01:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4gCEwMrzGEp0PafQu7jqK62ZOCsdnowi5XDGGZ+zVJY=;
        b=J1QNKW/ieilFTPsrWlAC5PS/C3RaNdnZ23FJVQVpA5MLRp7i8vD72QUIZvaeYWeyuw
         p2eHARJptM481V76mlEFn5Q7W+1TYDYaiYs3HHdqygTtWssqOLYay0afWETrM6e1C2Gk
         0MAV9ghHSF1gFJWc+M8ROZgVxiAEIqLZt+6MZlhi4SKA7eE8PhPtTg6xtVz/u5DawE5F
         e7JgLBvDRHnNATrufz8JxBvnnnLvt/YzPj9HRbIH7mA0P0iccy9Gh50r70npUs6Nq1pv
         9tqPyr/ydEBQ+jAR/9q0rWcvZxeN9oNqbW7hqeiZSHmqE9Hl9t9qmZJXVLj6cf3yPB7L
         /ctA==
X-Gm-Message-State: APjAAAUYRAlmi/NpyiswB6hBliePvXjT2FPOFMp5NmVnX9HYdbVCbpPt
        GbLFHTXFtrJ4eH8L/TNUMCW+F5guMGKdEQ==
X-Google-Smtp-Source: APXvYqxnvWlJct0mJAV49aoG9AD31ca03zMZ8am3c7F0guaUTcjE9cXv/LfawnGw6YKOOMoXvpd1aw==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr1701044wrj.325.1576663106946;
        Wed, 18 Dec 2019 01:58:26 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id g9sm2090584wro.67.2019.12.18.01.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 01:58:26 -0800 (PST)
Date:   Wed, 18 Dec 2019 10:58:25 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Paul Burton <paulburton@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 2/2] bpf, mips: limit to 33 tail calls
Message-ID: <20191218095825.GA15840@Omicron>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
 <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
 <20191210232316.aastpgbirqp4yaoi@lantea.localdomain>
 <8cf09e73329b3205a64eae4886b02fea@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8cf09e73329b3205a64eae4886b02fea@dlink.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:32:53PM +0300, Alexander Lobakin wrote:
> Paul Burton wrote 11.12.2019 02:23:
> > Hi Paul,
> > 
> > On Mon, Dec 09, 2019 at 07:52:52PM +0100, Paul Chaignon wrote:
> > > All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail
> > > calls
> > > limit at runtime.  In addition, a test was recently added, in
> > > tailcalls2,
> > > to check this limit.
> > > 
> > > This patch updates the tail call limit in MIPS' JIT compiler to allow
> > > 33 tail calls.
> 
> Hi Paul,
> 
> You've restored MIPS cBPF in mips-fixes tree, doesn't it require any
> changes to limit tail calls to 33? This series includes only eBPF as
> there was no MIPS cBPF at the moment of writing.

cBPF doesn't support tail calls or even the call instruction for
helpers.

Paul C.

> 
> > > Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
> > > Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
> > > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> > 
> > I'd be happy to take this through mips-fixes, but equally happy for it
> > to go through the BPF/net trees in which case:
> > 
> >   Acked-by: Paul Burton <paulburton@kernel.org>
> > 
> > Thanks,
> >     Paul
> > 
> > > ---
> > >  arch/mips/net/ebpf_jit.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
> > > index 46b76751f3a5..3ec69d9cbe88 100644
> > > --- a/arch/mips/net/ebpf_jit.c
> > > +++ b/arch/mips/net/ebpf_jit.c
> > > @@ -604,6 +604,7 @@ static void emit_const_to_reg(struct jit_ctx
> > > *ctx, int dst, u64 value)
> > >  static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
> > >  {
> > >  	int off, b_off;
> > > +	int tcc_reg;
> > > 
> > >  	ctx->flags |= EBPF_SEEN_TC;
> > >  	/*
> > > @@ -616,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx
> > > *ctx, int this_idx)
> > >  	b_off = b_imm(this_idx + 1, ctx);
> > >  	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
> > >  	/*
> > > -	 * if (--TCC < 0)
> > > +	 * if (TCC-- < 0)
> > >  	 *     goto out;
> > >  	 */
> > >  	/* Delay slot */
> > > -	emit_instr(ctx, daddiu, MIPS_R_T5,
> > > -		   (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4, -1);
> > > +	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
> > > +	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
> > >  	b_off = b_imm(this_idx + 1, ctx);
> > > -	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
> > > +	emit_instr(ctx, bltz, tcc_reg, b_off);
> > >  	/*
> > >  	 * prog = array->ptrs[index];
> > >  	 * if (prog == NULL)
> > > --
> > > 2.17.1
> > > 
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
