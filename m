Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47BF491736
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345237AbiARCic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:38:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344396AbiARCg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:36:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5800061157;
        Tue, 18 Jan 2022 02:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF0CC36AE3;
        Tue, 18 Jan 2022 02:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473386;
        bh=Uxs0Gx+3NmFC6BXoIOxZxNJaR0wXchGDKw1i4wsCkHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6Vzg6+QHf1/c8AbXAHattnbPHcHLen6z7iux9GoS7cqRMbyM+IiNbPAv0Lph7A61
         8gDShRiyhwejCfAxnmgHeW2AnOL5VWHclSLOlQNywELBgb4vkGL44HAgn7eWRib+ie
         lB/QCCFYE6HuhRZWOxwidcHMZ6cctjMw7NPAuWBswNFDgoB0/QUnD+d6J0wc+EuKZw
         JNDHkPgMB3QmAArAYpvGp7RWTZIEq5f1VcCEI0JBUcCeoH4c9aXfK+poemTQ4uRlZc
         hU/CuCnX4V1w0tmSx9g5/h3mbYb1Cfj7ZkOh1iGPEMieNqVq9C4LVx3EFPhpBNWgPm
         h0BnsEuHGfFLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, weiwan@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 096/188] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 17 Jan 2022 21:30:20 -0500
Message-Id: <20220118023152.1948105-96-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index dfa5ecff7f738..a4ae652633844 100644
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

