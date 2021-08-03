Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA7F3DF35D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhHCQ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbhHCQ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:56:08 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288ABC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c25so664479ejb.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZA/VmrYcR7bRHhdKZDac6LEdob5bPlkHZymtysuTxu4=;
        b=CNgyjNTUrhVGalib1Qhgb3p01mYOtN93cPZAKYkae2nGoxt/oVVe2FTelllIW5o3r6
         lbgwoo2kL57nbP3Pk+UTN2idDfX5VBDm3Yz2o5S1VBPWGxZACspqNikMe4sK6pDUvACk
         HEYigyI30MIdZWbHMxTtuLDUA2S6FWDgJSBpQYNntfOfvhcI11RRBT7wy5VAuNfK3si+
         BAlnzE60U35tYPtj19ZtkLGjhlfNR3VdJoZ5c5Yo81z95YFGFDOoB5wFofortnIr5pSL
         kjZ/u1+Cgu9f5Yk5bAupIgwVkQ1Ejvrqq+4jD7+yKbn5qoxkWG3ceANhGroQHnS7YQOj
         VYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZA/VmrYcR7bRHhdKZDac6LEdob5bPlkHZymtysuTxu4=;
        b=b32qJTfFDWNqXGTcdgF6MGo2R+bm1CiHtpsaN/P8qQgyK3LgGbFUMkd/zNSTVb47IY
         MVpEDn6Rj//nfdS8eZwJ9wCBYxnGxSTPmct4HasfyzwnpJllJF+aCqaeyvwLnziiqBkR
         /0CEVKkEloCrlOJj1YpNr8wSonTHrc1e1J58e99RoiQ4GK9xI5na1t0wr7uJndGtTNTY
         SHHnqF6Hs7mWol1asZlI573J7j/zdtY1uE5McSg/vqOJxcsrTcAXRiqfkXnIB2Vx5fNR
         qbqrK0Gt0b4nD/QMot+HrT5MehTQoK66pooX635Iz4llzGWP2gQ61DhMwUqBWvhAGuOh
         qB/w==
X-Gm-Message-State: AOAM530+uELVRC9MVSSPkm85pZyBaT3SaFDEox5knbE66+Ski4SIl0wn
        LAFaCpp9ZIZ4qUQr/6MDviKmM/73Z4UMVQ==
X-Google-Smtp-Source: ABdhPJwhNC9BL61XE/65WIuJ+t0V2ED5vUYCTgLPNjUhvI9JZk9obFp3fo6BIsVBKjfHZ2ntZxy26w==
X-Received: by 2002:a17:906:e21a:: with SMTP id gf26mr21337483ejb.313.1628009753698;
        Tue, 03 Aug 2021 09:55:53 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:53 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/8] dpaa2-switch: request all interrupts sources on the DPSW
Date:   Tue,  3 Aug 2021 19:57:38 +0300
Message-Id: <20210803165745.138175-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Request all interrupt sources to be read and then cleared on the DPSW
object. In the next patches we'll also add support for treating other
interrupts.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 71129724d9ca..42d31a4a7da6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1433,20 +1433,13 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 {
 	struct device *dev = (struct device *)arg;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
-
-	/* Mask the events and the if_id reserved bits to be cleared on read */
-	u32 status = DPSW_IRQ_EVENT_LINK_CHANGED | 0xFFFF0000;
+	u32 status = ~0;
 	int err;
 
 	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				  DPSW_IRQ_INDEX_IF, &status);
 	if (err) {
 		dev_err(dev, "Can't get irq status (err %d)\n", err);
-
-		err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
-					    DPSW_IRQ_INDEX_IF, 0xFFFFFFFF);
-		if (err)
-			dev_err(dev, "Can't clear irq status (err %d)\n", err);
 		goto out;
 	}
 
@@ -1454,6 +1447,11 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 		dpaa2_switch_links_state_update(ethsw);
 
 out:
+	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    DPSW_IRQ_INDEX_IF, status);
+	if (err)
+		dev_err(dev, "Can't clear irq status (err %d)\n", err);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.31.1

