Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76092CD8CA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgLCORD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:17:03 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:35747 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLCORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:17:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607005021; x=1638541021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/E2kwRANGrqrnkmNo6wdZi/gTYFoC/4n/2un0PXXDAU=;
  b=YRSbK/54Km0KvyDLkgCP1KcuWqaXz9ANtY1Ety/0XUldEiiQFjqPR6N2
   wDkz0GqY6Kd6m+8BHkgKLI9lmVRc5u6gvjOUwMZCIBada6EE4aD/Br1Vk
   TwYbM+ji1X0/ZVCQ9AebD6qnhuxDKSciNw5mE5OsSILSDxJLs50cj19gd
   M=;
X-IronPort-AV: E=Sophos;i="5.78,389,1599523200"; 
   d="scan'208";a="68903714"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Dec 2020 14:16:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id E9A22A22CB;
        Thu,  3 Dec 2020 14:16:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:16:16 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.139) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:16:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Thu, 3 Dec 2020 23:16:08 +0900
Message-ID: <20201203141608.53206-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201203042402.6cskdlit5f3mw4ru@kafai-mbp.dhcp.thefacebook.com>
References: <20201203042402.6cskdlit5f3mw4ru@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.139]
X-ClientProxiedBy: EX13D37UWA001.ant.amazon.com (10.43.160.61) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 2 Dec 2020 20:24:02 -0800
> On Wed, Dec 02, 2020 at 11:19:02AM -0800, Martin KaFai Lau wrote:
> > On Tue, Dec 01, 2020 at 06:04:50PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > >
> > > > This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> > > > check if the attached eBPF program is capable of migrating sockets.
> > > >
> > > > When the eBPF program is attached, the kernel runs it for socket migration
> > > > only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > > > The kernel will change the behaviour depending on the returned value:
> > > >
> > > >   - SK_PASS with selected_sk, select it as a new listener
> > > >   - SK_PASS with selected_sk NULL, fall back to the random selection
> > > >   - SK_DROP, cancel the migration
> > > >
> > > > Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> > > > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > ---
> > > >  include/uapi/linux/bpf.h       | 2 ++
> > > >  kernel/bpf/syscall.c           | 8 ++++++++
> > > >  tools/include/uapi/linux/bpf.h | 2 ++
> > > >  3 files changed, 12 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index 85278deff439..cfc207ae7782 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > > >         BPF_XDP_CPUMAP,
> > > >         BPF_SK_LOOKUP,
> > > >         BPF_XDP,
> > > > +       BPF_SK_REUSEPORT_SELECT,
> > > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > > >         __MAX_BPF_ATTACH_TYPE
> > > >  };
> > > >
> > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > index f3fe9f53f93c..a0796a8de5ea 100644
> > > > --- a/kernel/bpf/syscall.c
> > > > +++ b/kernel/bpf/syscall.c
> > > > @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> > > >                 if (expected_attach_type == BPF_SK_LOOKUP)
> > > >                         return 0;
> > > >                 return -EINVAL;
> > > > +       case BPF_PROG_TYPE_SK_REUSEPORT:
> > > > +               switch (expected_attach_type) {
> > > > +               case BPF_SK_REUSEPORT_SELECT:
> > > > +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> > > > +                       return 0;
> > > > +               default:
> > > > +                       return -EINVAL;
> > > > +               }
> > > 
> > > this is a kernel regression, previously expected_attach_type wasn't
> > > enforced, so user-space could have provided any number without an
> > > error.
> > I also think this change alone will break things like when the usual
> > attr->expected_attach_type == 0 case.  At least changes is needed in
> > bpf_prog_load_fixup_attach_type() which is also handling a
> > similar situation for BPF_PROG_TYPE_CGROUP_SOCK.
> > 
> > I now think there is no need to expose new bpf_attach_type to the UAPI.
> > Since the prog->expected_attach_type is not used, it can be cleared at load time
> > and then only set to BPF_SK_REUSEPORT_SELECT_OR_MIGRATE (probably defined
> > internally at filter.[c|h]) in the is_valid_access() when "migration"
> > is accessed.  When "migration" is accessed, the bpf prog can handle
> > migration (and the original not-migration) case.
> Scrap this internal only BPF_SK_REUSEPORT_SELECT_OR_MIGRATE idea.
> I think there will be cases that bpf prog wants to do both
> without accessing any field from sk_reuseport_md.
> 
> Lets go back to the discussion on using a similar
> idea as BPF_PROG_TYPE_CGROUP_SOCK in bpf_prog_load_fixup_attach_type().
> I am not aware there is loader setting a random number
> in expected_attach_type, so the chance of breaking
> is very low.  There was a similar discussion earlier [0].
> 
> [0]: https://lore.kernel.org/netdev/20200126045443.f47dzxdglazzchfm@ast-mbp/

Thank you for the idea and reference.

I will remove the change in bpf_prog_load_check_attach() and set the
default value (BPF_SK_REUSEPORT_SELECT) in bpf_prog_load_fixup_attach_type()
for backward compatibility if expected_attach_type is 0.


> > > >         case BPF_PROG_TYPE_EXT:
> > > >                 if (expected_attach_type)
> > > >                         return -EINVAL;
> > > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > > > index 85278deff439..cfc207ae7782 100644
> > > > --- a/tools/include/uapi/linux/bpf.h
> > > > +++ b/tools/include/uapi/linux/bpf.h
> > > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > > >         BPF_XDP_CPUMAP,
> > > >         BPF_SK_LOOKUP,
> > > >         BPF_XDP,
> > > > +       BPF_SK_REUSEPORT_SELECT,
> > > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > > >         __MAX_BPF_ATTACH_TYPE
> > > >  };
> > > >
> > > > --
> > > > 2.17.2 (Apple Git-113)
