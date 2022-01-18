Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5151491BAE
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbiARDIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347824AbiARC5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:57:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F65C061361;
        Mon, 17 Jan 2022 18:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF51F612F3;
        Tue, 18 Jan 2022 02:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A245C36AE3;
        Tue, 18 Jan 2022 02:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473939;
        bh=9aYQODP5szAojPD5WJTQP+8gls/HiWPful1vla/RVVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIR3TzSWmWfMVsSlYF44fOfNNWUyRN8HlQAoQq4xIuYMFkERSjtrgBeOqfFlNCQKH
         iNAxy4ZjKBoV3Eh+K6UJDJECohaXL6PqGNy2UyaONjIV76vRxPQCiU7LdM/htNg3a2
         xcd5qxYFf0ULz4a3Wqco1EBt5AGMW7vuE0TSSs7GEK+ttbSE04JdQf6fax+mSrZRNR
         XKQGjFX5Tmcsz99dcvPeFBepzssZygBQMY4e4yrAb4fXDilt2JVMs0IvMndCxcmLFR
         hBPckrk3PBzFH+/Mq8zCq5ScVetlNKlTHXtw818eRV0fA+NuQQwC3fSp32g4wdyj5j
         fHRpATyVk/DTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, weiwan@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 30/73] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 17 Jan 2022 21:43:49 -0500
Message-Id: <20220118024432.1952028-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 05b0c60bfba2b..bcad7028bbf45 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1661,6 +1661,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
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

