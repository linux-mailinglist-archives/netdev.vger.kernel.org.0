Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652A918A5FC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgCRUzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgCRUy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB6E2098B;
        Wed, 18 Mar 2020 20:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564899;
        bh=iz8yaV+d9GVVgUHW8fsRVpVSmKPfctEmjJPAOf2gPFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cql1ur588wqsUgeMaY6RSqRVsQ2dun59lQARsWixXhJWTE4nbf5VzCYaya5CU0Wsl
         dXW6hAtucX8AfAZA+3PnRl5GHf7hllwQ2u62zHxboJdF5vCrjm8cQSk0eZ4HEqPwkG
         qWSQFiNJWLLTvUvOR9wnC35KPYxdMJs3YncsxyAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 66/73] net: systemport: fix index check to avoid an array out of bounds access
Date:   Wed, 18 Mar 2020 16:53:30 -0400
Message-Id: <20200318205337.16279-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c0368595c1639947839c0db8294ee96aca0b3b86 ]

Currently the bounds check on index is off by one and can lead to
an out of bounds access on array priv->filters_loc when index is
RXCHK_BRCM_TAG_MAX.

Fixes: bb9051a2b230 ("net: systemport: Add support for WAKE_FILTER")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 4a27577e137bc..ad86a186ddc5f 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2135,7 +2135,7 @@ static int bcm_sysport_rule_set(struct bcm_sysport_priv *priv,
 		return -ENOSPC;
 
 	index = find_first_zero_bit(priv->filters, RXCHK_BRCM_TAG_MAX);
-	if (index > RXCHK_BRCM_TAG_MAX)
+	if (index >= RXCHK_BRCM_TAG_MAX)
 		return -ENOSPC;
 
 	/* Location is the classification ID, and index is the position
-- 
2.20.1

