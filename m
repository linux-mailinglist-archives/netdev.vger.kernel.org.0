Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F042D1A5443
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgDKXEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbgDKXEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C13E216FD;
        Sat, 11 Apr 2020 23:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646289;
        bh=70QxI/XnNG+p+hRvKqGo7LgBaeCOY62GcGH1duZbP6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbvQyFPi9Uvl5GUv2a2+KOAe4Ao4ZhuEWB5hKY+PzJF4QM/WqXdbLfFO4KIEpq3fc
         h522PBGVwzTShzXyPJFTizAUB002uMxK4JnOMev3BxY5iOQ16wP54H/8+h+7zslSx/
         rAF0Ndd+OZmgM8ld7NpH4YDuthqiGB5P83y9klgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 050/149] net: hns3: modify an unsuitable print when setting unknown duplex to fibre
Date:   Sat, 11 Apr 2020 19:02:07 -0400
Message-Id: <20200411230347.22371-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 2d3db26d78805c9e06e26def0081c76e9bb0b7d6 ]

Currently, if device is in link down status and user uses
'ethtool -s' command to set speed but not specify duplex
mode, the duplex mode passed from ethtool to driver is
unknown value(255), and the fibre port will identify this
value as half duplex mode and print "only copper port
supports half duplex!". This message is confusing.

So for fibre port, only the setting duplex is half, prints
error and returns.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c03856e633202..3f59a1924390f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -736,7 +736,7 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 	if (ops->get_media_type)
 		ops->get_media_type(handle, &media_type, &module_type);
 
-	if (cmd->base.duplex != DUPLEX_FULL &&
+	if (cmd->base.duplex == DUPLEX_HALF &&
 	    media_type != HNAE3_MEDIA_TYPE_COPPER) {
 		netdev_err(netdev,
 			   "only copper port supports half duplex!");
-- 
2.20.1

