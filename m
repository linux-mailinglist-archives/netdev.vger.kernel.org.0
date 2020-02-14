Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D10915F3AD
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393624AbgBNSOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731010AbgBNPwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C5224676;
        Fri, 14 Feb 2020 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695552;
        bh=e4oL/fv1Mjg3Df8wDT7b9emOle+kZOEDSt6D7uVpoVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vy3zgyES/5oPF9ovTZPiIeDujSxh7U/BhBafYdmqrxPl+8S+XULMmZQl/EAhIzSDu
         oKUYTrmQ1ACE7pLNgzag+VzdSusQ73R8bfML3PE6rrAA95B2mRgdcqHMMqdaa/X+T9
         bXbS8DLBc4bJETq/g1gRBVxa7cJsqiNcqEcZXY3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 167/542] ath10k: correct the tlv len of ath10k_wmi_tlv_op_gen_config_pno_start
Date:   Fri, 14 Feb 2020 10:42:39 -0500
Message-Id: <20200214154854.6746-167-sashal@kernel.org>
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

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit e01cc82c4d1ec3bddcbb7cd991cf5dc0131ed9a1 ]

the tlv len is set to the total len of the wmi cmd, it will trigger
firmware crash, correct the tlv len.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00017-QCARMSWP-1 and QCA6174
PCIE with firmware WLAN.RM.4.4.1-00110-QCARMSWPZ-1.

Fixes: ce834e280f2f875 ("ath10k: support NET_DETECT WoWLAN feature")
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 69a1ec53df294..7b358484940ec 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3707,6 +3707,7 @@ ath10k_wmi_tlv_op_gen_config_pno_start(struct ath10k *ar,
 	struct wmi_tlv *tlv;
 	struct sk_buff *skb;
 	__le32 *channel_list;
+	u16 tlv_len;
 	size_t len;
 	void *ptr;
 	u32 i;
@@ -3764,10 +3765,12 @@ ath10k_wmi_tlv_op_gen_config_pno_start(struct ath10k *ar,
 	/* nlo_configured_parameters(nlo_list) */
 	cmd->no_of_ssids = __cpu_to_le32(min_t(u8, pno->uc_networks_count,
 					       WMI_NLO_MAX_SSIDS));
+	tlv_len = __le32_to_cpu(cmd->no_of_ssids) *
+		sizeof(struct nlo_configured_parameters);
 
 	tlv = ptr;
 	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
-	tlv->len = __cpu_to_le16(len);
+	tlv->len = __cpu_to_le16(tlv_len);
 
 	ptr += sizeof(*tlv);
 	nlo_list = ptr;
-- 
2.20.1

