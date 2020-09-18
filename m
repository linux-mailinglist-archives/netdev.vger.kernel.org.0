Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABE626F1C9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIRCx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgIRCHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B99A2395B;
        Fri, 18 Sep 2020 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394861;
        bh=KRKeUQKw05VcBoIIUdo4APnCM5j8pGKovFeyyHAl6Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o35x9ncgJWXWlAGJuX3WLH8/fqfjzGrRbAaALFiJIS05kHXMbU+VdM3xT0AqI58Q4
         izUNuwYurDpwcD9pzoksmtyj7F76WcLLZRUbeW0cI8ADDQmGo4TEAOSYBIP8ZjUwuP
         AtKCat8sg2/dY/udTpwdXVL+pzZDMvgxizxnofoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 315/330] mac80211: skip mpath lookup also for control port tx
Date:   Thu, 17 Sep 2020 22:00:55 -0400
Message-Id: <20200918020110.2063155-315-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Theil <markus.theil@tu-ilmenau.de>

[ Upstream commit 5af7fef39d7952c0f5551afa7b821ee7b6c9dd3d ]

When using 802.1X over mesh networks, at first an ordinary
mesh peering is established, then the 802.1X EAPOL dialog
happens, afterwards an authenticated mesh peering exchange
(AMPE) happens, finally the peering is complete and we can
set the STA authorized flag.

As 802.1X is an intermediate step here and key material is
not yet exchanged for stations we have to skip mesh path lookup
for these EAPOL frames. Otherwise the already configure mesh
group encryption key would be used to send a mesh path request
which no one can decipher, because we didn't already establish
key material on both peers, like with SAE and directly using AMPE.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20200617082637.22670-2-markus.theil@tu-ilmenau.de
[remove pointless braces, remove unnecessary local variable,
 the list can only process one such frame (or its fragments)]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 30201aeb426cf..f029e75ec815a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3913,6 +3913,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb->prev = NULL;
 		skb->next = NULL;
 
+		if (skb->protocol == sdata->control_port_protocol)
+			ctrl_flags |= IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
+
 		skb = ieee80211_build_hdr(sdata, skb, info_flags,
 					  sta, ctrl_flags);
 		if (IS_ERR(skb))
@@ -5096,7 +5099,8 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 
 	if (proto == sdata->control_port_protocol)
-		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO |
+			      IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
 
 	if (unencrypted)
 		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
-- 
2.25.1

