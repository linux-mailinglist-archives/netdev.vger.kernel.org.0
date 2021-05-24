Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8013938EA3D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhEXOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbhEXOvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72F8613EA;
        Mon, 24 May 2021 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867679;
        bh=7QYHg/G0vqSBhvu7nR1ZgYEMhMPQcwZuTaOunGLXAVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocyRVZ0rUn04jDWwoqkFXF+xGfUrVqj9w/qG4e0LDMTawO15YnIaDcBcEGXMmtnvS
         pqKvjVD1yLjzE8j93JJSqjxE8PykFxTZvo8MA5suzKbLfYTnDHsrPnrPrgQhQv+shj
         P1aOZ+VwF5xTWAJj66vXa//ckG6nX0FuZ8wmYlFw0sCyHwUqECaJ1be4oHNZqHBA7y
         OOIkLs9pLh/fbXFP9K+xVP3eDbjhw6cLWycU90utsuMMAZ4QoEjDiA1QVrB25hzpuz
         /Hlmuq60bMTRcF+cR9e1RqjNIuh/QXsCtVOuvqs6DpUdR3YpSdU13/unKkNdo1a2HL
         Ej9ILYI4GFM2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/62] Revert "net: caif: replace BUG_ON with recovery code"
Date:   Mon, 24 May 2021 10:46:53 -0400
Message-Id: <20210524144744.2497894-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4df07045fcfd684379a394d0f2aa0cc4067bda2a ]

This reverts commit c5dea815834c7d2e9fc633785455bc428b7a1956.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original change here was pointless as dev can never be NULL in this
function so the claim in the changelog that this "fixes" anything is
incorrect (also the developer forgot about panic_on_warn).  A follow-up
change will resolve this issue properly.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-19-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index bcc14c5875bf..4cc0d91d9c87 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -270,9 +270,7 @@ static netdev_tx_t caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-	if (WARN_ON(!dev))
-		return -EINVAL;
-
+	BUG_ON(dev == NULL);
 	ser = netdev_priv(dev);
 
 	/* Send flow off once, on high water mark */
-- 
2.30.2

