Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0934A333C2F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhCJMFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhCJMEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:53 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17F9C061761
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id dx17so38200400ejb.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xA/ml8LK32aqYsuvbZVIyJ1xT0WmGfjBmjXYMFysg7Q=;
        b=nWNuqvMdNHXaNetrEAIl+oYi/B02EZmkHM+ngWtYvlcnx7Qw3dstdV5ED8IFmPUZpg
         mpPe8UypTu3u0DT2Icy9i4jvjN8qt/NqrSBjrzOHDyKKQ4JJ+40I1OFZ4d7YOo8XQQlX
         43WKjL68cgCifWUSYtylum3iBdPjUZyzXEdVk0jtuuutTXkUyKATWo2DN117Kv+etDif
         IwLIoA13huo0Dm5cPRwij24LLucJj2fxkWOfDhy4lEKkTqV/iZAMBq95CsQOFH5v5t3l
         3FTqeGwfnUM3BIc8KgC9/qBVbemRhbFI/DFLqlEs+2jSY0hYniFNdsgez+6uU7bsPXsX
         nFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xA/ml8LK32aqYsuvbZVIyJ1xT0WmGfjBmjXYMFysg7Q=;
        b=T788bxrTURSnBDjK9cN5HJJFH7xfOUGTUZXt/NjpHtGDe810n5UCildnPkFUB94Y0/
         h55hmMnHiLVfcZ1g0BxecDtF+asHcBjmBuS5tQG9aJPyIk+13W4Z9BcxTSHwjYJEk6oj
         5CTB2jlFkCe+L7CWAVBqY5PM81IgIBFJLWd9aBPg1R35W9DiQj7LTC8dMyJDsx4uMuRO
         60Uyss8CPD80tgA8/epX2YaY/Eze76hCXQ84RtI6A3ybJ66WbOgKMWB2zTX4lkvFCVdO
         Se0aLxd9h1VqD2SLoOoiQz4vUGthZp0Jf9vmjMmxqGrmynUBINRjBXcGS8NduEpks3l2
         VkCQ==
X-Gm-Message-State: AOAM530q/joLsYKATctza4+tNmb6afOjmaBvsOemjXKB49iVywZn1dch
        CUy1U9znwI7j7ag87xVIOrU=
X-Google-Smtp-Source: ABdhPJzjAYLMWKPVVne4JDVZKQHfVpWvuKfJnnmnkiO3q5N49NHC6SJdb5DxZuMdxE66/pGLu1CYtg==
X-Received: by 2002:a17:906:1754:: with SMTP id d20mr3210823eje.221.1615377891407;
        Wed, 10 Mar 2021 04:04:51 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 12/12] net: enetc: make enetc_refill_rx_ring update the consumer index
Date:   Wed, 10 Mar 2021 14:03:51 +0200
Message-Id: <20210310120351.542292-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit fd5736bf9f23 ("enetc: Workaround for MDIO register access
issue"), enetc_refill_rx_ring no longer updates the RX BD ring's
consumer index, that is left to be done by the caller. This has led to
bugs such as the ones found in 96a5223b918c ("net: enetc: remove bogus
write to SIRXIDR from enetc_setup_rxbdr") and 3a5d12c9be6f ("net: enetc:
keep RX ring consumer index in sync with hardware"), so it is desirable
that we move back the update of the consumer index into enetc_refill_rx_ring.

The trouble with that is the different MDIO locking context for the two
callers of enetc_refill_rx_ring:

- enetc_clean_rx_ring runs under enetc_lock_mdio()
- enetc_setup_rxbdr runs outside enetc_lock_mdio()

Simplify the callers of enetc_refill_rx_ring by making enetc_setup_rxbdr
explicitly take enetc_lock_mdio() around the call. It will be the only
place in need of ensuring the hot accessors can be used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c8b0b03f5ee7..e85dfccb9ed1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -439,6 +439,9 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 	if (likely(j)) {
 		rx_ring->next_to_alloc = i; /* keep track from page reuse */
 		rx_ring->next_to_use = i;
+
+		/* update ENETC's consumer index */
+		enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
 	}
 
 	return j;
@@ -624,13 +627,9 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		u32 bd_status;
 		u16 size;
 
-		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
-			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
-
-			/* update ENETC's consumer index */
-			enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
-			cleaned_cnt -= count;
-		}
+		if (cleaned_cnt >= ENETC_RXBD_BUNDLE)
+			cleaned_cnt -= enetc_refill_rx_ring(rx_ring,
+							    cleaned_cnt);
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
@@ -1122,9 +1121,9 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	rx_ring->rcir = hw->reg + ENETC_BDR(RX, idx, ENETC_RBCIR);
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
+	enetc_lock_mdio();
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
-	/* update ENETC's consumer index */
-	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, rx_ring->next_to_use);
+	enetc_unlock_mdio();
 
 	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
-- 
2.25.1

