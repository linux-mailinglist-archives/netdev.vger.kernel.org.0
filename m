Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770B14C43F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 01:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfFSX5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 19:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfFSX5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 19:57:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71C6130832D3;
        Wed, 19 Jun 2019 23:57:22 +0000 (UTC)
Received: from localhost (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C85B05D719;
        Wed, 19 Jun 2019 23:57:19 +0000 (UTC)
Date:   Thu, 20 Jun 2019 01:57:15 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v5 3/6] ipv4: Dump route exceptions if requested
Message-ID: <20190620015715.7f243380@redhat.com>
In-Reply-To: <b85db470-81c2-3abe-a68b-154711147656@gmail.com>
References: <cover.1560827176.git.sbrivio@redhat.com>
        <106687f38b1eaf957f4ff2bad343519231815482.1560827176.git.sbrivio@redhat.com>
        <b85db470-81c2-3abe-a68b-154711147656@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 19 Jun 2019 23:57:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 08:48:23 -0600
David Ahern <dsahern@gmail.com> wrote:

> > +++ b/net/ipv4/fib_trie.c
> > @@ -2000,28 +2000,92 @@ void fib_free_table(struct fib_table *tb)
> >  	call_rcu(&tb->rcu, __trie_free_rcu);
> >  }
> >  
> > +static int fib_dump_fnhe_from_leaf(struct fib_alias *fa, struct sk_buff *skb,
> > +				   struct netlink_callback *cb,
> > +				   int *fa_index, int fa_start)
> > +{
> > +	struct net *net = sock_net(cb->skb->sk);
> > +	struct fib_info *fi = fa->fa_info;
> > +	struct fnhe_hash_bucket *bucket;
> > +	struct fib_nh_common *nhc;
> > +	int i, genid;
> > +
> > +	if (!fi || fi->fib_flags & RTNH_F_DEAD)
> > +		return 0;
> > +
> > +	nhc = fib_info_nhc(fi, 0);  
> 
> This should be a loop over fi->fib_nhs for net:
> 	for (i = 0; i < fi->fib_nhs; i++) {
> 		nhc = fib_info_nhc(fi, 0);
> 		...
> 
> and a loop over fib_info_num_path(fi) for net-next:
> 	for (i = 0; i < fib_info_num_path(fi); i++) {
> 		nhc = fib_info_nhc(fi, 0);
> 		...

Right, I started this from net-next and only later "adapted" to net
clearly in the wrong way. Thanks for providing both expressions. Fixed
in v6.

> 
> > +	if (nhc->nhc_flags & RTNH_F_DEAD)
> > +		return 0;  
> 
> And then the loop over the exception bucket could be a helper in route.c
> in which case you don't need to export rt_fill_info and nhc_exceptions
> code does not spread to fib_trie.c

Cleaner I guess, changed in v6.
 
> > +
> > +	bucket = rcu_dereference(nhc->nhc_exceptions);
> > +	if (!bucket)
> > +		return 0;
> > +
> > +	genid = fnhe_genid(net);
> > +
> > +	for (i = 0; i < FNHE_HASH_SIZE; i++) {
> > +		struct fib_nh_exception *fnhe;
> > +
> > +		for (fnhe = rcu_dereference(bucket[i].chain); fnhe;
> > +		     fnhe = rcu_dereference(fnhe->fnhe_next)) {
> > +			struct flowi4 fl4 = {};  
> 
> rather than pass an empty flow struct, update rt_fill_info to handle a
> NULL fl4; it's only a few checks.

Added patch and changed in v6.

-- 
Stefano
