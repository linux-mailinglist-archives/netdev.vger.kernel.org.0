Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10143A4680
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFKQcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKQcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:32:22 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5392DC061574;
        Fri, 11 Jun 2021 09:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=loSuEwYH2/ErgrOv9smUX/ZtX7NHKWXh5V
        A17UsKWAU=; b=NhVTjKTko9VU+2hpWcEKNxkXl/V9ag7IK34UxjNgAagISWU0Mx
        jJAXOvmiCoLLVYWeTIbEDCIDe1X3fRvA2KApx0kpHJDJUadnCMmfDyAWo2b8KxfG
        /MgAXtiX1Px1GrwUa2mdpTqlFEUytrLqXxlnBCXMd3QBm1LZztIPXbaEo=
Received: from xhacker (unknown [101.86.20.15])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygCHj1tUj8NgA0LIAA--.30112S2;
        Sat, 12 Jun 2021 00:29:09 +0800 (CST)
Date:   Sat, 12 Jun 2021 00:23:34 +0800
From:   Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 7/9] riscv: bpf: Avoid breaking W^X
Message-ID: <20210612002334.6af72545@xhacker>
In-Reply-To: <87o8ccqypw.fsf@igel.home>
References: <20210330022144.150edc6e@xhacker>
        <20210330022521.2a904a8c@xhacker>
        <87o8ccqypw.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID: LkAmygCHj1tUj8NgA0LIAA--.30112S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AFy3KryxZr4UJr1rCw13CFg_yoW7Wr47pr
        4UAr1UGr48tr1UJr18Cr15AF1UAr1UAa13JFnrJrZ5J3WUWw1DJr18JrW7CF1DGr1rJF17
        tr1DXr48tr1DGaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkCb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
        FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
        0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY
        04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUg0D7DU
        UUU
X-CM-SenderInfo: xmv2xttqjtqzxdloh3xvwfhvlgxou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

On Fri, 11 Jun 2021 16:10:03 +0200
Andreas Schwab <schwab@linux-m68k.org> wrote:

> On M=C3=A4r 30 2021, Jisheng Zhang wrote:
>=20
> > From: Jisheng Zhang <jszhang@kernel.org>
> >
> > We allocate Non-executable pages, then call bpf_jit_binary_lock_ro()
> > to enable executable permission after mapping them read-only. This is
> > to prepare for STRICT_MODULE_RWX in following patch. =20
>=20
> That breaks booting with
> <https://github.com/openSUSE/kernel-source/blob/master/config/riscv64/def=
ault>.
>=20

Thanks for the bug report.
I reproduced an kernel panic with the defconfig on qemu, but I'm not sure w=
hether
this is the issue you saw, I will check.

    0.161959] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
[    0.167028] pinctrl core: initialized pinctrl subsystem
[    0.190727] Unable to handle kernel paging request at virtual address ff=
ffffff81651bd8
[    0.191361] Oops [#1]
[    0.191509] Modules linked in:
[    0.191814] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc5-default=
+ #3
[    0.192179] Hardware name: riscv-virtio,qemu (DT)
[    0.192492] epc : __memset+0xc4/0xfc
[    0.192712]  ra : skb_flow_dissector_init+0x22/0x86
[    0.192915] epc : ffffffff803e2700 ra : ffffffff8058f90c sp : ffffffe001=
a4fda0
[    0.193221]  gp : ffffffff8156d120 tp : ffffffe001a5b700 t0 : ffffffff81=
651b10
[    0.193631]  t1 : 0000000000000100 t2 : 00000000000003a8 s0 : ffffffe001=
a4fdd0
[    0.194034]  s1 : ffffffff80c9e250 a0 : ffffffff81651bd8 a1 : 0000000000=
000000
[    0.194502]  a2 : 000000000000003c a3 : ffffffff81651c10 a4 : 0000000000=
000064
[    0.195053]  a5 : ffffffff803e2700 a6 : 0000000000000040 a7 : 0000000000=
000002
[    0.195436]  s2 : ffffffff81651bd8 s3 : 0000000000000009 s4 : ffffffff81=
56e0c8
[    0.195723]  s5 : ffffffff8156e050 s6 : ffffffff80a105e0 s7 : ffffffff80=
a00738
[    0.195992]  s8 : ffffffff80f07be0 s9 : 0000000000000008 s10: ffffffff80=
8000ac
[    0.196257]  s11: 0000000000000000 t3 : fffffffffffffffc t4 : 0000000000=
000000
[    0.196511]  t5 : 00000000000003a9 t6 : 00000000000003ff
[    0.196714] status: 0000000000000120 badaddr: ffffffff81651bd8 cause: 00=
0000000000000f
[    0.197103] [<ffffffff803e2700>] __memset+0xc4/0xfc
[    0.197408] [<ffffffff80831f58>] init_default_flow_dissectors+0x22/0x60
[    0.197693] [<ffffffff800020fc>] do_one_initcall+0x3e/0x168
[    0.197907] [<ffffffff80801438>] kernel_init_freeable+0x25a/0x2c6
[    0.198157] [<ffffffff8070a8a8>] kernel_init+0x12/0x110
[    0.198351] [<ffffffff8000333a>] ret_from_exception+0x0/0xc
[    0.198973] Unable to handle kernel paging request at virtual address ff=
ffffff8164d860
[    0.199242] Oops [#2]
[    0.199336] Modules linked in:
[    0.199514] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D           5.=
13.0-rc5-default+ #3
[    0.199785] Hardware name: riscv-virtio,qemu (DT)
[    0.199940] epc : _raw_spin_lock_irqsave+0x14/0x4e
[    0.200113]  ra : _extract_crng+0x58/0xac
[    0.200264] epc : ffffffff807117ae ra : ffffffff80490774 sp : ffffffe001=
a4fa70
[    0.200489]  gp : ffffffff8156d120 tp : ffffffe001a5b700 t0 : ffffffff81=
57c0d7
[    0.200715]  t1 : ffffffff8157c0c8 t2 : 0000000000000000 s0 : ffffffe001=
a4fa80
[    0.200938]  s1 : ffffffff8164d818 a0 : 0000000000000022 a1 : ffffffe001=
a4fac8
[    0.201166]  a2 : 0000000000000010 a3 : 0000000000000001 a4 : ffffffff81=
64d860
[    0.201389]  a5 : 0000000000000000 a6 : c0000000ffffdfff a7 : ffffffffff=
ffffff
[    0.201612]  s2 : ffffffff8156e1c0 s3 : ffffffe001a4fac8 s4 : ffffffff81=
64d860
[    0.201836]  s5 : ffffffff8156e0c8 s6 : ffffffff80a105e0 s7 : ffffffff80=
a00738
[    0.202060]  s8 : ffffffff80f07be0 s9 : 0000000000000008 s10: ffffffff80=
8000ac
[    0.202295]  s11: 0000000000000000 t3 : 000000000000005b t4 : ffffffffff=
ffffff
[    0.202519]  t5 : 00000000000003a9 t6 : ffffffe001a4f9b8
[    0.202691] status: 0000000000000100 badaddr: ffffffff8164d860 cause: 00=
0000000000000f
[    0.202940] [<ffffffff807117ae>] _raw_spin_lock_irqsave+0x14/0x4e
[    0.203326] Unable to handle kernel paging request at virtual address ff=
ffffff8164d860
[    0.203574] Oops [#3]
[    0.203664] Modules linked in:
[    0.203784] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D           5.=
13.0-rc5-default+ #3
[    0.204046] Hardware name: riscv-virtio,qemu (DT)
[    0.204201] epc : _raw_spin_lock_irqsave+0x14/0x4e
[    0.204371]  ra : _extract_crng+0x58/0xac
[    0.204519] epc : ffffffff807117ae ra : ffffffff80490774 sp : ffffffe001=
a4f740
[    0.204819]  gp : ffffffff8156d120 tp : ffffffe001a5b700 t0 : ffffffff81=
57c0d7
[    0.205089]  t1 : ffffffff8157c0c8 t2 : 0000000000000000 s0 : ffffffe001=
a4f750
[    0.205330]  s1 : ffffffff8164d818 a0 : 0000000000000102 a1 : ffffffe001=
a4f798
[    0.205553]  a2 : 0000000000000010 a3 : 0000000000000001 a4 : ffffffff81=
64d860
[    0.205768]  a5 : 0000000000000000 a6 : c0000000ffffdfff a7 : ffffffff81=
408a40
[    0.205981]  s2 : ffffffff8156e1c0 s3 : ffffffe001a4f798 s4 : ffffffff81=
64d860
[    0.206197]  s5 : ffffffff8156e0c8 s6 : ffffffff80a105e0 s7 : ffffffff80=
a00738
[    0.206411]  s8 : ffffffff80f07be0 s9 : 0000000000000008 s10: ffffffff80=
8000ac
[    0.206633]  s11: 0000000000000000 t3 : 000000000000005b t4 : ffffffffff=
ffffff
[    0.206849]  t5 : 00000000000003a9 t6 : ffffffe001a4f688



