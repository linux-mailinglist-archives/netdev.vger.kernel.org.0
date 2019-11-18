Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878DC10093C
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfKRQbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:31:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbfKRQbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 11:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574094675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ra0BqXXUP8/yVHb6nWHHLByNR29ye23wEwGO+Z+UESw=;
        b=bCP5JXNWrQ9hUPzD2vbWmp4YhKxxmgl92K7dAu6+v2nSqZ0W+nF3Wwn2OnTblHtiB2CPCF
        glf+5yvjaseIYexi5NajKvCpdux805xLimaI4Diw88NZTVXB8w0te6Z8peST8FnbROsaEc
        VxhZTPzT3zR9ghxMWkBec3K2clfiBI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-IPLQO_vWMDKVpQW_YPiNsw-1; Mon, 18 Nov 2019 11:31:12 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E572A1857B45;
        Mon, 18 Nov 2019 16:31:10 +0000 (UTC)
Received: from ovpn-117-52.ams2.redhat.com (ovpn-117-52.ams2.redhat.com [10.36.117.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F7261FE;
        Mon, 18 Nov 2019 16:31:09 +0000 (UTC)
Message-ID: <3327209c4ac29e9051d1ebf41fb88a5749b46292.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] ipv4: use dst hint for ipv4 list receive
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Date:   Mon, 18 Nov 2019 17:31:08 +0100
In-Reply-To: <f81feaf9-8792-a648-431f-be14e17e2ace@gmail.com>
References: <cover.1574071944.git.pabeni@redhat.com>
         <592c763828171c414e8927878b1a22027e33dee7.1574071944.git.pabeni@redhat.com>
         <f81feaf9-8792-a648-431f-be14e17e2ace@gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: IPLQO_vWMDKVpQW_YPiNsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the feedback.

On Mon, 2019-11-18 at 09:07 -0700, David Ahern wrote:
> On 11/18/19 4:01 AM, Paolo Abeni wrote:
> > @@ -535,9 +540,20 @@ static void ip_sublist_rcv_finish(struct list_head=
 *head)
> >  =09}
> >  }
> > =20
> > +static bool ip_can_cache_route_hint(struct net *net, struct rtable *rt=
)
> > +{
> > +=09return rt->rt_type !=3D RTN_BROADCAST &&
> > +#ifdef CONFIG_IP_MULTIPLE_TABLES
> > +=09       !net->ipv6.fib6_has_custom_rules;
>=20
> that should be ipv4, not ipv6, right?

Indeed. More coffee needed here, sorry.

> Also, for readability it would be better to have 2 helpers in
> include//net/fib_rules.h that return true false and manage the net
> namespace issue.

Double checking I parsed the above correctly. Do you mean something
like the following - I think net/ip_fib.h fits more, as it already
deals with CONFIG_IP_MULTIPLE_TABLES?

---
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 52b2406a5dfc..b6c5cd544402 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -272,6 +272,11 @@ void fib_free_table(struct fib_table *tb);
 #define TABLE_LOCAL_INDEX      (RT_TABLE_LOCAL & (FIB_TABLE_HASHSZ - 1))
 #define TABLE_MAIN_INDEX       (RT_TABLE_MAIN  & (FIB_TABLE_HASHSZ - 1))
=20
+static bool fib4_has_custom_rules(struct net *net)
+{
+       return 0;
+}
+
 static inline struct fib_table *fib_get_table(struct net *net, u32 id)
 {
        struct hlist_node *tb_hlist;
@@ -341,6 +346,11 @@ void __net_exit fib4_rules_exit(struct net *net);
 struct fib_table *fib_new_table(struct net *net, u32 id);
 struct fib_table *fib_get_table(struct net *net, u32 id);
=20
+static bool fib4_has_custom_rules(struct net *net)
+{
+       return net->ipv4.fib_has_custom_rules;
+}
+
 int __fib_lookup(struct net *net, struct flowi4 *flp,
                 struct fib_result *res, unsigned int flags);
---
plus something similar for the previous patch, in include/net/ip6_fib.h

Thank you,

Paolo

