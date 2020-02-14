Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB915EFAC
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389309AbgBNRtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388495AbgBNP7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A0424676;
        Fri, 14 Feb 2020 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695955;
        bh=Y74Xd+mVklbZULUCpaI/t71V7iNTRldQmCAkpffYaHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxa3ZrRHWEy/ygDVJJYTmY9Xt2oOOQimgDkMHXrRuEvgs9mU4MeYlVD/tmKmjZCfp
         dwwt6Qpj379iLLSheGOEJ7D8f/Jtq/dS1qDmqJPR5n8JP0IBGB4nXnJKlgfUpJhS2u
         pbnPvZgC8FY8c2FFct6wAgFcyxSElg0c0p0al2tE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qing Xu <m1s5p6688@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 485/542] mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()
Date:   Fri, 14 Feb 2020 10:47:57 -0500
Message-Id: <20200214154854.6746-485-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qing Xu <m1s5p6688@gmail.com>

[ Upstream commit b70261a288ea4d2f4ac7cd04be08a9f0f2de4f4d ]

mwifiex_cmd_append_vsie_tlv() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Qing Xu <m1s5p6688@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 98f942b797f7b..a7968a84aaf88 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2884,6 +2884,13 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 			vs_param_set->header.len =
 				cpu_to_le16((((u16) priv->vs_ie[id].ie[1])
 				& 0x00FF) + 2);
+			if (le16_to_cpu(vs_param_set->header.len) >
+				MWIFIEX_MAX_VSIE_LEN) {
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "Invalid param length!\n");
+				break;
+			}
+
 			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
 			       le16_to_cpu(vs_param_set->header.len));
 			*buffer += le16_to_cpu(vs_param_set->header.len) +
-- 
2.20.1

