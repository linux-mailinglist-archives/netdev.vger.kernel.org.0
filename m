Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53F9491557
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbiARC10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:27:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiARCZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1CBB610AB;
        Tue, 18 Jan 2022 02:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C66C36AEB;
        Tue, 18 Jan 2022 02:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472721;
        bh=KnyhTXWyAhQ6+TJyfkCxRN8k4+AZ9shB9T5IiZSCg30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVyZ+ITfaM1Bxng40gQmHAhb7ALZxTKy4X+TJQWC0RkL1LxPuIXSH2BqtVlqe2FAY
         rVQ9qQPRnb2QGQ3Mbv4e2Z66cweSO28mOVrNIR2QJcO3TP6Tw9n/VdDmvdvHjXwy3f
         uhrbVPflmgtam0WzAke5Sty4PZT4ano+WEXWA500YxI5Ha9srJ3dLjf+r0lvrtB7Te
         LON34ffoNDUfwF5pd6F8JPWTpxQkqK+bUYFDm1N8+THEx6D94pcpInTQfqdObwKvYa
         28p6o0koVaZS+XsDRCHlulZzuetwjRO/bVb0G7pEJdCIK+3MTEpstpEV/bVW9dRneO
         MbKBt0+hF9FAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, weiwan@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 112/217] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 17 Jan 2022 21:17:55 -0500
Message-Id: <20220118021940.1942199-112-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit d7dac083414eb5bb99a6d2ed53dc2c1b405224e5 ]

When updating Rx and Tx queue kobjects, the queue count should always be
updated to match the queue kobjects count. This was not done in the net
device unregistration path, fix it. Tracking all queue count updates
will allow in a following up patch to detect illegal updates.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9c01c642cf9ef..d7f9ee830d34c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1820,6 +1820,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
 	net_rx_queue_update_kobjects(dev, real_rx, 0);
 	netdev_queue_update_kobjects(dev, real_tx, 0);
+
+	dev->real_num_rx_queues = 0;
+	dev->real_num_tx_queues = 0;
 #ifdef CONFIG_SYSFS
 	kset_unregister(dev->queues_kset);
 #endif
-- 
2.34.1

