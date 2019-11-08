Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6EF4AAB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbfKHLjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733266AbfKHLjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF50D20869;
        Fri,  8 Nov 2019 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213162;
        bh=dpSjd1hk84fWWcoabhUygmApwukG2qV9KDnFTNF0n4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0Q1atK0JSKAM7ED9iKEbpRoPvUI+pKdiuYcPxJRf6YLAd59Gw3jr4wB/V5axgYT9
         xLpzdD5+Q49vOdWGQLfJCXchi8iD0ij+xMzdEe4q5RaTH4fZx7se26DwO0OOBiFjiP
         8vvjrhNRyKcQaDMKDDLwkNcYGY5CfnQn7gdNSXwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 067/205] brcmfmac: fix wrong strnchr usage
Date:   Fri,  8 Nov 2019 06:35:34 -0500
Message-Id: <20191108113752.12502-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit cb18e2e9ec71d42409a51b83546686c609780dde ]

strnchr takes arguments in the order of its name: string, max bytes to
read, character to search for. Here we're passing '\n' aka 10 as the
buffer size, and searching for sizeof(buf) aka BRCMF_DCMD_SMLEN aka
256 (aka '\0', since it's implicitly converted to char) within those 10
bytes.

Just interchanging the last two arguments would still leave a bug,
because if we've been successful once, there are not sizeof(buf)
characters left after the new value of p.

Since clmver is immediately afterwards passed as a %s argument, I assume
that it is actually a properly nul-terminated string. For that case, we
have strreplace().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 27893af63ebc3..8510d207ee87d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -296,9 +296,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		/* Replace all newline/linefeed characters with space
 		 * character
 		 */
-		ptr = clmver;
-		while ((ptr = strnchr(ptr, '\n', sizeof(buf))) != NULL)
-			*ptr = ' ';
+		strreplace(clmver, '\n', ' ');
 
 		brcmf_dbg(INFO, "CLM version = %s\n", clmver);
 	}
-- 
2.20.1

