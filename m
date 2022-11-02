Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B107615B48
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiKBEFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59179220F0;
        Tue,  1 Nov 2022 21:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E393E6177E;
        Wed,  2 Nov 2022 04:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E26C433C1;
        Wed,  2 Nov 2022 04:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667361944;
        bh=zilE+0RPH4nsjm2cmooo/wxfBWawFsnYOnsjqA7FRNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eXzxB4AFqOshlaCSpr8zLi4B4oS8dxpACsfxpI4no0CyRCqguxDgD3L+sGGoXHlcM
         7MKaVB0PQD9n9jeXh3W+Te+jFN6vQmKx1biVmtNhkBZYVC/qu6l0VZaWsOMN5YPDph
         XfTBmq5aBgr/6ABeWRXgYiL4+K7VQsrDrWTRZGC/Rw+DKjc4NVlR7vaxEIaASByMtM
         xadYLIccjt/VBJXErJTLQXLiRqUIPAkY99ArR1S/lhi2oDaQhYNMISibADY4Xv5b0K
         WJ48e7rxTYEufCNjbD9k8QUGUnJmMGZ3evh6CMm7uvS4QeQmA9TNpH7dP6KkcNB1Vp
         rmLoLqjqk5IyQ==
Date:   Tue, 1 Nov 2022 21:05:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhongbaisong <zhongbaisong@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, <edumazet@google.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <song@kernel.org>,
        <yhs@fb.com>, <haoluo@google.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux MM <linux-mm@kvack.org>, <kasan-dev@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH -next] bpf, test_run: fix alignment problem in
 bpf_prog_test_run_skb()
Message-ID: <20221101210542.724e3442@kernel.org>
In-Reply-To: <ca6253bd-dcf4-2625-bc41-4b9a7774d895@huawei.com>
References: <20221101040440.3637007-1-zhongbaisong@huawei.com>
        <eca17bfb-c75f-5db1-f194-5b00c2a0c6f2@iogearbox.net>
        <ca6253bd-dcf4-2625-bc41-4b9a7774d895@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 10:59:44 +0800 zhongbaisong wrote:
> On 2022/11/2 0:45, Daniel Borkmann wrote:
> > [ +kfence folks ] =20
>=20
> + cc: Alexander Potapenko, Marco Elver, Dmitry Vyukov
>=20
> Do you have any suggestions about this problem?

+ Kees who has been sending similar patches for drivers

> > On 11/1/22 5:04 AM, Baisong Zhong wrote: =20
> >> Recently, we got a syzkaller problem because of aarch64
> >> alignment fault if KFENCE enabled.
> >>
> >> When the size from user bpf program is an odd number, like
> >> 399, 407, etc, it will cause skb shard info's alignment access,
> >> as seen below:
> >>
> >> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0=20
> >> net/core/skbuff.c:1032
> >>
> >> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
> >> =C2=A0 __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
> >> =C2=A0 arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
> >> =C2=A0 arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inlin=
e]
> >> =C2=A0 atomic_inc include/asm-generic/atomic-instrumented.h:241 [inlin=
e]
> >> =C2=A0 __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
> >> =C2=A0 skb_clone+0xf4/0x214 net/core/skbuff.c:1481
> >> =C2=A0 ____bpf_clone_redirect net/core/filter.c:2433 [inline]
> >> =C2=A0 bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
> >> =C2=A0 bpf_prog_d3839dd9068ceb51+0x80/0x330
> >> =C2=A0 bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
> >> =C2=A0 bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
> >> =C2=A0 bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
> >> =C2=A0 bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> >> =C2=A0 __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> >> =C2=A0 __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> >>
> >> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=3D407,=20
> >> cache=3Dkmalloc-512
> >>
> >> allocated by task 15074 on cpu 0 at 1342.585390s:
> >> =C2=A0 kmalloc include/linux/slab.h:568 [inline]
> >> =C2=A0 kzalloc include/linux/slab.h:675 [inline]
> >> =C2=A0 bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
> >> =C2=A0 bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
> >> =C2=A0 bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> >> =C2=A0 __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> >> =C2=A0 __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> >> =C2=A0 __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
> >>
> >> To fix the problem, we round up allocations with kmalloc_size_roundup()
> >> so that build_skb()'s use of kize() is always alignment and no special
> >> handling of the memory is needed by KFENCE.
> >>
> >> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> >> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> >> ---
> >> =C2=A0 net/bpf/test_run.c | 1 +
> >> =C2=A0 1 file changed, 1 insertion(+)
> >>
> >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >> index 13d578ce2a09..058b67108873 100644
> >> --- a/net/bpf/test_run.c
> >> +++ b/net/bpf/test_run.c
> >> @@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr=20
> >> *kattr, u32 user_size,
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (user_size > size)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(=
-EMSGSIZE);
> >> +=C2=A0=C2=A0=C2=A0 size =3D kmalloc_size_roundup(size);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data =3D kzalloc(size + headroom + tail=
room, GFP_USER); =20
> >=20
> > The fact that you need to do this roundup on call sites feels broken, n=
o?
> > Was there some discussion / consensus that now all k*alloc() call sites
> > would need to be fixed up? Couldn't this be done transparently in k*all=
oc()
> > when KFENCE is enabled? I presume there may be lots of other such occas=
ions
> > in the kernel where similar issue triggers, fixing up all call-sites fe=
els
> > like ton of churn compared to api-internal, generic fix.
> >  =20
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!data)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(=
-ENOMEM);
> >> =20
> >=20
> > Thanks,
> > Daniel
> > =20
>=20
>=20

