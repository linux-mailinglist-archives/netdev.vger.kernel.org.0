Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC230491BC7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbiARDJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346606AbiARDCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:02:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A98C028B82;
        Mon, 17 Jan 2022 18:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C494F6130C;
        Tue, 18 Jan 2022 02:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E675C36AE3;
        Tue, 18 Jan 2022 02:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474070;
        bh=A9QrOZZOs90LBJJ2cTE2RJkFHsE+7U4j+ayQc02i0ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdi0Q1Pp59G5EdrtNrnwflp3DtMhX9PGydGRfevpCepi+AdToecpFZq2b9zCWHQxQ
         ELSFAxr8XwbA2QlCN4jw381qbf2LQ8NTpAPJXHGL7McN1qT3N6SU+hKeJvwNsetd2N
         hUsWY0pgS+mCytNeHG5aiwM2qP1XkevZNtbJrCfLVNa7lXKCe4IJ2Q4RUpJJKGshWo
         3dzXBMn0Y1BgtGaVCVRKO/xF4e6UZb9r+WgXeTLTEESNNY/nyIwipIzdRAlpP3AMlZ
         ILj4wJ8RMqU1T506OVi2f+PLp6w0oLVSPfWMQELW53Huc496VWXKmqIYaVyzjaqKbl
         W03/snXuk5GOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, alexanderduyck@fb.com, weiwan@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/59] net-sysfs: update the queue counts in the unregistration path
Date:   Mon, 17 Jan 2022 21:46:23 -0500
Message-Id: <20220118024701.1952911-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index fe0d255d66c8b..e5dc04cb55992 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1616,6 +1616,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
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

