Return-Path: <netdev+bounces-445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D02C96F76CF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AF9B1C215D7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA9819538;
	Thu,  4 May 2023 19:51:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003CA1950A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C03C433A4;
	Thu,  4 May 2023 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229900;
	bh=nlAzl+QjPe6vIaEMNRkNBWxk5HmpBMb0t8KQPrpGh/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnC4xVNXZ1E7RDmdWMlCF74V2mh6C4JKCAtBK12APscJyKUzZPvtnSKdH8J2sfqr8
	 G/Z7cHWYO66ighyWHADHE6YRCvfA334Yxt6476fk/TsBkMqE/dEzhrie9Lcg1wnKrp
	 9nNgxSIpUxqUgg6+AGj8KUWvMaiscC4L9VuR5UlCu1Fr7YaolxGIQ1EBLZl5EhUwCo
	 Df+DkuSDzQbXOB9AhOOMm8so5tmnaPxodhlzlaGMwdOXpK+xpxsq0vjzvIpsoB8yly
	 SPk6iu5SFfeI6YlKRSDFC0nPyWcEG1Jva5rS0HqyjNnK7aFGa/sO9whrvFO0cphRpD
	 bi78C4K0hZsyQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aspriel@gmail.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	chi-hsien.lin@infineon.com,
	ian.lin@infineon.com,
	wright.feng@cypress.com,
	wataru.gohda@cypress.com,
	ramesh.rangavittal@infineon.com,
	prasanna.kerekoppa@cypress.com,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	SHA-cyfmac-dev-list@infineon.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/13] wifi: brcmfmac: cfg80211: Pass the PMK in binary instead of hex
Date: Thu,  4 May 2023 15:51:19 -0400
Message-Id: <20230504195132.3808946-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504195132.3808946-1-sashal@kernel.org>
References: <20230504195132.3808946-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 89b89e52153fda2733562776c7c9d9d3ebf8dd6d ]

Apparently the hex passphrase mechanism does not work on newer
chips/firmware (e.g. BCM4387). It seems there was a simple way of
passing it in binary all along, so use that and avoid the hexification.

OpenBSD has been doing it like this from the beginning, so this should
work on all chips.

Also clear the structure before setting the PMK. This was leaking
uninitialized stack contents to the device.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214092423.15175-6-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 75790b13c9621..22fdc92fd6f88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1238,13 +1238,14 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
 static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 {
 	struct brcmf_wsec_pmk_le pmk;
-	int i, err;
+	int err;
+
+	memset(&pmk, 0, sizeof(pmk));
 
-	/* convert to firmware key format */
-	pmk.key_len = cpu_to_le16(pmk_len << 1);
-	pmk.flags = cpu_to_le16(BRCMF_WSEC_PASSPHRASE);
-	for (i = 0; i < pmk_len; i++)
-		snprintf(&pmk.key[2 * i], 3, "%02x", pmk_data[i]);
+	/* pass pmk directly */
+	pmk.key_len = cpu_to_le16(pmk_len);
+	pmk.flags = cpu_to_le16(0);
+	memcpy(pmk.key, pmk_data, pmk_len);
 
 	/* store psk in firmware */
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
-- 
2.39.2


