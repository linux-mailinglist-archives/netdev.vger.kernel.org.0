Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F06A64FFB2
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiLRQFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLRQEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:04:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C79BB489;
        Sun, 18 Dec 2022 08:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30EABB80BD9;
        Sun, 18 Dec 2022 16:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D47C433F0;
        Sun, 18 Dec 2022 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379384;
        bh=ZOe+bKsqQUZL1HRBM3mff0Yg2ydfyAUrZqNFuRXj4wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndRy8/55HHHEYUkE0qTKk56c3SeTmwUyBSVTrHMvp8Zv+xvPSCDJqHnefGrLDo5p/
         O1XxZ12yXv7EMiXSWYSyWs4cKRN+exoA6R9JdTdoBG/uXVao839HOwKr1Tr1DvsvK2
         520h5R0clX8eqcbhSJNPBd4FSk09dQkfH1L8epfu04BqmPvP0/okRMp7ZECzGjTpFa
         eG3lgCUaDxUG8aysovtl55GdFP7l3GoV5x2X0hHYXjYurQTLkny4rtEL3oXA8FcgSj
         N9G13hy2si3NT3lZg/RlXv6en6xwmf0yy663aDVsM3p6uVaErbQ+hh45eC/lgUhhor
         yHYBDNmJVFf2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Bhattacharjee <quic_rbhattac@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 20/85] wifi: ath11k: Fix qmi_msg_handler data structure initialization
Date:   Sun, 18 Dec 2022 11:00:37 -0500
Message-Id: <20221218160142.925394-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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
index 51de2208b789..8358fe08c234 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3087,6 +3087,9 @@ static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
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

