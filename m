Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFEE13F2EE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390427AbgAPRMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390417AbgAPRMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9CFC24692;
        Thu, 16 Jan 2020 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194733;
        bh=CNP4GJpsBIHh4vJGmtfmNioN6lx+c2VhX/+kISUAlag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js0ZwNzlodUfZ3BeNkc2Kh3VgX7A76UAsSMUto46pqIhGUzyFLoBrEvM0Qxo3gsKy
         gYAKRgOTpi2IMgR0MWeqM7RejPdOmnSYwPjCneaRYGJWz48JI73PKcQGM4wqXoZjET
         UsgXNAi3c9+jr2v5wmsuALP0dI2VDUwBQnokUQOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 566/671] net: socionext: Fix a signedness bug in ave_probe()
Date:   Thu, 16 Jan 2020 12:03:24 -0500
Message-Id: <20200116170509.12787-303-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7f9e88e6ef8c971f2c638b5ff7044c59b5d0f58d ]

The "phy_mode" variable is an enum and in this context GCC treats it as
an unsigned int so the error handling is never triggered.

Fixes: 4c270b55a5af ("net: ethernet: socionext: add AVE ethernet driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/sni_ave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 09d25b87cf7c..c309accc6797 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1575,7 +1575,7 @@ static int ave_probe(struct platform_device *pdev)
 
 	np = dev->of_node;
 	phy_mode = of_get_phy_mode(np);
-	if (phy_mode < 0) {
+	if ((int)phy_mode < 0) {
 		dev_err(dev, "phy-mode not found\n");
 		return -EINVAL;
 	}
-- 
2.20.1

