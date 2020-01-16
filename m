Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E4013F2F5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgAPRMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390385AbgAPRMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB5624693;
        Thu, 16 Jan 2020 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194738;
        bh=JbhHvwluzNTzu0cHNddlm1QyR+Us984VFcXgucFJLGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBiGRjiJ7Ql15kN3URloY/+GokUaUJ1DVXquTZlCw5yq8mLQtkJONALntKieRSGWR
         66rg9BM296Ea/3yYKE/qjFNOgynvsMIoMbeYUuDe1oBzEnUjObZIlEMKei109wqbXo
         sWH3QFw/BIahaBbEJnz7T0f5SavMRDNPbgqN/kNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 569/671] of: mdio: Fix a signedness bug in of_phy_get_and_connect()
Date:   Thu, 16 Jan 2020 12:03:27 -0500
Message-Id: <20200116170509.12787-306-sashal@kernel.org>
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

[ Upstream commit d7eb651212fdbafa82d485d8e76095ac3b14c193 ]

The "iface" variable is an enum and in this context GCC treats it as
an unsigned int so the error handling is never triggered.

Fixes: b78624125304 ("of_mdio: Abstract a general interface for phy connect")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 5ad1342f5682..7d2bc22680d9 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -370,7 +370,7 @@ struct phy_device *of_phy_get_and_connect(struct net_device *dev,
 	int ret;
 
 	iface = of_get_phy_mode(np);
-	if (iface < 0)
+	if ((int)iface < 0)
 		return NULL;
 	if (of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
-- 
2.20.1

