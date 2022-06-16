Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344CE54E22E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377120AbiFPNj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377130AbiFPNj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 948582C10A
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655386766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yTdQlPuObsWaQT9I/9ftCAj4jBjbSSJ/czOcRGxPEo0=;
        b=Vb11MPXWhaMnXTF2cvi54pcg0783uY7icNJ/dtgnz9fVSmYZMeJXXVbuoc4Ak5ft3ANdd4
        y4y9Dil6EDbHJ1UzS5RXT8QqZf2kNO9N/coVC723QpMf4eeRghdyzf+avyq8LkjE++wczO
        KCR2ekh3Vyz5FEApygEBV7CjVqdkTJE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-1qNGqohkNymUkcMO5T9mMg-1; Thu, 16 Jun 2022 09:39:22 -0400
X-MC-Unique: 1qNGqohkNymUkcMO5T9mMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF131C004E9;
        Thu, 16 Jun 2022 13:39:21 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EB1F1121319;
        Thu, 16 Jun 2022 13:39:20 +0000 (UTC)
Date:   Thu, 16 Jun 2022 15:39:16 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Kaustubh Pandey" <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit
 of dev mtu
Message-ID: <20220616153916.26bc2876@elisabeth>
In-Reply-To: <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
        <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
        <20220615173516.29c80c96@kernel.org>
        <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
        <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Subash, please fix quoting of replies in your client, it's stripping
email authors. I rebuilt the chain here but it's kind of painful]

On Wed, 15 Jun 2022 23:36:10 -0600
"Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com> wrote:

> On Wed, 15 Jun 2022 18:21:07 -0700
> Maciej =C5=BBenczykowski <maze@google.com> wrote:
> >
> > On Wed, Jun 15, 2022 at 5:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > CC maze, please add him if there is v3
> > >
> > > I feel like the problem is with the fact that link mtu resets protocol
> > > MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
> > > whatever other quantification of infinity there is)

2^16 - 1, works for both IPv4 and IPv6.

> > > so you don't have
> > > to touch it as you discover the MTU for v4 and v6? =20
>=20
> That's a good point.
>=20
> > > My worry is that the tweaking of the route MTU update heuristic will
> > > have no end.
> > >
> > > Stefano, does that makes sense or you think the change is good? =20

It makes sense -- I'm also worried that we're introducing another small
issue to fix what, I think, is the smallest possible inconvenience.

> The only concern is that current behavior causes the initial packets=20
> after interface MTU increase to get dropped as part of PMTUD if the IPv6=
=20
> PMTU itself didn't increase. I am not sure if that was the intended=20
> behavior as part of the original change. Stefano, could you please confir=
m?

Correct, that was the intended behaviour, because I think one dropped
packet is the smallest possible price we can pay for, knowingly, not
having anymore a PMTU estimate that's accurate in terms of RFC 1191.

> > I vaguely recall that if you don't want device mtu changes to affect
> > ipv6 route mtu, then you should set 'mtu lock' on the routes.
> > (this meaning of 'lock' for v6 is different than for ipv4, where
> > 'lock' means transmit IPv4/TCP with Don't Frag bit unset) =20

"Locked" exceptions are rather what's created as a result of ICMP and
ICMPv6 messages -- I guess you can have a look or run the basic
pmtu_ipv4() and pmtu_ipv6() to get a sense of it.

With the existing implementation, if you increase the link MTU to a
value that's bigger than the locked value from PMTU discovery, it will
not increase in general: the exception is locking it. That's what's
described in the comment that this patch is removing.

It will increase only under that specific condition, namely, if the
current PMTU estimate is the same as the old link MTU, because then we
can take the reasonable assumption that our link was the limiting
factor, and not some other link on the path. It might be wrong, but I
still maintain it's a reasonable assumption, and, most importantly, we
have no way to prove it wrong without PMTU discovery.

--=20
Stefano

