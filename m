Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B926D30
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbfEVTkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbfEVT3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:29:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE16204FD;
        Wed, 22 May 2019 19:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553369;
        bh=ZBEVVKataqisP3PixDfYd1ZRgdNu2T9lyBIUTd8LUyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r63Hb4/jo6UHRb5pw5fxCdrzjZgyIiHo+InEGFBaBj59M9RYULIZbuuPM/DDjkK0t
         2t3aQQapJMsCcX0jyIr5z9VNgOKfXEu7CJKPw1lXre6znBb3LnpJyUvqVaE1+fKli3
         AlgBia4C9x7506v7zP0oRBXGXOCR7CDcPNXpAEDI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 029/167] iwlwifi: pcie: don't crash on invalid RX interrupt
Date:   Wed, 22 May 2019 15:26:24 -0400
Message-Id: <20190522192842.25858-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 30f24eabab8cd801064c5c37589d803cb4341929 ]

If for some reason the device gives us an RX interrupt before we're
ready for it, perhaps during device power-on with misconfigured IRQ
causes mapping or so, we can crash trying to access the queues.

Prevent that by checking that we actually have RXQs and that they
were properly allocated.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a40ad4675e19e..953e0254a94c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1252,10 +1252,15 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rxq *rxq = &trans_pcie->rxq[queue];
+	struct iwl_rxq *rxq;
 	u32 r, i, count = 0;
 	bool emergency = false;
 
+	if (WARN_ON_ONCE(!trans_pcie->rxq || !trans_pcie->rxq[queue].bd))
+		return;
+
+	rxq = &trans_pcie->rxq[queue];
+
 restart:
 	spin_lock(&rxq->lock);
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
-- 
2.20.1

