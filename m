Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73146CCA0B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjC1Sds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjC1Sdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E21FC7
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680028380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0FgVKBJToYK1yiFwX2s1PsIft578+IvEFZ8Q3E8Uj6U=;
        b=QL6rjApBJJc3dX1puBg8x0jLpiSSbStQ0EhOrWB8cSWtCeqjoSmLA0Wa6CwLNvNFjtCnUv
        BhBMXXR90NkPR7jynkJoczLDdxDXFA8WPBsZZDBnP9ReHewJv9qK1AMKs2nXWclbnkshvl
        9wvwmvSCvvyi9ECcSOCjRC81mH+Aszs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-hlos5qqgMIeNhMQ6Ou88Yg-1; Tue, 28 Mar 2023 14:32:59 -0400
X-MC-Unique: hlos5qqgMIeNhMQ6Ou88Yg-1
Received: by mail-qv1-f70.google.com with SMTP id h7-20020a0cd807000000b005dd254e7babso5478722qvj.14
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680028379;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0FgVKBJToYK1yiFwX2s1PsIft578+IvEFZ8Q3E8Uj6U=;
        b=dPODU46d8zkDp3KtTydhlQvqIeKafygjhH4gBliFCRFInCQmMcYMIihZ4usmu9OSNQ
         ub/u5Z4hpXpZDdXoqIrc5wsxOEXAu4bqqL1bR8+EDBvglvoitOLQxLLPb5hUjhZNL5fy
         Ew+oX6nKbdwPEySJw4qd3I/p54qdG17+A1gnvA68s0fWqEwLUc+LpKk1h2GSwlUnRKHS
         EpGynV6Ue3Ucczl6JVKfBF0SWzNM+2AXHJHyCTbd7Y4fj6f/hQ1c6WKYzLaWC4S5q4zk
         6z87Oen/vmAabV/kVtbGmPmoY6y0qwG/3skYGgDKjo0CxXyH6KTFJIqKYWh0dQpDf7wU
         Y/Ig==
X-Gm-Message-State: AAQBX9clrcGVy6SpGvYr1soCfH6sfu9dxw7fpNZVbtcJ5FwT2sgswu7K
        SBmoRDck15SKQYbdM/rH2qj50qPHyTvKPkzLqhw/YSyBALQk9iGHPCLl5cJX9Rqeb1938F1tcpr
        Denqa88XYyV/nnHKQpqy2es6g
X-Received: by 2002:a05:6214:2a84:b0:56e:b1e0:3fef with SMTP id jr4-20020a0562142a8400b0056eb1e03fefmr24948830qvb.24.1680028378881;
        Tue, 28 Mar 2023 11:32:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350agVIdSWAWKZ8MDYC+NHMiHVgkQs3dMufixptWREwInD7kg+MjyfAv/xNNRJGR25AxZl6O1YA==
X-Received: by 2002:a05:6214:2a84:b0:56e:b1e0:3fef with SMTP id jr4-20020a0562142a8400b0056eb1e03fefmr24948801qvb.24.1680028378609;
        Tue, 28 Mar 2023 11:32:58 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id lf21-20020a0562142cd500b005dd8b93457esm3945623qvb.22.2023.03.28.11.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 11:32:58 -0700 (PDT)
Message-ID: <739ab9b8b930092fc2c0b65feeb7469de98642ff.camel@redhat.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Jeff Layton <jlayton@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Date:   Tue, 28 Mar 2023 14:32:57 -0400
In-Reply-To: <8154E3F3-C8A2-4BCF-8DFC-E00EA7B9CF80@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
         <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
         <3e4e33c19a9c608be863d2d7207f5a9cb7db795f.camel@redhat.com>
         <8154E3F3-C8A2-4BCF-8DFC-E00EA7B9CF80@oracle.com>
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

On Tue, 2023-03-28 at 18:19 +0000, Chuck Lever III wrote:
>=20
> > On Mar 28, 2023, at 2:14 PM, Jeff Layton <jlayton@redhat.com> wrote:
> >=20
> > On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
> > > From: Chuck Lever <chuck.lever@oracle.com>
> > >=20
> > > When a kernel consumer needs a transport layer security session, it
> > > first needs a handshake to negotiate and establish a session. This
> > > negotiation can be done in user space via one of the several
> > > existing library implementations, or it can be done in the kernel.
> > >=20
> > > No in-kernel handshake implementations yet exist. In their absence,
> > > we add a netlink service that can:
> > >=20
> > > a. Notify a user space daemon that a handshake is needed.
> > >=20
> > > b. Once notified, the daemon calls the kernel back via this
> > >   netlink service to get the handshake parameters, including an
> > >   open socket on which to establish the session.
> > >=20
> > > c. Once the handshake is complete, the daemon reports the
> > >   session status and other information via a second netlink
> > >   operation. This operation marks that it is safe for the
> > >   kernel to use the open socket and the security session
> > >   established there.
> > >=20
> > > The notification service uses a multicast group. Each handshake
> > > mechanism (eg, tlshd) adopts its own group number so that the
> > > handshake services are completely independent of one another. The
> > > kernel can then tell via netlink_has_listeners() whether a handshake
> > > service is active and prepared to handle a handshake request.
> > >=20
> > > A new netlink operation, ACCEPT, acts like accept(2) in that it
> > > instantiates a file descriptor in the user space daemon's fd table.
> > > If this operation is successful, the reply carries the fd number,
> > > which can be treated as an open and ready file descriptor.
> > >=20
> > > While user space is performing the handshake, the kernel keeps its
> > > muddy paws off the open socket. A second new netlink operation,
> > > DONE, indicates that the user space daemon is finished with the
> > > socket and it is safe for the kernel to use again. The operation
> > > also indicates whether a session was established successfully.
> > >=20
> > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > ---
> > > Documentation/netlink/specs/handshake.yaml |  122 +++++++++++
> > > MAINTAINERS                                |    8 +
> > > include/trace/events/handshake.h           |  159 ++++++++++++++
> > > include/uapi/linux/handshake.h             |   70 ++++++
> > > net/Kconfig                                |    5=20
> > > net/Makefile                               |    1=20
> > > net/handshake/Makefile                     |   11 +
> > > net/handshake/genl.c                       |   57 +++++
> > > net/handshake/genl.h                       |   23 ++
> > > net/handshake/handshake.h                  |   82 +++++++
> > > net/handshake/netlink.c                    |  316 +++++++++++++++++++=
+++++++++
> > > net/handshake/request.c                    |  307 +++++++++++++++++++=
++++++++
> > > net/handshake/trace.c                      |   20 ++
> > > 13 files changed, 1181 insertions(+)
> > > create mode 100644 Documentation/netlink/specs/handshake.yaml
> > > create mode 100644 include/trace/events/handshake.h
> > > create mode 100644 include/uapi/linux/handshake.h
> > > create mode 100644 net/handshake/Makefile
> > > create mode 100644 net/handshake/genl.c
> > > create mode 100644 net/handshake/genl.h
> > > create mode 100644 net/handshake/handshake.h
> > > create mode 100644 net/handshake/netlink.c
> > > create mode 100644 net/handshake/request.c
> > > create mode 100644 net/handshake/trace.c
> > >=20
> > >=20
> >=20
> > [...]
> >=20
> > > diff --git a/net/handshake/request.c b/net/handshake/request.c
> > > new file mode 100644
> > > index 000000000000..3f8ae9e990d2
> > > --- /dev/null
> > > +++ b/net/handshake/request.c
> > > @@ -0,0 +1,307 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Handshake request lifetime events
> > > + *
> > > + * Author: Chuck Lever <chuck.lever@oracle.com>
> > > + *
> > > + * Copyright (c) 2023, Oracle and/or its affiliates.
> > > + */
> > > +
> > > +#include <linux/types.h>
> > > +#include <linux/socket.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/skbuff.h>
> > > +#include <linux/inet.h>
> > > +#include <linux/fdtable.h>
> > > +#include <linux/rhashtable.h>
> > > +
> > > +#include <net/sock.h>
> > > +#include <net/genetlink.h>
> > > +#include <net/netns/generic.h>
> > > +
> > > +#include <uapi/linux/handshake.h>
> > > +#include "handshake.h"
> > > +
> > > +#include <trace/events/handshake.h>
> > > +
> > > +/*
> > > + * We need both a handshake_req -> sock mapping, and a sock ->
> > > + * handshake_req mapping. Both are one-to-one.
> > > + *
> > > + * To avoid adding another pointer field to struct sock, net/handsha=
ke
> > > + * maintains a hash table, indexed by the memory address of @sock, t=
o
> > > + * find the struct handshake_req outstanding for that socket. The
> > > + * reverse direction uses a simple pointer field in the handshake_re=
q
> > > + * struct.
> > > + */
> > > +
> > > +static struct rhashtable handshake_rhashtbl ____cacheline_aligned_in=
_smp;
> > > +
> > > +static const struct rhashtable_params handshake_rhash_params =3D {
> > > +	.key_len		=3D sizeof_field(struct handshake_req, hr_sk),
> > > +	.key_offset		=3D offsetof(struct handshake_req, hr_sk),
> > > +	.head_offset		=3D offsetof(struct handshake_req, hr_rhash),
> > > +	.automatic_shrinking	=3D true,
> > > +};
> > > +
> > > +int handshake_req_hash_init(void)
> > > +{
> > > +	return rhashtable_init(&handshake_rhashtbl, &handshake_rhash_params=
);
> > > +}
> > > +
> > > +void handshake_req_hash_destroy(void)
> > > +{
> > > +	rhashtable_destroy(&handshake_rhashtbl);
> > > +}
> > > +
> > > +struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
> > > +{
> > > +	return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,
> >=20
> > Is this correct? It seems like we should be searching for the struct
> > sock pointer value, not on the pointer to the pointer (which will be a
> > stack var), right?
>=20
> I copied this from the nfsd_file and nfs4_file code we added recently.
> rhashtable_lookup_fast takes a pointer to the key, so a pointer to a
> pointer should be correct in this case.
>=20

Got it. Thanks for clarifying!
--=20
Jeff Layton <jlayton@redhat.com>

