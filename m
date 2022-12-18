Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94308650121
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiLRQYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiLRQXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB1813E85;
        Sun, 18 Dec 2022 08:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 993AA60DD4;
        Sun, 18 Dec 2022 16:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8692C433F2;
        Sun, 18 Dec 2022 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379730;
        bh=IXzeQCXm8BAgFsTlT7kee4OYsEwHI8bN5Jhh+0BXAQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tevoYLUF2nTeC3q+adZPKNofwI42kS01BT/dcA+MI0XwtfOHIPCrVDZ8qtcaUpdBR
         +EcI/nKB2nZJT338e9X2ictdrDfspIbUHFYMooFfzZU5fQ9b6WV71200bEmjFq7t9+
         vF5gJFMeOw1pwqqYMf6ZPtMY408moAR3T7AaolEO1W5tfp4Rg9u4s6dSvg/x7ZErHX
         Ay/2hIcGTe3/LWGg6WM4oOyaVkJ3zUbI4KqujWK0z6i/hDhR1T1xIRtcdOFmToqpr1
         te+gJFDJubKVZsXQpLu7+RM6I9vF6AhF2nJXKnQZVXtHlpVAY2EovIXsGQE5p1SfUB
         /3bAeLG5sLPcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Bhattacharjee <quic_rbhattac@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 17/73] wifi: ath11k: Fix qmi_msg_handler data structure initialization
Date:   Sun, 18 Dec 2022 11:06:45 -0500
Message-Id: <20221218160741.927862-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

From: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>

[ Upstream commit ed3725e15a154ebebf44e0c34806c57525483f92 ]

qmi_msg_handler is required to be null terminated by QMI module.
There might be a case where a handler for a msg id is not present in the
handlers array which can lead to infinite loop while searching the handler
and therefore out of bound access in qmi_invoke_handler().
Hence update the initialization in qmi_msg_handler data structure.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Signed-off-by: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221021090126.28626-1-quic_rbhattac@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index e6ced8597e1d..539134a6e9d9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3083,6 +3083,9 @@ static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
 			sizeof(struct qmi_wlfw_fw_init_done_ind_msg_v01),
 		.fn = ath11k_qmi_msg_fw_init_done_cb,
 	},
+
+	/* end of list */
+	{},
 };
 
 static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
-- 
2.35.1

