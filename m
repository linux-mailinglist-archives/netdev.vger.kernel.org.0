Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704FB41A87F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhI1GFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239648AbhI1GA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75145613A8;
        Tue, 28 Sep 2021 05:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808648;
        bh=Y4XjyZvXYrLEKqhTcaGzcA+k3/KH2wAv3Jyuw9cGryI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EianYCz/trToiQ0TXG2H1NnHFQZTY1kgJilWnwCT3Z4LFArFBpurBeWfylHHn6rPa
         pGvhqI+2F3gcEn7sV0ShN2bhRdDDM8MgVS5jtM3rl2CZ0J3sS2atKm4kCoe7SXOVQi
         6rBESfxDeUxwYzFfqyDZhTiqaBgYonjgoIZom4CeNdBY31c6hjAoAoGglOjsbB6IEk
         3xYLt9xaUEPU1V69+IQxsv+3cr0dN78lQmn+OpK5Gnr28Fx5G5bNIMMKr6YRWwUwk9
         1ausbTrBXiCbGO4cuGDQGsXkanvhD2jEQxzQO8qMtMcFmnCnkWIAuYkA2GoMF6VZEc
         Z2EFGwUtJA76A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/8] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:57:20 -0400
Message-Id: <20210928055727.173078-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055727.173078-1-sashal@kernel.org>
References: <20210928055727.173078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 3ede7f84c7c21f93c5eac611d60eba3f2c765e0f ]

When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
special considerations for the head of the SKB no longer apply. Don't
mistakenly report ERROR to the frontend for the first entry in the list,
even if - from all I can tell - this shouldn't matter much as the overall
transmit will need to be considered failed anyway.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index ad555a9a3eca..e1d6dbb4b770 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -492,7 +492,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
-- 
2.33.0

