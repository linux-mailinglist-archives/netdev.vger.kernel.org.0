Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CD57700
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfF0Ama (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbfF0Am3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:42:29 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CBEE205ED;
        Thu, 27 Jun 2019 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596148;
        bh=eLmJ0MunBZrCkh4WprqPh2eUFcE7ufq0sKoh+UC+SDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzX2Q701IziX0jfnD05ADcwu4sExYdlFoja+EewY0jSeEDisP2MUINEfIakbMqQiV
         HkqOgnlVHQseBtiiVvZEQ9VtyZxsbpXmjXqEpXl3lUuwsHXM+bl+0Fted5ssvQpvHK
         hB+5SAqVHhy8AqIEF2VaLLsjAPO+12PdgHHM21ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 19/21] bnx2x: Check if transceiver implements DDM before access
Date:   Wed, 26 Jun 2019 20:41:19 -0400
Message-Id: <20190627004122.21671-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627004122.21671-1-sashal@kernel.org>
References: <20190627004122.21671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>

[ Upstream commit cf18cecca911c0db96b868072665347efe6df46f ]

Some transceivers may comply with SFF-8472 even though they do not
implement the Digital Diagnostic Monitoring (DDM) interface described in
the spec. The existence of such area is specified by the 6th bit of byte
92, set to 1 if implemented.

Currently, without checking this bit, bnx2x fails trying to read sfp
module's EEPROM with the follow message:

ethtool -m enP5p1s0f1
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it is assumed
to exist the DDM data.

This issue was noticed using a Mellanox Passive DAC PN 01FT738. The EEPROM
data was confirmed by Mellanox as correct and similar to other Passive
DACs from other manufacturers.

Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 8aecd8ef6542..15a0850e6bde 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1562,7 +1562,8 @@ static int bnx2x_get_module_info(struct net_device *dev,
 	}
 
 	if (!sff8472_comp ||
-	    (diag_type & SFP_EEPROM_DIAG_ADDR_CHANGE_REQ)) {
+	    (diag_type & SFP_EEPROM_DIAG_ADDR_CHANGE_REQ) ||
+	    !(diag_type & SFP_EEPROM_DDM_IMPLEMENTED)) {
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 	} else {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
index b7d251108c19..7115f5025664 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
@@ -62,6 +62,7 @@
 #define SFP_EEPROM_DIAG_TYPE_ADDR		0x5c
 #define SFP_EEPROM_DIAG_TYPE_SIZE		1
 #define SFP_EEPROM_DIAG_ADDR_CHANGE_REQ		(1<<2)
+#define SFP_EEPROM_DDM_IMPLEMENTED		(1<<6)
 #define SFP_EEPROM_SFF_8472_COMP_ADDR		0x5e
 #define SFP_EEPROM_SFF_8472_COMP_SIZE		1
 
-- 
2.20.1

