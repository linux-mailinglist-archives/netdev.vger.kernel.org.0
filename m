Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DE65025B
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiLRQqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiLRQpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:45:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48567BC3C;
        Sun, 18 Dec 2022 08:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E893CB80BA4;
        Sun, 18 Dec 2022 16:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A791C433EF;
        Sun, 18 Dec 2022 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380170;
        bh=I8NcPXTT/Z+JkIDcihNXGhgelFWz/vPnqoVOuT7+Kf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDUixuEo4Megmz04EH9XV/K5eFTIwCbODFptbDeabWLo4Eeaa0jCm4gRzRYfJg1tk
         xop6AvM6S0EcWAbukuuTn0J51hpC+hRIRwRJVr365RDcdU1ggDLRlsJLzKj+zHHguX
         +LCYf3aja+F5ZYfhKjcIKI+bx4ssanWCvewDrCEay0oHSglikJaXl/MOXcY1C4BWdM
         T1gea/lK67knT0W3RQA05qpvUVfEteFYlhXzJAmyhGK+mKx3hSaVm1h0Cgs8Lqd70b
         eFIYfk+2ZuBsCkzRp1uxZhbNq0VCuNZKaAP/HVUTgj2XSzcQDRuuxQNMXdRQ4p5JQG
         AuCM3PKdvsaHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ian Lin <ian.lin@infineon.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, aspriel@gmail.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcan@marcan.st, linus.walleij@linaro.org,
        rmk+kernel@armlinux.org.uk, soontak.lee@cypress.com,
        alep@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/39] brcmfmac: return error when getting invalid max_flowrings from dongle
Date:   Sun, 18 Dec 2022 11:15:22 -0500
Message-Id: <20221218161559.932604-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit 2aca4f3734bd717e04943ddf340d49ab62299a00 ]

When firmware hit trap at initialization, host will read abnormal
max_flowrings number from dongle, and it will cause kernel panic when
doing iowrite to initialize dongle ring.
To detect this error at early stage, we directly return error when getting
invalid max_flowrings(>256).

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ian Lin <ian.lin@infineon.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220929031001.9962-3-ian.lin@infineon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 61febc9bfa14..4f419e8e3640 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1109,6 +1109,10 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 				BRCMF_NROF_H2D_COMMON_MSGRINGS;
 		max_completionrings = BRCMF_NROF_D2H_COMMON_MSGRINGS;
 	}
+	if (max_flowrings > 256) {
+		brcmf_err(bus, "invalid max_flowrings(%d)\n", max_flowrings);
+		return -EIO;
+	}
 
 	if (devinfo->dma_idx_sz != 0) {
 		bufsz = (max_submissionrings + max_completionrings) *
-- 
2.35.1

