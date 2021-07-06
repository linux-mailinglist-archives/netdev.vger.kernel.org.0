Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E2D3BD5C8
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbhGFMZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236802AbhGFLfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0748F61E4C;
        Tue,  6 Jul 2021 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570662;
        bh=4EUy9s6jiLazO1muKr06cQhG00kLjfMPslB3+SH/BBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4uDoKmAZuZKPvhikmTk6rIGdGi23RMIjYpU+o4rd6aRk0XVUEth2dMEFDbDbI5Dy
         hK/BUHds1MH/L3JO/uKU7WgNgS91VF4QNlxF4saNSvRJ3RszQ0clzNl/vqfkyA0zyO
         UZlrmi1lDIcjGMwk2HR7A/8xFnRFg2vJbODSIAokK+HpihDhJcFbNZmWfwYyXNDo4p
         ol0LyOinCNkHxKiAHrf75nW4oycC9xAxND58ti+mbJVU+jQVHLeYU+fpPMZMhgICi0
         F2xGF4MBedDHhpNYJIa4bMdz5D6yjauEjYkKf3A3dcQMXat4Yx/ofB5EBdlXGosCRI
         qYvGYbGag9G7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 107/137] iwlwifi: mvm: support LONG_GROUP for WOWLAN_GET_STATUSES version
Date:   Tue,  6 Jul 2021 07:21:33 -0400
Message-Id: <20210706112203.2062605-107-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d65ab7c0e0b92056754185d3f6925d7318730e94 ]

It's been a while that the firmware uses LONG_GROUP by default
and not LEGACY_GROUP.
Until now the firmware wrongly advertise the WOWLAN_GET_STATUS
command's version with LEGACY_GROUP, but it is now being fixed.
In order to support both firmwares, first try to get the version
number of the command with the LONG_GROUP and if the firmware
didn't advertise the command version with LONG_GROUP, try to get
the command version with LEGACY_GROUP.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618105614.cd6f4e421430.Iec07c746c8e65bc267e4750f38e4f74f2010ca45@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d21143495e70..2a53792a69f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1682,8 +1682,11 @@ struct iwl_wowlan_status *iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm)
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 
 	/* default to 7 (when we have IWL_UCODE_TLV_API_WOWLAN_KEY_MATERIAL) */
-	notif_ver = iwl_fw_lookup_notif_ver(mvm->fw, LEGACY_GROUP,
-					    WOWLAN_GET_STATUSES, 7);
+	notif_ver = iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP,
+					    WOWLAN_GET_STATUSES, 0);
+	if (!notif_ver)
+		notif_ver = iwl_fw_lookup_notif_ver(mvm->fw, LEGACY_GROUP,
+						    WOWLAN_GET_STATUSES, 7);
 
 	if (!fw_has_api(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_API_WOWLAN_KEY_MATERIAL)) {
-- 
2.30.2

