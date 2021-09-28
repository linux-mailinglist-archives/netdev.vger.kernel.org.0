Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF941A83F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbhI1GCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239163AbhI1GAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 02:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 560526138D;
        Tue, 28 Sep 2021 05:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808637;
        bh=9jFq3Ks7GD1NwvIEYZLWUZSvKCUXcz3duDRTepIsCuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gi9rnGArhb9P7ssHmbG2DftbHnA4RZLG90lbdmxq14mABntN1E4f212OhBq8YlKyO
         r+wGxsrWu2WSE0lgttjOvnlWzWvIChc1Ft6kYznuoZNMWft/0FPkFt56JXKxOAUfuj
         Z1CF/ygDvJ0HTYYULDz0Sv7wH4HJBWY0yaAxlkIA+6I987kH16LTr8PVB09NJVr4Xd
         Bo3Mevu03lPb5RAT67832/1KHdyFW4n+UIZSCSNLe+AOZsRxCD6FQZIxBfu45O0wPn
         keM3asrGvdZpNsR9SowFfJpV7PpRCP9UuZhFB9d9p2GItZaOQNo/BjfA4nb3aUJDJX
         xPlMmPz/w/brQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/10] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:57:08 -0400
Message-Id: <20210928055716.172951-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055716.172951-1-sashal@kernel.org>
References: <20210928055716.172951-1-sashal@kernel.org>
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
index 41bdfb684d46..4d0d5501ca56 100644
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

