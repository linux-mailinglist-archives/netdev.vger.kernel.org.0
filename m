Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822DE44BD4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 21:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfFMTML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 15:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfFMTML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 15:12:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DA4085A03;
        Thu, 13 Jun 2019 19:12:11 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C1C11001B06;
        Thu, 13 Jun 2019 19:12:10 +0000 (UTC)
Date:   Thu, 13 Jun 2019 14:12:08 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 3/9] x86/bpf: Move epilogue generation to a dedicated
 function
Message-ID: <20190613191208.s7m7ijkcsagaxotv@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <b091755f6053b4a3f66de9c168d4f73a751a5661.1560431531.git.jpoimboe@redhat.com>
 <A753FBC1-3781-4A47-B0AD-A4300C552F7B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A753FBC1-3781-4A47-B0AD-A4300C552F7B@fb.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 13 Jun 2019 19:12:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 06:57:10PM +0000, Song Liu wrote:
> 
> 
> > On Jun 13, 2019, at 6:21 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > Improve code readability by moving the BPF JIT function epilogue
> > generation code to a dedicated emit_epilogue() function, analagous to
> > the existing emit_prologue() function.
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > ---
> > arch/x86/net/bpf_jit_comp.c | 37 ++++++++++++++++++++++++-------------
> > 1 file changed, 24 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 32bfab4e21eb..da8c988b0f0f 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -240,6 +240,28 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
> > 	*pprog = prog;
> > }
> > 
> > +static void emit_epilogue(u8 **pprog)
> > +{
> > +	u8 *prog = *pprog;
> > +	int cnt = 0;
> > +
> > +	/* mov rbx, qword ptr [rbp+0] */
> > +	EMIT4(0x48, 0x8B, 0x5D, 0);
> > +	/* mov r13, qword ptr [rbp+8] */
> > +	EMIT4(0x4C, 0x8B, 0x6D, 8);
> > +	/* mov r14, qword ptr [rbp+16] */
> > +	EMIT4(0x4C, 0x8B, 0x75, 16);
> > +	/* mov r15, qword ptr [rbp+24] */
> > +	EMIT4(0x4C, 0x8B, 0x7D, 24);
> 
> Shall we update these comments to AT&T syntax? 

Yes, but they're updated with all the others in patch 8.

-- 
Josh
