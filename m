Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5443817B
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 05:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhJWD05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 23:26:57 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:45512 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhJWD0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 23:26:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634959471; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=iL5oPbWksXEVrldrO4+G8pNtHxXjaxfkvSxlz1HHHJo=; b=ty5LiRPJ+WkQDpf9D2Qbtg8eRp3CGKKKh7IuHo8hfJ5B7OJBOmSrZCGORRqgsoOY85xykHSJ
 ZtjwByNEVZPfVX7s64DU3jXkhTob7CT8vgdPqUsWAeEG9wUIBdTa9nYLHl0kBBFLLkbe01Y7
 rSsRWMq30EFAhgyDvgTrsSMbQaQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6173806e5baa84c77b00e970 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 03:24:30
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7212CC4338F; Sat, 23 Oct 2021 03:24:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F538C43460;
        Sat, 23 Oct 2021 03:24:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5F538C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v5 02/14] net: phy: at803x: use phy_modify()
Date:   Sat, 23 Oct 2021 11:24:00 +0800
Message-Id: <20211023032412.30479-3-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211023032412.30479-1-luoj@codeaurora.org>
References: <20211023032412.30479-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert at803x_set_wol to use phy_modify.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d0f41cdaec75..cf25cd428ffa 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -357,16 +357,12 @@ static int at803x_set_wol(struct phy_device *phydev,
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

