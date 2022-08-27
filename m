Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DB85A33B5
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345392AbiH0CNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345452AbiH0CNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:13:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393EB1F2D9;
        Fri, 26 Aug 2022 19:13:33 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MF0X54W3RzkWhB;
        Sat, 27 Aug 2022 10:09:57 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 10:13:31 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600010.china.huawei.com
 (7.193.23.86) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 27 Aug
 2022 10:13:30 +0800
From:   Sun Ke <sunke32@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <johannes.berg@intel.com>,
        <sunke32@huawei.com>
Subject: [PATCH] mac80211: fix potential deadlock in ieee80211_key_link()
Date:   Sat, 27 Aug 2022 10:24:52 +0800
Message-ID: <20220827022452.823381-1-sunke32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return in the error handling case.

Fixes: ccdde7c74ffd ("wifi: mac80211: properly implement MLO key handling")
Signed-off-by: Sun Ke <sunke32@huawei.com>
---
 net/mac80211/key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 86aac87e0211..d89ec93b243b 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -865,8 +865,10 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		if (link_id >= 0) {
 			link_sta = rcu_dereference_protected(sta->link[link_id],
 							     lockdep_is_held(&sta->local->sta_mtx));
-			if (!link_sta)
-				return -ENOLINK;
+			if (!link_sta) {
+				ret = -ENOLINK;
+				goto out;
+			}
 		}
 
 		old_key = key_mtx_dereference(sdata->local, link_sta->gtk[idx]);
-- 
2.31.1

