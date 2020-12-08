Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F84F2D24C8
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgLHHnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:43:22 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:45786 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgLHHnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:43:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607413401; x=1638949401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=T8wT7HHeLn/LSS2Bl2+pBce5pFFczv34J3fkqjLaloI=;
  b=Ood+wUcoEnEXOcMzIkB1oGV38JpRtYr8rizv3DlWdb4+OpT6N12lr449
   SS1QhFG30sBfZm8Mupxj6F4/CKEqLSHF8PKkWkPojsy8oAEeeBudHvM2I
   5GqIhvOaWb/TggcgR1idabmsQs1PsKn7ebJbt1mg+c0EtRSnjMtg1y62Y
   Q=;
X-IronPort-AV: E=Sophos;i="5.78,401,1599523200"; 
   d="scan'208";a="101236346"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Dec 2020 07:42:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id ED8C81A0B6D;
        Tue,  8 Dec 2020 07:42:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 07:42:39 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.53) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 07:42:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 8 Dec 2020 16:42:30 +0900
Message-ID: <20201208074230.35109-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201208065418.ne75jprdbpglrgal@kafai-mbp.dhcp.thefacebook.com>
References: <20201208065418.ne75jprdbpglrgal@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D48UWB002.ant.amazon.com (10.43.163.125) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Mon, 7 Dec 2020 22:54:18 -0800
> On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> 
> > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> >  
> >  		reuse->num_socks--;
> >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > +		prog = rcu_dereference(reuse->prog);
> >  
> >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > +			if (reuse->num_socks && !prog)
> > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> I asked in the earlier thread if the primary use case is to only
> use the bpf prog to pick.  That thread did not come to
> a solid answer but did conclude that the sysctl should not
> control the behavior of the BPF_SK_REUSEPORT_SELECT_OR_MIGRATE prog.
> 
> From this change here, it seems it is still desired to only depend
> on the kernel to random pick even when no bpf prog is attached.

I wrote this way only to split patches into tcp and bpf parts.
So, in the 10th patch, eBPF prog is run if the type is
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
https://lore.kernel.org/netdev/20201201144418.35045-11-kuniyu@amazon.co.jp/

But, it makes a breakage, so I will move
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE validation into 10th patch so that the
type is only available after 10th patch.

---8<---
	case BPF_PROG_TYPE_SK_REUSEPORT:
		switch (expected_attach_type) {
		case BPF_SK_REUSEPORT_SELECT:
		case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE: <- move to 10th.
			return 0;
		default:
			return -EINVAL;
		}
---8<---


> If that is the case, a sysctl to guard here for not changing
> the current behavior makes sense.
> It should still only control the non-bpf-pick behavior:
> when the sysctl is on, the kernel will still do a random pick
> when there is no bpf prog attached to the reuseport group.
> Thoughts?

If different applications listen on the same port without eBPF prog, I
think sysctl is necessary. But honestly, I am not sure there is really such
a case and sysctl is necessary.

If patcheset with sysctl is more acceptable, I will add it back in the next
spin.


> > +
> >  			reuse->num_closed_socks++;
> >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> >  		} else {
> > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> >  out:
> >  	spin_unlock_bh(&reuseport_lock);
> > +
> > +	return nsk;
> >  }
> >  EXPORT_SYMBOL(reuseport_detach_sock);
