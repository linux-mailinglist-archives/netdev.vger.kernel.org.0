Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4153A41D22C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346396AbhI3EUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 00:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhI3EUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 00:20:33 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F00C06161C;
        Wed, 29 Sep 2021 21:18:51 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id r4so10237169ybp.4;
        Wed, 29 Sep 2021 21:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BM3+YuEPCCFf8tnVNn41FpirshNfW0x9wEl2P7HQvXo=;
        b=BYDEpv9+qB5pI+2ZbITPdpCaidM0xuiXrlS/vk8ZE+e9VsLS6ubwW0ac2bu48KuvP0
         cUKCPv5ncs5Iw/f9M4IRMQPuQRMkX0+elSxZMPWM15rwRBwn9V8zjuIzI8YWuaD0PKBM
         dWTjGkLLds3Vh+xf5N/mxUctiZxAxEqBCuqriiWdmF4yU1/kvTR3y0LWBEAk65ZSAWIO
         Hs9quGpVfZ3YOhy+9fnOse40ScFdFRmMMBaiQwkISuxjvNhSWSLD/Z6/0kZwoJ/Wa6G6
         SVvRodICbq8NWb4/SRBs3wUhAv7JG5A7Z4yFq/7sRY90QdkRC+bTtqQz5qv0yR6m1HBM
         oZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BM3+YuEPCCFf8tnVNn41FpirshNfW0x9wEl2P7HQvXo=;
        b=W0CFOCgNUixKgVNahH8WNGD5jPip6y+TOAc7XMf2koSPt2QvHSlKC7hT4vxWWfr5tk
         mZgwKvGweS4b1BS/Ht/DRyo5GlJEUaU5Q9eW3dnTh7dQL3cpDfTkhZ38leVGh289xEH7
         TKVPk/524mtTC0ZtihSTUS1NpgVXMeHNbo5NjZHODeccwEAZrtnJnDC+EEBP/6PtCYP/
         Ij+rrg48OtiD/e+qg99/bLAQPsfnVgdWFtvH12sxeTDQJBg6yBruEpVuphW1278bAC6m
         vqCinpfLr6pdxJ2qObQa/iNdoqVAWqmqDOiBnP9U3he5vHR1MRr+9Mh+2TrXdqNLzeJz
         JxyQ==
X-Gm-Message-State: AOAM530eU6cP+ECCpiQorqmvKB0kM3E10EDjvZlD8kRNediN36CudTQH
        tp47B64OoYu+BhSGVY/Q1qcVGvgefutfPYu4Yis=
X-Google-Smtp-Source: ABdhPJxG9/V7h+JBx/vEOn0pfzD+Ov8bHsUw3MTd1M/mwB81H3w/MY0nqdiSQwYQshUykI5r2CPfec288HVjabf6hHM=
X-Received: by 2002:a25:5402:: with SMTP id i2mr4240704ybb.312.1632975530282;
 Wed, 29 Sep 2021 21:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
 <20210929111855.50254-6-hbathini@linux.ibm.com> <9628c18d-001e-9777-e800-486a83844ac1@csgroup.eu>
In-Reply-To: <9628c18d-001e-9777-e800-486a83844ac1@csgroup.eu>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Thu, 30 Sep 2021 14:18:38 +1000
Message-ID: <CACzsE9oNCaXoizCt-KzKS48A1L7v4_em-nLVfVLeeuWky1mrTA@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Hari Bathini <hbathini@linux.ibm.com>, naveen.n.rao@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        songliubraving@fb.com, netdev@vger.kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kpsingh@kernel.org,
        Paul Mackerras <paulus@samba.org>, yhs@fb.com,
        bpf@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        kafai@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 9:50 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 29/09/2021 =C3=A0 13:18, Hari Bathini a =C3=A9crit :
> > From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> >
> > BPF load instruction with BPF_PROBE_MEM mode can cause a fault
> > inside kernel. Append exception table for such instructions
> > within BPF program.
> >
> > Unlike other archs which uses extable 'fixup' field to pass dest_reg
> > and nip, BPF exception table on PowerPC follows the generic PowerPC
>
>
> For my curiosity, can you explain why we don't want and can't do the
> same on powerpc as on other archs ?

The main thing is on x86, the extable has another field , handler:
struct exception_table_entry { int insn, fixup, handler; };
handler can be used to perform other things before continuing on to fixup.
So for bpf the handler is used to clear the dest register (which is
encoded in the low byte of fixup).
More detail in 3dec541b2e63 ("bpf: Add support for BTF pointers to x86 JIT"=
).

arm64 is an example of an arch that doesn't have a handler field in the ext=
able.
They did something along the lines of this rather than adding a
handler field to the extable.
See 800834285361 ("bpf, arm64: Add BPF exception tables")

>
>
> > exception table design, where it populates both fixup and extable
> > sections within BPF program. fixup section contains two instructions,
> > first instruction clears dest_reg and 2nd jumps to next instruction
> > in the BPF code. extable 'insn' field contains relative offset of
> > the instruction and 'fixup' field contains relative offset of the
> > fixup entry. Example layout of BPF program with extable present:
> >
> >               +------------------+
> >               |                  |
> >               |                  |
> >     0x4020 -->| ld   r27,4(r3)   |
> >               |                  |
> >               |                  |
> >     0x40ac -->| lwz  r3,0(r4)    |
> >               |                  |
> >               |                  |
> >               |------------------|
> >     0x4280 -->| li  r27,0        |  \ fixup entry
> >               | b   0x4024       |  /
> >     0x4288 -->| li  r3,0         |
> >               | b   0x40b0       |
> >               |------------------|
> >     0x4290 -->| insn=3D0xfffffd90  |  \ extable entry
> >               | fixup=3D0xffffffec |  /
> >     0x4298 -->| insn=3D0xfffffe14  |
> >               | fixup=3D0xffffffec |
> >               +------------------+
> >
> >     (Addresses shown here are chosen random, not real)
> >
