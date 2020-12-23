Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C72E15CE
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgLWCxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729230AbgLWCVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBBBA23137;
        Wed, 23 Dec 2020 02:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690032;
        bh=uc2zw3ThyR4wHAex+t9uG3MLBOkmmhPTciDcxbPNCZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJ3GdFQbg8g6mId4DOd+DK0ZPfJyoQetI4cMFv/m51uVVoPENKXHkjBnwDg+nFt5S
         XsVZRxOf5WFwYBAgl3IZz/gA0TGvG0L88VLdY6uGROqQsd53K/YJkjwf0keWwYEMzI
         3gouPELEKDVqs8l92gT0WMOtMwuXT9yhIVAtuD0USQTqd/R1+nTCskZtACUauuyQtQ
         otFWj/UyhQwye/2GS729zfgX8u9XzXuTFhLwzPJURhZqkb7I7WMzNM3S4qH8Xex7pk
         t8NAU2bNOSzcb2Xp5dBPgcpCW51ea9XVbx21FXA3GZuIuSbzisnFtfKKcJXZgieiHm
         xS15k5Sl+PqWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 108/130] iwlwifi: pcie: validate RX descriptor length
Date:   Tue, 22 Dec 2020 21:17:51 -0500
Message-Id: <20201223021813.2791612-108-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 64c74acadb998..72ec2ddcaecd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1292,6 +1292,13 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 
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
 
@@ -1349,7 +1356,6 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		page_stolen |= rxcb._page_stolen;
 		if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 			break;
-		offset += ALIGN(len, FH_RSCSR_FRAME_ALIGN);
 	}
 
 	/* page was stolen from us -- free our reference */
-- 
2.27.0

