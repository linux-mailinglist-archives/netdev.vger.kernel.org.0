Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A052D0086
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgLFEdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:33:06 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:27981 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgLFEdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607229185; x=1638765185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8PJsmJsl6qhg6dDpLr36EjFSChF7mhWvsDFqM9brQ20=;
  b=lVf6d6G4x65nOMAu9/TUzWvm4eDKNaNcRn62lYcXWTtWtKfM3YlQRrKf
   rj5WIRgvS+DJ1rL+N20t+rDkjyDX5+F0QR+l1kml/c7Lcwac2AMH7k7bA
   Sr9KqkUBiYUrvJN9c6KcxutU6aqLY68byLW6z9sp0DG7jEwTcg7qXrsNF
   I=;
X-IronPort-AV: E=Sophos;i="5.78,396,1599523200"; 
   d="scan'208";a="100758043"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 Dec 2020 04:32:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id 7AF8CA189F;
        Sun,  6 Dec 2020 04:32:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:32:23 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.144) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:32:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Sun, 6 Dec 2020 13:32:16 +0900
Message-ID: <20201206043216.23046-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201204055226.c6abex2dmperhgx5@kafai-mbp.dhcp.thefacebook.com>
References: <20201204055226.c6abex2dmperhgx5@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D14UWB001.ant.amazon.com (10.43.161.158) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this mail just for logging because I failed to send mails only
to LKML, netdev, and bpf yesterday.


From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 3 Dec 2020 21:56:53 -0800
> On Thu, Dec 03, 2020 at 11:16:08PM +0900, Kuniyuki Iwashima wrote:
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Wed, 2 Dec 2020 20:24:02 -0800
> > > On Wed, Dec 02, 2020 at 11:19:02AM -0800, Martin KaFai Lau wrote:
> > > > On Tue, Dec 01, 2020 at 06:04:50PM -0800, Andrii Nakryiko wrote:
> > > > > On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > > >
> > > > > > This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> > > > > > check if the attached eBPF program is capable of migrating sockets.
> > > > > >
> > > > > > When the eBPF program is attached, the kernel runs it for socket migration
> > > > > > only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > > > > > The kernel will change the behaviour depending on the returned value:
> > > > > >
> > > > > >   - SK_PASS with selected_sk, select it as a new listener
> > > > > >   - SK_PASS with selected_sk NULL, fall back to the random selection
> > > > > >   - SK_DROP, cancel the migration
> > > > > >
> > > > > > Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> > > > > > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > ---
> > > > > >  include/uapi/linux/bpf.h       | 2 ++
> > > > > >  kernel/bpf/syscall.c           | 8 ++++++++
> > > > > >  tools/include/uapi/linux/bpf.h | 2 ++
> > > > > >  3 files changed, 12 insertions(+)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > index 85278deff439..cfc207ae7782 100644
> > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > > > > >         BPF_XDP_CPUMAP,
> > > > > >         BPF_SK_LOOKUP,
> > > > > >         BPF_XDP,
> > > > > > +       BPF_SK_REUSEPORT_SELECT,
> > > > > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > > > > >         __MAX_BPF_ATTACH_TYPE
> > > > > >  };
> > > > > >
> > > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > > index f3fe9f53f93c..a0796a8de5ea 100644
> > > > > > --- a/kernel/bpf/syscall.c
> > > > > > +++ b/kernel/bpf/syscall.c
> > > > > > @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> > > > > >                 if (expected_attach_type == BPF_SK_LOOKUP)
> > > > > >                         return 0;
> > > > > >                 return -EINVAL;
> > > > > > +       case BPF_PROG_TYPE_SK_REUSEPORT:
> > > > > > +               switch (expected_attach_type) {
> > > > > > +               case BPF_SK_REUSEPORT_SELECT:
> > > > > > +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> > > > > > +                       return 0;
> > > > > > +               default:
> > > > > > +                       return -EINVAL;
> > > > > > +               }
> > > > > 
> > > > > this is a kernel regression, previously expected_attach_type wasn't
> > > > > enforced, so user-space could have provided any number without an
> > > > > error.
> > > > I also think this change alone will break things like when the usual
> > > > attr->expected_attach_type == 0 case.  At least changes is needed in
> > > > bpf_prog_load_fixup_attach_type() which is also handling a
> > > > similar situation for BPF_PROG_TYPE_CGROUP_SOCK.
> > > > 
> > > > I now think there is no need to expose new bpf_attach_type to the UAPI.
> > > > Since the prog->expected_attach_type is not used, it can be cleared at load time
> > > > and then only set to BPF_SK_REUSEPORT_SELECT_OR_MIGRATE (probably defined
> > > > internally at filter.[c|h]) in the is_valid_access() when "migration"
> > > > is accessed.  When "migration" is accessed, the bpf prog can handle
> > > > migration (and the original not-migration) case.
> > > Scrap this internal only BPF_SK_REUSEPORT_SELECT_OR_MIGRATE idea.
> > > I think there will be cases that bpf prog wants to do both
> > > without accessing any field from sk_reuseport_md.
> > > 
> > > Lets go back to the discussion on using a similar
> > > idea as BPF_PROG_TYPE_CGROUP_SOCK in bpf_prog_load_fixup_attach_type().
> > > I am not aware there is loader setting a random number
> > > in expected_attach_type, so the chance of breaking
> > > is very low.  There was a similar discussion earlier [0].
> > > 
> > > [0]: https://lore.kernel.org/netdev/20200126045443.f47dzxdglazzchfm@ast-mbp/
> > 
> > Thank you for the idea and reference.
> > 
> > I will remove the change in bpf_prog_load_check_attach() and set the
> > default value (BPF_SK_REUSEPORT_SELECT) in bpf_prog_load_fixup_attach_type()
> > for backward compatibility if expected_attach_type is 0.
> check_attach_type() can be kept.  You can refer to
> commit aac3fc320d94 for a similar situation.

I confirmed bpf_prog_load_fixup_attach_type() is called just before
bpf_prog_load_check_attach(), so I will add the fixup code to this patch.
Thank you.
