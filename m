Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969F842EA40
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbhJOHhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:37:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62902 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhJOHhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:37:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634283334; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=NTJj+M9miHXQ7Sz0GUFeUo2/1Lc1nbkJNHvjEM2dvE0=; b=WmKHJBKMap8h0xUhSIFpbCWmpRR+o1w8NTrSE299VyyfxoglPptzC7OpgIe05dRPpMD86f91
 2a2ObkpAwtXwV6P0E+DXQ2YeewS7r5sVyiLCWBoZEqpE9Rlsjwli1t0UNG94qx20+asbNHg7
 b7b3yWq5/JlzJiAyNAjOgdoHK2w=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 61692f39f3e5b80f1f7c3c9d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 15 Oct 2021 07:35:21
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C2375C43618; Fri, 15 Oct 2021 07:35:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30FD5C4338F;
        Fri, 15 Oct 2021 07:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 30FD5C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 0/13] net: phy: Add qca8081 ethernet phy driver
Date:   Fri, 15 Oct 2021 15:34:52 +0800
Message-Id: <20211015073505.1893-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the qca8081 ethernet phy driver support, which
improve the wol feature, leverage at803x phy driver and add the fast
retrain, master/slave seed and CDT feature.

Changes in v2:
	* add definitions of fast retrain related registers in mdio.h.
	* break up the patch into small patches.
	* improve the at803x legacy code.

Changes in v1:
	* merge qca8081 phy driver into at803x.
	* add cdt feature.
	* leverage at803x phy driver helpers.

Luo Jie (13):
  net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
  net: phy: at803x: use phy_modify()
  net: phy: at803x: improve the WOL feature
  net: phy: at803x: use GENMASK() for speed status
  net: phy: add qca8081 ethernet phy driver
  net: phy: add qca8081 read_status
  net: phy: add qca8081 get_features
  net: phy: add qca8081 config_aneg
  net: phy: add constants for fast retrain related register
  net: phy: add qca8081 config_init
  net: phy: add qca8081 soft_reset and enable master/slave seed
  net: phy: adjust qca8081 master/slave seed value if link down
  net: phy: add qca8081 cdt feature

 drivers/net/phy/at803x.c  | 572 +++++++++++++++++++++++++++++++++++---
 include/uapi/linux/mdio.h |  10 +
 2 files changed, 536 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

