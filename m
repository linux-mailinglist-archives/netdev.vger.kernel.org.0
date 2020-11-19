Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4F2B9D79
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgKSWNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:13:44 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:52159 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgKSWNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605824022; x=1637360022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=6ZqawRj90596OyIiJCq+GBiWpU5fbf5vnBgay7an51Y=;
  b=p2hZ+FACO3ZWm+JqwImGcBOq8I60J5EUrJAVjUOOJ+Iu7duT/Oz3urG/
   onGzjPiJr+jlODsH12HqMMtvLZvQsNKx5v94MeEzeOAC6KGIhozcKckNl
   Lik76WxePy5NPtNtabV82wNpsh8ayocJNzhtrNirX83yIEry8Aw3zPWas
   I=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="67539107"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Nov 2020 22:13:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id D8B9EAEF15;
        Thu, 19 Nov 2020 22:13:40 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:13:40 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.67) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:13:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 7/8] bpf: Call bpf_run_sk_reuseport() for socket migration.
Date:   Fri, 20 Nov 2020 07:13:31 +0900
Message-ID: <20201119221331.77586-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201119010045.a6mqkzuv4tjruny6@kafai-mbp.dhcp.thefacebook.com>
References: <20201119010045.a6mqkzuv4tjruny6@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.67]
X-ClientProxiedBy: EX13d09UWC002.ant.amazon.com (10.43.162.102) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 18 Nov 2020 17:00:45 -0800
> On Tue, Nov 17, 2020 at 06:40:22PM +0900, Kuniyuki Iwashima wrote:
> > This patch makes it possible to select a new listener for socket migration
> > by eBPF.
> > 
> > The noteworthy point is that we select a listening socket in
> > reuseport_detach_sock() and reuseport_select_sock(), but we do not have
> > struct skb in the unhash path.
> > 
> > Since we cannot pass skb to the eBPF program, we run only the
> > BPF_PROG_TYPE_SK_REUSEPORT program by calling bpf_run_sk_reuseport() with
> > skb NULL. So, some fields derived from skb are also NULL in the eBPF
> > program.
> More things need to be considered here when skb is NULL.
> 
> Some helpers are probably assuming skb is not NULL.
> 
> Also, the sk_lookup in filter.c is actually passing a NULL skb to avoid
> doing the reuseport select.

Honestly, I have missed this point...
I wanted users to reuse the same eBPF program seamlessly, but it seems unsafe.


> > Moreover, we can cancel migration by returning SK_DROP. This feature is
> > useful when listeners have different settings at the socket API level or
> > when we want to free resources as soon as possible.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  net/core/filter.c          | 26 +++++++++++++++++++++-----
> >  net/core/sock_reuseport.c  | 23 ++++++++++++++++++++---
> >  net/ipv4/inet_hashtables.c |  2 +-
> >  3 files changed, 42 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 01e28f283962..ffc4591878b8 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8914,6 +8914,22 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >  	SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(S, NS, F, NF,		       \
> >  					     BPF_FIELD_SIZEOF(NS, NF), 0)
> >  
> > +#define SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF_OR_NULL(S, NS, F, NF, SIZE, OFF)	\
> > +	do {									\
> > +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), si->dst_reg,	\
> > +				      si->src_reg, offsetof(S, F));		\
> > +		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);		\
> Although it may not matter much, always doing this check seems not very ideal
> considering the fast path will always have skb and only the slow
> path (accept-queue migrate) has skb is NULL.  I think the req_sk usually
> has the skb also except the timer one.

Yes, but the migration happens only when/after the listener is closed, so
I think it does not occur so frequently and will not be a problem.


> First thought is to create a temp skb but it has its own issues.
> or it may actually belong to a new prog type.  However, lets keep
> exploring possible options (including NULL skb).

I also thought up the two ideas, but the former will be a bit complicated.
And the latter makes users implement the new eBPF program. I did not want
users to struggle anymore, so I have selected the NULL skb. However, it is
not safe, so adding a new prog type seems to be the better way.
