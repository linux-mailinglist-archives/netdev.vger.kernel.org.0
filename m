Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7392425F4C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbhJGVlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJGVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:41:54 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Oct 2021 14:40:00 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DD7C061570;
        Thu,  7 Oct 2021 14:40:00 -0700 (PDT)
From:   Nick Hainke <vincent@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1633642197;
        bh=MJwQ+q0KiuGyG+lblF9ElluwfUQc8/qwRfPq28lM2o8=;
        h=From:To:Cc:Subject:Date:From;
        b=aXjEQPOhEJAtZKrhCg2tupgKeTBMtvCx89IeBDqcVnMy6ZHWLTGO0bKGdJYlQN9Ri
         h7CSbS/JDUSlmtDzRgmzcxFG0IKJZY4NHP4ezxQ7EKUqrJBxNiM2OY/vlEC0XewocM
         X9OneCef1S2jmdPfB+CTkil+Hn0rLDiHRDc74tUtwetRmQigxkBEbCmsPw327FZ80Z
         w84arZxSUZ4wLDvvmf0NB9wppmMgr/fxpzlGwouDIdWwaBuAeHo/XYTIdbU2Rc7LDI
         s5eKOskI0pHDI4CcyGo7HNryZx4BkS9vNIak5JNH/C1FDiL+W003GoIKaJPYTpB3gS
         YuBoaC52Xkkgw==
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Robert Foss <robert.foss@linaro.org>,
        Nick Hainke <vincent@systemli.org>
Subject: [RFC v1] mt76: mt7615: mt7622: fix adhoc and ibss mode
Date:   Thu,  7 Oct 2021 23:23:23 +0200
Message-Id: <20211007212323.1223602-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").

commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
meshpoint support.

Both used in the "get_omac_idx"-function:

	if (~mask & BIT(HW_BSSID_0))
		return HW_BSSID_0;

With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
adhoc and meshpoint mode should "prefer hw bssid slot 1-3". However,
with that change the ibss or meshpoint mode will not send any beacon on
the mt7622 wifi anymore. Devices were still able to exchange data but
only if a bssid already existed. Two mt7622 devices will never be able
to communicate.

This commits reverts the preferation of slot 1-3 for adhoc and
meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.

Tested on Banana Pi R64.

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index dada43d6d879..51260a669d16 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -135,8 +135,6 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 	int i;
 
 	switch (type) {
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
 		/* prefer hw bssid slot 1-3 */
 		i = get_free_idx(mask, HW_BSSID_1, HW_BSSID_3);
@@ -160,6 +158,8 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 			return HW_BSSID_0;
 
 		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP:
 		/* ap uses hw bssid 0 and ext bssid */
-- 
2.33.0

