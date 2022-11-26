Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE4663952E
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiKZKIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 05:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKZKIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 05:08:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36022018A;
        Sat, 26 Nov 2022 02:08:42 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NK6qn4RxrzmW9H;
        Sat, 26 Nov 2022 18:08:05 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 18:08:40 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 2/2] wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
Date:   Sat, 26 Nov 2022 10:06:34 +0000
Message-ID: <20221126100634.106887-3-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221126100634.106887-1-yuancan@huawei.com>
References: <20221126100634.106887-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

