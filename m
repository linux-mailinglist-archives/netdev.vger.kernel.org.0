Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDBA4EF4B7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242912AbiDAOxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349807AbiDAOqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0912929EE0C;
        Fri,  1 Apr 2022 07:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C234360B8A;
        Fri,  1 Apr 2022 14:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29766C2BBE4;
        Fri,  1 Apr 2022 14:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823766;
        bh=zq+1QPbSekVzYFU/HR9QExlr4oS2/VMpbbXHvi4dsvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKiU8gUVHthbgpLbXtqI8ZH6Mj9hV7x22H1IZNSIs0Tylr2FRT3pyhb9wQeS10+xt
         EWOEGq5CzRFfRXhrW6MJ6mrvoWzG8EbJcH48aibkmD0eclWg2aG1dZnHcLBCeJ3BR6
         1tKTqFHxw34ShSdEkopX46rizJfQe7lVLAI5+yCvv8q6P1EjgSj8/n3rRFf/zgWQGR
         jTZEYFyQV/drRKdK7YMQ8PBICdV/5dLeGEYizRzY2ytJV2JamczOoKC99TE23Oi2Pe
         uMV5FKGJR4IokUNOQfVgzqle4Ar0iss9JSBf/bWpKXINc/0zE0KLncnYEpHez0CfnP
         5DgWrCasU3O5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, shayne.chen@mediatek.com,
        greearb@candelatech.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 069/109] mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU
Date:   Fri,  1 Apr 2022 10:32:16 -0400
Message-Id: <20220401143256.1950537-69-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index 38d66411444a..93aa2242c0d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -982,6 +982,7 @@ mt7915_mac_write_txwi_80211(struct mt7915_dev *dev, __le32 *txwi,
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
+		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
 
 	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
-- 
2.34.1

