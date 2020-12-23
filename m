Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7761C2E14D7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgLWCoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgLWCWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF211221E5;
        Wed, 23 Dec 2020 02:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690152;
        bh=hgehVMq8mURlrBR5kRfraFXCWYe/naiOqIOAOfTz+3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svv25BerBj/pxaENIuRvV5SBwEWWQ1AHdyxMM0Woeb3AQi+9JrzGKxZnp9NdHUlBd
         Mb6miTG+kUCKFBVFTPPhwGC3JZRL1ORJsg50j8FDYVHTOpdCQSMMliWUDriB7znqfZ
         ZWap4od1vnGDiWV+j8rOTHkIZ0l4Fb8GiEPTxtc2jfhXKStASkawM9NUTNPM7okyQs
         Nis/fRYkZE1TbJ9tHwFq+UXM1P32ajX2PT42y0CkIWXrX09jumWK9KQAHd3dMYzH9S
         1ivy/NxdNrZk6CXNqR02v5IYNTcrlYXF2ejCphnWqYy2flb0Yh/1RiG40B3+bKTuxt
         LuWOcFOy9keWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 72/87] iwlwifi: pcie: validate RX descriptor length
Date:   Tue, 22 Dec 2020 21:20:48 -0500
Message-Id: <20201223022103.2792705-72-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit df72138de4bc4e85e427aabc60fc51be6cc57fc7 ]

Validate the maximum RX descriptor length against the size
of the buffers we gave the device - if it doesn't fit then
the hardware messed up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.6378fb435cc0.Ib07485f3dc5999c74b03f21e7a808c50a05e353c@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 80a1a50f5da51..ebdb143b1b5a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1256,6 +1256,13 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 
 		len = iwl_rx_packet_len(pkt);
 		len += sizeof(u32); /* account for status word */
+
+		offset += ALIGN(len, FH_RSCSR_FRAME_ALIGN);
+
+		/* check that what the device tells us made sense */
+		if (offset > max_len)
+			break;
+
 		trace_iwlwifi_dev_rx(trans->dev, trans, pkt, len);
 		trace_iwlwifi_dev_rx_data(trans->dev, trans, pkt, len);
 
@@ -1313,7 +1320,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		page_stolen |= rxcb._page_stolen;
 		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 			break;
-		offset += ALIGN(len, FH_RSCSR_FRAME_ALIGN);
 	}
 
 	/* page was stolen from us -- free our reference */
-- 
2.27.0

