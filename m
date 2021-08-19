Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3D3F19D3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbhHSM4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:56:31 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39300
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235893AbhHSM4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:56:30 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 26A773F110;
        Thu, 19 Aug 2021 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629377753;
        bh=R7cOArTeMf4Z+13kjZUeEM64BDVv4YsvBwyzgpNCHT4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Ha/DTwuhAetyPC9+ngOydDWPtgLNhFqPCxIuYlyn96w+FBrrwWPtlg6+3iJ5YCP/r
         oRl0HaWFPpinfRc0FL8j08IVBg3jpgIF0IsAkfjXruVcLeC1LLjtvSmupRu4yPxXHw
         bCJmzqdQlrE2MuczaQFQTAcS3BTFP+uDB46rnVUbPfNRecIAuRRKJ544dWG31rgtN7
         gjKCnPGiv7jBOa4HCbdGVi8Y1eoXIOmCiy2PkbIZvOYC2c3I3ztD2K0Kz+bf8C75rh
         BPtyRS0CIPZ+Q3CxXmzOuRScGWuO/HZ/G1Ds31jIL5cFG9/3u2b6Du0WH2CprE/9bX
         q8exiF4MWamDA==
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org
Subject: [PATCH] brcmsmac: make array addr static const, makes object smaller
Date:   Thu, 19 Aug 2021 13:55:52 +0100
Message-Id: <20210819125552.8888-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array addr on the stack but instead it
static const. Makes the object code smaller by 79 bytes:

Before:
   text   data   bss     dec    hex filename
 176015  54652   128  230795  3858b .../broadcom/brcm80211/brcmsmac/main.o

After:
   text   data   bss     dec    hex filename
 175872  54716   128  230716  3853c .../broadcom/brcm80211/brcmsmac/main.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 26de1bd7fee9..8ddfc3d06687 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -704,7 +704,7 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 {
 	u8 idx;
-	u16 addr[] = {
+	static const u16 addr[] = {
 		M_HOST_FLAGS1, M_HOST_FLAGS2, M_HOST_FLAGS3, M_HOST_FLAGS4,
 		M_HOST_FLAGS5
 	};
-- 
2.32.0

