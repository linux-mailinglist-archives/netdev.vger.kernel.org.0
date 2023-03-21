Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1C46C3068
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCUL2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCUL2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:28:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0E44A1D2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679398081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+B4rMqiSRrSDakxwNYnZA7cpTxZeGPnc7W9SoaJsONg=;
        b=QNd+3ne9c3aN1eYGFOt5sAZ4hDXP7cAcE8p+JVtsvlcBnyRWxEhFa7f4oBjxILT0TqeohY
        2A1S5C2XY+LD69G/0JaY7PkmN6K+joCo4mxNZWxxOK2Z2pf5am2Svi+SoSFmnyscfZI5SM
        a/Dik5fBGgyiw+CGCEpFTk7SuKdromE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-tFqMlMUmPEqqLmYu3Fh4iQ-1; Tue, 21 Mar 2023 07:27:59 -0400
X-MC-Unique: tFqMlMUmPEqqLmYu3Fh4iQ-1
Received: by mail-qk1-f200.google.com with SMTP id az31-20020a05620a171f00b00745746178e2so6735409qkb.6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:27:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679398079; x=1681990079;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+B4rMqiSRrSDakxwNYnZA7cpTxZeGPnc7W9SoaJsONg=;
        b=o9nup2yMqKwzF7x/wV1vaFzO/owq/PfwdYwQOjKZNU98QvUnRRw3nTXYXgs63TWCod
         dAr8dcRo+el7cU/xFHq6hiqkbf/BhitwsigtoUY0ww7mkOgmPBkTAjlmt7JgYGFo0QYY
         +OIx/1Gtbi+IoiZY0KfqDZVLQoazszsgYCYMmqRs1TDcgv3c7rAybPRwH4GRMxIFGm0O
         Nf4sKrX3CptU5jNNnK18DbclaanX6uLRgBwuhffzh/qg5rgT98+1bdosfzZbBWLkwrTf
         GBhCIE+ARvzknUn8TvMqrts/Qrf3R/bFDOpQSa125sKeIGCLrK9IQABpOpv3zoFjE9F6
         zSVA==
X-Gm-Message-State: AO0yUKUAM2fL6vCEAMIPIqPRqSi2jrPEXl97mOoS3oVU5dAq/EboZJ5C
        ixI1nYYzwcasoJmTjDZoqNH3vt5NU7MtAHMCNgg4dtEkBoLiL9giUizYBHxW+d5mJeynwqV7iIG
        lew28PDTEmVSpC07Ev3aquw+K
X-Received: by 2002:ac8:5a8a:0:b0:3d9:56ce:a8cd with SMTP id c10-20020ac85a8a000000b003d956cea8cdmr3872072qtc.6.1679398078725;
        Tue, 21 Mar 2023 04:27:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set/qs44tf9EmPAUX6k4hyFZGMAHX3228WcE9qb8ip9x81q0WUSqW89xNIieWZL36v22I69+lvQ==
X-Received: by 2002:ac8:5a8a:0:b0:3d9:56ce:a8cd with SMTP id c10-20020ac85a8a000000b003d956cea8cdmr3872042qtc.6.1679398078330;
        Tue, 21 Mar 2023 04:27:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-19.dyn.eolo.it. [146.241.244.19])
        by smtp.gmail.com with ESMTPSA id b17-20020ac86791000000b003b9bb59543fsm7868795qtp.61.2023.03.21.04.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 04:27:57 -0700 (PDT)
Message-ID: <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever <cel@kernel.org>, kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Tue, 21 Mar 2023 12:27:54 +0100
In-Reply-To: <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
         <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
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

The hr_sk reference counting is unclear to me. It looks like
handshake_req retain a reference to such socket, but
handshake_req_destroy()/handshake_sk_destruct() do not release it.

Perhaps is better moving such sock_hold() into handshake_req_submit(),
once that the request is successful?

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

Nit: merge the initialization and the declaration

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

Nit: reverse xmas tree. In this case you have to split declaration and
initialization ;)

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

Is unclear to me who acquired the reference released above?!? If that
is the reference acquire by handshake_req_alloc(), I think it's cleaner
moving the sock_put() in handshake_req_destroy() or
handshake_req_destroy()

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

Same here.

Side note, I think at this point some tests could surface here? If
user-space-based self-tests are too cumbersome and/or do not offer
adequate coverage perhaps you could consider using kunit?

Cheers,

Paolo

