Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794C4919B5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345415AbiARCzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33146 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347696AbiARCmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18651612DE;
        Tue, 18 Jan 2022 02:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8660EC36AEF;
        Tue, 18 Jan 2022 02:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473756;
        bh=+lpXt2QvzgIYVVxYWVN0oM5QZUSO2Opgpdlmv+PCAI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmEdpPnpr0TjDVqTzZaFhshBmx7Y9FPFh16qfB5NX46flDgQPIB7xZwzO1ucxgNKC
         AE2t1ScPaS9A613/EICE6zozw0GC8b0SXd6oI5FVoTDTgKqCByrT/A8HjP47+A39h1
         O9pM+dA7n+8l5sZbTEnH6xR+qly/ISYKjKJtXhjiXrxCgN1oG5EqJyFk+wFXQTRSYH
         Ma7k7W8Nbb5NWT4pX7Df0xqclilM6IR0E613AqYaRhRq877F1tfZpeC1W9jF9joNnF
         XfCuUq2S4zGPrwY8duiqhKGYyqUrODZXSEnagbttfKa/ACBe74w1SRDYEC594neNBA
         vQzE3qkxTruHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, weiwan@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 055/116] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 17 Jan 2022 21:39:06 -0500
Message-Id: <20220118024007.1950576-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index af59123601055..99303897b7bb7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1804,6 +1804,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
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

