Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF049C175
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbiAZCud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiAZCuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60271C06161C;
        Tue, 25 Jan 2022 18:50:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E5E3B81BAA;
        Wed, 26 Jan 2022 02:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F18C340E0;
        Wed, 26 Jan 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643165429;
        bh=l0nYb71ICznF0TC6Otf2R+7zNuB27L/PI6WFuEk/bRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A1Sk+jI8A4ppe6yNMZs7A4lOWJeH4o4D76v1sBfquSHylnCf8SSiVk2vkp4KcHxBS
         PbK6t11Zy6Zw8rMYK0PlyARP/LF3mWIe+2sqko99rWmAeJTJWT84dJm19NWV330n5R
         5S+JUETGcX+gwNtuij/udiJQJL12IfJaC2bekPXAjVn3updaiwz+Kxzi4i2dRufKH/
         NBRJAkzBYagAME5rlVJFiIx9xqSR3dTXKaFqvfdnpEwpjKyhrLZrQTa9LuCPZdk/hu
         fBAPHDxOqc3JEqtbJRgfakf/RpgKHpOFWUrm0y4OR7hOjvI8YzhCFR53a0bEiEVBQG
         Dfni+OQ7glvaQ==
Date:   Wed, 26 Jan 2022 11:50:22 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 2/9] fprobe: Add ftrace based probe APIs
Message-Id: <20220126115022.fda21a3face4e97684f5bab9@kernel.org>
In-Reply-To: <YfA9aC5quQNc89Hc@krava>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311271777.1933078.9066058105807126444.stgit@devnote2>
        <YfAoMW6i4gqw2Na0@krava>
        <YfA9aC5quQNc89Hc@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 19:11:52 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Jan 25, 2022 at 05:41:24PM +0100, Jiri Olsa wrote:
> > On Tue, Jan 25, 2022 at 09:11:57PM +0900, Masami Hiramatsu wrote:
> > 
> > SNIP
> > 
> > > +
> > > +/* Convert ftrace location address from symbols */
> > > +static int convert_func_addresses(struct fprobe *fp)
> > > +{
> > > +	unsigned long addr, size;
> > > +	unsigned int i;
> > > +
> > > +	/* Convert symbols to symbol address */
> > > +	if (fp->syms) {
> > > +		fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
> > > +		if (!fp->addrs)
> > > +			return -ENOMEM;
> > > +
> > > +		for (i = 0; i < fp->nentry; i++) {
> > > +			fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
> > > +			if (!fp->addrs[i])	/* Maybe wrong symbol */
> > > +				goto error;
> > > +		}
> > > +	}
> > > +
> > > +	/* Convert symbol address to ftrace location. */
> > > +	for (i = 0; i < fp->nentry; i++) {
> > > +		if (!kallsyms_lookup_size_offset(fp->addrs[i], &size, NULL))
> > > +			size = MCOUNT_INSN_SIZE;
> > > +		addr = ftrace_location_range(fp->addrs[i], fp->addrs[i] + size);
> > 
> > you need to substract 1 from 'end' in here, as explained in
> > __within_notrace_func comment:
> > 
> >         /*
> >          * Since ftrace_location_range() does inclusive range check, we need
> >          * to subtract 1 byte from the end address.
> >          */
> > 
> > like in the patch below

Good catch, I missed that point.

> > also this convert is for archs where address from kallsyms does not match
> > the real attach addresss, like for arm you mentioned earlier, right?

Yes, that's right.

> > 
> > could we have that arch specific, so we don't have extra heavy search
> > loop for archs that do not need it?

Hmm, is that so heavy? Even though, this kind of convertion is better
to be implemented in the arch-specific ftrace. They may know the
best way to do, because the offset is fixed for each arch.

> 
> one more question..
> 
> I'm adding support for user to pass function symbols to bpf fprobe link
> and I thought I'd pass symbols array to register_fprobe, but I'd need to
> copy the whole array of strings from user space first, which could take
> lot of memory considering attachment of 10k+ functions
> 
> so I'm thinking better way is to resolve symbols already in bpf fprobe
> link code and pass just addresses to register_fprobe

That is OK. Fprobe accepts either ::syms or ::addrs.

> 
> I assume you want to keep symbol interface, right? could we have some
> flag ensuring the conversion code is skipped, so we don't go through
> it twice?

Yeah, we still have many unused bits in fprobe::flags. :)

Thank you,

> in any case I need addresses before I call register_fprobe, because
> of the bpf cookies setup
> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
