Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8262C2117
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgKXJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:25:04 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:21649 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbgKXJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:25:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606209901; x=1637745901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=lNZw1uUZvmxbFzlzMe0Blki4ZEHZ2wPeHOWCvjmyBDI=;
  b=hUPOnXmrV0c4iyHmA7HHEACkwM5wlpb9Jt4SW9vXrnIJ63+LeUGTYkCX
   cL5MjXybTvLcS5YYAoXCd6phEzjy5AnZkiYsgQVX1U24Byc2reonap0V4
   /Vyc+EFR/Q5GB/QxFM0xZTLeFwiXLyMAvSwTGB8W4UM+fboNpJZYrDB7N
   0=;
X-IronPort-AV: E=Sophos;i="5.78,365,1599523200"; 
   d="scan'208";a="66940334"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 24 Nov 2020 09:24:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 281D6A06E2;
        Tue, 24 Nov 2020 09:24:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Nov 2020 09:24:57 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.21) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Nov 2020 09:24:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/8] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 24 Nov 2020 18:24:48 +0900
Message-ID: <20201124092448.27711-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com>
References: <20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D39UWA003.ant.amazon.com (10.43.160.235) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Sun, 22 Nov 2020 16:40:20 -0800
> On Sat, Nov 21, 2020 at 07:13:22PM +0900, Kuniyuki Iwashima wrote:
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Thu, 19 Nov 2020 17:53:46 -0800
> > > On Fri, Nov 20, 2020 at 07:09:22AM +0900, Kuniyuki Iwashima wrote:
> > > > From: Martin KaFai Lau <kafai@fb.com>
> > > > Date: Wed, 18 Nov 2020 15:50:17 -0800
> > > > > On Tue, Nov 17, 2020 at 06:40:18PM +0900, Kuniyuki Iwashima wrote:
> > > > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > > > which is used only by inet_unhash(). If it is not NULL,
> > > > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > > > sockets from the closing listener to the selected one.
> > > > > > 
> > > > > > Listening sockets hold incoming connections as a linked list of struct
> > > > > > request_sock in the accept queue, and each request has reference to a full
> > > > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
> > > > > > requests from the closing listener's queue and relink them to the head of
> > > > > > the new listener's queue. We do not process each request, so the migration
> > > > > > completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
> > > > > > sockets, we will take special care in the next commit.
> > > > > > 
> > > > > > By default, we select the last element of socks[] as the new listener.
> > > > > > This behaviour is based on how the kernel moves sockets in socks[].
> > > > > > 
> > > > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > > > first two by turns. The sockets move in socks[] like below. (See also [1])
> > > > > > 
> > > > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > > > >   socks[2] : C   |      socks[2] : C --'
> > > > > >   socks[3] : D --'
> > > > > > 
> > > > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > > > requests evenly to new listeners.
> > > > > I don't think it should emphasize/claim there is a specific way that
> > > > > the kernel-pick here can redistribute the requests evenly.  It depends on
> > > > > how the application close/listen.  The userspace can not expect the
> > > > > ordering of socks[] will behave in a certain way.
> > > > 
> > > > I've expected replacing listeners by generations as a general use case.
> > > > But exactly. Users should not expect the undocumented kernel internal.
> > > > 
> > > > 
> > > > > The primary redistribution policy has to depend on BPF which is the
> > > > > policy defined by the user based on its application logic (e.g. how
> > > > > its binary restart work).  The application (and bpf) knows which one
> > > > > is a dying process and can avoid distributing to it.
> > > > > 
> > > > > The kernel-pick could be an optional fallback but not a must.  If the bpf
> > > > > prog is attached, I would even go further to call bpf to redistribute
> > > > > regardless of the sysctl, so I think the sysctl is not necessary.
> > > > 
> > > > I also think it is just an optional fallback, but to pick out a different
> > > > listener everytime, choosing the moved socket was reasonable. So the even
> > > > redistribution for a specific use case is a side effect of such socket
> > > > selection.
> > > > 
> > > > But, users should decide to use either way:
> > > >   (1) let the kernel select a new listener randomly
> > > >   (2) select a particular listener by eBPF
> > > > 
> > > > I will update the commit message like:
> > > > The kernel selects a new listener randomly, but as the side effect, it can
> > > > redistribute packets evenly for a specific case where an application
> > > > replaces listeners by generations.
> > > Since there is no feedback on sysctl, so may be something missed
> > > in the lines.
> > 
> > I'm sorry, I have missed this point while thinking about each reply...
> > 
> > 
> > > I don't think this migration logic should depend on a sysctl.
> > > At least not when a bpf prog is attached that is capable of doing
> > > migration, it is too fragile to ask user to remember to turn on
> > > the sysctl before attaching the bpf prog.
> > > 
> > > Your use case is to primarily based on bpf prog to pick or only based
> > > on kernel to do a random pick?
> Again, what is your primarily use case?

We have so many services and components that I cannot grasp all of their
implementations, but I have started this series because a service component
based on the random pick by the kernel suffered from the issue.


> > I think we have to care about both cases.
> > 
> > I think we can always enable the migration feature if eBPF prog is not
> > attached. On the other hand, if BPF_PROG_TYPE_SK_REUSEPORT prog is attached
> > to select a listener by some rules, along updating the kernel,
> > redistributing requests without user intention can break the application.
> > So, there is something needed to confirm user intension at least if eBPF
> > prog is attached.
> Right, something being able to tell if the bpf prog can do migration
> can confirm the user intention here.  However, this will not be a
> sysctl.
> 
> A new bpf_attach_type "BPF_SK_REUSEPORT_SELECT_OR_MIGRATE" can be added.
> "prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE"
> can be used to decide if migration can be done by the bpf prog.
> Although the prog->expected_attach_type has not been checked for
> BPF_PROG_TYPE_SK_REUSEPORT, there was an earlier discussion
> that the risk of breaking is very small and is acceptable.
> 
> Instead of depending on !reuse_md->data to decide if it
> is doing migration or not, a clearer signal should be given
> to the bpf prog.  A "u8 migration" can be added to "struct sk_reuseport_kern"
> (and to "struct sk_reuseport_md" accordingly).  It can tell
> the bpf prog that it is doing migration.  It should also tell if it is
> migrating a list of established sk(s) or an individual req_sk.
> Accessing "reuse_md->migration" should only be allowed for
> BPF_SK_REUSEPORT_SELECT_OR_MIGRATE during is_valid_access().
> 
> During migration, if skb is not available, an empty skb can be used.
> Migration is a slow path and does not happen very often, so it will
> be fine even it has to create a temp skb (or may be a static const skb
> can be used, not sure but this is implementation details).

I greatly appreciate your detailed idea and explanation!
I will try to implement this.


> > But honestly, I believe such eBPF users can follow this change and
> > implement migration eBPF prog if we introduce such a breaking change.
> > 
> > 
> > > Also, IIUC, this sysctl setting sticks at "*reuse", there is no way to
> > > change it until all the listening sockets are closed which is exactly
> > > the service disruption problem this series is trying to solve here.
> > 
> > Oh, exactly...
> > If we apply this series by live patching, we cannot enable the feature
> > without service disruption.
> > 
> > To enable the migration feature dynamically, how about this logic?
> > In this logic, we do not save the sysctl value and check it at each time.
> > 
> >   1. no eBPF prog attached -> ON
> >   2. eBPF prog attached and sysctl is 0 -> OFF
> No.  When bpf prog is attached and it clearly signals (expected_attach_type
> here) it can do migration, it should not depend on anything else.  It is very
> confusing to use.  When a prog is successfully loaded, verified
> and attached, it is expected to run.
> 
> This sysctl essentially only disables the bpf prog with
> type == BPF_PROG_TYPE_SK_REUSEPORT running at a particular point.
> This is going down a path that having another sysctl in the future
> to disable another bpf prog type.  If there would be a need to disable
> bpf prog on a type-by-type bases, it would need a more
> generic solution on the bpf side and do it in a consistent way
> for all prog types.  It needs a separate and longer discussion.
> 
> All behaviors of the BPF_SK_REUSEPORT_SELECT_OR_MIGRATE bpf prog
> should not depend on this sysctl at all .
> 
> /* Pseudo code to show the idea only.
>  * Actual implementation should try to fit
>  * better into the current code and should look
>  * quite different from here.
>  */
> 
> if ((prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
> 	/* call bpf to migrate */
> 	action = BPF_PROG_RUN(prog, &reuse_kern);
> 
> 	if (action == SK_PASS) {
> 		if (!reuse_kern.selected_sk)
> 			/* fallback to kernel random pick */
> 		else
> 			/* migrate to reuse_kern.selected_sk */
> 	} else {
> 		/* action == SK_DROP. don't do migration at all and
> 		 * don't fallback to kernel random pick.
> 		 */ 
> 	}
> }
> 
> Going back to the sysctl, with BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> do you still have a need on adding sysctl_tcp_migrate_req?

No, now I do not think the option should be sysctl.
It will be BPF_SK_REUSEPORT_SELECT_OR_MIGRATE in the next series.
Thank you!


> Regardless, if there is still a need,
> the document for sysctl_tcp_migrate_req should be something like:
> "the kernel will do a random pick when there is no bpf prog
>  attached to the reuseport group...."
> 
> [ ps, my reply will be slow in this week. ]
