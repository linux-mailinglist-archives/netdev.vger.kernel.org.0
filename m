Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D889248BAA4
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346155AbiAKWTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:19:47 -0500
Received: from mx2.uni-rostock.de ([139.30.22.72]:54512 "EHLO
        mx2.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiAKWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:19:47 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 17:19:46 EST
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmze; 
 t=1641939225; bh=cBNx1IF5BpVq8iSbXQ+lHnJOMBTTU4cKYGZZrhzxEwA=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=ed25519-sha256; b=
 JVrY214ffgcz4sAWnOlW/HBgOHQb9X4+ZhpX3kgtownoXqE406uUy5o1zy2DxwcXTxCIfjw4X8vFxrLRng5xCg==
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1641939225; bh=cBNx1IF5BpVq8iSbXQ+lHnJOMBTTU4cKYGZZrhzxEwA=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 eh1GHXizm1E7ETtVXwg80Dx1KEwsYqpy5XWCmhwphWMWkOrlu0MuRNAjGIUYqARh6PlMq9NaDqPD3BTDwNo6T55XksJzuL+8PknFk9KSSRpagyz7kOtbo/NaUgEcMiqn2qpaloPDUCyxSRSAFtS4o6kr3p98M2S3RoZUd+15WhY=
Received: from 139.30.22.83 by mx2.uni-rostock.de (Tls12, Aes256, Sha384,
 DiffieHellmanEllipticKey384); Tue, 11 Jan 2022 22:13:45 GMT
Received: from meshdev.amd.e-technik.uni-rostock.de (139.30.202.104) by
 email3.uni-rostock.de (139.30.22.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 11 Jan 2022 23:13:43 +0100
From:   Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: report NOACK frames in tx_status
Date:   Tue, 11 Jan 2022 22:13:26 +0000
Message-ID: <20220111221327.1499881-1-benjamin.beichler@uni-rostock.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [139.30.202.104]
X-ClientProxiedBy: EMAIL2.uni-rostock.de (139.30.22.82) To
 email3.uni-rostock.de (139.30.22.83)
X-TM-SNTS-SMTP: C4EAE77D2BE4552EEC6F13C23DB6B6CDDBEC554C5DE1860F42870C8D85E050152002:8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IEEE80211_TX_STAT_NOACK_TRANSMITTED to tx_status flags to have proper
statistics for non-acked frames.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0307a6677907..f54b515c62d5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3770,6 +3770,10 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
+
+	if (hwsim_flags & HWSIM_TX_CTL_NO_ACK)
+		txi->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
 out:
-- 
2.25.1
