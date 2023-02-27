Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06076A3E46
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjB0JYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0JYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:24:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB77A19B8
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 01:24:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 616A01F8D9;
        Mon, 27 Feb 2023 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677489886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MdlsS98iY1HVOcY6kHdGOf/avHSfFXQGxmY3jpS0kI=;
        b=et/3GCDuiJs95Uoje1qZ2ekzHtFjCrx6JYHxyurDe3CwAZydalWMqkHbywahtNO/XJHTSv
        7PSWuVxkY4aC19Wh6a6+0Rd6/p8XDjSZLA0kUqwZ3/74jPUJagVj9uyBkQXUN2oAS8I/hk
        XJl1wTouqp30tK45SWEhwRqAr0l6aEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677489886;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MdlsS98iY1HVOcY6kHdGOf/avHSfFXQGxmY3jpS0kI=;
        b=VAMF1i8982r8Y3jKbPdwUrlRZlqXTgOqH78MfNUNgz149hlcI4KxS+kxcYhI1y7J30AlhY
        ZklC58hDIJ2DEfDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4BA6D13912;
        Mon, 27 Feb 2023 09:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 070UEt52/GMbVQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 27 Feb 2023 09:24:46 +0000
Message-ID: <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
Date:   Mon, 27 Feb 2023 10:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 20:19, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
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
> mechanism (eg, tlshd) adopts its own group number so that the
> handshake services are completely independent of one another. The
> kernel can then tell via netlink_has_listeners() whether a handshake
> service is active and prepared to handle a handshake request.
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
>   Documentation/netlink/specs/handshake.yaml |  134 +++++++++++
>   include/net/handshake.h                    |   45 ++++
>   include/net/net_namespace.h                |    5
>   include/net/sock.h                         |    1
>   include/trace/events/handshake.h           |  159 +++++++++++++
>   include/uapi/linux/handshake.h             |   63 +++++
>   net/Makefile                               |    1
>   net/handshake/Makefile                     |   11 +
>   net/handshake/handshake.h                  |   41 +++
>   net/handshake/netlink.c                    |  340 ++++++++++++++++++++++++++++
>   net/handshake/request.c                    |  246 ++++++++++++++++++++
>   net/handshake/trace.c                      |   17 +
>   12 files changed, 1063 insertions(+)
>   create mode 100644 Documentation/netlink/specs/handshake.yaml
>   create mode 100644 include/net/handshake.h
>   create mode 100644 include/trace/events/handshake.h
>   create mode 100644 include/uapi/linux/handshake.h
>   create mode 100644 net/handshake/Makefile
>   create mode 100644 net/handshake/handshake.h
>   create mode 100644 net/handshake/netlink.c
>   create mode 100644 net/handshake/request.c
>   create mode 100644 net/handshake/trace.c
> 
> diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
> new file mode 100644
> index 000000000000..683a8f2df0a7
> --- /dev/null
> +++ b/Documentation/netlink/specs/handshake.yaml
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> +#
> +# GENL HANDSHAKE service.
> +#
> +# Author: Chuck Lever <chuck.lever@oracle.com>
> +#
> +# Copyright (c) 2023, Oracle and/or its affiliates.
> +#
> +
> +name: handshake
> +
> +protocol: genetlink-c
> +
> +doc: Netlink protocol to request a transport layer security handshake.
> +
> +uapi-header: linux/net/handshake.h
> +
> +definitions:
> +  -
> +    type: enum
> +    name: handler-class
> +    enum-name:
> +    value-start: 0
> +    entries: [ none ]
> +  -
> +    type: enum
> +    name: msg-type
> +    enum-name:
> +    value-start: 0
> +    entries: [ unspec, clienthello, serverhello ]
> +  -
> +    type: enum
> +    name: auth
> +    enum-name:
> +    value-start: 0
> +    entries: [ unspec, unauth, x509, psk ]
> +
> +attribute-sets:
> +  -
> +    name: accept
> +    attributes:
> +      -
> +        name: status
> +        doc: Status of this accept operation
> +        type: u32
> +        value: 1
> +      -
> +        name: sockfd
> +        doc: File descriptor of socket to use
> +        type: u32
> +      -
> +        name: handler-class
> +        doc: Which type of handler is responding
> +        type: u32
> +        enum: handler-class
> +      -
> +        name: message-type
> +        doc: Handshake message type
> +        type: u32
> +        enum: msg-type
> +      -
> +        name: auth
> +        doc: Authentication mode
> +        type: u32
> +        enum: auth
> +      -
> +        name: gnutls-priorities
> +        doc: GnuTLS priority string
> +        type: string
> +      -
> +        name: my-peerid
> +        doc: Serial no of key containing local identity
> +        type: u32
> +      -
> +        name: my-privkey
> +        doc: Serial no of key containing optional private key
> +        type: u32
> +  -
> +    name: done
> +    attributes:
> +      -
> +        name: status
> +        doc: Session status
> +        type: u32
> +        value: 1
> +      -
> +        name: sockfd
> +        doc: File descriptor of socket that has completed
> +        type: u32
> +      -
> +        name: remote-peerid
> +        doc: Serial no of keys containing identities of remote peer
> +        type: u32
> +
> +operations:
> +  list:
> +    -
> +      name: ready
> +      doc: Notify handlers that a new handshake request is waiting
> +      value: 1
> +      notify: accept
> +    -
> +      name: accept
> +      doc: Handler retrieves next queued handshake request
> +      attribute-set: accept
> +      flags: [ admin-perm ]
> +      do:
> +        request:
> +          attributes:
> +            - handler-class
> +        reply:
> +          attributes:
> +            - status
> +            - sockfd
> +            - message-type
> +            - auth
> +            - gnutls-priorities
> +            - my-peerid
> +            - my-privkey
> +    -
> +      name: done
> +      doc: Handler reports handshake completion
> +      attribute-set: done
> +      do:
> +        request:
> +          attributes:
> +            - status
> +            - sockfd
> +            - remote-peerid
> +
> +mcast-groups:
> +  list:
> +    -
> +      name: none
> diff --git a/include/net/handshake.h b/include/net/handshake.h
> new file mode 100644
> index 000000000000..08f859237936
> --- /dev/null
> +++ b/include/net/handshake.h
> @@ -0,0 +1,45 @@
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
> +	int			hp_handler_class;
> +	size_t			hp_privsize;
> +
> +	int			(*hp_accept)(struct handshake_req *req,
> +					     struct genl_info *gi, int fd);
> +	void			(*hp_done)(struct handshake_req *req,
> +					   int status, struct nlattr **tb);
> +	void			(*hp_destroy)(struct handshake_req *req);
> +};
> +
> +extern struct handshake_req *
> +handshake_req_alloc(struct socket *sock, const struct handshake_proto *proto,
> +		    gfp_t flags);
> +extern void *handshake_req_private(struct handshake_req *req);
> +extern int handshake_req_submit(struct handshake_req *req, gfp_t flags);
> +extern int handshake_req_cancel(struct socket *sock);
> +
> +extern struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
> +					   struct genl_info *gi);
> +
> +#endif /* _NET_HANDSHAKE_H */
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 78beaa765c73..a0ce9de4dab1 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -188,6 +188,11 @@ struct net {
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
> index 573f2bf7e0de..2a7345ce2540 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -519,6 +519,7 @@ struct sock {
>   
>   	struct socket		*sk_socket;
>   	void			*sk_user_data;
> +	void			*sk_handshake_req;
>   #ifdef CONFIG_SECURITY
>   	void			*sk_security;
>   #endif
> diff --git a/include/trace/events/handshake.h b/include/trace/events/handshake.h
> new file mode 100644
> index 000000000000..feffcd1d6256
> --- /dev/null
> +++ b/include/trace/events/handshake.h
> @@ -0,0 +1,159 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM handshake
> +
> +#if !defined(_TRACE_HANDSHAKE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_HANDSHAKE_H
> +
> +#include <linux/net.h>
> +#include <linux/tracepoint.h>
> +
> +DECLARE_EVENT_CLASS(handshake_event_class,
> +	TP_PROTO(
> +		const struct net *net,
> +		const struct handshake_req *req,
> +		const struct socket *sock
> +	),
> +	TP_ARGS(net, req, sock),
> +	TP_STRUCT__entry(
> +		__field(const void *, req)
> +		__field(const void *, sock)
> +		__field(unsigned int, netns_ino)
> +	),
> +	TP_fast_assign(
> +		__entry->req = req;
> +		__entry->sock = sock;
> +		__entry->netns_ino = net->ns.inum;
> +	),
> +	TP_printk("req=%p sock=%p",
> +		__entry->req, __entry->sock
> +	)
> +);
> +#define DEFINE_HANDSHAKE_EVENT(name)				\
> +	DEFINE_EVENT(handshake_event_class, name,		\
> +		TP_PROTO(					\
> +			const struct net *net,			\
> +			const struct handshake_req *req,	\
> +			const struct socket *sock		\
> +		),						\
> +		TP_ARGS(net, req, sock))
> +
> +DECLARE_EVENT_CLASS(handshake_fd_class,
> +	TP_PROTO(
> +		const struct net *net,
> +		const struct handshake_req *req,
> +		const struct socket *sock,
> +		int fd
> +	),
> +	TP_ARGS(net, req, sock, fd),
> +	TP_STRUCT__entry(
> +		__field(const void *, req)
> +		__field(const void *, sock)
> +		__field(int, fd)
> +		__field(unsigned int, netns_ino)
> +	),
> +	TP_fast_assign(
> +		__entry->req = req;
> +		__entry->sock = req->hr_sock;
> +		__entry->fd = fd;
> +		__entry->netns_ino = net->ns.inum;
> +	),
> +	TP_printk("req=%p sock=%p fd=%d",
> +		__entry->req, __entry->sock, __entry->fd
> +	)
> +);
> +#define DEFINE_HANDSHAKE_FD_EVENT(name)				\
> +	DEFINE_EVENT(handshake_fd_class, name,			\
> +		TP_PROTO(					\
> +			const struct net *net,			\
> +			const struct handshake_req *req,	\
> +			const struct socket *sock,		\
> +			int fd					\
> +		),						\
> +		TP_ARGS(net, req, sock, fd))
> +
> +DECLARE_EVENT_CLASS(handshake_error_class,
> +	TP_PROTO(
> +		const struct net *net,
> +		const struct handshake_req *req,
> +		const struct socket *sock,
> +		int err
> +	),
> +	TP_ARGS(net, req, sock, err),
> +	TP_STRUCT__entry(
> +		__field(const void *, req)
> +		__field(const void *, sock)
> +		__field(int, err)
> +		__field(unsigned int, netns_ino)
> +	),
> +	TP_fast_assign(
> +		__entry->req = req;
> +		__entry->sock = sock;
> +		__entry->err = err;
> +		__entry->netns_ino = net->ns.inum;
> +	),
> +	TP_printk("req=%p sock=%p err=%d",
> +		__entry->req, __entry->sock, __entry->err
> +	)
> +);
> +#define DEFINE_HANDSHAKE_ERROR(name)				\
> +	DEFINE_EVENT(handshake_error_class, name,		\
> +		TP_PROTO(					\
> +			const struct net *net,			\
> +			const struct handshake_req *req,	\
> +			const struct socket *sock,		\
> +			int err					\
> +		),						\
> +		TP_ARGS(net, req, sock, err))
> +
> +
> +/**
> + ** Request lifetime events
> + **/
> +
> +DEFINE_HANDSHAKE_EVENT(handshake_submit);
> +DEFINE_HANDSHAKE_ERROR(handshake_submit_err);
> +DEFINE_HANDSHAKE_EVENT(handshake_cancel);
> +DEFINE_HANDSHAKE_EVENT(handshake_cancel_none);
> +DEFINE_HANDSHAKE_EVENT(handshake_cancel_busy);
> +DEFINE_HANDSHAKE_EVENT(handshake_destruct);
> +
> +
> +TRACE_EVENT(handshake_complete,
> +	TP_PROTO(
> +		const struct net *net,
> +		const struct handshake_req *req,
> +		const struct socket *sock,
> +		int status
> +	),
> +	TP_ARGS(net, req, sock, status),
> +	TP_STRUCT__entry(
> +		__field(const void *, req)
> +		__field(const void *, sock)
> +		__field(int, status)
> +		__field(unsigned int, netns_ino)
> +	),
> +	TP_fast_assign(
> +		__entry->req = req;
> +		__entry->sock = sock;
> +		__entry->status = status;
> +		__entry->netns_ino = net->ns.inum;
> +	),
> +	TP_printk("req=%p sock=%p status=%d",
> +		__entry->req, __entry->sock, __entry->status
> +	)
> +);
> +
> +/**
> + ** Netlink events
> + **/
> +
> +DEFINE_HANDSHAKE_ERROR(handshake_notify_err);
> +DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_accept);
> +DEFINE_HANDSHAKE_ERROR(handshake_cmd_accept_err);
> +DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_done);
> +DEFINE_HANDSHAKE_ERROR(handshake_cmd_done_err);
> +
> +#endif /* _TRACE_HANDSHAKE_H */
> +
> +#include <trace/define_trace.h>
> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
> new file mode 100644
> index 000000000000..09fd7c37cba4
> --- /dev/null
> +++ b/include/uapi/linux/handshake.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Do not edit directly, auto-generated from: */
> +/*	Documentation/netlink/specs/handshake.yaml */
> +/* YNL-GEN uapi header */
> +
> +#ifndef _UAPI_LINUX_HANDSHAKE_H
> +#define _UAPI_LINUX_HANDSHAKE_H
> +
> +#define HANDSHAKE_FAMILY_NAME		"handshake"
> +#define HANDSHAKE_FAMILY_VERSION	1
> +
> +enum {
> +	HANDSHAKE_HANDLER_CLASS_NONE,
> +};
> +
> +enum {
> +	HANDSHAKE_MSG_TYPE_UNSPEC,
> +	HANDSHAKE_MSG_TYPE_CLIENTHELLO,
> +	HANDSHAKE_MSG_TYPE_SERVERHELLO,
> +};
> +
> +enum {
> +	HANDSHAKE_AUTH_UNSPEC,
> +	HANDSHAKE_AUTH_UNAUTH,
> +	HANDSHAKE_AUTH_X509,
> +	HANDSHAKE_AUTH_PSK,
> +};
> +
> +enum {
> +	HANDSHAKE_A_ACCEPT_STATUS = 1,
> +	HANDSHAKE_A_ACCEPT_SOCKFD,
> +	HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
> +	HANDSHAKE_A_ACCEPT_MESSAGE_TYPE,
> +	HANDSHAKE_A_ACCEPT_AUTH,
> +	HANDSHAKE_A_ACCEPT_GNUTLS_PRIORITIES,
> +	HANDSHAKE_A_ACCEPT_MY_PEERID,
> +	HANDSHAKE_A_ACCEPT_MY_PRIVKEY,
> +
> +	__HANDSHAKE_A_ACCEPT_MAX,
> +	HANDSHAKE_A_ACCEPT_MAX = (__HANDSHAKE_A_ACCEPT_MAX - 1)
> +};
> +
> +enum {
> +	HANDSHAKE_A_DONE_STATUS = 1,
> +	HANDSHAKE_A_DONE_SOCKFD,
> +	HANDSHAKE_A_DONE_REMOTE_PEERID,
> +
> +	__HANDSHAKE_A_DONE_MAX,
> +	HANDSHAKE_A_DONE_MAX = (__HANDSHAKE_A_DONE_MAX - 1)
> +};
> +
> +enum {
> +	HANDSHAKE_CMD_READY = 1,
> +	HANDSHAKE_CMD_ACCEPT,
> +	HANDSHAKE_CMD_DONE,
> +
> +	__HANDSHAKE_CMD_MAX,
> +	HANDSHAKE_CMD_MAX = (__HANDSHAKE_CMD_MAX - 1)
> +};
> +
> +#define HANDSHAKE_MCGRP_NONE	"none"
> +
> +#endif /* _UAPI_LINUX_HANDSHAKE_H */
> diff --git a/net/Makefile b/net/Makefile
> index 0914bea9c335..adbb64277601 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -79,3 +79,4 @@ obj-$(CONFIG_NET_NCSI)		+= ncsi/
>   obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
>   obj-$(CONFIG_MPTCP)		+= mptcp/
>   obj-$(CONFIG_MCTP)		+= mctp/
> +obj-y				+= handshake/
> diff --git a/net/handshake/Makefile b/net/handshake/Makefile
> new file mode 100644
> index 000000000000..a41b03f4837b
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
> +handshake-y := netlink.o request.o trace.o
> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> new file mode 100644
> index 000000000000..366c7659ec09
> --- /dev/null
> +++ b/net/handshake/handshake.h
> @@ -0,0 +1,41 @@
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
> +	struct list_head		hr_list;
> +	unsigned long			hr_flags;
> +	const struct handshake_proto	*hr_proto;
> +	struct socket			*hr_sock;
> +
> +	void				(*hr_saved_destruct)(struct sock *sk);
> +};
> +
> +#define HANDSHAKE_F_COMPLETED	BIT(0)
> +
> +/* netlink.c */
> +extern bool handshake_genl_inited;
> +int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags);
> +
> +/* request.c */
> +void __remove_pending_locked(struct net *net, struct handshake_req *req);
> +void handshake_complete(struct handshake_req *req, int status,
> +			struct nlattr **tb);
> +
> +#endif /* _INTERNAL_HANDSHAKE_H */
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> new file mode 100644
> index 000000000000..581e382236cf
> --- /dev/null
> +++ b/net/handshake/netlink.c
> @@ -0,0 +1,340 @@
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
> +#include <trace/events/handshake.h>
> +#include "handshake.h"
> +
> +static struct genl_family __ro_after_init handshake_genl_family;
> +bool handshake_genl_inited;
> +
> +/**
> + * handshake_genl_notify - Notify handlers that a request is waiting
> + * @net: target network namespace
> + * @handler_class: target handler
> + * @flags: memory allocation control flags
> + *
> + * Returns zero on success or a negative errno if notification failed.
> + */
> +int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	if (!genl_has_listeners(&handshake_genl_family, net, handler_class))
> +		return -ESRCH;
> +
> +	msg = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_put(msg, 0, 0, &handshake_genl_family, 0,
> +			  HANDSHAKE_CMD_READY);
> +	if (!hdr)
> +		goto out_free;
> +
> +	if (nla_put_u32(msg, HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
> +			handler_class) < 0) {
> +		genlmsg_cancel(msg, hdr);
> +		goto out_free;
> +	}
> +
> +	genlmsg_end(msg, hdr);
> +	return genlmsg_multicast_netns(&handshake_genl_family, net, msg,
> +				       0, handler_class, flags);
> +
> +out_free:
> +	nlmsg_free(msg);
> +	return -EMSGSIZE;
> +}
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
> +
> +/*
> + * dup() a kernel socket for use as a user space file descriptor
> + * in the current process.
> + *
> + * Implicit argument: "current()"
> + */
> +static int handshake_dup(struct socket *kernsock)
> +{
> +	struct file *file = get_file(kernsock->file);
> +	int newfd;
> +
> +	newfd = get_unused_fd_flags(O_CLOEXEC);
> +	if (newfd < 0) {
> +		fput(file);
> +		return newfd;
> +	}
> +
> +	fd_install(newfd, file);
> +	return newfd;
> +}
> +
> +static const struct nla_policy
> +handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HANDLER_CLASS + 1] = {
> +	[HANDSHAKE_A_ACCEPT_HANDLER_CLASS] = { .type = NLA_U32, },
> +};
> +
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
> +	if (!tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS])
> +		goto out_status;
> +
> +	req = NULL;
> +	spin_lock(&net->hs_lock);
> +	list_for_each_entry(pos, &net->hs_requests, hr_list) {
> +		if (pos->hr_proto->hp_handler_class !=
> +		    nla_get_u32(tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS]))
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
> +	[HANDSHAKE_A_DONE_REMOTE_PEERID] = { .type = NLA_U32, },
> +};
> +
> +static int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *gi)
> +{
> +	struct nlattr *tb[HANDSHAKE_A_DONE_MAX + 1];
> +	struct net *net = sock_net(skb->sk);
> +	struct socket *sock = NULL;
> +	struct handshake_req *req;
> +	int fd, status, err;
> +
> +	err = genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
> +			    HANDSHAKE_A_DONE_MAX, handshake_done_nl_policy,
> +			    NULL);
> +	if (err || !tb[HANDSHAKE_A_DONE_SOCKFD]) {
> +		err = -EINVAL;
> +		goto out_status;
> +	}
> +
> +	fd = nla_get_u32(tb[HANDSHAKE_A_DONE_SOCKFD]);
> +
> +	err = 0;
> +	sock = sockfd_lookup(fd, &err);
> +	if (err) {
> +		err = -EBADF;
> +		goto out_status;
> +	}
> +
> +	req = sock->sk->sk_handshake_req;
> +	if (!req) {
> +		err = -EBUSY;
> +		goto out_status;
> +	}
> +
> +	trace_handshake_cmd_done(net, req, sock, fd);
> +
> +	status = -EIO;
> +	if (tb[HANDSHAKE_A_DONE_STATUS])
> +		status = nla_get_u32(tb[HANDSHAKE_A_DONE_STATUS]);
> +
And this makes me ever so slightly uneasy.

As 'status' is a netlink attribute it's inevitably defined as 'unsigned'.
Yet we assume that 'status' is a negative number, leaving us 
_technically_ in unchartered territory.

And that is notwithstanding the problem that we haven't even defined 
_what_ should be in the status attribute.

Reading the code I assume that it's either '0' for success or a negative 
number (ie the error code) on failure.
Which implicitely means that we _never_ set a positive number here.
So what would we lose if we declare 'status' to carry the _positive_ 
error number instead?
It would bring us in-line with the actual netlink attribute definition, 
we wouldn't need to worry about possible integer overflows, yadda yadda...

Hmm?

> +	handshake_complete(req, status, tb);
> +	fput(sock->file);
> +	return 0;
> +
> +out_status:
> +	trace_handshake_cmd_done_err(net, req, sock, err);
> +	return handshake_status_reply(skb, gi, err);
> +}
> +
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
> +		.maxattr	= HANDSHAKE_A_DONE_REMOTE_PEERID,
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
> +
> +static int __net_init handshake_net_init(struct net *net)
> +{
> +	spin_lock_init(&net->hs_lock);
> +	INIT_LIST_HEAD(&net->hs_requests);
> +	net->hs_pending	= 0;
> +	return 0;
> +}
> +
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
> +
> +static struct pernet_operations handshake_genl_net_ops = {
> +	.init		= handshake_net_init,
> +	.exit		= handshake_net_exit,
> +};
> +
> +static int __init handshake_init(void)
> +{
> +	int ret;
> +
> +	ret = genl_register_family(&handshake_genl_family);
> +	if (ret) {
> +		pr_warn("handshake: netlink registration failed (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = register_pernet_subsys(&handshake_genl_net_ops);
> +	if (ret) {
> +		pr_warn("handshake: pernet registration failed (%d)\n", ret);
> +		genl_unregister_family(&handshake_genl_family);
> +	}
> +
> +	handshake_genl_inited = true;
> +	return ret;
> +}
> +
> +static void __exit handshake_exit(void)
> +{
> +	unregister_pernet_subsys(&handshake_genl_net_ops);
> +	genl_unregister_family(&handshake_genl_family);
> +}
> +
> +module_init(handshake_init);
> +module_exit(handshake_exit);
> diff --git a/net/handshake/request.c b/net/handshake/request.c
> new file mode 100644
> index 000000000000..1d3b8e76dd2c
> --- /dev/null
> +++ b/net/handshake/request.c
> @@ -0,0 +1,246 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Handshake request lifetime events
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
> +#include <linux/fdtable.h>
> +
> +#include <net/sock.h>
> +#include <net/genetlink.h>
> +#include <net/handshake.h>
> +
> +#include <uapi/linux/handshake.h>
> +#include <trace/events/handshake.h>
> +#include "handshake.h"
> +
> +/*
> + * This limit is to prevent slow remotes from causing denial of service.
> + * A ulimit-style tunable might be used instead.
> + */
> +#define HANDSHAKE_PENDING_MAX (10)
> +
> +static void __add_pending_locked(struct net *net, struct handshake_req *req)
> +{
> +	net->hs_pending++;
> +	list_add_tail(&req->hr_list, &net->hs_requests);
> +}
> +
> +void __remove_pending_locked(struct net *net, struct handshake_req *req)
> +{
> +	net->hs_pending--;
> +	list_del_init(&req->hr_list);
> +}
> +
> +/*
> + * Return values:
> + *   %true - the request was found on @net's pending list
> + *   %false - the request was not found on @net's pending list
> + *
> + * If @req was on a pending list, it has not yet been accepted.
> + */
> +static bool remove_pending(struct net *net, struct handshake_req *req)
> +{
> +	bool ret;
> +
> +	ret = false;
> +
> +	spin_lock(&net->hs_lock);
> +	if (!list_empty(&req->hr_list)) {
> +		__remove_pending_locked(net, req);
> +		ret = true;
> +	}
> +	spin_unlock(&net->hs_lock);
> +
> +	return ret;
> +}
> +
> +static void handshake_req_destroy(struct handshake_req *req, struct sock *sk)
> +{
> +	req->hr_proto->hp_destroy(req);
> +	sk->sk_handshake_req = NULL;
> +	kfree(req);
> +}
> +
> +static void handshake_sk_destruct(struct sock *sk)
> +{
> +	struct handshake_req *req = sk->sk_handshake_req;
> +
> +	if (req) {
> +		trace_handshake_destruct(sock_net(sk), req, req->hr_sock);
> +		handshake_req_destroy(req, sk);
> +	}
> +}
> +
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
> +}
> +EXPORT_SYMBOL(handshake_req_private);
> +
> +/**
> + * handshake_req_submit - consumer API to submit a handshake request
> + * @req: handshake arguments
> + * @flags: memory allocation flags
> + *
> + * Return values:
> + *   %0: Request queued
> + *   %-EBUSY: A handshake is already under way for this socket
> + *   %-ESRCH: No handshake agent is available
> + *   %-EAGAIN: Too many pending handshake requests
> + *   %-ENOMEM: Failed to allocate memory
> + *   %-EMSGSIZE: Failed to construct notification message
> + *
> + * A zero return value from handshake_request() means that
> + * exactly one subsequent completion callback is guaranteed.
> + *
> + * A negative return value from handshake_request() means that
> + * no completion callback will be done and that @req is
> + * destroyed.
> + */
> +int handshake_req_submit(struct handshake_req *req, gfp_t flags)
> +{
> +	struct socket *sock = req->hr_sock;
> +	struct sock *sk = sock->sk;
> +	struct net *net = sock_net(sk);
> +	int ret;
> +
> +	ret = -EAGAIN;
> +	if (READ_ONCE(net->hs_pending) >= HANDSHAKE_PENDING_MAX)
> +		goto out_err;
> +
> +	ret = -EBUSY;
> +	spin_lock(&net->hs_lock);
> +	if (sk->sk_handshake_req || !list_empty(&req->hr_list)) {
> +		spin_unlock(&net->hs_lock);
> +		goto out_err;
> +	}
> +	req->hr_saved_destruct = sk->sk_destruct;
> +	sk->sk_destruct = handshake_sk_destruct;
> +	sk->sk_handshake_req = req;
> +	__add_pending_locked(net, req);
> +	spin_unlock(&net->hs_lock);
> +
> +	ret = handshake_genl_notify(net, req->hr_proto->hp_handler_class,
> +				    flags);
> +	if (ret) {
> +		trace_handshake_notify_err(net, req, sock, ret);
> +		if (remove_pending(net, req))
> +			goto out_err;
> +	}
> +
> +	trace_handshake_submit(net, req, sock);
> +	return 0;
> +
> +out_err:
> +	trace_handshake_submit_err(net, req, sock, ret);
> +	handshake_req_destroy(req, sk);
> +	return ret;
> +}
> +EXPORT_SYMBOL(handshake_req_submit);
> +
> +void handshake_complete(struct handshake_req *req, int status,
> +			struct nlattr **tb)
> +{
> +	struct socket *sock = req->hr_sock;
> +	struct net *net = sock_net(sock->sk);
> +
> +	if (!test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
> +		trace_handshake_complete(net, req, sock, status);
> +		req->hr_proto->hp_done(req, status, tb);
> +		__sock_put(sock->sk);
> +	}
> +}
> +
> +/**
> + * handshake_req_cancel - consumer API to cancel an in-progress handshake
> + * @sock: socket on which there is an ongoing handshake
> + *
> + * XXX: Perhaps killing the user space agent might also be necessary?

I thought we had agreed that we would be sending a signal to the 
userspace process?
Ideally we would be sending a SIGHUP, wait for some time on the 
userspace process to respond with a 'done' message, and send a 'KILL' 
signal if we haven't received one.

Obs: Sending a KILL signal would imply that userspace is able to cope 
with children dying. Which pretty much excludes pthreads, I would think.

Guess I'll have to consult Stevens :-)

> + *
> + * Request cancellation races with request completion. To determine
> + * who won, callers examine the return value from this function.
> + *
> + * Return values:
> + *   %0 - Uncompleted handshake request was canceled or not found
> + *   %-EBUSY - Handshake request already completed

EBUSY? Wouldn't be EAGAIN more approriate?
After all, the request is everything _but_ busy...

> + */
> +int handshake_req_cancel(struct socket *sock)
> +{
> +	struct handshake_req *req;
> +	struct sock *sk;
> +	struct net *net;
> +
> +	if (!sock)
> +		return 0;
> +
> +	sk = sock->sk;
> +	req = sk->sk_handshake_req;
> +	net = sock_net(sk);
> +
> +	if (!req) {
> +		trace_handshake_cancel_none(net, req, sock);
> +		return 0;
> +	}
> +
> +	if (remove_pending(net, req)) {
> +		/* Request hadn't been accepted */
> +		trace_handshake_cancel(net, req, sock);
> +		return 0;
> +	}
> +	if (test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
> +		/* Request already completed */
> +		trace_handshake_cancel_busy(net, req, sock);
> +		return -EBUSY;
> +	}
> +
> +	__sock_put(sk);
> +	trace_handshake_cancel(net, req, sock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(handshake_req_cancel);
> diff --git a/net/handshake/trace.c b/net/handshake/trace.c
> new file mode 100644
> index 000000000000..3a5b6f29a2b8
> --- /dev/null
> +++ b/net/handshake/trace.c
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Trace points for transport security layer handshakes.
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2023, Oracle and/or its affiliates.
> + */
> +
> +#include <linux/types.h>
> +#include <net/sock.h>
> +
> +#include "handshake.h"
> +
> +#define CREATE_TRACE_POINTS
> +
> +#include <trace/events/handshake.h>
> 
Cheers,

Hannes


