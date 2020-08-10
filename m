Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75666240F8D
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgHJTMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbgHJTMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51042224D;
        Mon, 10 Aug 2020 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086765;
        bh=Xod+VzE1VPgUVP0IyRAqLiqOrCbqQE3tlugT8HfZHb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeBRXlG3XOiwwSN99vZ4n4FLoQQaAmhERZRnjioXtyPeb+xGqohWu79NFfqsvVY4Q
         0zmSxqZj+Rfvs6mbua7MhDxiHVTYRCMNeyTS5eK/vHXFBPt494bMr7Q875iQO/+Wps
         mKEip7sNbR6REeNWTx6wSntkCEUPbd6p9uigTtOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/45] ionic: update eid test for overflow
Date:   Mon, 10 Aug 2020 15:11:44 -0400
Message-Id: <20200810191153.3794446-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 3fbc9bb6ca32d12d4d32a7ae32abef67ac95f889 ]

Fix up our comparison to better handle a potential (but largely
unlikely) wrap around.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c00ec9a020973..e66002251596b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -666,7 +666,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	eid = le64_to_cpu(comp->event.eid);
 
 	/* Have we run out of new completions to process? */
-	if (eid <= lif->last_eid)
+	if ((s64)(eid - lif->last_eid) <= 0)
 		return false;
 
 	lif->last_eid = eid;
-- 
2.25.1

