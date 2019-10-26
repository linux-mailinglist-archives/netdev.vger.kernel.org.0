Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23A3E5CD4
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfJZNSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfJZNSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25BB21D80;
        Sat, 26 Oct 2019 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095883;
        bh=xxhDib96CAuu+qgU+FNLwIap1P+MIxRuHXvs11dU7e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUhogE7LAVlFErCmLPPwC7cq2+Hr9qme7OmmxrAxnBLhKnp9trIG+y0s7FY4yf4as
         F5C+KavuB/iZoNFOaKzK3E+M5bURh7T+ceh3HeZ2rdtXY5J0RSqBo6XmgOy9fkRi1p
         xX+QG8c9HRcUB+mvP4AYvzJsyS15ivRrSS7yip0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 69/99] net: aquantia: temperature retrieval fix
Date:   Sat, 26 Oct 2019 09:15:30 -0400
Message-Id: <20191026131600.2507-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit 06b0d7fe7e5ff3ba4c7e265ef41135e8bcc232bb ]

Chip temperature is a two byte word, colocated internally with cable
length data. We do all readouts from HW memory by dwords, thus
we should clear extra high bytes, otherwise temperature output
gets weird as soon as we attach a cable to the NIC.

Fixes: 8f8940118654 ("net: aquantia: add infrastructure to readout chip temperature")
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index da726489e3c8d..7bc51f8d6f2fc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -337,7 +337,7 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, int *temp)
 	/* Convert PHY temperature from 1/256 degree Celsius
 	 * to 1/1000 degree Celsius.
 	 */
-	*temp = temp_res  * 1000 / 256;
+	*temp = (temp_res & 0xFFFF) * 1000 / 256;
 
 	return 0;
 }
-- 
2.20.1

