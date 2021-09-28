Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8DB41A85C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 08:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbhI1GEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239861AbhI1GCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7E8613CD;
        Tue, 28 Sep 2021 05:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808655;
        bh=2LruOHFY9TUIe84RMFTD1y3uv7jB33twD9v32n68Fu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrtuqrkKgT/8t4bDjMX6aa5aFU9XifZlLakbbu/mh8vkQWG0S629duKIwqFlT4plt
         00BU6GYVmZWjUxiKTEYbawg+IQ1IEEy73F3EtRkCJsvcY4R6Nhzel1m4FIhESMohwc
         DUPGms7Mgl4QoCw3zcZHLYxBGVaya2k3Pzh7wqc6Sw6WJ6BI9CTRq6+Tse3a6/Fwmf
         0XY0WgsDgL7vcXvrmb2JW/MxeBLb/Km0EisE1a2MMOHi2xG4eti0UNAlGS47DdQH3z
         PPuU9dg+wdKBoL603JHrcCtydhw9BfxEwEKsVqw1GDmFNI082HlkpS/BsSlHmWg0vM
         bEs46EIWX6qNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/6] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:57:30 -0400
Message-Id: <20210928055734.173182-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055734.173182-1-sashal@kernel.org>
References: <20210928055734.173182-1-sashal@kernel.org>
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
index f7fd8b5a6a8c..3016869b4afd 100644
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

