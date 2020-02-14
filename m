Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368A415E4B4
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393770AbgBNQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405770AbgBNQX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93DF92476A;
        Fri, 14 Feb 2020 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697438;
        bh=p5Vka3MWRnnxWQWS9554okQybQol3sSg6zPQmh524Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJpYpKkvgLH9cekIFyYgFdf7kNETexv8B8oNIismsEAcpAWL1+NWipRGZkSShvtqv
         omXpFl4OCP90xypti/w92j2mvbrcvC5+OgW9elL2TkG+5bCuUUp8Xjfednayn6mQkA
         Bf7j7LIyi57Yxb7WbFqeq4+yE6AwEGK7DSqDSAHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qing Xu <m1s5p6688@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 124/141] mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
Date:   Fri, 14 Feb 2020 11:21:04 -0500
Message-Id: <20200214162122.19794-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qing Xu <m1s5p6688@gmail.com>

[ Upstream commit 3a9b153c5591548612c3955c9600a98150c81875 ]

mwifiex_ret_wmm_get_status() calls memcpy() without checking the
destination size.Since the source is given from remote AP which
contains illegal wmm elements , this may trigger a heap buffer
overflow.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Qing Xu <m1s5p6688@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/wmm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index 9843560e784fe..c93fcafbcc7a6 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -980,6 +980,10 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 				    "WMM Parameter Set Count: %d\n",
 				    wmm_param_ie->qos_info_bitmap & mask);
 
+			if (wmm_param_ie->vend_hdr.len + 2 >
+				sizeof(struct ieee_types_wmm_parameter))
+				break;
+
 			memcpy((u8 *) &priv->curr_bss_params.bss_descriptor.
 			       wmm_ie, wmm_param_ie,
 			       wmm_param_ie->vend_hdr.len + 2);
-- 
2.20.1

