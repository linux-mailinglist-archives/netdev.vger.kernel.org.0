Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D821E15E391
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406798AbgBNQax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406337AbgBNQ0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:26:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6F3246F3;
        Fri, 14 Feb 2020 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697573;
        bh=kPczogWiXOSiS49EYVauMu0X+s/wJe9Q8hPGsbMerHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqbAs2O3sj4wkruvd9EGeZCbFa2GvihajZ4QyoFDRdH5v5sW6eJu0O5dMeif46x+I
         XSS9PIDZfKd9U1YsLnCLqGrhSGRipLsDrS9LDGRCDaVMrJWa3S0uTMVMD5q0OKFCP9
         8qeQG29UNGdERsSORNBXdYAU3+E7eM87SV0wyKb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 087/100] iwlegacy: ensure loop counter addr does not wrap and cause an infinite loop
Date:   Fri, 14 Feb 2020 11:24:11 -0500
Message-Id: <20200214162425.21071-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c2f9a4e4a5abfc84c01b738496b3fd2d471e0b18 ]

The loop counter addr is a u16 where as the upper limit of the loop
is an int. In the unlikely event that the il->cfg->eeprom_size is
greater than 64K then we end up with an infinite loop since addr will
wrap around an never reach upper loop limit. Fix this by making addr
an int.

Addresses-Coverity: ("Infinite loop")
Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlegacy/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 887114582583b..544ab3750ea6e 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -717,7 +717,7 @@ il_eeprom_init(struct il_priv *il)
 	u32 gp = _il_rd(il, CSR_EEPROM_GP);
 	int sz;
 	int ret;
-	u16 addr;
+	int addr;
 
 	/* allocate eeprom */
 	sz = il->cfg->eeprom_size;
-- 
2.20.1

