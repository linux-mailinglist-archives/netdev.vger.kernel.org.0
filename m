Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74891088
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfHQNaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50307 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbfHQNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BF6D92096;
        Sat, 17 Aug 2019 09:30:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Lv+Ihoio00htzQ5kHgeXxEPrB4CdSW8OhaaVdGOJ1oE=; b=zGNTljzH
        tFY9eN6b6aCBUv+eW2JZsVx3BLsXGBhbe82w3A6rFDcLBOMQb/7JIT+1iDto/PZp
        KM3P8+ROcBMNaYmoLUVXR4ku+zWav5K1n0UB+s1Mwad64M7VtviiEGM7CfcQRlJ/
        5Lj8xMryBM4gGqXcRkZ1JherLMqywP5lYhimdIFQryjhtLFWyrOCI202P59z3tWQ
        ppMeTUl1C2pQyvXJxDYoUWNz8G4zUhkbREJZ8ZhPKnWEQR57iWGEdPb03Q/o5XWD
        DFXxu7qcCkfaD49DkKn+thNjGeYNlwG4ZrVQJG/EaRiTK095RmG5vKgD/mB7i46D
        1k1Zw846MMhGbA==
X-ME-Sender: <xms:bAFYXQ5zU7BiGhbsN9mIPIfakxiO_1zEbHmThQ1hFIA51_2K5pY5eQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:bAFYXZdwR_0MCbCwkOrKRCSpFGpeawM--t0vzfB_VQqYKGTJ8Zs-Cw>
    <xmx:bAFYXXC3_mc-KwmJAGIIH5Gu5EYVZPeQfW2Ax_jQ8B3WX4ChO_kgdA>
    <xmx:bAFYXVFCtejc8ZfdfyadzdRxFWfBA3ecNhoP10SW5hONp3iV3Nm61g>
    <xmx:bAFYXWO66RqrGxSIYJL_jkkLWJaBrs0Fy3S08kdNNEA4N7ffLxExTA>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0597D80062;
        Sat, 17 Aug 2019 09:30:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 02/16] drop_monitor: Initialize hardware per-CPU data
Date:   Sat, 17 Aug 2019 16:28:11 +0300
Message-Id: <20190817132825.29790-3-idosch@idosch.org>
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

