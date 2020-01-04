Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973E81302B3
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgADOdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 09:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgADOdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jan 2020 09:33:13 -0500
Received: from localhost.localdomain (unknown [194.230.155.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E778B2464E;
        Sat,  4 Jan 2020 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578148393;
        bh=MBPkeE/UObsJkilZtPqlkFSGUkCmbBS3UK95OTK2cdg=;
        h=From:To:Subject:Date:From;
        b=YttUBJNwR93t66VRxJtrWZCc5Jyhn2xVZowU1ScJ2ouEpX50G3mJ7fBAczPy1VTJt
         pV+GOFoLTglDX/FMDoCmd+g2UnYlcni6UduRU98D5AyyeKr2WDEPpA/UtkSCJnEYDF
         1h3zzaK7Eeg8N9tG1yxqMimCJQxvk51Zd99IiOYs=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: ethernet: 3c515: Fix cast from pointer to integer of different size
Date:   Sat,  4 Jan 2020 15:33:05 +0100
Message-Id: <20200104143306.21210-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer passed as integer should be cast to unsigned long to
avoid warning (compile testing on alpha architecture):

    drivers/net/ethernet/3com/3c515.c: In function ‘corkscrew_start_xmit’:
    drivers/net/ethernet/3com/3c515.c:1066:8: warning:
        cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Only compile tested
---
 drivers/net/ethernet/3com/3c515.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 1e233e2f0a5a..f5b4cacef07a 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -1063,7 +1063,7 @@ static netdev_tx_t corkscrew_start_xmit(struct sk_buff *skb,
 #ifdef VORTEX_BUS_MASTER
 	if (vp->bus_master) {
 		/* Set the bus-master controller to transfer the packet. */
-		outl((int) (skb->data), ioaddr + Wn7_MasterAddr);
+		outl((unsigned long)(skb->data), ioaddr + Wn7_MasterAddr);
 		outw((skb->len + 3) & ~3, ioaddr + Wn7_MasterLen);
 		vp->tx_skb = skb;
 		outw(StartDMADown, ioaddr + EL3_CMD);
-- 
2.17.1

