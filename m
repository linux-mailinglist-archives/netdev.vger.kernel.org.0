Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC74E68DB0
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732687AbfGOOAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733302AbfGON7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:55 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44FC20C01;
        Mon, 15 Jul 2019 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199194;
        bh=jfDF6V7sa3nAxjig1AZWLSaeAPzexvArYSwSba5R5Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntscr2COhhBGy5yK1ppI0nHdGSlPwUCgukIvnBrnFywkEvIq5fr2Q4k35bEbhtoJh
         AWFoPBjJVwiN91RlcrL8tN7boctk2KRMxAcao8eNtoxmTXkOCRPdBLcBC8iHjl+2WQ
         3/BMBc69vtzc1incqLU/9wg3p3byfYYbNnDHP7Po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 211/249] iwlwifi: dbg: fix debug monitor stop and restart delays
Date:   Mon, 15 Jul 2019 09:46:16 -0400
Message-Id: <20190715134655.4076-211-sashal@kernel.org>
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

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit fc838c775f35e272e5cc7ef43853f0b55babbe37 ]

The driver should delay only in recording stop flow between writing to
DBGC_IN_SAMPLE register and DBGC_OUT_CTRL register. Any other delay is
not needed.

Change the following:
1. Remove any unnecessary delays in the flow
2. Increase the delay in the stop recording flow since 100 micro is
   not enough
3. Use usleep_range instead of delay since the driver is allowed to
   sleep in this flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 5cfe79c8d92a ("iwlwifi: fw: stop and start debugging using host command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 --
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h | 6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 33d7bc5500db..c875e173771c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2303,8 +2303,6 @@ void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt)
 	/* start recording again if the firmware is not crashed */
 	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
 	    fwrt->fw->dbg.dest_tlv) {
-		/* wait before we collect the data till the DBGC stop */
-		udelay(500);
 		iwl_fw_dbg_restart_recording(fwrt, &params);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index fd0ad220e961..c5c015a66106 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -294,7 +294,10 @@ _iwl_fw_dbg_stop_recording(struct iwl_trans *trans,
 	}
 
 	iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, 0);
-	udelay(100);
+	/* wait for the DBGC to finish writing the internal buffer to DRAM to
+	 * avoid halting the HW while writing
+	 */
+	usleep_range(700, 1000);
 	iwl_write_umac_prph(trans, DBGC_OUT_CTRL, 0);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	trans->dbg_rec_on = false;
@@ -324,7 +327,6 @@ _iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 		iwl_set_bits_prph(trans, MON_BUFF_SAMPLE_CTL, 0x1);
 	} else {
 		iwl_write_umac_prph(trans, DBGC_IN_SAMPLE, params->in_sample);
-		udelay(100);
 		iwl_write_umac_prph(trans, DBGC_OUT_CTRL, params->out_ctrl);
 	}
 }
-- 
2.20.1

