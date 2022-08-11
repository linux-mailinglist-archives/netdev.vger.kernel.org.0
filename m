Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFF6590403
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiHKQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238361AbiHKQ1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E29F77A;
        Thu, 11 Aug 2022 09:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D80961426;
        Thu, 11 Aug 2022 16:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ABAC433D6;
        Thu, 11 Aug 2022 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234113;
        bh=IvK5vr6DMKLGtEAo+VxNzrO/s9h7vybNjsPB5ui6Euw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXSJpkzvqd6A6aVGtrCEalbuHwYsx5BSJNPgTX50mwcLZrrDwsqSG7MILCmz2I6j5
         UuEzsfccFoM97nqENrZPvhEDQ/oxwW6ajBmhZ5ENMr9bukVbWDZr3PZxWZHYaeKC6p
         Cw9Z9BOP9/FnPvhdwQXVrVtpWyEl0joLCAtz2w/YoGruQEp1fkcg3jNQ92Lmm4eoIV
         lYlYl5x2RrpxzosbjE26MGrEXmAhYFqwL/D8de0Mhmfbc+jWCEYeo0rxOYwCbsKcu2
         1vh1Hs2J19UGMBRWFb8Dutgs/Nqc0c8PEooBtwXC01tVCi8AmwZ+Fexa11pmCzmESy
         XoA4gMm26HY3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/25] ath10k: fix misreported tx bandwidth for 160Mhz
Date:   Thu, 11 Aug 2022 12:07:58 -0400
Message-Id: <20220811160826.1541971-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

[ Upstream commit 75a7062e533e309a9ca0812c69f3ac3cefadb8b1 ]

Because of this missing switch case, 160Mhz transmit was reported as
20Mhz, leading to wrong airtime calculation and AQL limiting max
throughput.

Tested-on: QCA9984 hw2.0 PCI 10.4-3.10-00047

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/cd2735a40da7f4fcc5323e3fca3775e7b5402ece.camel@freebox.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 760d24a28f39..3aa9536b95d7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3748,6 +3748,10 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		arsta->tx_info.status.rates[0].flags |=
 				IEEE80211_TX_RC_80_MHZ_WIDTH;
 		break;
+	case RATE_INFO_BW_160:
+		arsta->tx_info.status.rates[0].flags |=
+				IEEE80211_TX_RC_160_MHZ_WIDTH;
+		break;
 	}
 
 	if (peer_stats->succ_pkts) {
-- 
2.35.1

