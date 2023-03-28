Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B46CC9EB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjC1SQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjC1SPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5DB9F
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680027303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1a4zDEm255hUUkHx34kF1cE8zmhdi4LYKOYzj4waOc=;
        b=iATllb2pc/zIp85ufUhHdus9S7PjmvNvcPDNAhq68c33woa+rtp/T3kGriVkyqqA18Vcsz
        U7hphzapauYqH0DD4+9uD/GcQtNI30z6rehhFXvRhJ7i/JbdQurlDaSgm7XyCzZi5TDEN3
        aPy+J9h8AgfVHfqDRSnRAS8E719Ewqs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-WOe6Of4fMfuMjY0mINQnAQ-1; Tue, 28 Mar 2023 14:15:02 -0400
X-MC-Unique: WOe6Of4fMfuMjY0mINQnAQ-1
Received: by mail-qt1-f200.google.com with SMTP id v10-20020a05622a130a00b003e4ee70e001so2760234qtk.6
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680027301;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B1a4zDEm255hUUkHx34kF1cE8zmhdi4LYKOYzj4waOc=;
        b=X3RqeoW4/PlEvGFJmkOV+3x+65+tRV9UzbHHJrZkE4pdANkJ0zipblBEB6sWXbqvMO
         9V7BF6wc+bKc8vVYC8g9WRr1iH6ZQ9uzbu8uU53V139UDdyVi9WCrSALF4StmR1RRMNG
         6sORykj9MOBNyb0Cp6g5d4FvcfI52Pgp6LRAhECzvm29D1/zc0M6zYC86Hv0X/OjQOGi
         WKS/tSXhM7kompWpFMQSLmAuWX0km6qZiUMJCkYQ6cZOzIGswohTjN/jkl1VwGYdz1GB
         eAGzjCX/SXDQCh9QX7FtPe0oi2kIFg3gAOrMQuNHnxKOaAYbM+j03S0JE1w6n/n9N8ep
         WvZw==
X-Gm-Message-State: AAQBX9fMf2XRgqZSt9YI6D4dzWWj2U0687GridHdLipRjTcwYsMIzcQM
        8yaTQLArIcdwSCKQ+n1Uw3tvjzhg48tsi3C+G7WSsf8ah/Wjb9/SvP33Hny2TNUMjhxqKA/F45n
        GPZe/UJzmJYWixuFF
X-Received: by 2002:a05:622a:311:b0:3e4:eb8f:8a7b with SMTP id q17-20020a05622a031100b003e4eb8f8a7bmr9528407qtw.29.1680027301651;
        Tue, 28 Mar 2023 11:15:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350aTfW+UvczbaVczSvCGmR8Iw2qUyTJJ8632ZqTYt+ngsALZZGyfxxo94Ck9ik+1flz68u7T5A==
X-Received: by 2002:a05:622a:311:b0:3e4:eb8f:8a7b with SMTP id q17-20020a05622a031100b003e4eb8f8a7bmr9528368qtw.29.1680027301277;
        Tue, 28 Mar 2023 11:15:01 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id bn5-20020a05620a2ac500b00748448d9a7dsm3990150qkb.106.2023.03.28.11.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 11:15:00 -0700 (PDT)
Message-ID: <3e4e33c19a9c608be863d2d7207f5a9cb7db795f.camel@redhat.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Jeff Layton <jlayton@redhat.com>
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Tue, 28 Mar 2023 14:14:59 -0400
In-Reply-To: <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
         <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> When a kernel consumer needs a transport layer security session, it
> first needs a handshake to negotiate and establish a session. This
> negotiation can be done in user space via one of the several
> existing library implementations, or it can be done in the kernel.
>=20
> No in-kernel handshake implementations yet exist. In their absence,
> we add a netlink service that can:
>=20
> a. Notify a user space daemon that a handshake is needed.
>=20
> b. Once notified, the daemon calls the kernel back via this
>    netlink service to get the handshake parameters, including an
>    open socket on which to establish the session.
>=20
> c. Once the handshake is complete, the daemon reports the
>    session status and other information via a second netlink
>    operation. This operation marks that it is safe for the
>    kernel to use the open socket and the security session
>    established there.
>=20
> The notification service uses a multicast group. Each handshake
> mechanism (eg, tlshd) adopts its own group number so that the
> handshake services are completely independent of one another. The
> kernel can then tell via netlink_has_listeners() whether a handshake
> service is active and prepared to handle a handshake request.
>=20
> A new netlink operation, ACCEPT, acts like accept(2) in that it
> instantiates a file descriptor in the user space daemon's fd table.
> If this operation is successful, the reply carries the fd number,
> which can be treated as an open and ready file descriptor.
>=20
> While user space is performing the handshake, the kernel keeps its
> muddy paws off the open socket. A second new netlink operation,
> DONE, indicates that the user space daemon is finished with the
> socket and it is safe for the kernel to use again. The operation
> also indicates whether a session was established successfully.
>=20
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  Documentation/netlink/specs/handshake.yaml |  122 +++++++++++
>  MAINTAINERS                                |    8 +
>  include/trace/events/handshake.h           |  159 ++++++++++++++
>  include/uapi/linux/handshake.h             |   70 ++++++
>  net/Kconfig                                |    5=20
>  net/Makefile                               |    1=20
>  net/handshake/Makefile                     |   11 +
>  net/handshake/genl.c                       |   57 +++++
>  net/handshake/genl.h                       |   23 ++
>  net/handshake/handshake.h                  |   82 +++++++
>  net/handshake/netlink.c                    |  316 ++++++++++++++++++++++=
++++++
>  net/handshake/request.c                    |  307 ++++++++++++++++++++++=
+++++
>  net/handshake/trace.c                      |   20 ++
>  13 files changed, 1181 insertions(+)
>  create mode 100644 Documentation/netlink/specs/handshake.yaml
>  create mode 100644 include/trace/events/handshake.h
>  create mode 100644 include/uapi/linux/handshake.h
>  create mode 100644 net/handshake/Makefile
>  create mode 100644 net/handshake/genl.c
>  create mode 100644 net/handshake/genl.h
>  create mode 100644 net/handshake/handshake.h
>  create mode 100644 net/handshake/netlink.c
>  create mode 100644 net/handshake/request.c
>  create mode 100644 net/handshake/trace.c
>=20
>=20

[...]

> diff --git a/net/handshake/request.c b/net/handshake/request.c
> new file mode 100644
> index 000000000000..3f8ae9e990d2
> --- /dev/null
> +++ b/net/handshake/request.c
> @@ -0,0 +1,307 @@
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
> +#include <linux/rhashtable.h>
> +
> +#include <net/sock.h>
> +#include <net/genetlink.h>
> +#include <net/netns/generic.h>
> +
> +#include <uapi/linux/handshake.h>
> +#include "handshake.h"
> +
> +#include <trace/events/handshake.h>
> +
> +/*
> + * We need both a handshake_req -> sock mapping, and a sock ->
> + * handshake_req mapping. Both are one-to-one.
> + *
> + * To avoid adding another pointer field to struct sock, net/handshake
> + * maintains a hash table, indexed by the memory address of @sock, to
> + * find the struct handshake_req outstanding for that socket. The
> + * reverse direction uses a simple pointer field in the handshake_req
> + * struct.
> + */
> +
> +static struct rhashtable handshake_rhashtbl ____cacheline_aligned_in_smp=
;
> +
> +static const struct rhashtable_params handshake_rhash_params =3D {
> +	.key_len		=3D sizeof_field(struct handshake_req, hr_sk),
> +	.key_offset		=3D offsetof(struct handshake_req, hr_sk),
> +	.head_offset		=3D offsetof(struct handshake_req, hr_rhash),
> +	.automatic_shrinking	=3D true,
> +};
> +
> +int handshake_req_hash_init(void)
> +{
> +	return rhashtable_init(&handshake_rhashtbl, &handshake_rhash_params);
> +}
> +
> +void handshake_req_hash_destroy(void)
> +{
> +	rhashtable_destroy(&handshake_rhashtbl);
> +}
> +
> +struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
> +{
> +	return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,

Is this correct? It seems like we should be searching for the struct
sock pointer value, not on the pointer to the pointer (which will be a
stack var), right?

> +				      handshake_rhash_params);
> +}
> +
> +static noinline bool handshake_req_hash_add(struct handshake_req *req)
> +{
> +	int ret;
> +
> +	ret =3D rhashtable_lookup_insert_fast(&handshake_rhashtbl,
> +					    &req->hr_rhash,
> +					    handshake_rhash_params);
> +	return ret =3D=3D 0;
> +}
> +
> +static noinline void handshake_req_destroy(struct handshake_req *req)
> +{
> +	if (req->hr_proto->hp_destroy)
> +		req->hr_proto->hp_destroy(req);
> +	rhashtable_remove_fast(&handshake_rhashtbl, &req->hr_rhash,
> +			       handshake_rhash_params);
> +	kfree(req);
> +}
> +
> +static void handshake_sk_destruct(struct sock *sk)
> +{
> +	void (*sk_destruct)(struct sock *sk);
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_hash_lookup(sk);
> +	if (!req)
> +		return;
> +
> +	trace_handshake_destruct(sock_net(sk), req, sk);
> +	sk_destruct =3D req->hr_odestruct;
> +	handshake_req_destroy(req);
> +	if (sk_destruct)
> +		sk_destruct(sk);
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
> +	struct sock *sk =3D sock->sk;
> +	struct net *net =3D sock_net(sk);
> +	struct handshake_net *hn =3D handshake_pernet(net);
> +	struct handshake_req *req;
> +
> +	if (!hn)
> +		return NULL;
> +
> +	req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
> +	if (!req)
> +		return NULL;
> +
> +	sock_hold(sk);
> +
> +	INIT_LIST_HEAD(&req->hr_list);
> +	req->hr_sk =3D sk;
> +	req->hr_proto =3D proto;
> +	return req;
> +}
> +EXPORT_SYMBOL(handshake_req_alloc);
> +
> +/**
> + * handshake_req_private - consumer API to return per-handshake private =
data
> + * @req: handshake arguments
> + *
> + */
> +void *handshake_req_private(struct handshake_req *req)
> +{
> +	return (void *)&req->hr_priv;
> +}
> +EXPORT_SYMBOL(handshake_req_private);
> +
> +static bool __add_pending_locked(struct handshake_net *hn,
> +				 struct handshake_req *req)
> +{
> +	if (!list_empty(&req->hr_list))
> +		return false;
> +	hn->hn_pending++;
> +	list_add_tail(&req->hr_list, &hn->hn_requests);
> +	return true;
> +}
> +
> +void __remove_pending_locked(struct handshake_net *hn,
> +			     struct handshake_req *req)
> +{
> +	hn->hn_pending--;
> +	list_del_init(&req->hr_list);
> +}
> +
> +/*
> + * Returns %true if the request was found on @net's pending list,
> + * otherwise %false.
> + *
> + * If @req was on a pending list, it has not yet been accepted.
> + */
> +static bool remove_pending(struct handshake_net *hn, struct handshake_re=
q *req)
> +{
> +	bool ret;
> +
> +	ret =3D false;
> +
> +	spin_lock(&hn->hn_lock);
> +	if (!list_empty(&req->hr_list)) {
> +		__remove_pending_locked(hn, req);
> +		ret =3D true;
> +	}
> +	spin_unlock(&hn->hn_lock);
> +
> +	return ret;
> +}
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
> + *   %-EOPNOTSUPP: Handshake module not initialized
> + *
> + * A zero return value from handshake_request() means that
> + * exactly one subsequent completion callback is guaranteed.
> + *
> + * A negative return value from handshake_request() means that
> + * no completion callback will be done and that @req has been
> + * destroyed.
> + */
> +int handshake_req_submit(struct handshake_req *req, gfp_t flags)
> +{
> +	struct sock *sk =3D req->hr_sk;
> +	struct net *net =3D sock_net(sk);
> +	struct handshake_net *hn =3D handshake_pernet(net);
> +	int ret;
> +
> +	if (!hn)
> +		return -EOPNOTSUPP;
> +
> +	ret =3D -EAGAIN;
> +	if (READ_ONCE(hn->hn_pending) >=3D hn->hn_pending_max)
> +		goto out_err;
> +
> +	req->hr_odestruct =3D sk->sk_destruct;
> +	sk->sk_destruct =3D handshake_sk_destruct;
> +	spin_lock(&hn->hn_lock);
> +	ret =3D -EOPNOTSUPP;
> +	if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
> +		goto out_unlock;
> +	ret =3D -EBUSY;
> +	if (!handshake_req_hash_add(req))
> +		goto out_unlock;
> +	if (!__add_pending_locked(hn, req))
> +		goto out_unlock;
> +	spin_unlock(&hn->hn_lock);
> +
> +	ret =3D handshake_genl_notify(net, req->hr_proto->hp_handler_class,
> +				    flags);
> +	if (ret) {
> +		trace_handshake_notify_err(net, req, sk, ret);
> +		if (remove_pending(hn, req))
> +			goto out_err;
> +	}
> +
> +	trace_handshake_submit(net, req, sk);
> +	return 0;
> +
> +out_unlock:
> +	spin_unlock(&hn->hn_lock);
> +out_err:
> +	trace_handshake_submit_err(net, req, sk, ret);
> +	handshake_req_destroy(req);
> +	return ret;
> +}
> +EXPORT_SYMBOL(handshake_req_submit);
> +
> +void handshake_complete(struct handshake_req *req, unsigned int status,
> +			struct genl_info *info)
> +{
> +	struct sock *sk =3D req->hr_sk;
> +	struct net *net =3D sock_net(sk);
> +
> +	if (!test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
> +		trace_handshake_complete(net, req, sk, status);
> +		req->hr_proto->hp_done(req, status, info);
> +		__sock_put(sk);
> +	}
> +}
> +
> +/**
> + * handshake_req_cancel - consumer API to cancel an in-progress handshak=
e
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
> +	struct handshake_net *hn;
> +	struct sock *sk;
> +	struct net *net;
> +
> +	sk =3D sock->sk;
> +	net =3D sock_net(sk);
> +	req =3D handshake_req_hash_lookup(sk);
> +	if (!req) {
> +		trace_handshake_cancel_none(net, req, sk);
> +		return true;
> +	}
> +
> +	hn =3D handshake_pernet(net);
> +	if (hn && remove_pending(hn, req)) {
> +		/* Request hadn't been accepted */
> +		trace_handshake_cancel(net, req, sk);
> +		return true;
> +	}
> +	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
> +		/* Request already completed */
> +		trace_handshake_cancel_busy(net, req, sk);
> +		return false;
> +	}
> +
> +	__sock_put(sk);
> +	trace_handshake_cancel(net, req, sk);
> +	return true;
> +}
> +EXPORT_SYMBOL(handshake_req_cancel);
> diff --git a/net/handshake/trace.c b/net/handshake/trace.c
> new file mode 100644
> index 000000000000..1c4d8e27e17a
> --- /dev/null
> +++ b/net/handshake/trace.c
> @@ -0,0 +1,20 @@
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
> +
> +#include <net/sock.h>
> +#include <net/netlink.h>
> +#include <net/genetlink.h>
> +
> +#include "handshake.h"
> +
> +#define CREATE_TRACE_POINTS
> +
> +#include <trace/events/handshake.h>
>=20
>=20
>=20

--=20
Jeff Layton <jlayton@redhat.com>

