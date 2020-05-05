Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CBD1C6209
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgEEU2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:28:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729265AbgEEU2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588710513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lsuCFXl/9WOx+SBnmB7pmiseEGcoxnWbSyyl0YYGeOg=;
        b=LvPkxzo1mOIlFajscp9hsiYJy2vUnoBZG05TysqaAkFdLOfAcac4fCGk+b1adseX3i8jYT
        kN5DzaGcmyhkf8Kkx0mNkQdG+nEHnwWXN+oIhw1ycr5pj7xfUIofqb7ILdyNHnCepYNqbX
        Z+2t9PimrvJJeZIrpQF8maFDTDbd5sw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-P4G-wqi_OwKaMgqGSpAdZg-1; Tue, 05 May 2020 16:28:29 -0400
X-MC-Unique: P4G-wqi_OwKaMgqGSpAdZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BC56100CCC2;
        Tue,  5 May 2020 20:28:28 +0000 (UTC)
Received: from treble (ovpn-119-47.rdu2.redhat.com [10.10.119.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F06319C58;
        Tue,  5 May 2020 20:28:25 +0000 (UTC)
Date:   Tue, 5 May 2020 15:28:23 -0500
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
Message-ID: <20200505202823.zkmq6t55fxspqazk@treble>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <20200505181108.hwcqanvw3qf5qyxk@treble>
 <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505195320.lyphpnprn3sjijf6@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 12:53:20PM -0700, Alexei Starovoitov wrote:
> On Tue, May 05, 2020 at 01:11:08PM -0500, Josh Poimboeuf wrote:
> > On Tue, May 05, 2020 at 10:43:00AM -0700, Alexei Starovoitov wrote:
> > > > Or, if you want to minimize the patch's impact on other arches, and keep
> > > > the current patch the way it is (with bug fixed and changed patch
> > > > description), that's fine too.  I can change the patch description
> > > > accordingly.
> > > > 
> > > > Or if you want me to measure the performance impact of the +40% code
> > > > growth, and *then* decide what to do, that's also fine.  But you'd need
> > > > to tell me what tests to run.
> > > 
> > > I'd like to minimize the risk and avoid code churn,
> > > so how about we step back and debug it first?
> > > Which version of gcc are you using and what .config?
> > > I've tried:
> > > Linux version 5.7.0-rc2 (gcc version 10.0.1 20200505 (prerelease) (GCC)
> > > CONFIG_UNWINDER_ORC=y
> > > # CONFIG_RETPOLINE is not set
> > > 
> > > and objtool didn't complain.
> > > I would like to reproduce it first before making any changes.
> > 
> > Revert
> > 
> >   3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")
> > 
> > and compile with retpolines off (and either ORC or FP, doesn't matter).
> > 
> > I'm using GCC 9.3.1:
> > 
> >   kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8dc: sibling call from callable instruction with modified stack frame
> > 
> > That's the original issue described in that commit.
> 
> I see something different.
> With gcc 8, 9, and 10 and CCONFIG_UNWINDER_FRAME_POINTER=y
> I see:
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x4837: call without frame pointer save/setup
> and sure enough assembly code for ___bpf_prog_run does not countain frame setup
> though -fno-omit-frame-pointer flag was passed at command line.
> Then I did:
> static u64 /*__no_fgcse*/ ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> and the assembly had proper frame, but objtool wasn't happy:
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x480a: sibling call from callable instruction with modified stack frame
> 
> gcc 6.3 doesn't have objtool warning with and without -fno-gcse.
> 
> Looks like we have two issues here.
> First gcc 8, 9 and 10 have a severe bug with __attribute__((optimize("")))
> In this particular case passing -fno-gcse somehow overruled -fno-omit-frame-pointer
> which is serious issue. powerpc is using __nostackprotector. I don't understand
> how it can keep working with newer gcc-s. May be got lucky.
> Plenty of other projects use various __attribute__((optimize("")))
> they all have to double check that their vesion of GCC produces correct code.
> Can somebody reach out to gcc folks for explanation?

Right.  I've mentioned this several times now.  That's why my patch
reverts 3193c0836f20.  I don't see any other way around it.  The GCC
manual even says this attribute should not be used in production code.

> The second objtool issue is imo minor one. It can be worked around for now
> and fixed for real later.

Ok, so keep the patch like v1 (but with the bug fixed)?  Or did you want
to get rid of 'goto select_insn' altogether?

> > > Also since objtool cannot follow the optimizations compiler is doing
> > > how about admit the design failure and teach objtool to build ORC
> > > (and whatever else it needs to build) based on dwarf for the functions where
> > > it cannot understand the assembly code ?
> > > Otherwise objtool will forever be playing whackamole with compilers.
> > 
> > I agree it's not a good long term approach.  But DWARF has its own
> > issues and we can't rely on it for live patching.
> 
> Curious what is the issue with dwarf and live patching ?
> I'm sure dwarf is enough to build ORC tables.

DWARF is a best-effort thing, but for live patching, unwinding has to be
100% accurate.

For assembly code it was impossible to keep all the DWARF CFI
annotations always up to date and to ensure they were correct.

Even for C code there were DWARF problems with inline asm, alternatives
patching, jump labels, etc.

> > As I mentioned we have a plan to use a compiler plugin to annotate jump
> > tables (including GCC switch tables).  But the approach taken by this
> > patch should be good enough for now.
> 
> I don't have gcc 7 around. Could you please test the workaround with gcc 7,8,9,10
> and several clang versions? With ORC and with FP ? and retpoline on/off ?
> I don't see any issues with ORC=y. objtool complains with FP=y only for my configs.
> I want to make sure the workaround is actually effective.

Again, if you revert 3193c0836f20, you will see the issue...

I can certainly test on the matrix of compilers/configs you suggested.

-- 
Josh

