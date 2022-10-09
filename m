Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0649F5F8F8F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiJIWKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJIWJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:09:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8062871C;
        Sun,  9 Oct 2022 15:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1135660CEF;
        Sun,  9 Oct 2022 22:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BF4C43470;
        Sun,  9 Oct 2022 22:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353317;
        bh=GJeaeIkDAEUuIJcDNZjeybF29CHLuR5Wi0Dd2XNAshU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV1Is/G8N0fP2fgVvQfGYxVeb2Pm/FOIUyy2x5mBtLomxkaL7QcSvyP8a1H+vLxWq
         LftzorEJ+AuvnVyko9Zu87SK8h+88VXHFlIYbv4NM6WKongr4VnXMhTFbbYSd/xjtG
         9rmDoZ8HQmVeGI1LO6AK9s1wnRaikgsdee2++zJv7HtAa0uV0SpkPitsiw19VJa3nX
         x9Gm+MQhcVJuqWClKeRPyLxF4xYUeUFpYwgQKrud3if42xhH2pTGiGhK6cg8XNrKfQ
         3nrP1h6UgmEUhyGy36l0t6ZqfrzD6FIHkvIBokQuqeKSEtyoDIplWYCeW4Qyl5FFNb
         hH8nHYXOy+14A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 15/77] wifi: mac80211: accept STA changes without link changes
Date:   Sun,  9 Oct 2022 18:06:52 -0400
Message-Id: <20221009220754.1214186-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b303835dabe0340f932ebb4e260d2229f79b0684 ]

If there's no link ID, then check that there are no changes to
the link, and if so accept them, unless a new link is created.
While at it, reject creating a new link without an address.

This fixes authorizing an MLD (peer) that has no link 0.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a4f6971b7a19..167acf843d75 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1610,6 +1610,18 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 		rcu_dereference_protected(sta->link[link_id],
 					  lockdep_is_held(&local->sta_mtx));
 
+	/*
+	 * If there are no changes, then accept a link that doesn't exist,
+	 * unless it's a new link.
+	 */
+	if (params->link_id < 0 && !new_link &&
+	    !params->link_mac && !params->txpwr_set &&
+	    !params->supported_rates_len &&
+	    !params->ht_capa && !params->vht_capa &&
+	    !params->he_capa && !params->eht_capa &&
+	    !params->opmode_notif_used)
+		return 0;
+
 	if (!link || !link_sta)
 		return -EINVAL;
 
@@ -1625,6 +1637,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					     params->link_mac)) {
 			return -EINVAL;
 		}
+	} else if (new_link) {
+		return -EINVAL;
 	}
 
 	if (params->txpwr_set) {
-- 
2.35.1

