Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B0F699227
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjBPKsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjBPKso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:48:44 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF72A5649C
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:48:14 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BBEB3209BD;
        Thu, 16 Feb 2023 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676544472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLjdp1We5kz4H0SFaSME9gZHzx8kUip4I4Ubbbcem/I=;
        b=R0m48H7CSsZEBIcrJtkRSW/TWIe5TV3pjzkPRskDZ/lxv7rc3D1K/dg4sQt3dxwZ8UJMX1
        Xvwq5qghM5KOpJBN7SesNcAJOAzMSu9tYJk6yNfygwRWH/5BfS6038BdX0tgDedQbsg9oz
        iWbkBR0KDH7Sx7UlH9d3GD9dVkDjyEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676544472;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLjdp1We5kz4H0SFaSME9gZHzx8kUip4I4Ubbbcem/I=;
        b=aETy5t9+oxWWisyXo8ktf1Jj3BiZUmTQLBN2tgOA8sLkQI4h7kBsfpXQ2I8bIryzJGFGlK
        63XVH+RyQsBc+TBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0D6013484;
        Thu, 16 Feb 2023 10:47:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mtzpJtgJ7mM9TAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 16 Feb 2023 10:47:52 +0000
Message-ID: <d170edfd-f2a2-c7a2-c473-c80f20c6557a@suse.de>
Date:   Thu, 16 Feb 2023 11:47:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
 <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 20:23, Chuck Lever wrote:
> When a kernel consumer needs a transport layer security session, it
> first needs a handshake to negotiate and establish a session. This
> negotiation can be done in user space via one of the several
> existing library implementations, or it can be done in the kernel.
> 
> No in-kernel handshake implementations yet exist. In their absence,
> we add a netlink service that can:
> 
> a. Notify a user space daemon that a handshake is needed.
> 
> b. Once notified, the daemon calls the kernel back via this
>     netlink service to get the handshake parameters, including an
>     open socket on which to establish the session.
> 
> c. Once the handshake is complete, the daemon reports the
>     session status and other information via a second netlink
>     operation. This operation marks that it is safe for the
>     kernel to use the open socket and the security session
>     established there.
> 
> The notification service uses a multicast group. Each handshake
> protocol (eg, TLSv1.3, PSP, etc) adopts its own group number so that
> the user space daemons for performing handshakes are completely
> independent of one another. The kernel can then tell via
> netlink_has_listeners() whether a user space daemon is active and
> can handle a handshake request for the desired security layer
> protocol.
> 
> A new netlink operation, ACCEPT, acts like accept(2) in that it
> instantiates a file descriptor in the user space daemon's fd table.
> If this operation is successful, the reply carries the fd number,
> which can be treated as an open and ready file descriptor.
> 
> While user space is performing the handshake, the kernel keeps its
> muddy paws off the open socket. A second new netlink operation,
> DONE, indicates that the user space daemon is finished with the
> socket and it is safe for the kernel to use again. The operation
> also indicates whether a session was established successfully.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   include/net/handshake.h        |   46 +++++
>   include/net/net_namespace.h    |    5 +
>   include/net/sock.h             |    1
>   include/uapi/linux/handshake.h |   56 ++++++
>   net/Makefile                   |    1
>   net/handshake/Makefile         |   11 +
>   net/handshake/handshake.h      |   43 +++++
>   net/handshake/netlink.c        |  370 ++++++++++++++++++++++++++++++++++++++++
>   net/handshake/request.c        |  160 +++++++++++++++++
>   9 files changed, 693 insertions(+)
>   create mode 100644 include/net/handshake.h
>   create mode 100644 include/uapi/linux/handshake.h
>   create mode 100644 net/handshake/Makefile
>   create mode 100644 net/handshake/handshake.h
>   create mode 100644 net/handshake/netlink.c
>   create mode 100644 net/handshake/request.c
> 
> diff --git a/include/net/handshake.h b/include/net/handshake.h
> new file mode 100644
> index 000000000000..ca401c08c541
> --- /dev/null
> +++ b/include/net/handshake.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Generic HANDSHAKE service.
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +/*
> + * Data structures and functions that are visible only within the
> + * kernel are declared here.
> + */
> +
> +#ifndef _NET_HANDSHAKE_H
> +#define _NET_HANDSHAKE_H
> +
> +struct handshake_req;
> +
> +/*
> + * Invariants for all handshake requests for one transport layer
> + * security protocol
> + */
> +struct handshake_proto {
> +	int			hp_protocol;
> +	int			hp_mcgrp;
> +	size_t			hp_privsize;
> +
> +	int			(*hp_accept)(struct handshake_req *req,
> +					     struct genl_info *gi, int fd);
> +	void			(*hp_done)(struct handshake_req *req,
> +					   int status, struct nlattr *args);
> +	void			(*hp_destroy)(struct handshake_req *req);
> +};
> +
> +extern struct handshake_req *
> +handshake_req_alloc(struct socket *sock, const struct handshake_proto *proto,
> +		    gfp_t flags);
> +extern void *handshake_req_private(struct handshake_req *req);
> +extern int handshake_req_submit(struct handshake_req *req, gfp_t flags);
> +extern void handshake_req_cancel(struct socket *sock);
> +
> +extern struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
> +					   struct genl_info *gi);
> +
> +#endif /* _NET_HANDSHAKE_H */
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 8c3587d5c308..a66309789560 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -186,6 +186,11 @@ struct net {
>   #if IS_ENABLED(CONFIG_SMC)
>   	struct netns_smc	smc;
>   #endif
> +
> +	/* transport layer security handshake requests */
> +	spinlock_t		hs_lock;
> +	struct list_head	hs_requests;
> +	int			hs_pending;
>   } __randomize_layout;
>   
>   #include <linux/seq_file_net.h>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index e0517ecc6531..e16e63ff61f2 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -515,6 +515,7 @@ struct sock {
>   
>   	struct socket		*sk_socket;
>   	void			*sk_user_data;
> +	void			*sk_handshake_req;
>   #ifdef CONFIG_SECURITY
>   	void			*sk_security;
>   #endif
> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
> new file mode 100644
> index 000000000000..9544edeb181f
> --- /dev/null
> +++ b/include/uapi/linux/handshake.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * GENL HANDSHAKE service.
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +/*
> + * Data structures and functions that are visible to user space are
> + * declared here. This file constitutes an API contract between the
> + * Linux kernel and user space.
> + */
> +
> +#ifndef _UAPI_LINUX_HANDSHAKE_H
> +#define _UAPI_LINUX_HANDSHAKE_H
> +
> +#define HANDSHAKE_GENL_NAME	"handshake"
> +#define HANDSHAKE_GENL_VERSION	0x01
> +
> +enum handshake_genl_mcgrps {
> +	HANDSHAKE_GENL_MCGRP_NONE = 0,
> +};
> +
> +#define HANDSHAKE_GENL_MCGRP_NONE_NAME	"none"
> +
> +enum handshake_genl_cmds {
> +	HANDSHAKE_GENL_CMD_UNSPEC = 0,
> +	HANDSHAKE_GENL_CMD_READY,
> +	HANDSHAKE_GENL_CMD_ACCEPT,
> +	HANDSHAKE_GENL_CMD_DONE,
> +
> +	__HANDSHAKE_GENL_CMD_MAX
> +};
> +#define HANDSHAKE_GENL_CMD_MAX	(__HANDSHAKE_GENL_CMD_MAX - 1)
> +
> +enum handshake_genl_attrs {
> +	HANDSHAKE_GENL_ATTR_UNSPEC = 0,
> +	HANDSHAKE_GENL_ATTR_MSG_STATUS,
> +	HANDSHAKE_GENL_ATTR_SESS_STATUS,
> +	HANDSHAKE_GENL_ATTR_SOCKFD,
> +	HANDSHAKE_GENL_ATTR_PROTOCOL,
> +
> +	HANDSHAKE_GENL_ATTR_ACCEPT,
> +	HANDSHAKE_GENL_ATTR_DONE,
> +
> +	__HANDSHAKE_GENL_ATTR_MAX
> +};
> +#define HANDSHAKE_GENL_ATTR_MAX	(__HANDSHAKE_GENL_ATTR_MAX - 1)
> +
> +enum handshake_genl_protocol {
> +	HANDSHAKE_GENL_PROTO_UNSPEC = 0,
> +};
> +
> +#endif /* _UAPI_LINUX_HANDSHAKE_H */
> diff --git a/net/Makefile b/net/Makefile
> index 6a62e5b27378..c1bb53f00486 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -78,3 +78,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
>   obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
>   obj-$(CONFIG_MPTCP)		+= mptcp/
>   obj-$(CONFIG_MCTP)		+= mctp/
> +obj-y				+= handshake/
> diff --git a/net/handshake/Makefile b/net/handshake/Makefile
> new file mode 100644
> index 000000000000..824e08c626af
> --- /dev/null
> +++ b/net/handshake/Makefile
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Makefile for the Generic HANDSHAKE service
> +#
> +# Author: Chuck Lever <chuck.lever@oracle.com>
> +#
> +# Copyright (c) 2023, Oracle and/or its affiliates.
> +#
> +
> +obj-y += handshake.o
> +handshake-y := netlink.o request.o
> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> new file mode 100644
> index 000000000000..1cbcfc632a24
> --- /dev/null
> +++ b/net/handshake/handshake.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Generic netlink handshake service
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +/*
> + * Data structures and functions that are visible only within the
> + * handshake module are declared here.
> + */
> +
> +#ifndef _INTERNAL_HANDSHAKE_H
> +#define _INTERNAL_HANDSHAKE_H
> +
> +/*
> + * One handshake request
> + */
> +struct handshake_req {
> +	refcount_t			hr_ref;
> +	struct list_head		hr_list;
> +	unsigned long			hr_flags;
> +	const struct handshake_proto	*hr_proto;
> +	struct socket			*hr_sock;
> +	int				hr_fd;
> +};
> +
> +#define HANDSHAKE_F_COMPLETED	BIT(0)
> +
> +int handshake_genl_notify(struct net *net, struct handshake_req *req,
> +			  gfp_t flags);
> +void handshake_complete(struct handshake_req *req, int status,
> +			struct nlattr *args);
> +
> +struct handshake_req *handshake_req_get(struct handshake_req *req);
> +void handshake_req_put(struct handshake_req *req);
> +
> +void add_pending_locked(struct net *net, struct handshake_req *req);
> +bool handshake_remove_pending(struct net *net, struct handshake_req *req);
> +
> +#endif /* _INTERNAL_HANDSHAKE_H */
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> new file mode 100644
> index 000000000000..8d0bf11396a7
> --- /dev/null
> +++ b/net/handshake/netlink.c
> @@ -0,0 +1,370 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Generic netlink handshake service
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/socket.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/inet.h>
> +
> +#include <net/sock.h>
> +#include <net/genetlink.h>
> +#include <net/handshake.h>
> +
> +#include <uapi/linux/handshake.h>
> +#include "handshake.h"
> +
> +static struct genl_family __ro_after_init handshake_genl_family;
> +
> +void add_pending_locked(struct net *net, struct handshake_req *req)
> +{
> +	net->hs_pending++;
> +	list_add_tail(&req->hr_list, &net->hs_requests);
> +}
> +
> +static void remove_pending_locked(struct net *net, struct handshake_req *req)
> +{
> +	net->hs_pending--;
> +	list_del_init(&req->hr_list);
> +}
> +
> +/*
> + * Returns true if this req was on the pending list.
> + */
> +bool handshake_remove_pending(struct net *net, struct handshake_req *req)
> +{
> +	struct sock *sk = req->hr_sock->sk;
> +	bool ret;
> +
> +	ret = false;
> +
> +	spin_lock(&net->hs_lock);
> +	if (!list_empty(&req->hr_list)) {
> +		remove_pending_locked(net, req);
> +		ret = true;
> +	}
> +	sk->sk_handshake_req = NULL;
> +	spin_unlock(&net->hs_lock);
> +
> +	return ret;
> +}
> +
> +void handshake_complete(struct handshake_req *req, int status,
> +			struct nlattr *args)
> +{
> +	if (!test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
> +		req->hr_proto->hp_done(req, status, args);
> +		req->hr_sock->sk->sk_handshake_req = NULL;
> +	}
> +	handshake_req_put(req);
> +}
> +
> +int handshake_genl_notify(struct net *net, struct handshake_req *req,
> +			  gfp_t flags)
> +{
> +	struct sk_buff *skb;
> +	void *hdr;
> +
> +	if (!genl_has_listeners(&handshake_genl_family, net,
> +				req->hr_proto->hp_mcgrp))
> +		return -ESRCH;
> +
> +	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_put(skb, 0, 0, &handshake_genl_family, 0,
> +			  HANDSHAKE_GENL_CMD_READY);
> +	if (!hdr) {
> +		nlmsg_free(skb);
> +		return -EMSGSIZE;
> +	}
> +
> +	genlmsg_end(skb, hdr);
> +	return genlmsg_multicast(&handshake_genl_family, skb, 0,
> +				 req->hr_proto->hp_mcgrp, flags);
> +}
> +
> +static int handshake_accept(struct handshake_req *req)
> +{
> +	struct socket *sock = req->hr_sock;
> +	int flags = O_CLOEXEC;
> +	struct file *file;
> +	int fd;
> +
> +	fd = get_unused_fd_flags(flags);
> +	if (fd < 0)
> +		return fd;
> +	file = sock_alloc_file(sock, flags, sock->sk->sk_prot_creator->name);
> +	if (IS_ERR(file)) {
> +		put_unused_fd(fd);
> +		return PTR_ERR(file);
> +	}
> +
> +	req->hr_fd = fd;
> +	fd_install(fd, file);
> +	return 0;
> +}
> +
> +static const struct nla_policy
> +handshake_genl_policy[HANDSHAKE_GENL_ATTR_MAX + 1] = {
> +	[HANDSHAKE_GENL_ATTR_MSG_STATUS] = {
> +		.type = NLA_U32
> +	},
> +	[HANDSHAKE_GENL_ATTR_SESS_STATUS] = {
> +		.type = NLA_U32
> +	},
> +	[HANDSHAKE_GENL_ATTR_SOCKFD] = {
> +		.type = NLA_U32
> +	},
> +	[HANDSHAKE_GENL_ATTR_PROTOCOL] = {
> +		.type = NLA_U32
> +	},
> +
> +	[HANDSHAKE_GENL_ATTR_ACCEPT] = {
> +		.type = NLA_NESTED,
> +	},
> +	[HANDSHAKE_GENL_ATTR_DONE] = {
> +		.type = NLA_NESTED,
> +	},
> +};
> +
> +/**
> + * handshake_genl_put - Create a generic netlink message header
> + * @msg: buffer in which to create the header
> + * @gi: generic netlink message context
> + *
> + * Returns a ready-to-use header, or NULL.
> + */
> +struct nlmsghdr *handshake_genl_put(struct sk_buff *msg, struct genl_info *gi)
> +{
> +	return genlmsg_put(msg, gi->snd_portid, gi->snd_seq,
> +			   &handshake_genl_family, 0, gi->genlhdr->cmd);
> +}
> +EXPORT_SYMBOL(handshake_genl_put);
> +
> +static int handshake_genl_status_reply(struct sk_buff *skb,
> +				       struct genl_info *gi, int status)
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
> +	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_MSG_STATUS, status);
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
> +
> +static int handshake_genl_cmd_accept(struct sk_buff *skb, struct genl_info *gi)
> +{
> +	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
> +	struct net *net = sock_net(skb->sk);
> +	struct handshake_req *pos, *req;
> +	int err;
> +
> +	err = genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
> +			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
> +			    NULL);
> +	if (err) {
> +		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
> +				   __func__, err);
> +		return err;
> +	}
> +
> +	if (!tb[HANDSHAKE_GENL_ATTR_PROTOCOL])
> +		return handshake_genl_status_reply(skb, gi, -EINVAL);
> +
> +	req = NULL;
> +	spin_lock(&net->hs_lock);
> +	list_for_each_entry(pos, &net->hs_requests, hr_list) {
> +		if (pos->hr_proto->hp_protocol !=
> +		    nla_get_u32(tb[HANDSHAKE_GENL_ATTR_PROTOCOL]))
> +			continue;
> +		remove_pending_locked(net, pos);
> +		req = handshake_req_get(pos);
> +		break;
> +	}
> +	spin_unlock(&net->hs_lock);
> +	if (!req)
> +		return handshake_genl_status_reply(skb, gi, -EAGAIN);
> +
> +	err = handshake_accept(req);
> +	if (err < 0) {
> +		handshake_complete(req, -EIO, NULL);
> +		handshake_req_put(req);
> +		return handshake_genl_status_reply(skb, gi, err);
> +	}
> +	err = req->hr_proto->hp_accept(req, gi, req->hr_fd);
> +	if (err) {
> +		put_unused_fd(req->hr_fd);
> +		handshake_complete(req, -EIO, NULL);
> +		handshake_req_put(req);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This function is careful to not close the socket. It merely removes
> + * it from the file descriptor table so that it is no longer visible
> + * to the calling process.
> + */
> +static int handshake_genl_cmd_done(struct sk_buff *skb, struct genl_info *gi)
> +{
> +	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
> +	struct handshake_req *req;
> +	struct socket *sock;
> +	int fd, status, err;
> +
> +	err = genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
> +			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
> +			    NULL);
> +	if (err) {
> +		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
> +				   __func__, err);
> +		return err;
> +	}
> +
> +	if (!tb[HANDSHAKE_GENL_ATTR_SOCKFD])
> +		return handshake_genl_status_reply(skb, gi, -EINVAL);
> +	err = 0;
> +	fd = nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SOCKFD]);
> +	sock = sockfd_lookup(fd, &err);
> +	if (err)
> +		return handshake_genl_status_reply(skb, gi, -EBADF);
> +
> +	req = sock->sk->sk_handshake_req;

And this will crash horribly if userspace released the socket in the 
meantime (as then sock->sk is NULL).
(Note: I probably show my complete ignorance of the network stack here, 
but ...)
Is there a good way of figuring out if 'sock->sk' is valid?
sock_hold() only makes sure that 'sock' is valid; it does nothing about
sock->sk.
Especially this bit in net/socket.c:__sock_release()

         if (!sock->file) {
                 iput(SOCK_INODE(sock));
                 return;
         }
         sock->file = NULL;

will always get you, as the _first_ caller to sock_release() does the 
right thing (by setting sock->file to NULL), but the second caller will
crash in iput().
There _must_ be a better way of checking...

Cheers,

Hannes

