Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BB46626DA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbjAINVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbjAINVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:21:43 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C5613F14;
        Mon,  9 Jan 2023 05:21:37 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c6so9490568pls.4;
        Mon, 09 Jan 2023 05:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55cpmeYHA7DCtU0PqJDR9yhzjmXYqv18FD85Rkv9woI=;
        b=FK6l095MUD0scUeQQVsycfqA8gu9K77WOSdijrpoIOCh5uTZHEOZzosXBEot0ZobeI
         7H+TRpqL78YqAh9D5XVgQkrWpWkZtuejaJorhoXE+W8nU7gAuxJ6XXE3JHaI2mXJ+eJh
         30ObtdKJWlgQ1HuYmtG/c+6gJnJ6dRDwC9GrR90jAwS6zRkpZwM4xjg1OZ1o4JQhTtmr
         xdckMIMZ9rzOdO1zv/O+dvyi9hwy9jbyD3eFfyxCoL3n0yxMyjayxfcQIr+22pvOmlZJ
         P1wHshyYjqLp7HlnNqZzcysTM/PWuIOFqnvoiRtobV0Wbt38cbrX7keSHP0H1e5bwooP
         6lVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=55cpmeYHA7DCtU0PqJDR9yhzjmXYqv18FD85Rkv9woI=;
        b=mjhEZZPwpfkBgp53bLlBRORtESb9m8ExyyOM6W3PO7+zZ/XpIdbfTRvdOskfGjwCn1
         t6MLLGrjXSi70H/pfOEFw70dBTgsqKrdS9Fo151/13yBK9KpSD+Euo8yTSZ+jjZARixn
         Yh6eFnoOMwNAJ6GaiDL84KwQAQuae/0yTq9CP5hOyPrRpPRJgUYJ3EUg41/JTGaxH2q3
         uwUnnfGMVVfqXGmg03CDH9yy4dPDhLQDZEssqL4PmZ4jENgfpBDCyXVQAclGlqA68cwg
         k6Cq0UKyRqtWA7BEg4FCN3Ko/q2Cquo9yIDUm2tD/WYzg1AfiDsZDJMzUl5YnBa9Jf3a
         1MnQ==
X-Gm-Message-State: AFqh2kp1KhkVCvQ6TVL85yas9/vHJqWAP+i5Psj4dAW/chbss+J7YdXM
        DArCNzFjfb+ORisw2gC/Ig==
X-Google-Smtp-Source: AMrXdXvAYrPKulRkWDMDkwUh/XI/kD/WRdk/GJnFImKeGNuyE74rB44oQYKXTl1ohOR1xXeocb2aeg==
X-Received: by 2002:a05:6a20:d68f:b0:9d:efbf:48e7 with SMTP id it15-20020a056a20d68f00b0009defbf48e7mr82635536pzb.43.1673270496686;
        Mon, 09 Jan 2023 05:21:36 -0800 (PST)
Received: from smtpclient.apple (n119236129232.netvigator.com. [119.236.129.232])
        by smtp.gmail.com with ESMTPSA id x9-20020aa79569000000b00581f8965116sm5987111pfq.202.2023.01.09.05.21.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 05:21:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
From:   Hao Sun <sunhao.th@gmail.com>
In-Reply-To: <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
Date:   Mon, 9 Jan 2023 21:21:22 +0800
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <933A445C-725E-4BC2-8860-2D0A92C34C58@gmail.com>
References: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
 <52379286-960e-3fcd-84a2-3cab4d3b7c4e@meta.com>
 <5B270DBF-E305-4C86-B246-F5C8A5D942CA@gmail.com>
 <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
To:     Yonghong Song <yhs@meta.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Yonghong Song <yhs@meta.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=8818=E6=97=A5=E5=
=91=A8=E6=97=A5 00:57=E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
> On 12/16/22 10:54 PM, Hao Sun wrote:
>>=20
>>=20
>>> On 17 Dec 2022, at 1:07 PM, Yonghong Song <yhs@meta.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 12/14/22 11:49 PM, Hao Sun wrote:
>>>> Hi,
>>>> The following KASAN report can be triggered by loading and test
>>>> running this simple BPF prog with a random data/ctx:
>>>> 0: r0 =3D bpf_get_current_task_btf      ;
>>>> R0_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
>>>> 1: r0 =3D *(u32 *)(r0 +8192)       ;
>>>> R0_w=3Dscalar(umax=3D4294967295,var_off=3D(0x0; 0xffffffff))
>>>> 2: exit
>>>> I've simplified the C reproducer but didn't find the root cause.
>>>> JIT was disabled, and the interpreter triggered UAF when executing
>>>> the load insn. A slab-out-of-bound read can also be triggered:
>>>> https://pastebin.com/raw/g9zXr8jU
>>>> This can be reproduced on:
>>>> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to =
test
>>>> padding handling of btf_dump
>>>> git tree: bpf-next
>>>> console log: https://pastebin.com/raw/1EUi9tJe
>>>> kernel config: https://pastebin.com/raw/rgY3AJDZ
>>>> C reproducer: https://pastebin.com/raw/cfVGuCBm
>>>=20
>>> I I tried with your above kernel config and C reproducer and cannot =
reproduce the kasan issue you reported.
>>>=20
>>> [root@arch-fb-vm1 bpf-next]# ./a.out
>>> func#0 @0
>>> 0: R1=3Dctx(off=3D0,imm=3D0) R10=3Dfp0
>>> 0: (85) call bpf_get_current_task_btf#158     ; =
R0_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
>>> 1: (61) r0 =3D *(u32 *)(r0 +8192)       ; =
R0_w=3Dscalar(umax=3D4294967295,var_off=3D(0x0; 0xffffffff))
>>> 2: (95) exit
>>> processed 3 insns (limit 1000000) max_states_per_insn 0 total_states =
0 peak_states 0 mark_read 0
>>>=20
>>> prog fd: 3
>>> [root@arch-fb-vm1 bpf-next]#
>>>=20
>>> Your config indeed has kasan on.
>>=20
>> Hi,
>>=20
>> I can still reproduce this on a latest bpf-next build: 0e43662e61f25
>> (=E2=80=9Ctools/resolve_btfids: Use pkg-config to locate libelf=E2=80=9D=
).
>> The simplified C reproducer sometime need to be run twice to trigger
>> the UAF. Also note that interpreter is required. Here is the original
>> C reproducer that loads and runs the BPF prog continuously for your
>> convenience:
>> https://pastebin.com/raw/WSJuNnVU
>>=20
>=20
> I still cannot reproduce with more than 10 runs. The config has jit =
off
> so it already uses interpreter. It has kasan on as well.
> # CONFIG_BPF_JIT is not set
>=20
> Since you can reproduce it, I guess it would be great if you can
> continue to debug this.
>=20

The load insn =E2=80=98r0 =3D *(u32*) (current + 8192)=E2=80=99 is OOB, =
because sizeof(task_struct)
is 7240 as shown in KASAN report. The issue is that struct task_struct =
is special,
its runtime size is actually smaller than it static type size. In X86:

task_struct->thread_struct->fpu->fpstate->union fpregs_state is
/*
* ...
* The size of the structure is determined by the largest
* member - which is the xsave area. The padding is there
* to ensure that statically-allocated task_structs (just
* the init_task today) have enough space.
*/
union fpregs_state {
	struct fregs_state fsave;
	struct fxregs_state fxsave;
	struct swregs_state soft;
	struct xregs_state xsave;
	u8 __padding[PAGE_SIZE];
};

In btf_struct_access(), the resolved size for task_struct is 10496, much =
bigger
than its runtime size, so the prog in reproducer passed the verifier and =
leads
to the oob. This can happen to all similar types, whose runtime size is =
smaller
than its static size.

Not sure how many similar cases are there, maybe special check to =
task_struct
is enough. Any hint on how this should be addressed?


