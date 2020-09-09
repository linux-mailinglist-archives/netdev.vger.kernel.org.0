Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D722026374B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgIIU0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:26:24 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:12566 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgIIU0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:26:16 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 089KPr6E013006;
        Wed, 9 Sep 2020 13:26:11 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Venkatesh Ellapu <venkatesh.e@chelsio.com>
Subject: [PATCH net-next 3/6] chelsio/chtls:Fix panic when server is on ipv6
Date:   Thu, 10 Sep 2020 01:55:37 +0530
Message-Id: <20200909202540.22052-4-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200909202540.22052-1-vinay.yadav@chelsio.com>
References: <20200909202540.22052-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netdev is filled in egress_dev when connection is established,
If connection is closed before establishment, then egress_dev
is NULL, Fix it using ip_dev_find() rather then extracting from
egress_dev.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Venkatesh Ellapu <venkatesh.e@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 2f9eceaf706d..e46228ca49ad 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -736,14 +736,13 @@ void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == PF_INET6) {
-		struct chtls_sock *csk;
+		struct net_device *ndev = chtls_find_netdev(cdev, sk);
 		int addr_type = 0;
 
-		csk = rcu_dereference_sk_user_data(sk);
 		addr_type = ipv6_addr_type((const struct in6_addr *)
 					  &sk->sk_v6_rcv_saddr);
 		if (addr_type != IPV6_ADDR_ANY)
-			cxgb4_clip_release(csk->egress_dev, (const u32 *)
+			cxgb4_clip_release(ndev, (const u32 *)
 					   &sk->sk_v6_rcv_saddr, 1);
 	}
 #endif
-- 
2.18.1

