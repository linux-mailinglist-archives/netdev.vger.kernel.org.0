Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26426C4595
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCVJFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCVJFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86AB21A35
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679475900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zm6fHynkBFWZGfQdf0VUoXVF9x4NZeMNqBI588ZQLQ=;
        b=aixvnyt6euIG72IAJFHi5b5h5gMkBHJpczUzO7bfcOJ/004dN/CCMvL5trjs5L+8U1iIZ8
        ZGqCUfdTgUSoK6/WVR3oV2nAuWpZxq7RnfKD0KjKGxhhwIRJrhVEA22ms4KFRVAxYDsQq5
        U6uX8UOpkMVlArI2FaKyN2XSvRxnK/A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-9RRw_Q3wOduUqknRmUCUNQ-1; Wed, 22 Mar 2023 05:03:24 -0400
X-MC-Unique: 9RRw_Q3wOduUqknRmUCUNQ-1
Received: by mail-qv1-f69.google.com with SMTP id f8-20020a0cbec8000000b005b14a30945cso8960440qvj.8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679475804;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/zm6fHynkBFWZGfQdf0VUoXVF9x4NZeMNqBI588ZQLQ=;
        b=kG23BgPriRH+81F0F1UYn001vpp4LZegwYFwXkQ5s1LsKDt1THwI1l1sHdmmxUQIFK
         WHYSh0QzLdb6tHS7w+e5jRKXlJZ1GVZQuVh+lKylQw5yPFREij16RG8kA7wxbbr7rDH8
         29fmBp07+fZ9PcNUPfEK3CeP30zy9t8X8nnABev5UcOIk5BhzuN+EvHSv/7VFXvSwG5W
         b/9zlPh4hHiDa6gwn6GFntJB0xP1kiB+Opc3rbJQaef/JZu/nDZbFkinyh6d07C85vOY
         KD9qfpa7XOwH2OwAdXsmqoJ1WaHPYb5GHyTnpZk/YlzbLq5QWTxxRrZZ9yuiqndVs78I
         1u3w==
X-Gm-Message-State: AO0yUKUDN/MuoJhaPkZVKQ6/WNoFEbT1PRtDSJ4sgJHvXkv8PJVM6WZM
        NGhB6dfYkCfEbyemWDQDtKJbmmXZSeoolHlGhznCjmyXDPIqt3oTgnhehNMXlTSL+3BuFOnc4DZ
        J5Elv9b4b1THMAIJh
X-Received: by 2002:a05:6214:300f:b0:5a8:a090:59c8 with SMTP id ke15-20020a056214300f00b005a8a09059c8mr8584048qvb.4.1679475803784;
        Wed, 22 Mar 2023 02:03:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set+/51KpdCOsu3NLy3CjzKOj3PT56zaQDyi5tZEdyg3IM69is8V7UTLNw1gT/lxHLhoA2L/TmA==
X-Received: by 2002:a05:6214:300f:b0:5a8:a090:59c8 with SMTP id ke15-20020a056214300f00b005a8a09059c8mr8584024qvb.4.1679475803460;
        Wed, 22 Mar 2023 02:03:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id a4-20020ae9e804000000b007467f8b76f0sm6409594qkg.41.2023.03.22.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 02:03:22 -0700 (PDT)
Message-ID: <dc32e3654de0bee5d8c6cf64375fa491b89d655f.camel@redhat.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Date:   Wed, 22 Mar 2023 10:03:19 +0100
In-Reply-To: <674AEE9C-BDB7-440E-902E-73918D6E2370@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
         <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
         <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
         <674AEE9C-BDB7-440E-902E-73918D6E2370@oracle.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, 2023-03-21 at 13:58 +0000, Chuck Lever III wrote:
>=20
> > On Mar 21, 2023, at 7:27 AM, Paolo Abeni <pabeni@redhat.com> wrote:
> >=20
> > On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
> > > +/**
> > > + * handshake_req_alloc - consumer API to allocate a request
> > > + * @sock: open socket on which to perform a handshake
> > > + * @proto: security protocol
> > > + * @flags: memory allocation flags
> > > + *
> > > + * Returns an initialized handshake_req or NULL.
> > > + */
> > > +struct handshake_req *handshake_req_alloc(struct socket *sock,
> > > +					  const struct handshake_proto *proto,
> > > +					  gfp_t flags)
> > > +{
> > > +	struct sock *sk =3D sock->sk;
> > > +	struct net *net =3D sock_net(sk);
> > > +	struct handshake_net *hn =3D handshake_pernet(net);
> > > +	struct handshake_req *req;
> > > +
> > > +	if (!hn)
> > > +		return NULL;
> > > +
> > > +	req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flag=
s);
> > > +	if (!req)
> > > +		return NULL;
> > > +
> > > +	sock_hold(sk);
> >=20
> > The hr_sk reference counting is unclear to me. It looks like
> > handshake_req retain a reference to such socket, but
> > handshake_req_destroy()/handshake_sk_destruct() do not release it.
>=20
> If we rely on sk_destruct to release the final reference count,
> it will never get invoked.
>=20
>=20
> > Perhaps is better moving such sock_hold() into handshake_req_submit(),
> > once that the request is successful?
>=20
> I will do that.
>=20
> Personally, I find it more clear to bump a reference count when
> saving a copy of the object's pointer, as is done in _alloc. But if
> others find it easier the other way, I have no problem changing
> it to suit community preferences.

I made the above suggestion because it looks like the sk reference is
not released in the handshake_req_submit() error path, but anything
addressing that would be good enough for me.

[...]

> >=20
> > > +/**
> > > + * handshake_req_cancel - consumer API to cancel an in-progress hand=
shake
> > > + * @sock: socket on which there is an ongoing handshake
> > > + *
> > > + * XXX: Perhaps killing the user space agent might also be necessary=
?
> > > + *
> > > + * Request cancellation races with request completion. To determine
> > > + * who won, callers examine the return value from this function.
> > > + *
> > > + * Return values:
> > > + *   %true - Uncompleted handshake request was canceled or not found
> > > + *   %false - Handshake request already completed
> > > + */
> > > +bool handshake_req_cancel(struct socket *sock)
> > > +{
> > > +	struct handshake_req *req;
> > > +	struct handshake_net *hn;
> > > +	struct sock *sk;
> > > +	struct net *net;
> > > +
> > > +	sk =3D sock->sk;
> > > +	net =3D sock_net(sk);
> > > +	req =3D handshake_req_hash_lookup(sk);
> > > +	if (!req) {
> > > +		trace_handshake_cancel_none(net, req, sk);
> > > +		return true;
> > > +	}
> > > +
> > > +	hn =3D handshake_pernet(net);
> > > +	if (hn && remove_pending(hn, req)) {
> > > +		/* Request hadn't been accepted */
> > > +		trace_handshake_cancel(net, req, sk);
> > > +		return true;
> > > +	}
> > > +	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
> > > +		/* Request already completed */
> > > +		trace_handshake_cancel_busy(net, req, sk);
> > > +		return false;
> > > +	}
> > > +
> > > +	__sock_put(sk);
> >=20
> > Same here.
>=20
> I'll move the sock_hold() to _submit, and cook up a comment or two.

In such comments please also explain why sock_put() is not needed here
(and above). e.g. who is retaining the extra sk ref.

>=20
>=20
> > Side note, I think at this point some tests could surface here? If
> > user-space-based self-tests are too cumbersome and/or do not offer
> > adequate coverage perhaps you could consider using kunit?
>=20
> I'm comfortable with Kunit, having just added a bunch of tests
> for the kernel's SunRPC GSS Kerberos implementation.
>=20
> There, however, I had clearly defined test cases to add, thanks
> to the RFCs. I guess I'm a little unclear on what specific tests
> would be necessary or valuable here. Suggestions and existing
> examples are very welcome.

I *think* that a good start would be exercising the expected code
paths:

handshake_req_alloc, handshake_req_submit, handshake_complete
handshake_req_alloc, handshake_req_submit, handshake_cancel
or even
tls_*_hello_*, tls_handshake_accept, tls_handshake_done
tls_*_hello_*, tls_handshake_accept, tls_handshake_cancel

plus explicitly triggering some errors path e.g.=C2=A0

hn_pending_max+1 consecutive submit with no accept
handshake_cancel after handshake_complete
multiple handshake_complete on the same req
multiple handshake_cancel on the same req

Cheers,

Paolo

