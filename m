Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151711C1DCC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgEATWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:22:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43805 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726045AbgEATWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588360936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lw1/q6yiSjaJYWPZdVrBNcZFPbxM0G0lNYnc8X95Tg0=;
        b=KIkn2JNSgjLlYG7AsOZQ+LgXs5M4PFjrD56iaMiXxlIhYROM9xVo93e7zvHAz8Z0MDqE3M
        npUmT68gx9xNZMpUXDIRa7MUCV7K/28daROPWG647k3pOBQAbjyEPpsv0M42fFR2GJIJo4
        ZgxMnmMbVwHhMGz/Pt9xV1IkRQnQs/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-daBVEp11O9maB_fvViMN5g-1; Fri, 01 May 2020 15:22:14 -0400
X-MC-Unique: daBVEp11O9maB_fvViMN5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98EEF19067E3;
        Fri,  1 May 2020 19:22:12 +0000 (UTC)
Received: from treble (ovpn-114-104.rdu2.redhat.com [10.10.114.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 252DD6152A;
        Fri,  1 May 2020 19:22:11 +0000 (UTC)
Date:   Fri, 1 May 2020 14:22:04 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200501192204.cepwymj3fln2ngpi@treble>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 12:09:30PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 30, 2020 at 02:07:43PM -0500, Josh Poimboeuf wrote:
> > Objtool decodes instructions and follows all potential code branches
> > within a function.  But it's not an emulator, so it doesn't track
> > register values.  For that reason, it usually can't follow
> > intra-function indirect branches, unless they're using a jump table
> > which follows a certain format (e.g., GCC switch statement jump tables).
> > 
> > In most cases, the generated code for the BPF jump table looks a lot
> > like a GCC jump table, so objtool can follow it.  However, with
> > RETPOLINE=n, GCC keeps the jump table address in a register, and then
> > does 160+ indirect jumps with it.  When objtool encounters the indirect
> > jumps, it can't tell which jump table is being used (or even whether
> > they might be sibling calls instead).
> > 
> > This was fixed before by disabling an optimization in ___bpf_prog_run(),
> > using the "optimize" function attribute.  However, that attribute is bad
> > news.  It doesn't append options to the command-line arguments.  Instead
> > it starts from a blank slate.  And according to recent GCC documentation
> > it's not recommended for production use.  So revert the previous fix:
> > 
> >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > 
> > With that reverted, solve the original problem in a different way by
> > getting rid of the "goto select_insn" indirection, and instead just goto
> > the jump table directly.  This simplifies the code a bit and helps GCC
> > generate saner code for the jump table branches, at least in the
> > RETPOLINE=n case.
> > 
> > But, in the RETPOLINE=y case, this simpler code actually causes GCC to
> > generate far worse code, ballooning the function text size by +40%.  So
> > leave that code the way it was.  In fact Alexei prefers to leave *all*
> > the code the way it was, except where needed by objtool.  So even
> > non-x86 RETPOLINE=n code will continue to have "goto select_insn".
> > 
> > This stuff is crazy voodoo, and far from ideal.  But it works for now.
> > Eventually, there's a plan to create a compiler plugin for annotating
> > jump tables.  That will make this a lot less fragile.
> 
> I don't like this commit log.
> Here you're saying that the code recognized by objtool is sane and good
> whereas well optimized gcc code is somehow voodoo and bad.
> That is just wrong.

I have no idea what you're talking about.

Are you saying that ballooning the function text size by 40% is well
optimized GCC code?  It seems like a bug to me.  That's the only place I
said anything bad about GCC code.

When I said "this stuff is crazy voodoo" I was referring to the patch
itself.  I agree it's horrible, it's only the best approach we're able
to come up with at the moment.

If any of that isn't clear then can you provide specifics about what
seems wrong?

-- 
Josh

