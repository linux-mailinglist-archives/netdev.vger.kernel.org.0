Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFCE1DCD00
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgEUMe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgEUMe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 08:34:56 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F394D2070A;
        Thu, 21 May 2020 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590064496;
        bh=FHL2jEvxOll6vmZM4DX6DqzH90iBYE9p2hBWzKlPxkE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z3uh7cHNKQpZCISsf6c+gxtdwdCXNbRFeQ0vnkQaA2rGWm7WSWfcTRs+TbArLs7Nt
         23/qWplkyfMdUlfFIo03HzGrdvHCr9hAwOhEDS9nmBS7ubVszAZA2AKNXBkqf2BLSK
         vTp2L2NyZzYW0cv9W+IXCGqoBeB4kkbNUaHDJYhU=
Received: by pali.im (Postfix)
        id 9332C34B; Thu, 21 May 2020 14:34:53 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Parse all API_VER_ID properties
Date:   Thu, 21 May 2020 14:34:44 +0200
Message-Id: <20200521123444.28957-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During initialization of SD8997 wifi chip kernel prints warnings:

  mwifiex_sdio mmc0:0001:1: Unknown api_id: 3
  mwifiex_sdio mmc0:0001:1: Unknown api_id: 4

This patch adds support for parsing all api ids provided by SD8997
firmware.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 17 +++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h     |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 7e4b8cd52..589cc5eb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1581,8 +1581,21 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 					adapter->fw_api_ver =
 							api_rev->major_ver;
 					mwifiex_dbg(adapter, INFO,
-						    "Firmware api version %d\n",
-						    adapter->fw_api_ver);
+						    "Firmware api version %d.%d\n",
+						    adapter->fw_api_ver,
+						    api_rev->minor_ver);
+					break;
+				case UAP_FW_API_VER_ID:
+					mwifiex_dbg(adapter, INFO,
+						    "uAP api version %d.%d\n",
+						    api_rev->major_ver,
+						    api_rev->minor_ver);
+					break;
+				case CHANRPT_API_VER_ID:
+					mwifiex_dbg(adapter, INFO,
+						    "channel report api version %d.%d\n",
+						    api_rev->major_ver,
+						    api_rev->minor_ver);
 					break;
 				default:
 					mwifiex_dbg(adapter, FATAL,
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index a415d73a7..6f86f5b96 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1052,6 +1052,8 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 enum API_VER_ID {
 	KEY_API_VER_ID = 1,
 	FW_API_VER_ID = 2,
+	UAP_FW_API_VER_ID = 3,
+	CHANRPT_API_VER_ID = 4,
 };
 
 struct hw_spec_api_rev {
-- 
2.20.1

