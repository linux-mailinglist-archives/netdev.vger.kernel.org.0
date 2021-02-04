Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D138E30F7E8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbhBDQaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237048AbhBDQ3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:29:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F69664F4E;
        Thu,  4 Feb 2021 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612456138;
        bh=056fz5EMahpKz5J2AFFhrRZLdav0oksdlYuTWVkGTOE=;
        h=From:To:Cc:Subject:Date:From;
        b=eKDw/p05Tk3cZopTI/UO6ecZ5Eykblpe5zL6hLjtrJgK2KMxtbbHgIFoSH7m1tLkS
         SWq8wSUoO4aAFOQge9zMzhZdh8bC71t68PbkrQcWYf/y7SLaPUTS5hHexHWAjdCDXB
         GT06EoDJAyCUByYYwNDHVzgRcqcH++MFI8pEKEL0e5Atf8gdYtLzDLTVHQ2ohXkaGc
         Z3ocjVZY4RsD0g8xA10tDA/v1gRIJw8l2nosngyjXt22BIXmvvN3ZmWHMMxydoYQlu
         gpYe2L+jeVU2wrCSuq4xsKiDDPmONooL4mTfS9mSR1JUCbHGttZV+whqC0dotR3Tfr
         E1qjijBZKzP/g==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: fix alignment constraints
Date:   Thu,  4 Feb 2021 17:28:35 +0100
Message-Id: <20210204162852.3219572-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

sturct d11txh contains a ieee80211_rts structure, which is required to
have at least two byte alignment, and this conflicts with the __packed
attribute:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h:786:1: warning: alignment 1 of 'struct d11txh' is less than 2 [-Wpacked-not-aligned]

Mark d11txh itself as having two-byte alignment to ensure the
inner structure is properly aligned.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
index 9035cc4d6ff3..7870093629c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/d11.h
@@ -783,7 +783,7 @@ struct d11txh {
 	u8 RTSPhyHeader[D11_PHY_HDR_LEN];	/* 0x2c - 0x2e */
 	struct ieee80211_rts rts_frame;	/* 0x2f - 0x36 */
 	u16 PAD;		/* 0x37 */
-} __packed;
+} __packed __aligned(2);
 
 #define	D11_TXH_LEN		112	/* bytes */
 
-- 
2.29.2

