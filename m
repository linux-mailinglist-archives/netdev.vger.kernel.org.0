Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B0339F0D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfFHLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727676AbfFHLkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E1E208C0;
        Sat,  8 Jun 2019 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994036;
        bh=Av4HY/0Q8NsA0c/favFMI7/QIDxKXvn8c7LgQSJ9lWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udkZPYId9FlQ0E1Zgz6va6KCyX25WUyY/kKYKY8JCk3iWSbvsGB+kWI9eNS2NtACY
         wd7yijoP2diQzOzrkHjikT1IuqI1yBXEMlapYFxcH/klxwJvrxdsP4M1MDR4sQJRLu
         Z7RJOBVziMSLc5Q16HmOQ9nt4gXf1JWUfLfIPis8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 30/70] dpaa2-eth: Fix potential spectre issue
Date:   Sat,  8 Jun 2019 07:39:09 -0400
Message-Id: <20190608113950.8033-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

[ Upstream commit 5a20a093d965560f632b2ec325f8876918f78165 ]

Smatch reports a potential spectre vulnerability in the dpaa2-eth
driver, where the value of rxnfc->fs.location (which is provided
from user-space) is used as index in an array.

Add a call to array_index_nospec() to sanitize the access.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 591dfcf76adb..0610fc0bebc2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/net_tstamp.h>
+#include <linux/nospec.h>
 
 #include "dpni.h"	/* DPNI_LINK_OPT_* */
 #include "dpaa2-eth.h"
@@ -589,6 +590,8 @@ static int dpaa2_eth_get_rxnfc(struct net_device *net_dev,
 	case ETHTOOL_GRXCLSRULE:
 		if (rxnfc->fs.location >= max_rules)
 			return -EINVAL;
+		rxnfc->fs.location = array_index_nospec(rxnfc->fs.location,
+							max_rules);
 		if (!priv->cls_rules[rxnfc->fs.location].in_use)
 			return -EINVAL;
 		rxnfc->fs = priv->cls_rules[rxnfc->fs.location].fs;
-- 
2.20.1

