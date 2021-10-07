Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6967E42601C
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhJGW7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJGW7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 18:59:41 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3EDC061570;
        Thu,  7 Oct 2021 15:57:46 -0700 (PDT)
From:   Nick Hainke <vincent@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1633647464;
        bh=+hKKdgFuA2J0aeNKNChnhg/KBV16OKZtTZZwb8uPqeY=;
        h=From:To:Cc:Subject:Date:From;
        b=YwryZknexn60K5FsltKWffap1HeK2F3iZLLPXf0VJ07q5AAPswNzzZZ7iVJrgpSok
         jb2JZ+7CFrUPnnJCFHm9B/z5Zho+IIu/pcN/Nq6KdmJm6+SDIdo9N+GS233YfR95oE
         tUTDRaS1U68aqtcPk2DWgDTTl47SkH2CmcR1JwIx+dU2J/yde8+07zslpi6nd+v1sw
         WBvx8a2UEuNMsW5EAExSDVdDfW0uOrNzHM4MdfMy2HxtHHk+wheJKiPSg/f+nOHfT+
         7BD0EDfyHLmUFRwtqp1ufJYrQOITkRKZ7iRHhFL1uZg9oo9fEaF90+E+13BE11jedN
         PCui8UphaEE+A==
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Robert Foss <robert.foss@linaro.org>,
        Nick Hainke <vincent@systemli.org>
Subject: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Date:   Fri,  8 Oct 2021 00:57:25 +0200
Message-Id: <20211007225725.2615-1-vincent@systemli.org>
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
ibss and meshpoint mode should "prefer hw bssid slot 1-3". However,
with that change the ibss or meshpoint mode will not send any beacon on
the mt7622 wifi anymore. Devices were still able to exchange data but
only if a bssid already existed. Two mt7622 devices will never be able
to communicate.

This commits reverts the preferation of slot 1-3 for ibss and
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

