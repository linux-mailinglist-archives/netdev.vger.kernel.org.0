Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68341A86C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhI1GEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238841AbhI1GCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06348613BD;
        Tue, 28 Sep 2021 05:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808662;
        bh=7/jeTgXBCZ19Re/PHtFD00k6FbJyqk+hhvotdk4Nf/0=;
        h=From:To:Cc:Subject:Date:From;
        b=SFJq/caJsa5hrdWd5cmAp19He1QCeoCqCaZoSgSNjhPuDlT+muqkxUu0XCS7HigHl
         1oqmOfDbdBvCpHS/6px5q1hCKW4RKcBd0w+DN6y6jEJjUOE2uoIMsmavbbcMswpbUI
         nq0Orl9MyrexdF3+uT5P5+1SWUu5X0sYANcHZYBamoWAV/gGNnbFBJuDxr7NbcJKwI
         81SHp5gid5yK9NMX5VixotfPO7p1S7jI49b2f12HAxaGBYVLNvtZvT1TQOMwcHXrKX
         KRKNzvxVoyh8WZTKH86TWp8bHsYTLlecS56wOTzKeuqrnnQghu84HIMtZYDRMUD262
         3+RmFlh8VRgzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/5] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:57:37 -0400
Message-Id: <20210928055741.173265-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index c8c6afc0ab51..15c73ebe5efc 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -994,7 +994,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
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

