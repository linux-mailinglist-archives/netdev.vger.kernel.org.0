Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE243D1476
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhGUQE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234532AbhGUQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zrJJBSp28F7+S8SVJdlDpI62YOFgpVTiDbprhSEFuw=;
        b=CuFG+nnVVlu7n0z3kRlBTSOlx0R4tWvus0Km0YT0hkODVFK8ff9QxzCOCrRcfLuxEfsKip
        8Be5VoqvXiHuYfoYzmcIArSWYQ7Iwq7IQ/NAZfkw2sZAZKww6xMkKw4oSCY8oucXDIsUcc
        xFQF1nTYDUajFtkbVUkSbr65ShpNZNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-VJ44S0x4MhK9a1Ctoe-dYg-1; Wed, 21 Jul 2021 12:45:22 -0400
X-MC-Unique: VJ44S0x4MhK9a1Ctoe-dYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39ED91084F67;
        Wed, 21 Jul 2021 16:45:21 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DAE2797C0;
        Wed, 21 Jul 2021 16:45:19 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 6/9] veth: use skb_prepare_for_gro()
Date:   Wed, 21 Jul 2021 18:44:38 +0200
Message-Id: <1abe7f6e76864ee634f437972f9249f05414f61c.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leveraging the previous patch we can now avoid orphaning the
skb in the veth gro path, allowing correct backpressure.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 381670c08ba7..50eb43e5bf45 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -713,7 +713,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	int mac_len, delta, off;
 	struct xdp_buff xdp;
 
-	skb_orphan_partial(skb);
+	skb_prepare_for_gro(skb);
 
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
-- 
2.26.3

