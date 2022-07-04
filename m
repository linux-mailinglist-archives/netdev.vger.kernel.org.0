Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3F565DE1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiGDTQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiGDTQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:16:14 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C152ECE33
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:16:13 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 8RYIoSrT0ZDzU8RYJoUC9X; Mon, 04 Jul 2022 21:16:12 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 04 Jul 2022 21:16:12 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Use the bitmap API to allocate bitmaps
Date:   Mon,  4 Jul 2022 21:16:09 +0200
Message-Id: <dfb438a6a199ee4c95081fa01bd758fd30e50931.1656962156.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/mac80211/mesh_plink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 55bed9ce98fe..d67011745048 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -477,8 +477,7 @@ static int mesh_allocate_aid(struct ieee80211_sub_if_data *sdata)
 	unsigned long *aid_map;
 	int aid;
 
-	aid_map = kcalloc(BITS_TO_LONGS(IEEE80211_MAX_AID + 1),
-			  sizeof(*aid_map), GFP_KERNEL);
+	aid_map = bitmap_zalloc(IEEE80211_MAX_AID + 1, GFP_KERNEL);
 	if (!aid_map)
 		return -ENOMEM;
 
@@ -491,7 +490,7 @@ static int mesh_allocate_aid(struct ieee80211_sub_if_data *sdata)
 	rcu_read_unlock();
 
 	aid = find_first_zero_bit(aid_map, IEEE80211_MAX_AID + 1);
-	kfree(aid_map);
+	bitmap_free(aid_map);
 
 	if (aid > IEEE80211_MAX_AID)
 		return -ENOBUFS;
-- 
2.34.1

