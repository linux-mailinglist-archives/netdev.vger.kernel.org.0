Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F403E18A515
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgCRU6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgCRU5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:57:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D955F208FE;
        Wed, 18 Mar 2020 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565019;
        bh=VZtQ570IgtuXtdl8BoiCwvfb4bxuN8ufWPzTwgYnKX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxAu5mkRqs3lQaDtmuy9qmtfhSjUdwfMqancNOCL3aJ6qARDHWtURb/PMLccj3qZt
         Min8g/Y2BgAsNMmYIlFqMur2P0nqNLIjVrQhtHwJ/SV2PxhHT6WXFetRoTMy4jTw6k
         c6SOHhNYF1Td2pZyn2/nOpcESCxtOqWiCpPZGovc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/12] mac80211: Do not send mesh HWMP PREQ if HWMP is disabled
Date:   Wed, 18 Mar 2020 16:56:45 -0400
Message-Id: <20200318205648.17937-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205648.17937-1-sashal@kernel.org>
References: <20200318205648.17937-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit ba32679cac50c38fdf488296f96b1f3175532b8e ]

When trying to transmit to an unknown destination, the mesh code would
unconditionally transmit a HWMP PREQ even if HWMP is not the current
path selection algorithm.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://lore.kernel.org/r/20200305140409.12204-1-cavallar@lri.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_hwmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 466922f09d048..43edcba6d67b7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1112,7 +1112,8 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!(mpath->flags & MESH_PATH_RESOLVING))
+	if (!(mpath->flags & MESH_PATH_RESOLVING) &&
+	    mesh_path_sel_is_hwmp(sdata))
 		mesh_queue_preq(mpath, PREQ_Q_F_START);
 
 	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-- 
2.20.1

