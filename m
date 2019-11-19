Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB9B102E56
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKSVlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:41:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27972 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbfKSVlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:41:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574199672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZj6AjNiGIzAOjShrA46xS+ThnjsprmeOOKRF4aOpwk=;
        b=TDYShWi8wtff5/A5LMetQu0Wtp1d7kgj5fQWsU5Rg9bpAtURNsj1HfK/LPv142ml7WfzJ1
        +JTVs+N900sBGuLb9CtX6hHcuCb39ARlh4adWUrsWgCcyJYjsaYXhy123K9ewFZwR59a4Q
        7jUXrhk/raglAReWPaxSXj1qo+XVgJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-2QYKujMfNpSZc3O9UY56xg-1; Tue, 19 Nov 2019 16:41:11 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73DA01034B22;
        Tue, 19 Nov 2019 21:41:09 +0000 (UTC)
Received: from ovpn-117-12.ams2.redhat.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE5721001E75;
        Tue, 19 Nov 2019 21:41:07 +0000 (UTC)
Message-ID: <53775b48bd52a148598ee418600c0b3cd01277c3.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look
 hints for list input
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>
Date:   Tue, 19 Nov 2019 22:41:06 +0100
In-Reply-To: <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
References: <cover.1574165644.git.pabeni@redhat.com>
         <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
         <c6d67eb8-623e-9265-567c-3d5cc1de7477@gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2QYKujMfNpSZc3O9UY56xg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-19 at 09:34 -0800, Eric Dumazet wrote:
> On 11/19/19 6:38 AM, Paolo Abeni wrote:
> > diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> > index 5d1615463138..9ab60611b97b 100644
> > --- a/include/net/ip6_fib.h
> > +++ b/include/net/ip6_fib.h
> > @@ -502,6 +502,11 @@ static inline bool fib6_metric_locked(struct fib6_=
info *f6i, int metric)
> >  }
> > =20
> >  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
> > +static inline bool fib6_has_custom_rules(struct net *net)
>=20
> const struct net *net

Yep, will do in the next iteration.

> > +{
> > +=09return net->ipv6.fib6_has_custom_rules;
>=20
> It would be nice to be able to detect that some custom rules only impact =
egress routes :/

My [mis-] understanding is that addressing correctly the above (and VRF
and likely many other use-cases) is beyond these patches scope.

> > +}
> > +
> >  int fib6_rules_init(void);
> >  void fib6_rules_cleanup(void);
> >  bool fib6_rule_default(const struct fib_rule *rule);
> > @@ -527,6 +532,10 @@ static inline bool fib6_rules_early_flow_dissect(s=
truct net *net,
> >  =09return true;
> >  }
> >  #else
> > +static inline bool fib6_has_custom_rules(struct net *net)
>=20
> const struct net *net

Ditto ;)

> > +{
> > +=09return 0;
>=20
> =09return false;
>=20
>=20
> BTW, this deserves a patch on its own :)

Oks, will do

> > +}
> >  static inline int               fib6_rules_init(void)
> >  {
> >  =09return 0;
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index ef7f707d9ae3..792b52aa9fc9 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -59,6 +59,7 @@ static void ip6_rcv_finish_core(struct net *net, stru=
ct sock *sk,
> >  =09=09=09INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
> >  =09=09=09=09=09udp_v6_early_demux, skb);
> >  =09}
> > +
>=20
> Why adding a new line ? Please refrain adding noise to a patch.

Sorry this is a left-over from previous iterations, will fix in the
next one.

Thank you for the detailed feedback!

Paolo

