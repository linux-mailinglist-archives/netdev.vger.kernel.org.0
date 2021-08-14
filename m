Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB493EBF24
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhHNBB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:01:29 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:60653 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhHNBB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628902862; x=1660438862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qedY7j3n4lJj1ou1ePjI/4MPlgHnzigr2lbey4ecztY=;
  b=V3cte5+KubA0n7dBK6whHX2CpgSGCIJCjdLUtG9k1e3NwsQALSb+3ucv
   nnwuDEXQMxYvAcKhjBq8LmGwxx213cPkiM0o0r6Ks4lqBvIMT6CKpFlyK
   YxNxQiH5sTLXcurYLHEou0MJAb33JoJ5dd9YdcU8Pthak2nxTA5HpSIKT
   E=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="141723220"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 14 Aug 2021 01:00:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 8674F1A0939;
        Sat, 14 Aug 2021 01:00:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:00:56 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.187) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:00:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v5 bpf-next 3/4] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Sat, 14 Aug 2021 10:00:41 +0900
Message-ID: <20210814010041.38316-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzbVpqkXk4XiaXW=hTa6hwH3u8c2n8MruTNAKM5Y0XTjQg@mail.gmail.com>
References: <CAEf4BzbVpqkXk4XiaXW=hTa6hwH3u8c2n8MruTNAKM5Y0XTjQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.187]
X-ClientProxiedBy: EX13D40UWC004.ant.amazon.com (10.43.162.175) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 17:26:05 -0700
> On Fri, Aug 13, 2021 at 5:21 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Date:   Fri, 13 Aug 2021 16:25:53 -0700
> > > On Thu, Aug 12, 2021 at 9:46 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > The iterator can output almost the same result compared to /proc/net/unix.
> > > > The header line is aligned, and the Inode column uses "%8lu" because "%5lu"
> > > > can be easily overflown.
> > > >
> > > >   # cat /sys/fs/bpf/unix
> > > >   Num               RefCount Protocol Flags    Type St Inode    Path
> > >
> > > It's totally my OCD, but why the column name is not aligned with
> > > values? I mean the "Inode" column. It's left aligned, but values
> > > (numbers) are right-aligned? I'd fix that while applying, but I can't
> > > apply due to selftests failures, so please take a look.
> >
> > Ah, honestly, I've felt something strange about the column... will fix it!
> >
> >
> > >
> > >
> > > >   ffff963c06689800: 00000002 00000000 00010000 0001 01    18697 private/defer
> > > >   ffff963c7c979c00: 00000002 00000000 00000000 0001 01   598245 @Hello@World@
> > > >
> > > >   # cat /proc/net/unix
> > > >   Num       RefCount Protocol Flags    Type St Inode Path
> > > >   ffff963c06689800: 00000002 00000000 00010000 0001 01 18697 private/defer
> > > >   ffff963c7c979c00: 00000002 00000000 00000000 0001 01 598245 @Hello@World@
> > > >
> > > > Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
> > > > Yonghong Song for analysing and fixing.
> > > >
> > > > [0] https://reviews.llvm.org/D107483
> > > >
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > Acked-by: Yonghong Song <yhs@fb.com>
> > > > ---
> > >
> > > This selftests breaks test_progs-no_alu32 ([0], the error log is super
> > > long and can freeze browser; it looks like an infinite loop and BPF
> > > verifier just keeps reporting it until it runs out of 1mln
> > > instructions or something). Please check what's going on there, I
> > > can't land it as it is right now.
> > >
> > >   [0] https://github.com/kernel-patches/bpf/runs/3326071112?check_suite_focus=true#step:6:124288
> > >
> > >
> > > >  tools/testing/selftests/bpf/README.rst        | 38 +++++++++
> > > >  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
> > > >  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
> > > >  .../selftests/bpf/progs/bpf_iter_unix.c       | 77 +++++++++++++++++++
> > > >  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
> > > >  5 files changed, 143 insertions(+)
> > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > > >
> > >
> > > [...]
> > >
> > > > +                       /* The name of the abstract UNIX domain socket starts
> > > > +                        * with '\0' and can contain '\0'.  The null bytes
> > > > +                        * should be escaped as done in unix_seq_show().
> > > > +                        */
> > > > +                       int i, len;
> > > > +
> > >
> > > no_alu32 variant probably isn't happy about using int for this, it
> > > probably does << 32, >> 32 dance and loses track of actual value in
> > > the loop. You can try using u64 instead.
> >
> > Sorry, I missed the no_alu32 test.
> > Changing int to __u64 fixed the error, thanks!
> >
> >
> > >
> > > > +                       len = unix_sk->addr->len - sizeof(short);
> > > > +
> > > > +                       BPF_SEQ_PRINTF(seq, " @");
> > > > +
> > > > +                       /* unix_mkname() tests this upper bound. */
> > > > +                       if (len < sizeof(struct sockaddr_un))
> > > > +                               for (i = 1; i < len; i++)
> > >
> > > if you move above if inside the loop to break out of the loop, does it
> > > change how Clang generates code?
> > >
> > > for (i = 1; i < len i++) {
> > >     if (i >= sizeof(struct sockaddr_un))
> > >         break;
> > >     BPF_SEQ_PRINTF(...);
> > > }
> >
> > Yes, but there seems little defference.
> > Which is preferable?
> >
> > ---8<---
> > before (for inside if) <- -> after (if inside loop)
> >       96:       07 08 00 00 fe ff ff ff r8 += -2                          |     ;                       for (i = 1; i < len; i++) {
> > ;                       if (len < sizeof(struct sockaddr_un))             |           97:       bf 81 00 00 00 00 00 00 r1 = r8
> >       97:       25 08 10 00 6d 00 00 00 if r8 > 109 goto +16 <LBB0_21>    |           98:       07 01 00 00 fc ff ff ff r1 += -4
> > ;                               for (i = 1; i < len; i++)                 |           99:       25 01 12 00 6b 00 00 00 if r1 > 107 goto +18 <LBB0_21>
> >       98:       a5 08 0f 00 02 00 00 00 if r8 < 2 goto +15 <LBB0_21>      |          100:       07 08 00 00 fe ff ff ff r8 += -2
> >       99:       b7 09 00 00 01 00 00 00 r9 = 1                            |          101:       b7 09 00 00 01 00 00 00 r9 = 1
> >      100:       05 00 16 00 00 00 00 00 goto +22 <LBB0_18>                |          102:       b7 06 00 00 02 00 00 00 r6 = 2
> >                                                                           |          103:       05 00 17 00 00 00 00 00 goto +23 <LBB0_17>
> > ...
> >      111:       85 00 00 00 7e 00 00 00 call 126                          |          113:       b4 05 00 00 08 00 00 00 w5 = 8
> > ;                               for (i = 1; i < len; i++)                 |          114:       85 00 00 00 7e 00 00 00 call 126
> >      112:       07 09 00 00 01 00 00 00 r9 += 1                           |     ;                       for (i = 1; i < len; i++) {
> >      113:       ad 89 09 00 00 00 00 00 if r9 < r8 goto +9 <LBB0_18>      |          115:       25 08 02 00 6d 00 00 00 if r8 > 109 goto +2 <LBB0_21>
> >                                                                           >          116:       07 09 00 00 01 00 00 00 r9 += 1
> >                                                                           >     ;                       for (i = 1; i < len; i++) {
> >                                                                           >          117:       ad 89 09 00 00 00 00 00 if r9 < r8 goto +9 <LBB0_17>
> > ---8<---
> >
> 
> Have you tried running the variant I proposed on Clang without
> Yonghong's recent fix? I wonder if it works without that fix (not that
> there is anything wrong about the fix, but if we can avoid depending
> on it, it would be great).

It was with the fix.

I rebuilt LLVM without the fix, then the if-inside-for code worked well :)
There was no transformation from '<' to '!='.

I'll drop the change in README and respin with your suggestion soon.

---8<---
; 			for (i = 1; i < len; i++) {
      97:	bf 81 00 00 00 00 00 00	r1 = r8
      98:	07 01 00 00 fc ff ff ff	r1 += -4
      99:	25 01 12 00 6b 00 00 00	if r1 > 107 goto +18 <LBB0_21>
     100:	07 08 00 00 fe ff ff ff	r8 += -2
     101:	b7 09 00 00 01 00 00 00	r9 = 1
     102:	b7 06 00 00 02 00 00 00	r6 = 2
     103:	05 00 17 00 00 00 00 00	goto +23 <LBB0_17>
...
; 			for (i = 1; i < len; i++) {
     115:	25 08 02 00 6d 00 00 00	if r8 > 109 goto +2 <LBB0_21>
     116:	07 09 00 00 01 00 00 00	r9 += 1
; 			for (i = 1; i < len; i++) {
     117:	ad 89 09 00 00 00 00 00	if r9 < r8 goto +9 <LBB0_17>
---8<---


> 
> >
> > >
> > >
> > > > +                                       BPF_SEQ_PRINTF(seq, "%c",
> > > > +                                                      unix_sk->addr->name->sun_path[i] ?:
> > > > +                                                      '@');
> > > > +               }
> > > > +       }
> > > > +
> > > > +       BPF_SEQ_PRINTF(seq, "\n");
> > > > +
> > > > +       return 0;
> > > > +}
> > > > diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > > index 3af0998a0623..eef5646ddb19 100644
> > > > --- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > > +++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
> > > > @@ -5,6 +5,10 @@
> > > >  #define AF_INET                        2
> > > >  #define AF_INET6               10
> > > >
> > > > +#define __SO_ACCEPTCON         (1 << 16)
> > > > +#define UNIX_HASH_SIZE         256
> > > > +#define UNIX_ABSTRACT(unix_sk) (unix_sk->addr->hash < UNIX_HASH_SIZE)
> > > > +
> > > >  #define SOL_TCP                        6
> > > >  #define TCP_CONGESTION         13
> > > >  #define TCP_CA_NAME_MAX                16
> > > > --
> > > > 2.30.2
