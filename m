Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA52E38BAC7
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhEUA2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:28:12 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:58936 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhEUA2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621556810; x=1653092810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eewKL0o5ab93XycvawAMNkIQzYy/iR4dXsH93kuwGOI=;
  b=aygKZbxzkzJcJcqF+NOQgP5zmavDVmHJMaDQPBziPp/FjnwAqFlo9baq
   enHaj+q5bjWqgJpenevR5iUVTSDAbfT+Ijbu7A50+0g7A00vbRKbcYh0K
   1YcfX2y1GlUq/lzsYXRFX84TbsK9WEf4FflbEaLBe+QJQK4kBIGx18csn
   0=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="2476173"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 May 2021 00:26:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id DAB13A1757;
        Fri, 21 May 2021 00:26:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 00:26:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.239) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 21 May 2021 00:26:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Fri, 21 May 2021 09:26:39 +0900
Message-ID: <20210521002639.20533-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520233906.c7yphwjrstqmhfk6@kafai-mbp.dhcp.thefacebook.com>
References: <20210520233906.c7yphwjrstqmhfk6@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.239]
X-ClientProxiedBy: EX13D05UWB004.ant.amazon.com (10.43.161.208) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 20 May 2021 16:39:06 -0700
> On Fri, May 21, 2021 at 07:54:48AM +0900, Kuniyuki Iwashima wrote:
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Thu, 20 May 2021 14:22:01 -0700
> > > On Thu, May 20, 2021 at 05:51:17PM +0900, Kuniyuki Iwashima wrote:
> > > > From:   Martin KaFai Lau <kafai@fb.com>
> > > > Date:   Wed, 19 May 2021 23:26:48 -0700
> > > > > On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:
> > > > > 
> > > > > > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > > > > > +			       struct sock_reuseport *reuse, bool bind_inany)
> > > > > > +{
> > > > > > +	if (old_reuse == reuse) {
> > > > > > +		/* If sk was in the same reuseport group, just pop sk out of
> > > > > > +		 * the closed section and push sk into the listening section.
> > > > > > +		 */
> > > > > > +		__reuseport_detach_closed_sock(sk, old_reuse);
> > > > > > +		__reuseport_add_sock(sk, old_reuse);
> > > > > > +		return 0;
> > > > > > +	}
> > > > > > +
> > > > > > +	if (!reuse) {
> > > > > > +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> > > > > > +		 * for the shutdown()ed socket. In setsockopt() path, we should
> > > > > > +		 * not change the eBPF prog of listening sockets by attaching a
> > > > > > +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> > > > > > +		 * reuseport group and detach sk from the old group.
> > > > > > +		 */
> > > > > For the reuseport_attach_prog() path, I think it needs to consider
> > > > > the reuse->num_closed_socks != 0 case also and that should belong
> > > > > to the resurrect case.  For example, when
> > > > > sk_unhashed(sk) but sk->sk_reuseport == 0.
> > > > 
> > > > In the path, reuseport_resurrect() is called from reuseport_alloc() only
> > > > if reuse->num_closed_socks != 0.
> > > > 
> > > > 
> > > > > @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> > > > >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > > > >  					  lockdep_is_held(&reuseport_lock));
> > > > >  	if (reuse) {
> > > > > +		if (reuse->num_closed_socks) {
> > > > 
> > > > But, should this be
> > > > 
> > > > 	if (sk->sk_state == TCP_CLOSE && reuse->num_closed_socks)
> > > > 
> > > > because we need not allocate a new group when we attach a bpf prog to
> > > > listeners?
> > > The reuseport_alloc() is fine as is.  No need to change.
> > 
> > I missed sk_unhashed(sk) prevents calling reuseport_alloc()
> > if sk_state == TCP_LISTEN. I'll keep it as is.
> > 
> > 
> > > 
> > > I should have copied reuseport_attach_prog() in the last reply and
> > > commented there instead.
> > > 
> > > I meant reuseport_attach_prog() needs a change.  In reuseport_attach_prog(),
> > > iiuc, currently passing the "else if (!rcu_access_pointer(sk->sk_reuseport_cb))"
> > > check implies the sk was (and still is) hashed with sk_reuseport enabled
> > > because the current behavior would have set sk_reuseport_cb to NULL during
> > > unhash but it is no longer true now.  For example, this will break:
> > > 
> > > 1. shutdown(lsk); /* lsk was bound with sk_reuseport enabled */
> > > 2. setsockopt(lsk, ..., SO_REUSEPORT, &zero, ...); /* disable sk_reuseport */
> > > 3. setsockopt(lsk, ..., SO_ATTACH_REUSEPORT_EBPF, &prog_fd, ...);
> > >    ^---- /* This will work now because sk_reuseport_cb is not NULL.
> > >           * However, it shouldn't be allowed.
> > > 	  */
> > 
> > Thank you for explanation, I understood the case.
> > 
> > Exactly, I've confirmed that the case succeeded in the setsockopt() and I
> > could change the active listeners' prog via a shutdowned socket.
> > 
> > 
> > > 
> > > I am thinking something like this (uncompiled code):
> > > 
> > > int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
> > > {
> > > 	struct sock_reuseport *reuse;
> > > 	struct bpf_prog *old_prog;
> > > 
> > > 	if (sk_unhashed(sk)) {
> > > 		int err;
> > > 
> > > 		if (!sk->sk_reuseport)
> > > 			return -EINVAL;
> > > 
> > > 		err = reuseport_alloc(sk, false);
> > > 		if (err)
> > > 			return err;
> > > 	} else if (!rcu_access_pointer(sk->sk_reuseport_cb)) {
> > > 		/* The socket wasn't bound with SO_REUSEPORT */
> > > 		return -EINVAL;
> > > 	}
> > > 
> > > 	/* ... */
> > > }
> > > 
> > > WDYT?
> > 
> > I tested this change worked fine. I think this change should be added in
> > reuseport_detach_prog() also.
> > 
> > ---8<---
> > int reuseport_detach_prog(struct sock *sk)
> > {
> >         struct sock_reuseport *reuse;
> >         struct bpf_prog *old_prog;
> > 
> >         if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > 		return sk->sk_reuseport ? -ENOENT : -EINVAL;
> > ---8<---
> Right, a quick thought is something like this for detach:
> 
> 	spin_lock_bh(&reuseport_lock);
> 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> 					  lockdep_is_held(&reuseport_lock));

Is this necessary because reuseport_grow() can detach sk?

        if (!reuse) {
                spin_unlock_bh(&reuseport_lock);
                return -ENOENT;
        }

Then we can remove rcu_access_pointer() check and move sk_reuseport check
here.


> 	if (sk_unhashed(sk) && reuse->num_closed_socks) {
> 		spin_unlock_bh(&reuseport_lock);
> 		return -ENOENT;
> 	}
> 
> Although checking with reuseport_sock_index() will also work,
> the above probably is simpler and faster?

Yes, if sk is unhashed and has sk_reuseport_cb, it stays in the closed
section of socks[] and num_closed_socks is larger than 0.


> 
> > 
> > 
> > Another option is to add the check in sock_setsockopt():
> > SO_ATTACH_REUSEPORT_[CE]BPF, SO_DETACH_REUSEPORT_BPF.
> > 
> > Which do you think is better ?
> I think it is better to have this sock_reuseport specific bits
> staying in sock_reuseport.c.

Exactly, I'll keep the change in sock_reuseport.c
