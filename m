Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6598D4743CA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhLNNpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhLNNpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:45:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59809C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 05:45:38 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26GwEMF7AGneK4l0UHeYTB845ctWzrnTU2d7an7yp9o=;
        b=bYrFwUt0cosW/ISGRM0QzXWaPDUcnQEMHgJgR0JYUGMdvKZLMfv0jyINxikqsdcYwcFnkE
        pcRUBRidvOhSpTevCN2cSECFsll+rPHBYuZe/rbmEEViJ3Wcp9LYIi908nk413OJz403X8
        /SngImZsCKXyfv0JPjAfmTQ6O5nu1yFcO3c82jhbfHZguTY2ZqwREW5hCmgM+Pu6BcnHBR
        ZQXkfT7HqKF7aRHEgwGSHiWITvC2DONjRaiKdgezx30EB/fH7h1eFnECtxMup+oQdMhu2c
        hY6i9S2aui1WAgrhTB6q2t9OMhebxjEuEmNvxMmev4690OnovJVvG07bMfN19A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26GwEMF7AGneK4l0UHeYTB845ctWzrnTU2d7an7yp9o=;
        b=zNHyntp44BbWYLC4cdzF9NKQ6MGYu1dEIj6qBJfrngGqGrWg/aFAeMKQLrbogHDaj+E7n+
        iiTxiS5PgY8BExAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2 2/4] net: dsa: hellcreek: Add STP forwarding rule
Date:   Tue, 14 Dec 2021 14:45:06 +0100
Message-Id: <20211214134508.57806-3-kurt@linutronix.de>
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
References: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat STP as management traffic. STP traffic is designated for the CPU port
only. In addition, STP traffic has to pass blocked ports.

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index c4f840b20adf..17d3a4a3582e 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1075,6 +1075,17 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
 	};
+	static struct hellcreek_fdb_entry stp = {
+		/* MAC: 01-80-C2-00-00-00 */
+		.mac	      = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 },
+		.portmask     = 0x03,	/* Management ports */
+		.age	      = 0,
+		.is_obt	      = 0,
+		.pass_blocked = 1,
+		.is_static    = 1,
+		.reprio_tc    = 6,
+		.reprio_en    = 1,
+	};
 	int ret;
 
 	mutex_lock(&hellcreek->reg_lock);
@@ -1082,6 +1093,9 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	if (ret)
 		goto out;
 	ret = __hellcreek_fdb_add(hellcreek, &p2p);
+	if (ret)
+		goto out;
+	ret = __hellcreek_fdb_add(hellcreek, &stp);
 out:
 	mutex_unlock(&hellcreek->reg_lock);
 
-- 
2.30.2

