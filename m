Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1345137
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFNBhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:37:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41077 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfFNBhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 21:37:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so356208pff.8;
        Thu, 13 Jun 2019 18:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=altUb3OMBtP8Eh07qNkDfpDAn+USTPOIX/hShosp1Xc=;
        b=XJBwkrzMdLZMwxwG7Ipf+Xxl2X4rLcbpw0aP80k81tld6+TUBIFK0lwC5YaTkeYeR2
         BcPsStqeMgPIklbdgPRHcW/gXFcdQ/bn6qpZFkO00dbkE8Mp+BFNctamAnUOIb4CBZxF
         o11yjRygE6p4ZkZ6A8ZgkKzbVGHhWPLcPn36eXIf4xw/qSCSGIwU5+Ac5wq3yFNfGHzz
         B8WJRGFLNNgIuqehbJdxmXyLgRm7x5ngRNDSfBi9N7JoDjnUlqEqnm3UCuJDHxVxeYJe
         OUkylrCCS/+0DxFN8jWhhp9NHWC+SCldcCvmNl+iIUWFa8p6jJ7iEfTAHaJ9KSDph/QL
         cAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=altUb3OMBtP8Eh07qNkDfpDAn+USTPOIX/hShosp1Xc=;
        b=lkuNqA9z4mz3d0dNrswyZsgfJAYe8xqnNwkTvcVQ4uEzsVVKm5n6f/Gck+NJhNMdMa
         0RieW0MF55L6ewRcz35MgPfaw8VgitlyuFbPYsfO72ID7Jo6QWfJtKecgurtRvwH3OVa
         FrOuWghhBlaWlunymnGtfZkiRNClrc+sFrog+2ivHaujVHK69nXmz16t/xPTp4g9AhnT
         9iWTO6DP+8XITccEinNxt1lKSazhsshlEMVUmPaCvAfH+8tDjXp4XXK7eHSGTWyNCpbl
         heJmSimmPgBvoKsxJNdmMULQPA2NrVctD4f4RgPXqqBPx2pxHU+ez9Gi/8IiuKR6mf0C
         L8tg==
X-Gm-Message-State: APjAAAWeWjGvHLIy+wGqGr7FLu3CHPOc4a+yPkGRzOoNNXdpZmWmwXuK
        uzbuJyUUQratemSZCVw1QwEgsez0
X-Google-Smtp-Source: APXvYqzb+54d3soTbagGqljguNXxbS+mE9dmSVvIjM8T2QhmZ3MiqSk2+1hIgFIwNc8V2HqEEyOsvg==
X-Received: by 2002:aa7:86c6:: with SMTP id h6mr59334374pfo.51.1560476243670;
        Thu, 13 Jun 2019 18:37:23 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e034])
        by smtp.gmail.com with ESMTPSA id d5sm919301pfn.25.2019.06.13.18.37.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 18:37:22 -0700 (PDT)
Date:   Thu, 13 Jun 2019 18:37:21 -0700
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
Message-ID: <20190614013719.eqwpqfxukh6nhgec@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614012030.b6eujm7b4psu62kj@treble>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> > On Thu, Jun 13, 2019 at 08:20:59AM -0500, Josh Poimboeuf wrote:
> > > Objtool currently ignores ___bpf_prog_run() because it doesn't
> > > understand the jump table.  This results in the ORC unwinder not being
> > > able to unwind through non-JIT BPF code.
> > > 
> > > Luckily, the BPF jump table resembles a GCC switch jump table, which
> > > objtool already knows how to read.
> > > 
> > > Add generic support for reading any static local jump table array named
> > > "jump_table", and rename the BPF variable accordingly, so objtool can
> > > generate ORC data for ___bpf_prog_run().
> > > 
> > > Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> > > Reported-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > ---
> > >  kernel/bpf/core.c     |  5 ++---
> > >  tools/objtool/check.c | 16 ++++++++++++++--
> > >  2 files changed, 16 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index 7c473f208a10..aa546ef7dbdc 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
> > >  {
> > >  #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
> > >  #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
> > > -	static const void *jumptable[256] = {
> > > +	static const void *jump_table[256] = {
> > 
> > Nack to the change like above
> 
> "jump table" is two words, so does it not make sense to separate them
> with an underscore for readability?
> 
> I created a generic feature in objtool for this so that other code can
> also use it.  So a generic name (and typical Linux naming convention --
> separating words with an underscore) makes sense here.
> 
> > and to patches 8 and 9.
> 
> Well, it's your code, but ... can I ask why?  AT&T syntax is the
> standard for Linux, which is in fact the OS we are developing for.
> 
> It makes the code extra confusing for it to be annotated differently
> than all other Linux asm code.  And due to the inherent complexity of
> generating code at runtime, I'd think we'd want to make the code as
> readable as possible, for as many people as possible (i.e. other Linux
> developers).

imo your changes make it less readable.
please do not randomly change names and style based on your own preferences.
dst=src
mov(dst,src)
memcpy(dst,src)
if people want to have more bugs in assembler code. it's their call.
bpf_jit_comp.c is C code. dest is on the left.

