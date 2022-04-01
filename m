Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8954EF4BD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbiDAOxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbiDAOt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:49:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9742B19DA;
        Fri,  1 Apr 2022 07:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68B76B82504;
        Fri,  1 Apr 2022 14:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD15C2BBE4;
        Fri,  1 Apr 2022 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824029;
        bh=9Wc3k6gE6jmVeDTnq2FcMaJX6Ctbq58Pzce8ZBN2X+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBi+scHJlORbjdv5JIfJwlokRmWF/VVoBT+JgjB+MadOsxqd1Mli4e+XMpHyZRM/9
         SWiPcWBhe5MBsBu6kOq8yKUjA9ddTY+nyz04JLcWWXdLiJFeoHFWeSX/nBAYybKe4C
         Lnzsu7iuNLjCtbZrc/wsqN1pmeUihiA9I2hYUKUI0L6pxtOWuXDSgrwOfZcX+VIwoS
         l4PUFWwgwMkq6+dB2d1gyDNrAnOKsxqaiBS4jqeCc7bNh6XXmhgjxr81hMVIEo/PIY
         lFtYAPumZbiZfPlzxlB0QzNYG/x59dSaUAA9JCl5vHpC7UVZBDBp+LtM9Hg2Er3Mqc
         XD0OXYMRUXI6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, Bo.Jiao@mediatek.com,
        shayne.chen@mediatek.com, greearb@candelatech.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 58/98] mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU
Date:   Fri,  1 Apr 2022 10:37:02 -0400
Message-Id: <20220401143742.1952163-58-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 28225a6ef80ebf46c46e5fbd5b1ee231a0b2b5b7 ]

Before, the hardware would be allowed to transmit injected 802.11 MPDUs
as A-MSDU. This resulted in corrupted frames being transmitted. Now,
injected MPDUs are transmitted as-is, without A-MSDU.

The fix was verified with frame injection on MT7915 hardware, both with
and without the injected frame being encrypted.

If the hardware cannot do A-MSDU aggregation on MPDUs, this problem
would also be present in the TX path where mac80211 does the 802.11
encapsulation. However, I have not observed any such problem when
disabling IEEE80211_HW_SUPPORTS_TX_ENCAP_OFFLOAD to force that mode.
Therefore this fix is isolated to injected frames only.

The same A-MSDU logic is also present in the mt7921 driver, so it is
likely that this fix should be applied there too. I do not have access
to mt7921 hardware so I have not been able to test that.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ff613d705611..7691292526e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -899,6 +899,7 @@ mt7915_mac_write_txwi_80211(struct mt7915_dev *dev, __le32 *txwi,
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
+		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
 
 	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
-- 
2.34.1

