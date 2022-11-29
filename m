Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4363B762
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiK2Boc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbiK2BoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:44:25 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C75442F41;
        Mon, 28 Nov 2022 17:44:24 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NLlRJ2RH5zJp0H;
        Tue, 29 Nov 2022 09:41:00 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 29 Nov
 2022 09:44:22 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH RESEND] wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
Date:   Tue, 29 Nov 2022 01:42:11 +0000
Message-ID: <20221129014211.56558-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: ce08cd344a00 ("wifi: nl80211: expose link information for interfaces")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 597c52236514..d2321c683398 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3868,6 +3868,9 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			struct cfg80211_chan_def chandef = {};
 			int ret;
 
+			if (!link)
+				goto nla_put_failure;
+
 			if (nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id))
 				goto nla_put_failure;
 			if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN,
-- 
2.17.1

