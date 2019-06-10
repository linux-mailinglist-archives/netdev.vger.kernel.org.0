Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9256F3BF7D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390280AbfFJW1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:27:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFJW1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:27:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D752A3082B15;
        Mon, 10 Jun 2019 22:27:21 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59A6E60A9F;
        Mon, 10 Jun 2019 22:27:20 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 2/2] geneve: Don't assume linear buffers in error handler
Date:   Tue, 11 Jun 2019 00:27:06 +0200
Message-Id: <2bdcf7ad6c46f91d554c86b5b25937b2ce8741d2.1560205281.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560205281.git.sbrivio@redhat.com>
References: <cover.1560205281.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 10 Jun 2019 22:27:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit a07966447f39 ("geneve: ICMP error lookup handler") I wrongly
assumed buffers from icmp_socket_deliver() would be linear. This is not
the case: icmp_socket_deliver() only guarantees we have 8 bytes of linear
data.

Eric fixed this same issue for fou and fou6 in commits 26fc181e6cac
("fou, fou6: do not assume linear skbs") and 5355ed6388e2 ("fou, fou6:
avoid uninit-value in gue_err() and gue6_err()").

Use pskb_may_pull() instead of checking skb->len, and take into account
the fact we later access the GENEVE header with udp_hdr(), so we also
need to sum skb_transport_header() here.

Reported-by: Guillaume Nault <gnault@redhat.com>
Fixes: a07966447f39 ("geneve: ICMP error lookup handler")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 98d1a45c0606..25770122c219 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -395,7 +395,7 @@ static int geneve_udp_encap_err_lookup(struct sock *sk, struct sk_buff *skb)
 	u8 zero_vni[3] = { 0 };
 	u8 *vni = zero_vni;
 
-	if (skb->len < GENEVE_BASE_HLEN)
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) + GENEVE_BASE_HLEN))
 		return -EINVAL;
 
 	geneveh = geneve_hdr(skb);
-- 
2.20.1

