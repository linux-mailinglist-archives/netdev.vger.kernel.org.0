Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA015577D0
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfF0Ahe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbfF0Ahd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:33 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D504121851;
        Thu, 27 Jun 2019 00:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595852;
        bh=8uBScBdl8XMNzEQIBDNipy741zQgpj506xIZOhko9jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1yPJQw37KdKMESDctDHIkRLKm7+IVafPZ8DvpATn7ETAJ2kAFZGCu9/GxMv5AZ+m
         kY5m5uKUoaPaTqLWk99HSD4mygVewxO8KIag8aaKW6DM61sUCRcj3UYJumoSEm910O
         a3JMppm3167ipIyqhdKzfrpzEn/Ef6YWFblQ6OOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/60] can: af_can: Fix error path of can_init()
Date:   Wed, 26 Jun 2019 20:35:39 -0400
Message-Id: <20190627003616.20767-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit c5a3aed1cd3152429348ee1fe5cdcca65fe901ce ]

This patch add error path for can_init() to avoid possible crash if some
error occurs.

Fixes: 0d66548a10cb ("[CAN]: Add PF_CAN core module")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 1684ba5b51eb..80d0ec599439 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -958,6 +958,8 @@ static struct pernet_operations can_pernet_ops __read_mostly = {
 
 static __init int can_init(void)
 {
+	int err;
+
 	/* check for correct padding to be able to use the structs similarly */
 	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
 		     offsetof(struct canfd_frame, len) ||
@@ -971,15 +973,31 @@ static __init int can_init(void)
 	if (!rcv_cache)
 		return -ENOMEM;
 
-	register_pernet_subsys(&can_pernet_ops);
+	err = register_pernet_subsys(&can_pernet_ops);
+	if (err)
+		goto out_pernet;
 
 	/* protocol register */
-	sock_register(&can_family_ops);
-	register_netdevice_notifier(&can_netdev_notifier);
+	err = sock_register(&can_family_ops);
+	if (err)
+		goto out_sock;
+	err = register_netdevice_notifier(&can_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
 
 	return 0;
+
+out_notifier:
+	sock_unregister(PF_CAN);
+out_sock:
+	unregister_pernet_subsys(&can_pernet_ops);
+out_pernet:
+	kmem_cache_destroy(rcv_cache);
+
+	return err;
 }
 
 static __exit void can_exit(void)
-- 
2.20.1

