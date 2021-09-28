Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645A41A80C
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhI1GBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 02:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239440AbhI1F7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2310461360;
        Tue, 28 Sep 2021 05:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808626;
        bh=42D796lJ3lX0gb34lIi7EqCTnnN659dJBHy0opAhq9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2+VEN+olz3jKRAA9EL81jxoqZEUMlolyneyFXNtWxRLul/95x/+0/yZiS54JfByc
         WkFLskh3BJl3EYAl0fHCzZchCBaZnx9abu0CBKcKLuy/oC6dtY9GYJyOmDhgw91Ozg
         ZAws6PwLtwCOHTEVCqZoO+Ncbc6NnSiZZDM+rPG7lEhZiVvpKK8gcUmuPKLmGtH8Cv
         PMmqvklXMCwQv6JWJ7kGEuvM21SKWLR8mAmgepWj/+eWHFjUQL4gOrCNMeKEYJXGEx
         rPNssq9Cop+cNJbOw2SLdwn9Xcwl+1fZh4Qu+eg2vPVRfwcEtWZ6Z1SYbX3nxgHy0s
         GH0AEH0AL0xBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        kuba@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/11] xen-netback: correct success/error reporting for the SKB-with-fraglist case
Date:   Tue, 28 Sep 2021 01:56:55 -0400
Message-Id: <20210928055704.172814-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055704.172814-1-sashal@kernel.org>
References: <20210928055704.172814-1-sashal@kernel.org>
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
index c213f2b81269..995566a2785f 100644
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

