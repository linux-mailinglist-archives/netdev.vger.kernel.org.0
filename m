Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52999630A03
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiKSCWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiKSCVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:21:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331DC15FF9;
        Fri, 18 Nov 2022 18:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 69BDCCE2104;
        Sat, 19 Nov 2022 02:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E51C433D7;
        Sat, 19 Nov 2022 02:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824049;
        bh=LJuXFRrohITPW5o/NWROAe/Hfesl4OxQ4ROoWvTWE60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLXbCudm6hcj6Q6m7zmlvqaU35EEmfkhlPT3Lyfmjad0Zc7o1m10SNdqRJUweiZFY
         QdTvySOpYtB2ehv0PCbROG8BcfAjL+yAIfF4YF6uT15rlbuz9Y3lm+Ql089WETT7K3
         8g9Y0zDxx1xpKrabrAaRLUKfzbNUlcBvINQe9fEm4JBsBVo+aqqKQ7I2B2lD+ozIs9
         /FX3E+kcQ7tKsg5pibSSih/6sKjxczzGuqhUomAs7bQSAxtNZUpLTcQCOi/3cM9SQU
         EMDtPNahWdZR5ux4iXsSIsW4MoIegoqNBf+zhR7YLkiHLW1+kLsJq+jePkr0lVEXpD
         QrSnc3NuVhLhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tyler J. Stachecki" <stachecki.tyler@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/27] wifi: ath11k: Fix QCN9074 firmware boot on x86
Date:   Fri, 18 Nov 2022 21:13:32 -0500
Message-Id: <20221119021352.1774592-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
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

From: "Tyler J. Stachecki" <stachecki.tyler@gmail.com>

[ Upstream commit 3a89b6dec9920026eaa90fe8457f4348d3388a98 ]

The 2.7.0 series of QCN9074's firmware requests 5 segments
of memory instead of 3 (as in the 2.5.0 series).

The first segment (11M) is too large to be kalloc'd in one
go on x86 and requires piecemeal 1MB allocations, as was
the case with the prior public firmware (2.5.0, 15M).

Since f6f92968e1e5, ath11k will break the memory requests,
but only if there were fewer than 3 segments requested by
the firmware. It seems that 5 segments works fine and
allows QCN9074 to boot on x86 with firmware 2.7.0, so
change things accordingly.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.16

Signed-off-by: Tyler J. Stachecki <stachecki.tyler@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221022042728.43015-1-stachecki.tyler@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index 3d5930330703..25940b683ea4 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -27,7 +27,7 @@
 #define ATH11K_QMI_WLANFW_MAX_NUM_MEM_SEG_V01	52
 #define ATH11K_QMI_CALDB_SIZE			0x480000
 #define ATH11K_QMI_BDF_EXT_STR_LENGTH		0x20
-#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	3
+#define ATH11K_QMI_FW_MEM_REQ_SEGMENT_CNT	5
 
 #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
 #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
-- 
2.35.1

