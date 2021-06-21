Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BB83AF452
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhFUSIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhFUSFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 430466141F;
        Mon, 21 Jun 2021 17:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298179;
        bh=QR7oTvSOD4g+P2aR/hFUhfVBo6A/oBvDfcmz4ZeQt3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD8WaF+JHGSrTYQr6fUAHfwSN0EHqZJ8zRog9e4MnZjwsOrvDoCNBlAWxK1eHtaA7
         ZLXERKTPEq4RmBhGwdVcnRxk7I7f0fadDDLU9thnbJ+0gdVOoLjB2MXfLAf028K0sy
         nnjpMUqAbauIOnc0B1FnpXHVmtO3DoyUx5Piy0Pj4t3fmA+Xro/KrC7hbUPZwYuza2
         31VAjtXnAR1pGoCkEZQEMuv2fq/vbei9rX5VrJTIMxmy7ZGbxjF2Gi+ehhkjQTf7fF
         4pHbCcxpvOTVpoDUroFBfJogW4IsAIfLaySv91A8aGsOoP4+oCesGMxICMJ7T+QECc
         kbItJ9rzuqXpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 8/9] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Mon, 21 Jun 2021 13:56:06 -0400
Message-Id: <20210621175608.736581-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175608.736581-1-sashal@kernel.org>
References: <20210621175608.736581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit da5ac772cfe2a03058b0accfac03fad60c46c24d ]

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index f3a685d3f649..55b0f11bf2a0 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2314,7 +2314,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch(stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8169_gstrings, sizeof(rtl8169_gstrings));
+		memcpy(data, rtl8169_gstrings, sizeof(rtl8169_gstrings));
 		break;
 	}
 }
-- 
2.30.2

