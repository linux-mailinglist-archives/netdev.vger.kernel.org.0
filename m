Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBB7F65B2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfKJDJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbfKJCop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FBF215EA;
        Sun, 10 Nov 2019 02:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353885;
        bh=ltuqeh4pgWkWNtMciU1akQaTGuNdUOU/m4QsRZ0H6Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QPHLZOp9Qt3DBwXh+CyuSgyhGs+so5OpmVDJV/9LYgYaO/B5thRb9x8LhVJ3X0XT
         CMSrpanaDri+LmNTl5ze2ZALk86bnYOIxept0bs3i3cnOhzGshiZrfioSbuFIRCg0H
         GTyPKqiMjuC5gb0E+gdTOyyCVrxTmhdP0OhTv02M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 160/191] iwlwifi: dbg: don't crash if the firmware crashes in the middle of a debug dump
Date:   Sat,  9 Nov 2019 21:39:42 -0500
Message-Id: <20191110024013.29782-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 79f25b10c9da3dbc953e47033d0494e51580ac3b ]

We can dump data from the firmware either when it crashes,
or when the firmware is alive.
Not all the data is available if the firmware is running
(like the Tx / Rx FIFOs which are available only when the
firmware is halted), so we first check that the firmware
is alive to compute the required size for the dump and then
fill the buffer with the data.

When we allocate the buffer, we test the STATUS_FW_ERROR
bit to check if the firmware is alive or not. This bit
can be changed during the course of the dump since it is
modified in the interrupt handler.

We hit a case where we allocate the buffer while the
firmware is sill working, and while we start to fill the
buffer, the firmware crashes. Then we test STATUS_FW_ERROR
again and decide to fill the buffer with data like the
FIFOs even if no room was allocated for this data in the
buffer. This means that we overflow the buffer that was
allocated leading to memory corruption.

To fix this, test the STATUS_FW_ERROR bit only once and
rely on local variables to check if we should dump fifos
or other firmware components.

Fixes: 04fd2c28226f ("iwlwifi: mvm: add rxf and txf to dump data")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a31a42e673c46..37657e999ff8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -824,7 +824,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	/* We only dump the FIFOs if the FW is in error state */
-	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
+	if (fifo_data_len) {
 		iwl_fw_dump_fifos(fwrt, &dump_data);
 		if (radio_len)
 			iwl_read_radio_regs(fwrt, &dump_data);
-- 
2.20.1

