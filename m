Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53BA2634C1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgIIRiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbgIIRiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 13:38:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D277921D80;
        Wed,  9 Sep 2020 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599673079;
        bh=9Q+vyPWb73tHKw8GIISQM/7RZJaIXNsRtV4eH92kpiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3ORhsA9eawPJvRbQG7Payhmwub3VPxVoyD+L26RfBP8TOw1GfRifM9TTlGIJMmJU
         LzDHrkIm5hWxJ5uUj/TW9F7ha9IayXKZ+7uo5ARDLT1I1EspQZUtwTpmuaP9ZQ95cz
         zbsxtMMEBThgVBJumdx3I1x8wKlIIaLEBq6TU4d4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] net: make sure napi_list is safe for RCU traversal
Date:   Wed,  9 Sep 2020 10:37:53 -0700
Message-Id: <20200909173753.229124-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909173753.229124-1-kuba@kernel.org>
References: <20200909173753.229124-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netpoll needs to traverse dev->napi_list under RCU, make
sure it uses the right iterator and that removal from this
list is handled safely.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c     | 2 +-
 net/core/netpoll.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e0a1be986824..03624192862a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6656,7 +6656,7 @@ void __netif_napi_del(struct napi_struct *napi)
 		return;
 
 	napi_hash_del(napi);
-	list_del_init(&napi->dev_list);
+	list_del_rcu(&napi->dev_list);
 	napi_free_frags(napi);
 
 	flush_gro_hash(napi);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2338753e936b..c310c7c1cef7 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -297,7 +297,7 @@ static int netpoll_owner_active(struct net_device *dev)
 {
 	struct napi_struct *napi;
 
-	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
 		if (napi->poll_owner == smp_processor_id())
 			return 1;
 	}
-- 
2.26.2

