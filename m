Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EA041A7E4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhI1F7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239305AbhI1F6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D7661361;
        Tue, 28 Sep 2021 05:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808608;
        bh=aXvnqcLO8Ou+S5mb1OFq4rMhDipi4tUId/TV8UmR9yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsNv/pA8GFyTZIWBUET7BM7qqwasXrq5k5G9x5Ql3j+dU69C0NoChAFdcoT/pqPFv
         ik8KCqGPpUVEOnsZhzuhw0Aq5TTEyadEKqlAHZJVhuTv1pB3JtTmwVoLn3QVugi+4/
         8SJCdhIdrnGBGSn5gtujSwSLZhk3FQNAhX2LzUK5OkNCHNvKjYhOC6aVE2OeXv3TsK
         GqZplc26ZunwBVcM1FLCq9RbhLJ7Ihpqq6bXuHiKxdzYR43/GO/doQXn453crXorz2
         PvIKYOftco2TuKzNC6ipoiYXU96yXZ/mKqOavJ1zlb4Ilm1XQywJP0vRkGxcKh4Yjn
         EQy0vfT4Lb/Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/23] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:56:29 -0400
Message-Id: <20210928055645.172544-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
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
index 986b56970961..b0cbc7fead74 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -499,7 +499,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
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

