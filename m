Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D09742EA4A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbhJOHia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:38:30 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21520 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbhJOHiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:38:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634283356; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=p0N/R4qBm5nWNfCWJWLkAY+u2pxF7YQMM0X3pG5xugM=; b=rbSn9BBvZecExTJXacvu5yLzAbEU4nqDXRmn0VA+llw9KjhXJSqwns9gQwP6VMvdwDJCJV5Y
 IfFiCE669iXbEQnL+FPA+G4fTX3BHihScdRFnGJ2SawZHRU9bMV/tUA+DhZ/voAM/lU/BdSo
 otmvHDSsrDk0MNU2IYrwopBn38M=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 61692f56f3e5b80f1f7ca697 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 15 Oct 2021 07:35:50
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 95313C4361C; Fri, 15 Oct 2021 07:35:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A1F50C43618;
        Fri, 15 Oct 2021 07:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A1F50C43618
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 12/13] net: phy: adjust qca8081 master/slave seed value if link down
Date:   Fri, 15 Oct 2021 15:35:04 +0800
Message-Id: <20211015073505.1893-13-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211015073505.1893-1-luoj@codeaurora.org>
References: <20211015073505.1893-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. The master/slave seed needs to be updated when the link can't
be created.

2. The case where two qca8081 PHYs are connected each other and
master/slave seed is generated as the same value also needs
to be considered, so adding this code change into read_status
instead of link_change_notify.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 4d283c0c828c..6c5dc4eed752 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
 	else
 		phydev->interface = PHY_INTERFACE_MODE_SMII;
 
+	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
+	 * excpet for master/slave configuration fault detected.
+	 * the reason for not putting this code into the function link_change_notify is
+	 * the corner case where the link partner is also the qca8081 PHY and the seed
+	 * value is configured as the same value, the link can't be up and no link change
+	 * occurs.
+	 */
+	if (!phydev->link) {
+		if (phydev->master_slave_state == MASTER_SLAVE_STATE_ERR) {
+			qca808x_phy_ms_seed_enable(phydev, false);
+		} else {
+			qca808x_phy_ms_random_seed_set(phydev);
+			qca808x_phy_ms_seed_enable(phydev, true);
+		}
+	}
+
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

