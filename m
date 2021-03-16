Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2767C33D614
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhCPOsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbhCPOr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:47:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF86AC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:56 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ci14so72448721ejc.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LhJuhikxc24QKZZG9OF8S1Z4/usCbY8j/7Kimi/+4oo=;
        b=KcRzqwL2OX7lDSQr5eThQ57aUGBLut2Enj4WjsqgCLW2UgxqN4Fhi75GkNDMXwwnJ9
         xMjUYA4y2hzyUUZuupBX4Szn2KyUjbID6eZGRh3hyO7jCHrXDCmGux2j140neB9oCJkY
         7HDYE9e6pFH2PBSsz1UXCDqhnyx8HLXN+8fKhsoe86Xm5YIphn1F49XV7twNwdzwHbZa
         xshOa5Tgiw6xD74ZWNtmhergp+qO69OmaK9ArVgfWC5mg56NtaWewR0K7PQLexQPEoLo
         17Hth2v0jPMAp0myToKwKnfEihrstpqPYKJfgcChl7hLHqUONanuK/MobL/gsvfQzQsd
         9ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhJuhikxc24QKZZG9OF8S1Z4/usCbY8j/7Kimi/+4oo=;
        b=dBC1nLiTgk9ZdktXrY4yFy2HL9xRBqdrwm0XUJPs1gkz9019/mvikLIWt4qPnNz6Nk
         KYJkAfPojXDhLhyElePlWVTUsjKYfi5bGXkMlCqxp/Vei6B+8o4QuJpvRu38rDkYkDol
         /aU378OgpZgDSjLPMbm3VKvm9ySwAkFgs2Lmgq4/QHYsMi18bgrDKwTV4wmB/ifk/SwA
         SIP5ElSNL5hFjXbccW6rXwJSnnyu0Fak36z5slCwuspNYGgcLgCVpM81C3Gh8BxVLtAv
         B31Onjw3mrmhi59r+nBWpiKDBYAHQgVsYgSit09XmNJihPDEkOq4PVT3iE/PbTYJZviP
         KnTw==
X-Gm-Message-State: AOAM531vc0EyTS/CnG5rCDnFeYW9rOvWPTWxbiC+NAPXg52X4OsC2S4i
        uPByYeLlO9PdlYB0ZtSAmyQ=
X-Google-Smtp-Source: ABdhPJyStqhE+nG+XpJAYMa5glYuhUrNR13iLudXky9ZoIXvfqTbrwXY0fSDC3q6Ujc3fkyw/NMRSQ==
X-Received: by 2002:a17:907:1614:: with SMTP id hb20mr14970291ejc.77.1615906075557;
        Tue, 16 Mar 2021 07:47:55 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id de17sm9467441ejc.16.2021.03.16.07.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:47:55 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-eth: use indirect calls wrapper for FD enqueue
Date:   Tue, 16 Mar 2021 16:47:28 +0200
Message-Id: <20210316144730.2150767-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316144730.2150767-1-ciorneiioana@gmail.com>
References: <20210316144730.2150767-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

We can avoid an indirect call per Tx packet by wrapping the enqueue of
the frame descriptor with the appropriate helper.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 492943bb9c48..7702b921ab0b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -266,8 +266,11 @@ static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
 	num_fds = xdp_fds->num;
 	max_retries = num_fds * DPAA2_ETH_ENQUEUE_RETRIES;
 	while (total_enqueued < num_fds && retries < max_retries) {
-		err = priv->enqueue(priv, fq, &fds[total_enqueued],
-				    0, num_fds - total_enqueued, &enqueued);
+		err = INDIRECT_CALL_2(priv->enqueue,
+				      dpaa2_eth_enqueue_fq_multiple,
+				      dpaa2_eth_enqueue_qd,
+				      priv, fq, &fds[total_enqueued],
+				      0, num_fds - total_enqueued, &enqueued);
 		if (err == -EBUSY) {
 			percpu_extras->tx_portal_busy += ++retries;
 			continue;
@@ -1153,7 +1156,10 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	 * the Tx confirmation callback for this frame
 	 */
 	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, prio, 1, NULL);
+		err = INDIRECT_CALL_2(priv->enqueue,
+				      dpaa2_eth_enqueue_fq_multiple,
+				      dpaa2_eth_enqueue_qd,
+				      priv, fq, &fd, prio, 1, NULL);
 		if (err != -EBUSY)
 			break;
 	}
-- 
2.30.0

