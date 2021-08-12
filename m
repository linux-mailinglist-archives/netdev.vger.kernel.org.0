Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7157E3E9DBE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhHLFEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 01:04:33 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:9113 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhHLFEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628744649; x=1660280649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TGAXqGk6SkPObI86s0lBoYKjYvllUpVh8BE3DCHWgtw=;
  b=SyDIZ3Swnc2s8tc5z2FwXFmuLYta9zXH/JkLOlqm4FgxHhB5I7FCzPEq
   oSm8OiNoLYt1qYlWlhqE+fURX/14d8S67Ljf6LJrdvSrBhyHoIlqnPB/S
   WDxHId2cv+LdbboFfvO/mqqNmgVfL/v1E2Py2id/6tZ7w0RNfp1F/uwCO
   I=;
X-IronPort-AV: E=Sophos;i="5.84,314,1620691200"; 
   d="scan'208";a="151996627"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 12 Aug 2021 05:04:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 15070A1947;
        Thu, 12 Aug 2021 05:04:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 05:04:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.90) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 05:04:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in bpf_bprintf_prepare().
Date:   Thu, 12 Aug 2021 14:03:57 +0900
Message-ID: <20210812050357.8512-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzbA-k+SrvbiYQt8OBAxEHNwkTdaqxM=Pqn6udgPRBbF4g@mail.gmail.com>
References: <CAEf4BzbA-k+SrvbiYQt8OBAxEHNwkTdaqxM=Pqn6udgPRBbF4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13d09UWC003.ant.amazon.com (10.43.162.113) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 21:24:31 -0700
> On Wed, Aug 11, 2021 at 7:15 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Date:   Wed, 11 Aug 2021 14:15:50 -0700
> > > On Tue, Aug 10, 2021 at 2:29 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > /proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
> > > > the name of the abstract UNIX domain socket.  The following selftest uses
> > > > it, so this patch adds support for "%c".  Note that it does not support
> > > > wide character ("%lc" and "%llc") for simplicity.
> > > >
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > ---
> > > >  kernel/bpf/helpers.c | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > > > index 15746f779fe1..6d3aaf94e9ac 100644
> > > > --- a/kernel/bpf/helpers.c
> > > > +++ b/kernel/bpf/helpers.c
> > > > @@ -907,6 +907,20 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
> > > >                         tmp_buf += err;
> > > >                         num_spec++;
> > > >
> > > > +                       continue;
> > > > +               } else if (fmt[i] == 'c') {
> > >
> > > you are adding new features to printk-like helpers, please add
> > > corresponding tests as well. I'm particularly curious how something
> > > like "% 9c" (which is now allowed, along with a few other unusual
> > > combinations) will work.
> >
> > I see. I'll add a test.
> > I'm now thinking of test like:
> >   1. pin the bpf prog that outputs "% 9c" and other format strings.
> >   2. read and validate it
> 
> Simpler. Use bpf_snprintf() to test all this logic.
> bpf_trace_printk(), bpf_snprintf() and bpf_seq_printf() share the same
> "backend" in kernel. No need to use bpf_iter program for testing this.
> Look for other snprintf() tests and just extend them.

I'll extend prog_tests/snprintf.c.
Thank you!


> 
> >
> > Is there any related test ?
> > and is there other complicated fomat strings to test ?
> >
> > Also, "% 9c" worked as is :)
> >
> > ---8<---
> > $ sudo ./tools/bpftool/bpftool iter pin ./bpf_iter_unix.o /sys/fs/bpf/unix
> > $ sudo cat /sys/fs/bpf/unix | head -n 1
> >         a
> > $ git diff
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > index ad397e2962cf..8a7d5aa4c054 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> > @@ -34,8 +34,10 @@ int dump_unix(struct bpf_iter__unix *ctx)
> >
> >         seq = ctx->meta->seq;
> >         seq_num = ctx->meta->seq_num;
> > -       if (seq_num == 0)
> > +       if (seq_num == 0) {
> > +               BPF_SEQ_PRINTF(seq, "% 9c\n", 'a');
> >                 BPF_SEQ_PRINTF(seq, "Num               RefCount Protocol Flags    Type St Inode    Path\n");
> > +       }
> >
> >         BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %8lu",
> >                        unix_sk,
> > ---8<---
> >
> >
> >
> > >
> > > > +                       if (!tmp_buf)
> > > > +                               goto nocopy_fmt;
> > > > +
> > > > +                       if (tmp_buf_end == tmp_buf) {
> > > > +                               err = -ENOSPC;
> > > > +                               goto out;
> > > > +                       }
> > > > +
> > > > +                       *tmp_buf = raw_args[num_spec];
> > > > +                       tmp_buf++;
> > > > +                       num_spec++;
> > > > +
> > > >                         continue;
> > > >                 }
> > > >
> > > > --
> > > > 2.30.2
