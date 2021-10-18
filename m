Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F01430E41
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJRDhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:37:04 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34869 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhJRDge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 23:36:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528064; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=HvSdzHqkwxS38TSLtOTgzKXHm7iZi5c9Oz0zT2gsx+w=; b=ckzV9tKRNSkzEkWlM9TpymkGvt4OmwQmLd5RFm/jRN+63dPEaomJQ99iluOrNzerb+1zWl3z
 JMPi0bm1opdUCmYI8T5Px79WysTJ0k9tzwAhDWQhpgDzcd8pEOb6MraEft6qqZ2XU3fYgnSP
 dgh8vqR5W2fAgK7N50I5WnSlRSY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 616ceb3eea41a97c240fe870 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:34:22
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 753A9C43617; Mon, 18 Oct 2021 03:34:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E738EC4361A;
        Mon, 18 Oct 2021 03:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E738EC4361A
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 12/13] net: phy: adjust qca8081 master/slave seed value if link down
Date:   Mon, 18 Oct 2021 11:33:32 +0800
Message-Id: <20211018033333.17677-13-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211018033333.17677-1-luoj@codeaurora.org>
References: <20211018033333.17677-1-luoj@codeaurora.org>
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
index 5d007f89e9d3..77aaf9e72781 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
 	else
 		phydev->interface = PHY_INTERFACE_MODE_SMII;
 
+	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
+	 * except for master/slave configuration fault detected.
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

