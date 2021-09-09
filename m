Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C197240536F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355187AbhIIMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355099AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A724C61BC0;
        Thu,  9 Sep 2021 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188505;
        bh=OObXcfMPhShBnk286/vBx+X4jknTOz5u8U8voGgtQbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1B/AayNbHE9f4BIEK3PawUTB5Gs61LDphiKeu//MoVJdWPiHjF45g7EYiOH56025
         aW/5/GJdBQtj0IWqR8xxDH1ZfS7QSGmoRbJce6GTRkKobeifc6X/ir0h7Pv4E2LiBG
         RAxVwKk0x4bW2u7Pb1NAPAAadurRBINmUKFMeSkvwESTdXIAPa9nzK5WdvHhG3Pak0
         5nwQCbNVbLEfqSjLsvea8csN4lWS9ewiE7RHNxLGvcOui7X1h6k34s8/CnrxFzh00y
         0AkK/UFEXUoAynPRGQ4qKpCjF2H22NjogeuARAoQYq0XQnM8k9eQaYVhaKaST6uWf8
         kZoHn/lE0dR+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 176/176] net: hns3: clean up a type mismatch warning
Date:   Thu,  9 Sep 2021 07:51:18 -0400
Message-Id: <20210909115118.146181-176-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

[ Upstream commit e79c0e324b011b0288cd411a5b53870a7730f163 ]

abs() returns signed long, which could not convert the type
as unsigned, and it may cause a mismatch type warning from
static tools. To fix it, this patch uses an variable to save
the abs()'s result and does a explicit conversion.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 61f6f0287cbe..ff9d84a7147f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -10,7 +10,14 @@
 
 static u16 hclge_errno_to_resp(int errno)
 {
-	return abs(errno);
+	int resp = abs(errno);
+
+	/* The status for pf to vf msg cmd is u16, constrainted by HW.
+	 * We need to keep the same type with it.
+	 * The intput errno is the stander error code, it's safely to
+	 * use a u16 to store the abs(errno).
+	 */
+	return (u16)resp;
 }
 
 /* hclge_gen_resp_to_vf: used to generate a synchronous response to VF when PF
-- 
2.30.2

