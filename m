Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2556642EA47
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbhJOHiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:38:00 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34544 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbhJOHh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:37:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634283353; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=kAntNQHuXNNYiMl1eS0qX1uZ1jRQgpLgR9OVNPkS2Hg=; b=FQeyN0Y90CpoTjn76jrPtVrwJWSHSMo97gLvia4GIalfqQtGXN4P7jcIjxZPXRyAeVCtM09z
 KlJJygGiBrQnOib6h4P5LYMUJnonTl2KalqRP0UQ8SQACkiJBEYOrjiFl/i8qVpKaH4Fz+Cx
 oBSSi7kHFww2fUz+rmVJlon9Dj8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 61692f3ef3e5b80f1f7c498d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 15 Oct 2021 07:35:26
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 19780C4338F; Fri, 15 Oct 2021 07:35:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9D5BC43616;
        Fri, 15 Oct 2021 07:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D9D5BC43616
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 02/13] net: phy: at803x: use phy_modify()
Date:   Fri, 15 Oct 2021 15:34:54 +0800
Message-Id: <20211015073505.1893-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211015073505.1893-1-luoj@codeaurora.org>
References: <20211015073505.1893-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert at803x_set_wol to use phy_modify.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5843b5b742f8..c5e145ff5ec8 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -348,16 +348,12 @@ static int at803x_set_wol(struct phy_device *phydev,
 			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
 				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
 
-		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value |= AT803X_INTR_ENABLE_WOL;
-		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
+		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
 		if (ret)
 			return ret;
 		value = phy_read(phydev, AT803X_INTR_STATUS);
 	} else {
-		value = phy_read(phydev, AT803X_INTR_ENABLE);
-		value &= (~AT803X_INTR_ENABLE_WOL);
-		ret = phy_write(phydev, AT803X_INTR_ENABLE, value);
+		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
 		if (ret)
 			return ret;
 		value = phy_read(phydev, AT803X_INTR_STATUS);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

