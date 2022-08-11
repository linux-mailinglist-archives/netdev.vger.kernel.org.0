Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3759039C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbiHKQXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbiHKQXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:23:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CC1A1A44;
        Thu, 11 Aug 2022 09:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 711C9B821B1;
        Thu, 11 Aug 2022 16:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9189CC433C1;
        Thu, 11 Aug 2022 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233871;
        bh=XBFwK4rubRr+4osIDMDJvoV6g7vilCpfMRyuvH86SI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVKIK7OudSy1KFdaD4VEaJ/eVAuWDQHK8vHzWUaOaeBGIW1bEHCjon2hTLZKLlKw+
         EdKktaMMFkJoql9yoPX+U7mKlmpuiGfABwXPGZEjDYwijIq4OwwcJ9V+Cn3bGMB5Po
         7i5uzY3u+s+RLz46ZrCOjFCq6Ve4prv60k8cWNutXoV/4kNL2sSRo+1t4zoItkjxsx
         N1iQ74Ggh/3q8f6crX1gKtwH4Drx7D4H4aG+ZUUoO5xeTz+68wCpnF2yiDfCEZ52En
         HrZqK+o5XjBv/yDAPIH09rFf7gfAagKMw28Vz0LquXhc2nWpwB5/FDMPSkDy2yRA7s
         kM1j5XBNRYsyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/46] ath10k: fix misreported tx bandwidth for 160Mhz
Date:   Thu, 11 Aug 2022 12:03:27 -0400
Message-Id: <20220811160421.1539956-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index 28ec3c5b4d1f..6d50955d15cf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3761,6 +3761,10 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
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

