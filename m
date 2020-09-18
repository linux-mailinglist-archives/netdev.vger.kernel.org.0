Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069F226F0EF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgIRCrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgIRCJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 792892395C;
        Fri, 18 Sep 2020 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394979;
        bh=lQcexyaZjXVoeH73AvKNhcfC2KEiQeqKqtVo1iyGMso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH/WIS7SM34UKClyiA23KA3J5ftMBEyZFTlAqWWEc75GnD5c3zYH/aXLfUIiWa2cr
         4fNRnH8brTv01Zn9MdniDMZStblswAehMHFgvTlEaG3qA6beaxJqPOGPN9258pLdmG
         Fx3hsvkLSgwhEk2ibDa3NVATE6MJIj93o/Dh8wN8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 079/206] mt76: clear skb pointers from rx aggregation reorder buffer during cleanup
Date:   Thu, 17 Sep 2020 22:05:55 -0400
Message-Id: <20200918020802.2065198-79-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9379df2fd9234e3b67a23101c2370c99f6af6d77 ]

During the cleanup of the aggregation session, a rx handler (or release timer)
on another CPU might still hold a pointer to the reorder buffer and could
attempt to release some packets.
Clearing pointers during cleanup avoids a theoretical use-after-free bug here.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index d44d57e6eb27a..97df6b3a472b1 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -278,6 +278,7 @@ static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
 		if (!skb)
 			continue;
 
+		tid->reorder_buf[i] = NULL;
 		tid->nframes--;
 		dev_kfree_skb(skb);
 	}
-- 
2.25.1

