Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767A39108A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfHQNa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:29 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41573 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E84A820D5;
        Sat, 17 Aug 2019 09:30:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=P1rm92h4dBKRE32uuSGa2030s95LDr78Wk1QK+5WDYo=; b=mRMyqZRC
        HKT4ii/c6nG3zQYoXn4VYbziDjR3sKbxYYRtnAAiwQZLObpuwJZYco+Ab2h3iVa1
        HsmnAf7lIGx4f8NROS4TkZObEWxnnrszvdySXTxL/B8Tsl+yRMFgx0taHUu7nprU
        SRq9X/Drlifp6bykhgS/Kdh04yXqiyEuq2/O0cGUaVHBs0wZMMmtYU9XoX4DaU3p
        gvhZBgrsmwz/wO2uFTMXVVS1c2xbQ89/Ag13BNUn3d77QDChTLDP2h4kIvUwXVaV
        /VHjGFvV00qzrYLW7MOr48oqpbLL0lWADtwaYimOACNVXFoUUym37FOsmNirawt+
        Xjx6HPKL19SNmQ==
X-ME-Sender: <xms:cwFYXRUPm9G_udvIoNjJlmVvBerE38U8ig6P9QXT7cMaDiND9LaSOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:cwFYXcN5bi0J4qjcApwU_jEpHVjeSFRv3aU_S-jqR5sSQVZ-rdTcGw>
    <xmx:cwFYXTbA1ARD4Bb9dtw-CrlhXkedctUzrspMr6rP8S3jPi4Q02Jzgw>
    <xmx:cwFYXT9XFQJUvj27zoDjxz2yVK6YaErfxkUUslIMA-6zMyVNGjMR9A>
    <xmx:cwFYXashmYPnN7aJM3Xmk1ToN5qA2O3yqI1rbhs1ch_wO3AEyVVLmg>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 924FA80066;
        Sat, 17 Aug 2019 09:30:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 04/16] drop_monitor: Consider all monitoring states before performing configuration
Date:   Sat, 17 Aug 2019 16:28:13 +0300
Message-Id: <20190817132825.29790-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The drop monitor configuration (e.g., alert mode) is global, but user
will be able to enable monitoring of only software or hardware drops.

Therefore, ensure that monitoring of both software and hardware drops are
disabled before allowing drop monitor configuration to take place.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 6020f34728af..a2c7f9162c9d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -633,6 +633,11 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
 	return rc;
 }
 
+static bool net_dm_is_monitoring(void)
+{
+	return trace_state == TRACE_ON || monitor_hw;
+}
+
 static int net_dm_alert_mode_get_from_info(struct genl_info *info,
 					   enum net_dm_alert_mode *p_alert_mode)
 {
@@ -694,8 +699,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	int rc;
 
-	if (trace_state == TRACE_ON) {
-		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor while tracing is on");
+	if (net_dm_is_monitoring()) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor during monitoring");
 		return -EBUSY;
 	}
 
-- 
2.21.0

