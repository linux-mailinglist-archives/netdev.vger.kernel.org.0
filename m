Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1C3E9C28
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 04:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhHLCQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 22:16:02 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:32248 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhHLCPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 22:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628734531; x=1660270531;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RTy5lVmp/IOgnUGWV4V3jVdC4iVR+O644060Oaq+9s0=;
  b=JOTT1tndk/ia+mKR0Dk2KlzpkUsiND2KKWWlRUXh7PZGqz+uwXEbwHUQ
   Eezcch5xQPnE6C7bcFHClasYygkLtzFrFqrd/6tiJXldUkx0VEqEbpW5D
   6sV/6r/x6usug5jRMVE5GSdA3VgMYj2/rwYxw0ZIUKghT85WpLz78oHBv
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,314,1620691200"; 
   d="scan'208";a="18716084"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 12 Aug 2021 02:15:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 6E254A0691;
        Thu, 12 Aug 2021 02:15:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 02:15:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.186) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 02:15:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in bpf_bprintf_prepare().
Date:   Thu, 12 Aug 2021 11:15:21 +0900
Message-ID: <20210812021521.91494-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzZBxA2+nNtbOVEyMXDG9i_3zfxm78=--ssjrX4ESC_ixA@mail.gmail.com>
References: <CAEf4BzZBxA2+nNtbOVEyMXDG9i_3zfxm78=--ssjrX4ESC_ixA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.186]
X-ClientProxiedBy: EX13D45UWA002.ant.amazon.com (10.43.160.38) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 14:15:50 -0700
> On Tue, Aug 10, 2021 at 2:29 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > /proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
> > the name of the abstract UNIX domain socket.  The following selftest uses
> > it, so this patch adds support for "%c".  Note that it does not support
> > wide character ("%lc" and "%llc") for simplicity.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  kernel/bpf/helpers.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index 15746f779fe1..6d3aaf94e9ac 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -907,6 +907,20 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
> >                         tmp_buf += err;
> >                         num_spec++;
> >
> > +                       continue;
> > +               } else if (fmt[i] == 'c') {
> 
> you are adding new features to printk-like helpers, please add
> corresponding tests as well. I'm particularly curious how something
> like "% 9c" (which is now allowed, along with a few other unusual
> combinations) will work.

I see. I'll add a test.
I'm now thinking of test like:
  1. pin the bpf prog that outputs "% 9c" and other format strings.
  2. read and validate it

Is there any related test ?
and is there other complicated fomat strings to test ?

Also, "% 9c" worked as is :)

---8<---
$ sudo ./tools/bpftool/bpftool iter pin ./bpf_iter_unix.o /sys/fs/bpf/unix
$ sudo cat /sys/fs/bpf/unix | head -n 1
        a
$ git diff
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
index ad397e2962cf..8a7d5aa4c054 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -34,8 +34,10 @@ int dump_unix(struct bpf_iter__unix *ctx)
 
        seq = ctx->meta->seq;
        seq_num = ctx->meta->seq_num;
-       if (seq_num == 0)
+       if (seq_num == 0) {
+               BPF_SEQ_PRINTF(seq, "% 9c\n", 'a');
                BPF_SEQ_PRINTF(seq, "Num               RefCount Protocol Flags    Type St Inode    Path\n");
+       }
 
        BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %8lu",
                       unix_sk,
---8<---



> 
> > +                       if (!tmp_buf)
> > +                               goto nocopy_fmt;
> > +
> > +                       if (tmp_buf_end == tmp_buf) {
> > +                               err = -ENOSPC;
> > +                               goto out;
> > +                       }
> > +
> > +                       *tmp_buf = raw_args[num_spec];
> > +                       tmp_buf++;
> > +                       num_spec++;
> > +
> >                         continue;
> >                 }
> >
> > --
> > 2.30.2
