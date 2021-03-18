Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA00340D45
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhCRSih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhCRSiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 875D46023B;
        Thu, 18 Mar 2021 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092702;
        bh=OvY5UMvAG0qTSbOdbmgYEnXGqUuNy/yw9wXX7u9iJlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cenCuwvnXDs7u/h/LsyhWAfPA9uFlZnlm+Z3uRZwr3X/MQzsChN58HCpyZdkNHzez
         4uPZj4gpgud1DEzr8YoQl1nOEj3CzaEcZjnOJbyT6r8W5IQJ+uQSranJAnRCVVouUj
         YC8HubK+ZilkzkWuG9MHfZXDkBPWpZcIM+2xRsG79Hvml1nXX37wU5ywKzrJgYNnHa
         l3LGED6G9xQtpshXJrKXZZjeJncePi7hEH9yyYMuLTlhB3YR4yquk2C0MN+NNf6H8L
         IifWQSiuMxppLWBjoNzvcqCy3bT5IyruC1W+2RKB/cNXI4zl0/I4d4TtPqMjcyO/PW
         B9TljPVIEtCXQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 09/13] net: improve queue removal readability in __netif_set_xps_queue
Date:   Thu, 18 Mar 2021 19:37:48 +0100
Message-Id: <20210318183752.2612563-10-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the readability of the loop removing tx-queue from unused
CPUs/rx-queues in __netif_set_xps_queue. The change should only be
cosmetic.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 00f6b41e11d8..c8ce2dfcc97d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2784,13 +2784,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	/* removes tx-queue from unused CPUs/rx-queues */
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
-			active |= remove_xps_queue(dev_maps, tci, index);
-		if (!netif_attr_test_mask(j, mask, dev_maps->nr_ids) ||
-		    !netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
-			active |= remove_xps_queue(dev_maps, tci, index);
-		for (i = dev_maps->num_tc - tc, tci++; --i; tci++)
+		tci = j * dev_maps->num_tc;
+
+		for (i = 0; i < dev_maps->num_tc; i++, tci++) {
+			if (i == tc &&
+			    netif_attr_test_mask(j, mask, dev_maps->nr_ids) &&
+			    netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
+				continue;
+
 			active |= remove_xps_queue(dev_maps, tci, index);
+		}
 	}
 
 	/* free map if not active */
-- 
2.30.2

