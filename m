Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4528E3BF7C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390257AbfFJW1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFJW1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:27:19 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5871C18B2C8;
        Mon, 10 Jun 2019 22:27:19 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64EDB608CD;
        Mon, 10 Jun 2019 22:27:18 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] vxlan: Don't assume linear buffers in error handler
Date:   Tue, 11 Jun 2019 00:27:05 +0200
Message-Id: <4875a7f58fc31701a14156978dd7d9abe9870908.1560205281.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560205281.git.sbrivio@redhat.com>
References: <cover.1560205281.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 10 Jun 2019 22:27:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c3a43b9fec8a ("vxlan: ICMP error lookup handler") I wrongly
assumed buffers from icmp_socket_deliver() would be linear. This is not
the case: icmp_socket_deliver() only guarantees we have 8 bytes of linear
data.

Eric fixed this same issue for fou and fou6 in commits 26fc181e6cac
("fou, fou6: do not assume linear skbs") and 5355ed6388e2 ("fou, fou6:
avoid uninit-value in gue_err() and gue6_err()").

Use pskb_may_pull() instead of checking skb->len, and take into account
the fact we later access the VXLAN header with udp_hdr(), so we also
need to sum skb_transport_header() here.

Reported-by: Guillaume Nault <gnault@redhat.com>
Fixes: c3a43b9fec8a ("vxlan: ICMP error lookup handler")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5994d5415a03..4c9bc29fe3d5 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1766,7 +1766,7 @@ static int vxlan_err_lookup(struct sock *sk, struct sk_buff *skb)
 	struct vxlanhdr *hdr;
 	__be32 vni;
 
-	if (skb->len < VXLAN_HLEN)
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) + VXLAN_HLEN))
 		return -EINVAL;
 
 	hdr = vxlan_hdr(skb);
-- 
2.20.1

