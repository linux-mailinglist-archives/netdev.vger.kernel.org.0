Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9794E8B1A2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfHMHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:55:53 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41599 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727501AbfHMHzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:55:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7127630D0;
        Tue, 13 Aug 2019 03:55:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Lv+Ihoio00htzQ5kHgeXxEPrB4CdSW8OhaaVdGOJ1oE=; b=o0G7JH9E
        KfwvdZoloAyANjeA419mmVmeMSW7luCNf+ee/y5U5f15oGwzwXuBjEvryVd8H8ql
        Nr9N8wUAEiffM4UpB9bxsYM5/iu1+l2zcoPa20RgPEcg0baqVqHm62R1ZMrZR8WE
        mJodlTatPdfWwhxAnlmMpK/Lx84rfuByKJ2zSx4wUtX2sLWcA7iP7TUVev5MJhfr
        gQGxlAbri3qCnspuqnB1Hh+FUdcMOCQGbBEGZqMii3ZeBXARJ0uUNT5XVu4dUqwc
        WrgEjF9+IFqjz9bjPXitB/QZneugHsyWRUFgztNcI/mTHsXdvqXjY16UFBJwsMg+
        j79lUHqQ0x7C0A==
X-ME-Sender: <xms:B21SXSq8BWPl1MF1n5QP5WRN5S8_xblFxbpzy3fqJoJpLI_860daZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepud
X-ME-Proxy: <xmx:B21SXefnVgzA3_ia8D0N_cSHIl79rqTeilZsB3_maAgAqLwXNcexcw>
    <xmx:B21SXRp9jx3XJFxT4Ov4Hqxeus8l3NsJlFRUdHCHPl5-1i8lm0Ezeg>
    <xmx:B21SXfHtC6_mzm_JfiWMnAYLRsocctOBI1mOn2EDv7n0RvX3Mwvrgg>
    <xmx:B21SXdowPt5ML6XUwoKYkSinupbiwF-ueWiGlf5M1Etb_yDxTe-WXw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2A6480060;
        Tue, 13 Aug 2019 03:55:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/14] drop_monitor: Initialize hardware per-CPU data
Date:   Tue, 13 Aug 2019 10:53:48 +0300
Message-Id: <20190813075400.11841-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Like software drops, hardware drops also need the same type of per-CPU
data. Therefore, initialize it during module initialization and
de-initialize it during module exit.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 349ab78b8c3e..aa9147a18329 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -76,6 +76,7 @@ struct dm_hw_stat_delta {
 static struct genl_family net_drop_monitor_family;
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);
+static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_hw_cpu_data);
 
 static int dm_hit_limit = 64;
 static int dm_delay = 1;
@@ -966,6 +967,22 @@ static void net_dm_cpu_data_fini(int cpu)
 	__net_dm_cpu_data_fini(data);
 }
 
+static void net_dm_hw_cpu_data_init(int cpu)
+{
+	struct per_cpu_dm_data *hw_data;
+
+	hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+	__net_dm_cpu_data_init(hw_data);
+}
+
+static void net_dm_hw_cpu_data_fini(int cpu)
+{
+	struct per_cpu_dm_data *hw_data;
+
+	hw_data = &per_cpu(dm_hw_cpu_data, cpu);
+	__net_dm_cpu_data_fini(hw_data);
+}
+
 static int __init init_net_drop_monitor(void)
 {
 	int cpu, rc;
@@ -992,8 +1009,10 @@ static int __init init_net_drop_monitor(void)
 
 	rc = 0;
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		net_dm_cpu_data_init(cpu);
+		net_dm_hw_cpu_data_init(cpu);
+	}
 
 	goto out;
 
@@ -1014,8 +1033,10 @@ static void exit_net_drop_monitor(void)
 	 * we are guarnateed not to have any current users when we get here
 	 */
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
+		net_dm_hw_cpu_data_fini(cpu);
 		net_dm_cpu_data_fini(cpu);
+	}
 
 	BUG_ON(genl_unregister_family(&net_drop_monitor_family));
 }
-- 
2.21.0

