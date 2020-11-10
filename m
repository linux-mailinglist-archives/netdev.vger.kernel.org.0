Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996BE2ADF4B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgKJT0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:26:41 -0500
Received: from namei.org ([65.99.196.166]:52328 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJT0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 14:26:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 0AAJQCLt001815;
        Tue, 10 Nov 2020 19:26:12 GMT
Date:   Wed, 11 Nov 2020 06:26:12 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Casey Schaufler <casey@schaufler-ca.com>,
        casey.schaufler@intel.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v22 16/23] LSM: security_secid_to_secctx in netlink
 netfilter
In-Reply-To: <20201110133715.GA1890@salvia>
Message-ID: <alpine.LRH.2.21.2011110626050.32313@namei.org>
References: <20201105004924.11651-1-casey@schaufler-ca.com> <20201105004924.11651-17-casey@schaufler-ca.com> <20201110133715.GA1890@salvia>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020, Pablo Neira Ayuso wrote:

> Hi Casey,
> 
> On Wed, Nov 04, 2020 at 04:49:17PM -0800, Casey Schaufler wrote:
> > Change netlink netfilter interfaces to use lsmcontext
> > pointers, and remove scaffolding.
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: John Johansen <john.johansen@canonical.com>
> > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Cc: netdev@vger.kernel.org
> > Cc: netfilter-devel@vger.kernel.org
> 
> You can carry this tag in your follow up patches.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for the review!

> 
> Thanks.
> 
> > ---
> >  net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
> >  1 file changed, 14 insertions(+), 23 deletions(-)
> > 
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index 84be5a49a157..0d8b83d84422 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -301,15 +301,13 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
> >  	return -1;
> >  }
> >  
> > -static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
> > +static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
> >  {
> > -	u32 seclen = 0;
> >  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
> >  	struct lsmblob blob;
> > -	struct lsmcontext context = { };
> >  
> >  	if (!skb || !sk_fullsock(skb->sk))
> > -		return 0;
> > +		return;
> >  
> >  	read_lock_bh(&skb->sk->sk_callback_lock);
> >  
> > @@ -318,14 +316,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
> >  		 * blob. security_secid_to_secctx() will know which security
> >  		 * module to use to create the secctx.  */
> >  		lsmblob_init(&blob, skb->secmark);
> > -		security_secid_to_secctx(&blob, &context);
> > -		*secdata = context.context;
> > +		security_secid_to_secctx(&blob, context);
> >  	}
> >  
> >  	read_unlock_bh(&skb->sk->sk_callback_lock);
> > -	seclen = context.len;
> >  #endif
> > -	return seclen;
> > +	return;
> >  }
> >  
> >  static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
> > @@ -398,12 +394,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >  	struct net_device *indev;
> >  	struct net_device *outdev;
> >  	struct nf_conn *ct = NULL;
> > +	struct lsmcontext context = { };
> >  	enum ip_conntrack_info ctinfo;
> >  	struct nfnl_ct_hook *nfnl_ct;
> >  	bool csum_verify;
> > -	struct lsmcontext scaff; /* scaffolding */
> > -	char *secdata = NULL;
> > -	u32 seclen = 0;
> >  
> >  	size = nlmsg_total_size(sizeof(struct nfgenmsg))
> >  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> > @@ -469,9 +463,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >  	}
> >  
> >  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> > -		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
> > -		if (seclen)
> > -			size += nla_total_size(seclen);
> > +		nfqnl_get_sk_secctx(entskb, &context);
> > +		if (context.len)
> > +			size += nla_total_size(context.len);
> >  	}
> >  
> >  	skb = alloc_skb(size, GFP_ATOMIC);
> > @@ -604,7 +598,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >  	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
> >  		goto nla_put_failure;
> >  
> > -	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
> > +	if (context.len &&
> > +	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
> >  		goto nla_put_failure;
> >  
> >  	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
> > @@ -632,10 +627,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >  	}
> >  
> >  	nlh->nlmsg_len = skb->len;
> > -	if (seclen) {
> > -		lsmcontext_init(&scaff, secdata, seclen, 0);
> > -		security_release_secctx(&scaff);
> > -	}
> > +	if (context.len)
> > +		security_release_secctx(&context);
> >  	return skb;
> >  
> >  nla_put_failure:
> > @@ -643,10 +636,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
> >  	kfree_skb(skb);
> >  	net_err_ratelimited("nf_queue: error creating packet message\n");
> >  nlmsg_failure:
> > -	if (seclen) {
> > -		lsmcontext_init(&scaff, secdata, seclen, 0);
> > -		security_release_secctx(&scaff);
> > -	}
> > +	if (context.len)
> > +		security_release_secctx(&context);
> >  	return NULL;
> >  }
> >  
> > -- 
> > 2.24.1
> > 
> 

-- 
James Morris
<jmorris@namei.org>

