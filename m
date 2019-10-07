Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD154CE3EE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfJGNlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:41:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGNlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:41:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iHTGD-0008KW-IG; Mon, 07 Oct 2019 13:41:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: make array interval static, makes object smaller
Date:   Mon,  7 Oct 2019 14:41:13 +0100
Message-Id: <20191007134113.5647-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array interval on the stack but instead make it
static. Makes the object code smaller by 121 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
 167797	  29676	    448	 197921	  30521	wireless/intel/iwlegacy/common.o

After:
   text	   data	    bss	    dec	    hex	filename
 167580	  29772	    448	 197800	  304a8	wireless/intel/iwlegacy/common.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 73f7bbf742bc..e4ea734e58d8 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -1072,7 +1072,7 @@ EXPORT_SYMBOL(il_get_channel_info);
 static void
 il_build_powertable_cmd(struct il_priv *il, struct il_powertable_cmd *cmd)
 {
-	const __le32 interval[3][IL_POWER_VEC_SIZE] = {
+	static const __le32 interval[3][IL_POWER_VEC_SIZE] = {
 		SLP_VEC(2, 2, 4, 6, 0xFF),
 		SLP_VEC(2, 4, 7, 10, 10),
 		SLP_VEC(4, 7, 10, 10, 0xFF)
-- 
2.20.1

