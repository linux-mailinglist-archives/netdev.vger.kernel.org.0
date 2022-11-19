Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747066309D9
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiKSCTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiKSCTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:19:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7C6BCDC8;
        Fri, 18 Nov 2022 18:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B36562836;
        Sat, 19 Nov 2022 02:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4879C4315B;
        Sat, 19 Nov 2022 02:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824048;
        bh=S+z5YfB3i4OEKPPY2KBWgFeIQbit3Q3Tk4lqP7UErRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LN+yTgLkDqC45APPFuZTgbVj6baQK5ki3xUSwrCeB2tdSfUbGLRtP6XMARf9s5/zR
         V2BEIIYPkSDfGfPrJrBdyBhKapWF3HcINb3Zk6UoafEkEFIVoArkOfs//uW4Ndf/4b
         MSinnStgPqp9TOlMX8o5ele4AqyUXIC4bnTNGAspSUBfo2Z5W/ukuTIa0ohKhgMTtq
         ury+T9ELoHPY+zuglfepQGGctjru8iigwIG+ianuFWvxvYvjpyD1AkvaEhZ7IyGRxF
         EHHyvzWjesPNZOd37bGf2/YEl13V4znLK/Aue5jhy1M4xRJJk3NvakQOsdCr+4JNiz
         w04TjQRlN86sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/27] wifi: mac80211: Fix ack frame idr leak when mesh has no route
Date:   Fri, 18 Nov 2022 21:13:31 -0500
Message-Id: <20221119021352.1774592-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021352.1774592-1-sashal@kernel.org>
References: <20221119021352.1774592-1-sashal@kernel.org>
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

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 39e7b5de9853bd92ddbfa4b14165babacd7da0ba ]

When trying to transmit an data frame with tx_status to a destination
that have no route in the mesh, then it is dropped without recrediting
the ack_status_frames idr.

Once it is exhausted, wpa_supplicant starts failing to do SAE with
NL80211_CMD_FRAME and logs "nl80211: Frame command failed".

Use ieee80211_free_txskb() instead of kfree_skb() to fix it.

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://lore.kernel.org/r/20221027140133.1504-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index acc1c299f1ae..69d5e1ec6ede 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -710,7 +710,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb)
 {
-	kfree_skb(skb);
+	ieee80211_free_txskb(&sdata->local->hw, skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
-- 
2.35.1

