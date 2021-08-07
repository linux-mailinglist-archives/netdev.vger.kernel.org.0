Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F523E3245
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 02:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhHGAK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 20:10:26 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:10892 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhHGAKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 20:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628295009; x=1659831009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G7hvc2JfYxTEVAOnKFJt2A3T+FBe5RfRAePjrg/6gfs=;
  b=GqQ7VANkSH5c8nfZ4nIbOaqvQpYAXtGbcQNb7uZ3eMHH6QGnwxlObI66
   k+7D/RkSbwakkPSJ088estjwalqerD6v6TUIfmd/mDBxsQm/B0+9gSefK
   XyVjx+2rIeFXXWdDcxRZB0kEksFAtXcfsGgSgHATbJltu2ieqb44EEHsm
   4=;
X-IronPort-AV: E=Sophos;i="5.84,301,1620691200"; 
   d="scan'208";a="948940935"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 07 Aug 2021 00:10:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 18E74A1D63;
        Sat,  7 Aug 2021 00:10:08 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 7 Aug 2021 00:10:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.90) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 7 Aug 2021 00:10:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/2] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Sat, 7 Aug 2021 09:09:58 +0900
Message-ID: <20210807000958.32890-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzaqH1sZM-ZH-C3bkCDCDNL0tYm4_2XGpqYRt33RdBOmhg@mail.gmail.com>
References: <CAEf4BzaqH1sZM-ZH-C3bkCDCDNL0tYm4_2XGpqYRt33RdBOmhg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D31UWA002.ant.amazon.com (10.43.160.82) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 16:33:22 -0700
> On Wed, Aug 4, 2021 at 12:09 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > If there are no abstract sockets, this prog can output the same result
> > compared to /proc/net/unix.
> >
> >   # cat /sys/fs/bpf/unix | head -n 2
> >   Num       RefCount Protocol Flags    Type St Inode Path
> >   ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> >
> >   # cat /proc/net/unix | head -n 2
> >   Num       RefCount Protocol Flags    Type St Inode Path
> >   ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> >
> > According to the analysis by Yonghong Song (See the link), the BPF verifier
> > cannot load the code in the comment to print the name of the abstract UNIX
> > domain socket due to LLVM optimisation.  It can be uncommented once the
> > LLVM code gen is improved.
> >
> > Link: https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/
> 
> Our patchworks tooling, used to apply patches, is using Link: tag to
> record original discussion, so this will be quite confusing if you use
> the same "Link: " for referencing relevant discussions. Please use
> standard link reference syntax:
> 
> According to the analysis by Yonghong Song ([0]), ...
> 
> ...
> 
>   [0] https://lore.kernel.org/netdev/1994df05-8f01-371f-3c3b-d33d7836878c@fb.com/

I'll use this format.


> 
> 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_iter.c       | 16 ++++
> >  tools/testing/selftests/bpf/progs/bpf_iter.h  |  8 ++
> >  .../selftests/bpf/progs/bpf_iter_unix.c       | 86 +++++++++++++++++++
> >  .../selftests/bpf/progs/bpf_tracing_net.h     |  4 +
> >  4 files changed, 114 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> >
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
> > index 3d83b185c4bc..d92648621bcb 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_iter.h
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
> > @@ -12,6 +12,7 @@
> >  #define tcp6_sock tcp6_sock___not_used
> >  #define bpf_iter__udp bpf_iter__udp___not_used
> >  #define udp6_sock udp6_sock___not_used
> > +#define bpf_iter__unix bpf_iter__unix___not_used
> >  #define bpf_iter__bpf_map_elem bpf_iter__bpf_map_elem___not_used
> >  #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
> >  #define bpf_iter__sockmap bpf_iter__sockmap___not_used
> > @@ -32,6 +33,7 @@
> >  #undef tcp6_sock
> >  #undef bpf_iter__udp
> >  #undef udp6_sock
> > +#undef bpf_iter__unix
> >  #undef bpf_iter__bpf_map_elem
> >  #undef bpf_iter__bpf_sk_storage_map
> >  #undef bpf_iter__sockmap
> > @@ -103,6 +105,12 @@ struct udp6_sock {
> >         struct ipv6_pinfo inet6;
> >  } __attribute__((preserve_access_index));
> >
> > +struct bpf_iter__unix {
> > +       struct bpf_iter_meta *meta;
> > +       struct unix_sock *unix_sk;
> > +       uid_t uid __attribute__((aligned(8)));
> 
> just fyi, aligned doesn't matter here, CO-RE will relocate offsets
> appropriately anyways

Thank you, I'll remove it.


> 
> > +} __attribute__((preserve_access_index));
> > +
> >  struct bpf_iter__bpf_map_elem {
> >         struct bpf_iter_meta *meta;
> >         struct bpf_map *map;
> 
> [...]
> 
> > +SEC("iter/unix")
> > +int dump_unix(struct bpf_iter__unix *ctx)
> > +{
> > +       struct unix_sock *unix_sk = ctx->unix_sk;
> > +       struct sock *sk = (struct sock *)unix_sk;
> > +       struct seq_file *seq;
> > +       __u32 seq_num;
> > +
> > +       if (!unix_sk)
> > +               return 0;
> > +
> > +       seq = ctx->meta->seq;
> > +       seq_num = ctx->meta->seq_num;
> > +       if (seq_num == 0)
> > +               BPF_SEQ_PRINTF(seq, "Num       RefCount Protocol Flags    "
> > +                              "Type St Inode Path\n");
> 
> nit: please keep format strings on a single line

I'll fix it.

Thanks for review.


> 
> > +
> > +       BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
> > +                      unix_sk,
> > +                      sk->sk_refcnt.refs.counter,
> > +                      0,
> > +                      sk->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
> > +                      sk->sk_type,
> > +                      sk->sk_socket ?
> > +                      (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTED : SS_UNCONNECTED) :
> > +                      (sk->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
> > +                      sock_i_ino(sk));
> > +
> 
> [...]
