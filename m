Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3C13F433
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgAPRJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:09:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389743AbgAPRJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEE024690;
        Thu, 16 Jan 2020 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194587;
        bh=ndoE0vtiw44UxpP7RJFkZ4ATAyIcKw/7d2h5EyFh7Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAfpHZJLL2VfkjU9Xyia7L+Haqvg5YNd9YeuQXEUoVVQcziT9MDnCHwpF7lCS62Ec
         lVmzQ3lupJyRPIS+yK6HeMNLVkCwL8a9x5nZLXQy1QcpFnofd1DiW+4uAi1Y0G0KXJ
         d93jfZmspjqS8ZzwoTHPnzKASyH1y1JXcR3u+NxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 459/671] net/tls: fix socket wmem accounting on fallback with netem
Date:   Thu, 16 Jan 2020 12:01:37 -0500
Message-Id: <20200116170509.12787-196-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 5c4b4608fe100838c62591877101128467e56c00 ]

netem runs skb_orphan_partial() which "disconnects" the skb
from normal TCP write memory accounting.  We should not adjust
sk->sk_wmem_alloc on the fallback path for such skbs.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device_fallback.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 426dd97725e4..6cf832891b53 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -208,6 +208,10 @@ static void complete_skb(struct sk_buff *nskb, struct sk_buff *skb, int headln)
 
 	update_chksum(nskb, headln);
 
+	/* sock_efree means skb must gone through skb_orphan_partial() */
+	if (nskb->destructor == sock_efree)
+		return;
+
 	delta = nskb->truesize - skb->truesize;
 	if (likely(delta < 0))
 		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));
-- 
2.20.1

