Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5727708AE
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfGVSdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:33:35 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43931 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbfGVSde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:33:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0ABFD2489;
        Mon, 22 Jul 2019 14:33:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Jul 2019 14:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=s5t4OlPP3JGpyDqXoD3iDJ4e7Ue64A23Mwi1MmpY2yU=; b=l2iALN7A
        HFrYMRRjgj3SJScUxxGGA7tLNaF8S0EeV2VE0Wzz46ZC4GCJuJjtWospgpvK/U1W
        FZsFZTIiASAPlf8lnphZDrabI6sjGjzjWTHzVr7hiKKABvS4E3cxIAU+8hwzciWA
        plXwK2iGT3MeHkzXvZpkXytz/lgQzY9X9pdKr2uZ4yfr3Obz9+IT5GNlwGuKMta+
        rWkYNoJB4wscudcsfEInhbVmCZl9qTqscpQ1Z8XPA0MPm+d6+/zVZ3nanjdqGTvd
        1OOsF8aKLQdkwrkDzgB6eke7N/Rs0ZlFV3oy1USH9RmKWbQYOsA03a7T9+quJ3v+
        wCJCqPdkCIgPFw==
X-ME-Sender: <xms:fQE2XdaKtZlIVLPwqU1b2qEYDuKA8zArc8UNGILUQc6U8Ejq7A5Vaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:fQE2XW0bmVLvTsn2OpOhBP00_awrwikWp5DXqHghiw-lqwIRMqjAwQ>
    <xmx:fQE2XQJh9adZyAJ5vDGx9QsDSClNwuYhQlnysC-J2pwGfpEqHOXISw>
    <xmx:fQE2XTLLsLEZkQyXPGrk39u5Lfy_4mdlAvxGjscAJCVGCpnauNwIuw>
    <xmx:fgE2Xfs_t8Gix04kfzC1ytmtr45JRSQRhassNsrltuetfrxdBYQGIg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B3C180059;
        Mon, 22 Jul 2019 14:33:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, toke@redhat.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 06/12] drop_monitor: Use pre_doit / post_doit hooks
Date:   Mon, 22 Jul 2019 21:31:28 +0300
Message-Id: <20190722183134.14516-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Each operation from user space should be protected by the global drop
monitor mutex. Use the pre_doit / post_doit hooks to take / release the
lock instead of doing it explicitly in each function.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/core/drop_monitor.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 1d463c0d4bc5..099000930736 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -75,6 +75,20 @@ static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
 
+static int net_dm_nl_pre_doit(const struct genl_ops *ops,
+			      struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_lock(&net_dm_mutex);
+
+	return 0;
+}
+
+static void net_dm_nl_post_doit(const struct genl_ops *ops,
+				struct sk_buff *skb, struct genl_info *info)
+{
+	mutex_unlock(&net_dm_mutex);
+}
+
 static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
 	size_t al;
@@ -247,12 +261,9 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *temp;
 
-	mutex_lock(&net_dm_mutex);
-
 	if (state == trace_state) {
 		NL_SET_ERR_MSG_MOD(extack, "Trace state already set to requested state");
-		rc = -EAGAIN;
-		goto out_unlock;
+		return -EAGAIN;
 	}
 
 	switch (state) {
@@ -296,9 +307,6 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	else
 		rc = -EINPROGRESS;
 
-out_unlock:
-	mutex_unlock(&net_dm_mutex);
-
 	return rc;
 }
 
@@ -384,6 +392,8 @@ static struct genl_family net_drop_monitor_family __ro_after_init = {
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
+	.pre_doit	= net_dm_nl_pre_doit,
+	.post_doit	= net_dm_nl_post_doit,
 	.module		= THIS_MODULE,
 	.ops		= dropmon_ops,
 	.n_ops		= ARRAY_SIZE(dropmon_ops),
-- 
2.21.0

