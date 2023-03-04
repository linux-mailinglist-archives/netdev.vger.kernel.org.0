Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760A56AA78D
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCDCVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCDCVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:21:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3B61BAC6
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC655B819D1
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5564EC433EF;
        Sat,  4 Mar 2023 02:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677896492;
        bh=mLDbDmj7DUPp85tIXcZFM50tE9LMLn8GIU42W4q05Z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hj5nJf7ZnSK1qmt/3bTWQa0H/MXBwbTVeFxUAHvHmJk2IZ7TOvVppFCno1TPDMfdP
         ZGYMv2XRIpXoUxLHuKqic3d8OsFybpMd3+pdLr59s9KGLi52iRXnePS8yeFmaix1c7
         OI35K6J0YTIBY+0KhVtLhEnDZ+V0AmOyeD0yLZ7XVel+AY8WzwR+T0sNa5tqz/b44m
         a4/U1/EN9xSARvzqiwx3xh4qEZOmTRHyNsOvqWNPbq5AykNz0111nGbEtG8SaYrfTl
         5+yItxJ3nGCTYWs0h+SFiZUfMkflcayJ/nWKHV3VQB9wtOez8XQB9+0XtR8XRavOfN
         mh4doQZXdF+3w==
Date:   Fri, 3 Mar 2023 18:21:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <cel@kernel.org>
Cc:     pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        kernel-tls-handshake@lists.linux.dev, john.haxby@oracle.com
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230303182131.1d1dd4d8@kernel.org>
In-Reply-To: <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
        <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Mar 2023 13:51:31 -0500 Chuck Lever wrote:
> +operations:
> +  list:
> +    -
> +      name: ready
> +      doc: Notify handlers that a new handshake request is waiting
> +      value: 1

FWIW the value: 1 is now default for attr sets and ops, so you can drop
in v7 if you want.

> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 78beaa765c73..a0ce9de4dab1 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -188,6 +188,11 @@ struct net {
>  #if IS_ENABLED(CONFIG_SMC)
>  	struct netns_smc	smc;
>  #endif
> +
> +	/* transport layer security handshake requests */
> +	spinlock_t		hs_lock;
> +	struct list_head	hs_requests;
> +	int			hs_pending;

Do we need this statically here? Can you use .id and .size of
pernet_operations and then net_generic() to access?

Also spinlock_t is 4B, right? So it'd be better for packing
to put in next to hs_pending.

>  } __randomize_layout;
>  
>  #include <linux/seq_file_net.h>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 573f2bf7e0de..2a7345ce2540 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -519,6 +519,7 @@ struct sock {
>  
>  	struct socket		*sk_socket;
>  	void			*sk_user_data;
> +	void			*sk_handshake_req;

Additions to core structures need an #ifdef I reckon.
Preferably put the pointer in a hashtable, there will
likely be relatively few sockets in a system with a req
outstanding. Not to mention distro kernels which will have
to burn 8B whether the feature is used or not.

> +static int handshake_status_reply(struct sk_buff *skb, struct genl_info *gi,
> +				  int status)
> +{
> +	struct nlmsghdr *hdr;
> +	struct sk_buff *msg;
> +	int ret;
> +
> +	ret = -ENOMEM;
> +	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		goto out;
> +	hdr = handshake_genl_put(msg, gi);
> +	if (!hdr)
> +		goto out_free;
> +
> +	ret = -EMSGSIZE;
> +	ret = nla_put_u32(msg, HANDSHAKE_A_ACCEPT_STATUS, status);
> +	if (ret < 0)
> +		goto out_free;
> +
> +	genlmsg_end(msg, hdr);
> +	return genlmsg_reply(msg, gi);
> +
> +out_free:
> +	genlmsg_cancel(msg, hdr);
> +out:
> +	return ret;
> +}

Why implement a full reply to return errno? The normal Netlink ACK
carries errno, you can simply return an error from the .doit().

> +static int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *gi)
> +{
> +	struct nlattr *tb[HANDSHAKE_A_ACCEPT_MAX + 1];
> +	struct net *net = sock_net(skb->sk);
> +	struct handshake_req *pos, *req;
> +	int fd, err;
> +
> +	err = -EINVAL;
> +	if (genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
> +			  HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
> +			  handshake_accept_nl_policy, NULL))
> +		goto out_status;

gi->attrs has the attributes already parsed and ready to use!

BTW would you mind sed'ing /gi/info/ on the patches?
That's the most common variable name for struct genl_info.

> +	if (!tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS])
> +		goto out_status;

Shouldn't that be an error (checked with GENL_REQ_ATTR_CHECK())?

> +	req = NULL;
> +	spin_lock(&net->hs_lock);
> +	list_for_each_entry(pos, &net->hs_requests, hr_list) {
> +		if (pos->hr_proto->hp_handler_class !=
> +		    nla_get_u32(tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS]))

Maybe let's store this to a local variable to avoid long lines.

> +			continue;
> +		__remove_pending_locked(net, pos);
> +		req = pos;
> +		break;
> +	}
> +	spin_unlock(&net->hs_lock);
> +	if (!req)
> +		goto out_status;
> +
> +	fd = handshake_dup(req->hr_sock);
> +	if (fd < 0) {
> +		err = fd;
> +		goto out_complete;
> +	}
> +	err = req->hr_proto->hp_accept(req, gi, fd);
> +	if (err)
> +		goto out_complete;
> +
> +	trace_handshake_cmd_accept(net, req, req->hr_sock, fd);
> +	return 0;
> +
> +out_complete:
> +	handshake_complete(req, -EIO, NULL);
> +	fput(req->hr_sock->file);
> +out_status:
> +	trace_handshake_cmd_accept_err(net, req, NULL, err);
> +	return handshake_status_reply(skb, gi, err);
> +}
> +
> +static const struct nla_policy
> +handshake_done_nl_policy[HANDSHAKE_A_DONE_MAX + 1] = {
> +	[HANDSHAKE_A_DONE_SOCKFD] = { .type = NLA_U32, },
> +	[HANDSHAKE_A_DONE_STATUS] = { .type = NLA_U32, },
> +	[HANDSHAKE_A_DONE_REMOTE_AUTH] = { .type = NLA_U32, },
> +};

> +static const struct genl_split_ops handshake_nl_ops[] = {
> +	{
> +		.cmd		= HANDSHAKE_CMD_ACCEPT,
> +		.doit		= handshake_nl_accept_doit,
> +		.policy		= handshake_accept_nl_policy,
> +		.maxattr	= HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
> +		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
> +	},
> +	{
> +		.cmd		= HANDSHAKE_CMD_DONE,
> +		.doit		= handshake_nl_done_doit,
> +		.policy		= handshake_done_nl_policy,
> +		.maxattr	= HANDSHAKE_A_DONE_MAX,
> +		.flags		= GENL_CMD_CAP_DO,
> +	},
> +};
> +
> +static const struct genl_multicast_group handshake_nl_mcgrps[] = {
> +	[HANDSHAKE_HANDLER_CLASS_NONE] = { .name = HANDSHAKE_MCGRP_NONE, },
> +};
> +
> +static struct genl_family __ro_after_init handshake_genl_family = {
> +	.hdrsize		= 0,
> +	.name			= HANDSHAKE_FAMILY_NAME,
> +	.version		= HANDSHAKE_FAMILY_VERSION,
> +	.netnsok		= true,
> +	.parallel_ops		= true,
> +	.n_mcgrps		= ARRAY_SIZE(handshake_nl_mcgrps),
> +	.n_split_ops		= ARRAY_SIZE(handshake_nl_ops),
> +	.split_ops		= handshake_nl_ops,
> +	.mcgrps			= handshake_nl_mcgrps,
> +	.module			= THIS_MODULE,
> +};

You're not auto-generating the family, ops, and policies?
Any reason?

> +static void __net_exit handshake_net_exit(struct net *net)
> +{
> +	struct handshake_req *req;
> +	LIST_HEAD(requests);
> +
> +	/*
> +	 * This drains the net's pending list. Requests that
> +	 * have been accepted and are in progress will be
> +	 * destroyed when the socket is closed.
> +	 */
> +	spin_lock(&net->hs_lock);
> +	list_splice_init(&requests, &net->hs_requests);

What about new requests getting queued?

> +	spin_unlock(&net->hs_lock);
> +
> +	while (!list_empty(&requests)) {
> +		req = list_first_entry(&requests, struct handshake_req, hr_list);
> +		list_del(&req->hr_list);
> +
> +		/*
> +		 * Requests on this list have not yet been
> +		 * accepted, so they do not have an fd to put.
> +		 */
> +
> +		handshake_complete(req, -ETIMEDOUT, NULL);
> +	}
> +}

> +/**
> + * handshake_req_alloc - consumer API to allocate a request
> + * @sock: open socket on which to perform a handshake
> + * @proto: security protocol
> + * @flags: memory allocation flags
> + *
> + * Returns an initialized handshake_req or NULL.
> + */
> +struct handshake_req *handshake_req_alloc(struct socket *sock,
> +					  const struct handshake_proto *proto,
> +					  gfp_t flags)
> +{
> +	struct handshake_req *req;
> +
> +	/* Avoid accessing uninitialized global variables later on */
> +	if (!handshake_genl_inited)
> +		return NULL;
> +
> +	req = kzalloc(sizeof(*req) + proto->hp_privsize, flags);

Go to the next comment, then come back ...

... and then here you can use struct_size(req, priv, proto->hp_privsize)
to avoid false positive "this addition may overflow" patches.

> +	if (!req)
> +		return NULL;
> +
> +	sock_hold(sock->sk);
> +
> +	INIT_LIST_HEAD(&req->hr_list);
> +	req->hr_sock = sock;
> +	req->hr_proto = proto;
> +	return req;
> +}
> +EXPORT_SYMBOL(handshake_req_alloc);
> +
> +/**
> + * handshake_req_private - consumer API to return per-handshake private data
> + * @req: handshake arguments
> + *
> + */
> +void *handshake_req_private(struct handshake_req *req)
> +{
> +	return (void *)(req + 1);

IDK if this is not going to run afoul of the new object size checks
from Kees. You may be better of adding a flex array member to req
(char priv[]) and returning it here. (go back up)

> +}
> +EXPORT_SYMBOL(handshake_req_private);

> +/**
> + * handshake_req_cancel - consumer API to cancel an in-progress handshake
> + * @sock: socket on which there is an ongoing handshake
> + *
> + * XXX: Perhaps killing the user space agent might also be necessary?
> + *
> + * Request cancellation races with request completion. To determine
> + * who won, callers examine the return value from this function.
> + *
> + * Return values:
> + *   %true - Uncompleted handshake request was canceled or not found
> + *   %false - Handshake request already completed
> + */
> +bool handshake_req_cancel(struct socket *sock)
> +{
> +	struct handshake_req *req;
> +	struct sock *sk;
> +	struct net *net;
> +
> +	if (!sock)
> +		return true;

Is there a strong reason to check the input here?

> +	sk = sock->sk;
> +	req = sk->sk_handshake_req;
> +	net = sock_net(sk);
> +
> +	if (!req) {
> +		trace_handshake_cancel_none(net, req, sock);
> +		return true;
> +	}
> +
> +	if (remove_pending(net, req)) {
> +		/* Request hadn't been accepted */
> +		trace_handshake_cancel(net, req, sock);
> +		return true;
> +	}
> +	if (test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
> +		/* Request already completed */
> +		trace_handshake_cancel_busy(net, req, sock);
> +		return false;
> +	}
> +
> +	__sock_put(sk);
> +	trace_handshake_cancel(net, req, sock);
> +	return true;
> +}
