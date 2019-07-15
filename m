Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC6697EB
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbfGONsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731564AbfGONso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:48:44 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3173B2067C;
        Mon, 15 Jul 2019 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198523;
        bh=M8oYnJxeXBPkY5HQOxKLmoImQd3w9QKWiQyKPguFl00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EENsJRpFQnL0pjEja3j/o8O12O75GxO1vdzrneEzIPJFMKFpVV1jogMbzjX70zdTf
         PVa8aVU8QIgftMNSQFchjmQU8YQk925zaKNuYRNudhcwVPzHFaNvigFKi1Gr8MshgX
         +RfIoDWAfjqm19aMh9sQygE2Oe4QAB6O+cg1R8fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 034/249] net: mvpp2: cls: Extract the RSS context when parsing the ethtool rule
Date:   Mon, 15 Jul 2019 09:43:19 -0400
Message-Id: <20190715134655.4076-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit c561da68038a738f30eca21456534c2d1872d13d ]

ethtool_rx_flow_rule_create takes into parameter the ethtool flow spec,
which doesn't contain the rss context id. We therefore need to extract
it ourself before parsing the ethtool rule.

The FLOW_RSS flag is only set in info->fs.flow_type, and not
info->flow_type.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index a57d17ab91f0..fb06c0aa620a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1242,6 +1242,12 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 
 	input.fs = &info->fs;
 
+	/* We need to manually set the rss_ctx, since this info isn't present
+	 * in info->fs
+	 */
+	if (info->fs.flow_type & FLOW_RSS)
+		input.rss_ctx = info->rss_context;
+
 	ethtool_rule = ethtool_rx_flow_rule_create(&input);
 	if (IS_ERR(ethtool_rule)) {
 		ret = PTR_ERR(ethtool_rule);
-- 
2.20.1

