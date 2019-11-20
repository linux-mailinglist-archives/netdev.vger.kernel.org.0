Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9577C1035D1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKTIIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:08:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726358AbfKTIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 03:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574237291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFwHg0Aepm83lYz1O/Q9HSyWIzejcLe8dDXjBLqAcE0=;
        b=JjAFQQesureQ/vYc3PWVlSd9jz0STKcgqTn8EfFYGHGXTYoUyoPMcYirb0DySQ3Ls1YwVC
        y9MjFgFhmYBARLrNsYzNc4mEc2KycZA5R9V6vYyLXat7UCBkIdWmBNix0FGJFoiATQsTle
        ErHY3faRM5KIosU3qmHv9pZvStRLwq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-EJ_ys-OlONyn9c5alkdWMg-1; Wed, 20 Nov 2019 03:08:05 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 078B21005502;
        Wed, 20 Nov 2019 08:08:04 +0000 (UTC)
Received: from ovpn-117-23.ams2.redhat.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A1267E52;
        Wed, 20 Nov 2019 08:08:02 +0000 (UTC)
Message-ID: <3981530c7b8a0a014e28a704c7bc8fb189f6fcf6.camel@redhat.com>
Subject: Re: [PATCH net-next v3 0/2] net: introduce and use route hint
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ecree@solarflare.com, dsahern@gmail.com
Date:   Wed, 20 Nov 2019 09:08:01 +0100
In-Reply-To: <20191119.184727.837407293057991626.davem@davemloft.net>
References: <cover.1574165644.git.pabeni@redhat.com>
         <20191119.184727.837407293057991626.davem@davemloft.net>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: EJ_ys-OlONyn9c5alkdWMg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-19 at 18:47 -0800, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Tue, 19 Nov 2019 15:38:35 +0100
>=20
> > This series leverages the listification infrastructure to avoid
> > unnecessary route lookup on ingress packets. In absence of policy routi=
ng,
> > packets with equal daddr will usually land on the same dst.
> >=20
> > When processing packet bursts (lists) we can easily reference the previ=
ous
> > dst entry. When we hit the 'same destination' condition we can avoid th=
e
> > route lookup, coping the already available dst.
> >=20
> > Detailed performance numbers are available in the individual commit
> > messages. Figures are slightly better then previous iteration because
> > thanks to Willem's suggestion we additionally skip early demux when usi=
ng
> > the route hint.
> >=20
> > v2 -> v3:
> >  - use fib*_has_custom_rules() helpers (David A.)
> >  - add ip*_extract_route_hint() helper (Edward C.)
> >  - use prev skb as hint instead of copying data (Willem )
> >=20
> > v1 -> v2:
> >  - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
> >  - fix potential race in ip6_list_rcv_finish()
>=20
> To reiterate David A.'s feedback,=20

Yep, I'm working to address it...

> having this depend upon
> IP_MULTIPLE_TABLES being disabled is %100 a non-starter.

...anyway in its current form it 'just' depends on CONFIG_IPV6_SUBTREE
being disabled. Next iteration will remove such dep, as per David's
feedback.

Thanks,

Paolo

