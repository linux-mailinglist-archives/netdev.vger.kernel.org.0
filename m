Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36724F47CB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390819AbfKHLww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403799AbfKHLq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9FE9218AE;
        Fri,  8 Nov 2019 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213618;
        bh=ON1L6FHRZCSgyfc+YX7cNsYgDakQmYbouwjMn0KnQBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRnwpEht6byJvfdDH/NiC9BbKN16tUy042TS5yiR+BjCWeoIY8XZ/rRjrGzupZ2ip
         QDEkkxLF79+y6IVUWL5UToJWG8MH1rXbI6Vsuvrvz3lUah8GbedU+UbC0wDi4qMK9b
         GPSlAzp7fAXcEYnQbxN4VKCiDEePsKw6S3oqV3GA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 51/64] llc: avoid blocking in llc_sap_close()
Date:   Fri,  8 Nov 2019 06:45:32 -0500
Message-Id: <20191108114545.15351-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 9708d2b5b7c648e8e0a40d11e8cea12f6277f33c ]

llc_sap_close() is called by llc_sap_put() which
could be called in BH context in llc_rcv(). We can't
block in BH.

There is no reason to block it here, kfree_rcu() should
be sufficient.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc.h  | 1 +
 net/llc/llc_core.c | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/llc.h b/include/net/llc.h
index 82d989995d18a..95e5ced4c1339 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -66,6 +66,7 @@ struct llc_sap {
 	int sk_count;
 	struct hlist_nulls_head sk_laddr_hash[LLC_SK_LADDR_HASH_ENTRIES];
 	struct hlist_head sk_dev_hash[LLC_SK_DEV_HASH_ENTRIES];
+	struct rcu_head rcu;
 };
 
 static inline
diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index e896a2c53b120..f1e442a39db8d 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -127,9 +127,7 @@ void llc_sap_close(struct llc_sap *sap)
 	list_del_rcu(&sap->node);
 	spin_unlock_bh(&llc_sap_list_lock);
 
-	synchronize_rcu();
-
-	kfree(sap);
+	kfree_rcu(sap, rcu);
 }
 
 static struct packet_type llc_packet_type __read_mostly = {
-- 
2.20.1

