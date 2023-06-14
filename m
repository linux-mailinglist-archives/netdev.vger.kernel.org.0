Return-Path: <netdev+bounces-10629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 351C672F745
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57AED1C20754
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E41A41;
	Wed, 14 Jun 2023 08:04:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B97F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:04:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE53B1FD6
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686729862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AdExDkio2IavDiEBIZ3Za2q9aIwRCw4IZu4sfOZDrT0=;
	b=HniLBpEyLSSXF/i+m0bP+d+/WOWMVXeiGZahQh7oTggjX4e/vLTrYMLceR8WcF9xpNINI4
	GKDl7q94GMnIW/ESmrGBEqGxtygrU0YoirU8KVSnJr3QL6f1rMKUouZdB2hGpVAajuMsUT
	+eXOQiiE31ob3nT/LeDXMONe5JshV14=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-ikdS9KTKNjSb28DFQ4X47Q-1; Wed, 14 Jun 2023 04:04:19 -0400
X-MC-Unique: ikdS9KTKNjSb28DFQ4X47Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5793810BB3;
	Wed, 14 Jun 2023 08:04:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 080E740C6F5C;
	Wed, 14 Jun 2023 08:04:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
cc: dhowells@redhat.com,
    syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
    Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] ip, ip6: Fix splice to raw and ping sockets
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1410155.1686729856.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Jun 2023 09:04:16 +0100
Message-ID: <1410156.1686729856@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

    =

Splicing to SOCK_RAW sockets may set MSG_SPLICE_PAGES, but in such a case,
__ip_append_data() will call skb_splice_from_iter() to access the 'from'
data, assuming it to point to a msghdr struct with an iter, instead of
using the provided getfrag function to access it.

In the case of raw_sendmsg(), however, this is not the case and 'from' wil=
l
point to a raw_frag_vec struct and raw_getfrag() will be the frag-getting
function.  A similar issue may occur with rawv6_sendmsg().

Fix this by ignoring MSG_SPLICE_PAGES if getfrag !=3D ip_generic_getfrag a=
s
ip_generic_getfrag() expects "from" to be a msghdr*, but the other getfrag=
s
don't.  Note that this will prevent MSG_SPLICE_PAGES from being effective
for udplite.

This likely affects ping sockets too.  udplite looks like it should be oka=
y
as it expects "from" to be a msghdr.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000ae4cbf05fdeb8349@google.com/
Fixes: 2dc334f1a63a ("splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather th=
an ->sendpage()")
Tested-by: syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com
cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
cc: David Ahern <dsahern@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/ipv4/ip_output.c  |    3 ++-
 net/ipv6/ip6_output.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 244fb9365d87..4b39ea99f00b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1040,7 +1040,8 @@ static int __ip_append_data(struct sock *sk,
 	} else if ((flags & MSG_SPLICE_PAGES) && length) {
 		if (inet->hdrincl)
 			return -EPERM;
-		if (rt->dst.dev->features & NETIF_F_SG)
+		if (rt->dst.dev->features & NETIF_F_SG &&
+		    getfrag =3D=3D ip_generic_getfrag)
 			/* We need an empty buffer to attach stuff to */
 			paged =3D true;
 		else
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c722cb881b2d..dd845139882c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1592,7 +1592,8 @@ static int __ip6_append_data(struct sock *sk,
 	} else if ((flags & MSG_SPLICE_PAGES) && length) {
 		if (inet_sk(sk)->hdrincl)
 			return -EPERM;
-		if (rt->dst.dev->features & NETIF_F_SG)
+		if (rt->dst.dev->features & NETIF_F_SG &&
+		    getfrag =3D=3D ip_generic_getfrag)
 			/* We need an empty buffer to attach stuff to */
 			paged =3D true;
 		else


