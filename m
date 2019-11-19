Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710D710292B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfKSQVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:21:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727456AbfKSQVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574180463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ga2MG7Qezbgzp/eI2D/oS5KzF2TePrUERsL8SXp+RcA=;
        b=Xw5NEmFBngSsblC8+wvchY1nUtBF4utRwkhXVNrZ1fswE81i4L8i9Dx1UGTdjA7Gor3s8L
        WYXvSUGRFSzwyCfVy3EtHPyx+n6qzeeShlZFgZK702mQglyoVZaJ7h+Ad8RL7ii3/uPPY3
        UHyK1KPXOaa4GanQ69kg/K161TLKY7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-Qjh7XTSMNlaaWUjPgVZffw-1; Tue, 19 Nov 2019 11:20:59 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87032593A2;
        Tue, 19 Nov 2019 16:20:58 +0000 (UTC)
Received: from ovpn-117-12.ams2.redhat.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A8A0605A7;
        Tue, 19 Nov 2019 16:20:56 +0000 (UTC)
Message-ID: <f8035cdd76f22d0eef3f3921779cebf0e2033934.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] ipv4: use dst hint for ipv4 list receive
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Date:   Tue, 19 Nov 2019 17:20:56 +0100
In-Reply-To: <34b44ddc-046b-a829-62af-7c32d6a0cbbe@gmail.com>
References: <cover.1574165644.git.pabeni@redhat.com>
         <f242674de1892d14ed602047c3817cc7212a618d.1574165644.git.pabeni@redhat.com>
         <34b44ddc-046b-a829-62af-7c32d6a0cbbe@gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Qjh7XTSMNlaaWUjPgVZffw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-19 at 09:00 -0700, David Ahern wrote:
> On 11/19/19 7:38 AM, Paolo Abeni wrote:
> > @@ -535,11 +550,20 @@ static void ip_sublist_rcv_finish(struct list_hea=
d *head)
> >  =09}
> >  }
> > =20
> > +static struct sk_buff *ip_extract_route_hint(struct net *net,
> > +=09=09=09=09=09     struct sk_buff *skb, int rt_type)
> > +{
> > +=09if (fib4_has_custom_rules(net) || rt_type !=3D RTN_LOCAL)
>=20
> Why the local only limitation for v4 but not v6? Really, why limit this
> to LOCAL at all?=20

The goal here was to simplify as much as possible the ipv4
ip_route_use_hint() helper, as its complexity raised some eyebrown.

Yes, hints can be used also for forwarding. I'm unsure how much will
help, given the daddr contraint. If there is agreement I can re-add it.

Thanks,

Paolo

