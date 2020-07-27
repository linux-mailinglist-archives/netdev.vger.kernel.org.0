Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438B122F367
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgG0PGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:06:11 -0400
Received: from verein.lst.de ([213.95.11.211]:44011 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729630AbgG0PGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 11:06:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8445868B05; Mon, 27 Jul 2020 17:06:01 +0200 (CEST)
Date:   Mon, 27 Jul 2020 17:06:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 12/26] netfilter: switch nf_setsockopt to sockptr_t
Message-ID: <20200727150601.GA3447@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-13-hch@lst.de> <20200727150310.GA1632472@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727150310.GA1632472@zx2c4.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 05:03:10PM +0200, Jason A. Donenfeld wrote:
> Hi Christoph,
> 
> On Thu, Jul 23, 2020 at 08:08:54AM +0200, Christoph Hellwig wrote:
> > diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> > index da933f99b5d517..42befbf12846c0 100644
> > --- a/net/ipv4/ip_sockglue.c
> > +++ b/net/ipv4/ip_sockglue.c
> > @@ -1422,7 +1422,8 @@ int ip_setsockopt(struct sock *sk, int level,
> >  			optname != IP_IPSEC_POLICY &&
> >  			optname != IP_XFRM_POLICY &&
> >  			!ip_mroute_opt(optname))
> > -		err = nf_setsockopt(sk, PF_INET, optname, optval, optlen);
> > +		err = nf_setsockopt(sk, PF_INET, optname, USER_SOCKPTR(optval),
> > +				    optlen);
> >  #endif
> >  	return err;
> >  }
> > diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> > index 4697d09c98dc3e..f2a9680303d8c0 100644
> > --- a/net/ipv4/netfilter/ip_tables.c
> > +++ b/net/ipv4/netfilter/ip_tables.c
> > @@ -1102,7 +1102,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
> >  }
> >  
> >  static int
> > -do_replace(struct net *net, const void __user *user, unsigned int len)
> > +do_replace(struct net *net, sockptr_t arg, unsigned int len)
> >  {
> >  	int ret;
> >  	struct ipt_replace tmp;
> > @@ -1110,7 +1110,7 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
> >  	void *loc_cpu_entry;
> >  	struct ipt_entry *iter;
> >  
> > -	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
> > +	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
> >  		return -EFAULT;
> >  
> >  	/* overflow check */
> > @@ -1126,8 +1126,8 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
> >  		return -ENOMEM;
> >  
> >  	loc_cpu_entry = newinfo->entries;
> > -	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
> > -			   tmp.size) != 0) {
> > +	sockptr_advance(arg, sizeof(tmp));
> > +	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
> >  		ret = -EFAULT;
> >  		goto free_newinfo;
> >  	}
> 
> Something along this path seems to have broken with this patch. An
> invocation of `iptables -A INPUT -m length --length 1360 -j DROP` now
> fails, with
> 
> nf_setsockopt->do_replace->translate_table->check_entry_size_and_hooks:
>   (unsigned char *)e + e->next_offset > limit  ==>  TRUE
> 
> resulting in the whole call chain returning -EINVAL. It bisects back to
> this commit. This is on net-next.

This is another use o sockptr_advance that Ido already found a problem
in.  I'm looking into this at the moment..
