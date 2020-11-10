Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6162B2AD7C1
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgKJNhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:37:24 -0500
Received: from correo.us.es ([193.147.175.20]:36772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731187AbgKJNhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 08:37:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7AE5339627A
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:37:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BBB8DA7E1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:37:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53E45DA85D; Tue, 10 Nov 2020 14:37:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADF1ADA789;
        Tue, 10 Nov 2020 14:37:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Nov 2020 14:37:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7CCF642EF9E0;
        Tue, 10 Nov 2020 14:37:15 +0100 (CET)
Date:   Tue, 10 Nov 2020 14:37:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v22 16/23] LSM: security_secid_to_secctx in netlink
 netfilter
Message-ID: <20201110133715.GA1890@salvia>
References: <20201105004924.11651-1-casey@schaufler-ca.com>
 <20201105004924.11651-17-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201105004924.11651-17-casey@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casey,

On Wed, Nov 04, 2020 at 04:49:17PM -0800, Casey Schaufler wrote:
> Change netlink netfilter interfaces to use lsmcontext
> pointers, and remove scaffolding.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org

You can carry this tag in your follow up patches.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
>  1 file changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 84be5a49a157..0d8b83d84422 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -301,15 +301,13 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
>  	return -1;
>  }
>  
> -static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
> +static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
>  {
> -	u32 seclen = 0;
>  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
>  	struct lsmblob blob;
> -	struct lsmcontext context = { };
>  
>  	if (!skb || !sk_fullsock(skb->sk))
> -		return 0;
> +		return;
>  
>  	read_lock_bh(&skb->sk->sk_callback_lock);
>  
> @@ -318,14 +316,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>  		 * blob. security_secid_to_secctx() will know which security
>  		 * module to use to create the secctx.  */
>  		lsmblob_init(&blob, skb->secmark);
> -		security_secid_to_secctx(&blob, &context);
> -		*secdata = context.context;
> +		security_secid_to_secctx(&blob, context);
>  	}
>  
>  	read_unlock_bh(&skb->sk->sk_callback_lock);
> -	seclen = context.len;
>  #endif
> -	return seclen;
> +	return;
>  }
>  
>  static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
> @@ -398,12 +394,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	struct net_device *indev;
>  	struct net_device *outdev;
>  	struct nf_conn *ct = NULL;
> +	struct lsmcontext context = { };
>  	enum ip_conntrack_info ctinfo;
>  	struct nfnl_ct_hook *nfnl_ct;
>  	bool csum_verify;
> -	struct lsmcontext scaff; /* scaffolding */
> -	char *secdata = NULL;
> -	u32 seclen = 0;
>  
>  	size = nlmsg_total_size(sizeof(struct nfgenmsg))
>  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> @@ -469,9 +463,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	}
>  
>  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> -		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
> -		if (seclen)
> -			size += nla_total_size(seclen);
> +		nfqnl_get_sk_secctx(entskb, &context);
> +		if (context.len)
> +			size += nla_total_size(context.len);
>  	}
>  
>  	skb = alloc_skb(size, GFP_ATOMIC);
> @@ -604,7 +598,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
>  		goto nla_put_failure;
>  
> -	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
> +	if (context.len &&
> +	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
>  		goto nla_put_failure;
>  
>  	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
> @@ -632,10 +627,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	}
>  
>  	nlh->nlmsg_len = skb->len;
> -	if (seclen) {
> -		lsmcontext_init(&scaff, secdata, seclen, 0);
> -		security_release_secctx(&scaff);
> -	}
> +	if (context.len)
> +		security_release_secctx(&context);
>  	return skb;
>  
>  nla_put_failure:
> @@ -643,10 +636,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	kfree_skb(skb);
>  	net_err_ratelimited("nf_queue: error creating packet message\n");
>  nlmsg_failure:
> -	if (seclen) {
> -		lsmcontext_init(&scaff, secdata, seclen, 0);
> -		security_release_secctx(&scaff);
> -	}
> +	if (context.len)
> +		security_release_secctx(&context);
>  	return NULL;
>  }
>  
> -- 
> 2.24.1
> 
