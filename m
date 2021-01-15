Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E062F868B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbhAOUU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 15:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388588AbhAOUUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 15:20:52 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8AEC0613D3;
        Fri, 15 Jan 2021 12:20:12 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id d81so5430378iof.3;
        Fri, 15 Jan 2021 12:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3XzHspCX9O1x943fOc9JVbEHt7+srRIHgKjIIe0gcTw=;
        b=NgWS5kVabAPxdHhBiKkubPCMxZN3NZ2xmbF8XalcBWU3OrQ3/tV+zpDt/IDcz+5IkC
         U3+38yv5icRvZyOmDELIfUuDz2bazw0ZDq+9azXPkIlqimmDJ+H7dLk1zGUcuZbzXw7J
         7/95a4q72b7v/RTX2DePIsNQIaentHQ63Vey+hFENcrAIMRia9po4SjMbhemuvPSPOJv
         CxemdbgEYCzsYDesOub6heMvvjV3px1PPvTCbyYATyauWYmJqjOCdu8YRwROtwKtrJNL
         8k41j0IB2qf8fy1A9fyrs/RWrWql4NwyH5z++D5WY0hFQ+cR2fydYUxMVl/rU09uZOB7
         p/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3XzHspCX9O1x943fOc9JVbEHt7+srRIHgKjIIe0gcTw=;
        b=Kid3kpYDTx3X69+CKIo+YJrDwH3JzquXxCYhgzVrwsMzsFf4ZJpRXM3mRoU794YyQN
         oEXxFLZMIdVICVLzd2ICYXXV5GcU4Yu9/oQKgHbVOFWcdQB4YPaIr8bI5rV9Sy6dD4U0
         h9uOe4lYRwgi23BxWRjrh1G99S5KzZ/BCJoE9k6VESVuBD2uWZbEHNoZIdV+mDOhcXbM
         8gnhs+PKT/Q9RR641ksu3Qw4DZbjEtpI1+Rf30VonbKIx9NZd7jbFdHdzU4vWczbqjWr
         A5tbWju8c25W2jMyN180fMlxRKRmLTov7zax4pObaNhzCL2hKW3MPHJBhvrOAnAzN3G5
         dLHw==
X-Gm-Message-State: AOAM530JvDvNi+QkjMK9eqKAT+onVGDnOdUHPjrtEvimdtK3JNrpTeAm
        dEaWCJ5WW3eGODsxz12HVBOWEwvLAk3LuPC7
X-Google-Smtp-Source: ABdhPJwKEbWqA8LJEeHIYAOPbhOtSAIGSkE20xlarQKNl+/RedBLvYsuTNRj6JxcFkzNL6Pch4Hy6w==
X-Received: by 2002:a6b:6f09:: with SMTP id k9mr9923958ioc.30.1610742011324;
        Fri, 15 Jan 2021 12:20:11 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:475c:c79e:a431:bccb])
        by smtp.gmail.com with ESMTPSA id e28sm4194900iov.38.2021.01.15.12.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:20:10 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/4] net: ethernet: ravb: Enable optional refclk
Date:   Fri, 15 Jan 2021 14:19:51 -0600
Message-Id: <20210115201953.443710-4-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115201953.443710-1-aford173@gmail.com>
References: <20210115201953.443710-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For devices that use a programmable clock for the avb reference clock,
the driver may need to enable them.  Add code to find the optional clock
and enable it when available.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++++
 2 files changed, 9 insertions(+)

V2:  The previous patch to fetch the fclk was dropped.  In its place
     is code to enable the refclk

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7453b17a37a2..ff363797bd2b 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -994,6 +994,7 @@ struct ravb_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
 	struct clk *clk;
+	struct clk *refclk;
 	struct mdiobb_ctrl mdiobb;
 	u32 num_rx_ring[NUM_RX_QUEUE];
 	u32 num_tx_ring[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index bd30505fbc57..739e30f45daa 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2148,6 +2148,14 @@ static int ravb_probe(struct platform_device *pdev)
 		goto out_release;
 	}
 
+	priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
+	if (IS_ERR(priv->refclk)) {
+		error = PTR_ERR(priv->refclk);
+		goto out_release;
+	} else {
+		(void)clk_prepare_enable(priv->refclk);
+	}
+
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-- 
2.25.1

