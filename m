Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632BE3D9326
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhG1QYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230283AbhG1QYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zrJJBSp28F7+S8SVJdlDpI62YOFgpVTiDbprhSEFuw=;
        b=UyFpJI9sUcpRacMg88L2VaxU+zHPaySfdnr4gkVtD/q+lwtDlzyS2/J2Mc5sBAxZs2y3LD
        g1+/YL+ynk74buUol1IWxzpspo3XJkapsh+JL5NVeycgdjz96pobTqa4qy1QFKolw9Auci
        onZZ8ikvsrg3lHWrn6bUELQELdtwqy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-kZ1aZCJrMAe3gikLlWSn-Q-1; Wed, 28 Jul 2021 12:24:42 -0400
X-MC-Unique: kZ1aZCJrMAe3gikLlWSn-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 186A110066E5;
        Wed, 28 Jul 2021 16:24:41 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 004EE5C1B4;
        Wed, 28 Jul 2021 16:24:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 6/6] veth: use skb_prepare_for_gro()
Date:   Wed, 28 Jul 2021 18:24:04 +0200
Message-Id: <d07db89b5847806e63e2fdf66b88af706a461c9d.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

