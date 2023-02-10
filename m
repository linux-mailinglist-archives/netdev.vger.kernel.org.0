Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55151691E8A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjBJLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjBJLmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:42:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E0C2125
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676029306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMpjvNeBswYA00fcx8FtcYGJOlxCfChlGuwAOI4NZC8=;
        b=i3aBbiYVIaUDMpGKpeJH8I5Cw68FJ2rjSZuxHE/KmyejWRaVlCuWRUhwPQt83Adlz09ORj
        d6/ngJkRXh1EOe5bIxdRwH0rzuOmadKVt4ZGKkyTF5p0+nvOnjbihoXs8LQrcYKBNK2/0l
        fpUXopmYy5rxvVIRfIWN6fAu7el+rNI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-ewIDCOexMCm5qZH0vlHycg-1; Fri, 10 Feb 2023 06:41:43 -0500
X-MC-Unique: ewIDCOexMCm5qZH0vlHycg-1
Received: by mail-qv1-f71.google.com with SMTP id jo26-20020a056214501a00b0053aa15f61d4so2971977qvb.7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:41:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mMpjvNeBswYA00fcx8FtcYGJOlxCfChlGuwAOI4NZC8=;
        b=fNgoElfGld3XhtUSksoX1eaPii4yMNNyxd21+G9MvAYWfnOpoVaWHHuCFA0rZ5mI0j
         8d2RRY5uty6/OUcJz678qTF7S+vUQkObb37XPfcR7SXjQ18W/yMvw81dZm0sPjGix0jL
         5BrRCdoTWWjQFcMXhs/dJC0kWSdddiP0hqTvq+aoy6itUhPnTKLIz9L2g86oBibb643i
         7PdVGYICr6UfDjaQWIdZ9vOnnQcWGaYz7Fgoaz6H1La1czrqTpGk4RaKySH4nLYFNzgr
         x6+/hxJ5YCbqqOH5mDAiz2fIigZwJ36B62DpU1wewWcrhgLdibINLMvVy7dFxQW4L2G/
         emzg==
X-Gm-Message-State: AO0yUKWb+u5BaxvIJwZ4aEwIv41LW0GZqd9FqQjTFLGakMrB8DtbYbPt
        dJnbtZRwkiUXqlZx1j84uFvji7PQg0k+bUxknDp2Rvb9me9SRsfc9NdL+nIMuRgINBIawU9oEeF
        8MHvn3vVnSc5HTYiZ
X-Received: by 2002:a0c:e194:0:b0:56c:268e:ed1c with SMTP id p20-20020a0ce194000000b0056c268eed1cmr8844798qvl.1.1676029303100;
        Fri, 10 Feb 2023 03:41:43 -0800 (PST)
X-Google-Smtp-Source: AK7set/rdcEQEbAGoLWHNEllSz/44/Sy8vM41Xyn4kZLH4huKjiyyuccV3S6gwuRu6pa9bAzHDJxCQ==
X-Received: by 2002:a0c:e194:0:b0:56c:268e:ed1c with SMTP id p20-20020a0ce194000000b0056c268eed1cmr8844780qvl.1.1676029302815;
        Fri, 10 Feb 2023 03:41:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a05620a048200b007290be5557bsm3348573qkr.38.2023.02.10.03.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 03:41:42 -0800 (PST)
Message-ID: <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Date:   Fri, 10 Feb 2023 12:41:38 +0100
In-Reply-To: <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
         <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
         <20230208220025.0c3e6591@kernel.org>
         <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
         <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
         <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Thu, 2023-02-09 at 16:34 +0000, Chuck Lever III wrote:
>=20
> > On Feb 9, 2023, at 11:02 AM, Paolo Abeni <pabeni@redhat.com> wrote:
> >=20
> > On Thu, 2023-02-09 at 15:43 +0000, Chuck Lever III wrote:
> > > > On Feb 9, 2023, at 1:00 AM, Jakub Kicinski <kuba@kernel.org> wrote:
> > > >=20
> > > > On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
> > > > > diff --git a/tools/include/uapi/linux/netlink.h
> > > > > b/tools/include/uapi/linux/netlink.h
> > > > > index 0a4d73317759..a269d356f358 100644
> > > > > --- a/tools/include/uapi/linux/netlink.h
> > > > > +++ b/tools/include/uapi/linux/netlink.h
> > > > > @@ -29,6 +29,7 @@
> > > > > #define NETLINK_RDMA		20
> > > > > #define NETLINK_CRYPTO		21	/* Crypto layer */
> > > > > #define NETLINK_SMC		22	/* SMC monitoring */
> > > > > +#define NETLINK_HANDSHAKE	23	/* transport layer sec
> > > > > handshake requests */
> > > >=20
> > > > The extra indirection of genetlink introduces some complications?
> > >=20
> > > I don't think it does, necessarily. But neither does it seem
> > > to add any value (for this use case). <shrug>
> >=20
> > To me it introduces a good separation between the handshake mechanism
> > itself and the current subject (sock).
> >=20
> > IIRC the previous version allowed the user-space to create a socket of
> > the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
> > construct - assuming I interpreted it correctly - did not sound right
> > to me.
> >=20
> > Back to these patches, they looks sane to me, even if the whole
> > architecture is a bit hard to follow, given the non trivial cross
> > references between the patches - I can likely have missed some relevant
> > point.
>=20
> One of the original goals was to support other security protocols
> besides TLS v1.3, which is why the code is split between two
> patches. I know that is cumbersome for some review workflows.
>=20
> Now is a good time to simplify, if we see a sensible opportunity
> to do so.

I think that adding a 'hi_free'/'hi_release' op inside the
handshake_info struct - and moving the handshake info deallocation
inside the 'core' could possibly simplify a bit the architecture.

Since it looks like there is a reasonable agreement on this path
(@Dave, @Eric, @Jakub: please educate me otherwise!), and no
clear/immediate show stoppers, I suggested start hammering some
documentation with an high level overview that will help also
understanding/reviewing the code.

> > I'm wondering if this approach scales well enough with the number of
> > concurrent handshakes: the single list looks like a potential bottle-
> > neck.
>=20
> It's not clear how much scaling is needed. I don't have a strong
> sense of how frequently a busy storage server will need a handshake,
> for instance, but it seems like it would be relatively less frequent
> than, say, I/O. Network storage connections are typically long-lived,
> unlike http.
>=20
> In terms of scalability, I am a little more concerned about the
> handshake_mutex. Maybe that isn't needed since the pending list is
> spinlock protected?

Good point. Indeed it looks like that is not needed.

> All that said, the single pending list can be replaced easily. It
> would be straightforward to move it into struct net, for example.

In the end I don't see a operations needing a full list traversal.
handshake_nl_msg_accept walk that, but it stops at netns/proto matching
which should be ~always /~very soon in the typical use-case. And as you
said it should be easy to avoid even that.

I think it could be useful limiting the number of pending handshake to
some maximum, to avoid problems in pathological/malicious scenarios.

Cheers,

Paolo

