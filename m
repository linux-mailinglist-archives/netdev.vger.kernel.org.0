Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37EE102AD6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfKSRdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:33:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20324 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727591AbfKSRdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574184801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+fbbjOO6VFq5HeaZusRMTPQQrHfBSxInXUPoNF0KpUA=;
        b=U+4IHVlRWpsJkrPpVknhRRmKTI7Gra9BKEKuNgtMBmfrxoPEmmrk48KZ6/yVHn3kMgQz1+
        qsXSEG1cj4omUO0jqtwM5Z0Azdy+wn1wuMcxW9BG8PUv4X2IKs9z49nugvT9qAE6pamsCP
        SM/fquZ0BVQv4oEUf0n235W3ZNuVJT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-nyHip3KDMXekfKZxflqtBg-1; Tue, 19 Nov 2019 12:33:18 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2E4C802A62;
        Tue, 19 Nov 2019 17:33:16 +0000 (UTC)
Received: from ovpn-117-12.ams2.redhat.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1BB82937D;
        Tue, 19 Nov 2019 17:33:15 +0000 (UTC)
Message-ID: <6c619ef604e8236f2fc7e08fd2f977137633fbc6.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] ipv4: use dst hint for ipv4 list receive
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Date:   Tue, 19 Nov 2019 18:33:14 +0100
In-Reply-To: <f8035cdd76f22d0eef3f3921779cebf0e2033934.camel@redhat.com>
References: <cover.1574165644.git.pabeni@redhat.com>
         <f242674de1892d14ed602047c3817cc7212a618d.1574165644.git.pabeni@redhat.com>
         <34b44ddc-046b-a829-62af-7c32d6a0cbbe@gmail.com>
         <f8035cdd76f22d0eef3f3921779cebf0e2033934.camel@redhat.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: nyHip3KDMXekfKZxflqtBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-19 at 17:20 +0100, Paolo Abeni wrote:
> On Tue, 2019-11-19 at 09:00 -0700, David Ahern wrote:
> > On 11/19/19 7:38 AM, Paolo Abeni wrote:
> > > @@ -535,11 +550,20 @@ static void ip_sublist_rcv_finish(struct list_h=
ead *head)
> > >  =09}
> > >  }
> > > =20
> > > +static struct sk_buff *ip_extract_route_hint(struct net *net,
> > > +=09=09=09=09=09     struct sk_buff *skb, int rt_type)
> > > +{
> > > +=09if (fib4_has_custom_rules(net) || rt_type !=3D RTN_LOCAL)
> >=20
> > Why the local only limitation for v4 but not v6? Really, why limit this
> > to LOCAL at all?=20
>=20
> The goal here was to simplify as much as possible the ipv4
> ip_route_use_hint() helper, as its complexity raised some eyebrown.
>=20
> Yes, hints can be used also for forwarding. I'm unsure how much will
> help, given the daddr contraint. If there is agreement I can re-add it.

Sorry, I forgot to ask: would you be ok enabling the route hint for
!RTN_BROADCAST, as in the previous iteration? Covering RTN_BROADCAST
will add quite a bit of complexity to ip_route_use_hint(), likely with
no relevant use-case.

Thanks!

Paolo

