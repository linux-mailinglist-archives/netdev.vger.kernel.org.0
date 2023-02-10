Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C232A6921FF
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjBJPWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjBJPWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDBC74055
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676042492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6+v+z7J504+oYXspjCcCUbF8h2zp9FCUssb+aAZlzI=;
        b=LB8hAZ4ktAadOHCxgFhIWCFETmNNH9Zf+wZHrdCUalfdTthF5xHbFxz5YV4rkKx4qb9IVo
        lBpqBqYHpCAuxmQH3l0tOsEPCq2waUeKzhw7QtjHhzb6J8Bl/95/2fvuB1c/AFAm9Udrfg
        cdvlEW6SqBHo5XL/j2nAnl0+K8Ft6j4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-160-KR3Nw0b0PMmRGjO8EeaSvQ-1; Fri, 10 Feb 2023 10:21:31 -0500
X-MC-Unique: KR3Nw0b0PMmRGjO8EeaSvQ-1
Received: by mail-qt1-f198.google.com with SMTP id s4-20020ac85284000000b003b849aa2cd6so3227829qtn.15
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J6+v+z7J504+oYXspjCcCUbF8h2zp9FCUssb+aAZlzI=;
        b=2dYNbXsEzxYXc5IQn2SNxWSefNYuu7C9yOr7DkhTXqbO5j0SV9OYPgXCmJLUXuEIkJ
         EoBsR4eSuyXuFySDhiaV2kl9DckVctKoSRgCV3WGewg343fQtj5BU9GP4L3L++qmgNw0
         SU9UnRJ/idypJyWkaDhRdn240fIzFbeFVTZAr7MlvyZurTURjfa4SPq+BMuGC8jeUn5A
         jiWKMogMR99wpScHYNhaCTemEGS+UNRAR67fZWLOFzp/0Ox+N+1YkQLt6HV8hFUVy7Is
         kpKx86q8FsTIxDsPR2Zj5H6NBQWoT8QYj2omUvPuMHjhZNXqag2WGBwfYr4iAFEiv7ac
         EqbQ==
X-Gm-Message-State: AO0yUKVOBVFWcxpQkFmEkLdEEKnmCYDadfpjyhjPied5Ehhn04cf+n/p
        DuWaTQPyfc5ZCW9O/kpxU8jh0DOX28w9NLzv9ZzCaDHr/iKbF5hicqui41qUrd0/v4vSAOxh2rE
        97ZXx4Xeqox9De8EV
X-Received: by 2002:a0c:dd0f:0:b0:539:aae2:8dc4 with SMTP id u15-20020a0cdd0f000000b00539aae28dc4mr21914467qvk.4.1676042490572;
        Fri, 10 Feb 2023 07:21:30 -0800 (PST)
X-Google-Smtp-Source: AK7set9W8KS2Ohj6BB2Clwkvzdknwq7Qg1SMwlMO4lh/q0WJiyCFVgkkBy1UMZmjWQ0gnQlaSWdkTA==
X-Received: by 2002:a0c:dd0f:0:b0:539:aae2:8dc4 with SMTP id u15-20020a0cdd0f000000b00539aae28dc4mr21914433qvk.4.1676042490230;
        Fri, 10 Feb 2023 07:21:30 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id r204-20020a3744d5000000b00706bc44fda8sm3686362qka.79.2023.02.10.07.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:21:29 -0800 (PST)
Message-ID: <0939bf91b21c27ca78d09206ad0c81d560ed5fed.camel@redhat.com>
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
Date:   Fri, 10 Feb 2023 16:21:26 +0100
In-Reply-To: <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
         <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
         <20230208220025.0c3e6591@kernel.org>
         <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
         <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
         <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
         <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
         <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
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

On Fri, 2023-02-10 at 14:31 +0000, Chuck Lever III wrote:
> In previous generations of this series, there was an addition
> to Documentation/ that explained how kernel TLS consumers use
> the tls_ handshake API.=C2=A0I can add that back now that things
> are settling down.

That would be useful, thank!

> But maybe you are thinking of some other topics. I'm happy to
> write down whatever is needed, but I'd like suggestions about
> what particular areas would be most helpful.

A reference user-space implementation would be very interesting, too.=C2=A0

Even a completely "dummy" one for self-tests purpose only could be
useful.=C2=A0

Speaking of that, at some point we will need some self-tests ;)

> > > > I'm wondering if this approach scales well enough with the number o=
f
> > > > concurrent handshakes: the single list looks like a potential bottl=
e-
> > > > neck.
> > >=20
> > > It's not clear how much scaling is needed. I don't have a strong
> > > sense of how frequently a busy storage server will need a handshake,
> > > for instance, but it seems like it would be relatively less frequent
> > > than, say, I/O. Network storage connections are typically long-lived,
> > > unlike http.
> > >=20
> > > In terms of scalability, I am a little more concerned about the
> > > handshake_mutex. Maybe that isn't needed since the pending list is
> > > spinlock protected?
> >=20
> > Good point. Indeed it looks like that is not needed.
>=20
> I will remove the handshake_mutex in v4.
>=20
>=20
> > > All that said, the single pending list can be replaced easily. It
> > > would be straightforward to move it into struct net, for example.
> >=20
> > In the end I don't see a operations needing a full list traversal.
> > handshake_nl_msg_accept walk that, but it stops at netns/proto matching
> > which should be ~always /~very soon in the typical use-case. And as you
> > said it should be easy to avoid even that.
> >=20
> > I think it could be useful limiting the number of pending handshake to
> > some maximum, to avoid problems in pathological/malicious scenarios.
>=20
> Defending against DoS is sensible. Maybe having a per-net
> maximum of 5 or 10 pending handshakes? handshake_request() can
> return an error code if a handshake is requested while we're
> over that maximum.

I'm wondering if we could use an {r,w}mem based limits, so that the
user-space could eventually tune it as/if needed without any additional
knob.

Cheers,

Paolo

