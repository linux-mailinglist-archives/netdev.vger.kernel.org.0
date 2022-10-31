Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C97D613179
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 09:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJaIMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 04:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJaIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 04:12:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14C9764D;
        Mon, 31 Oct 2022 01:12:15 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N15Q274sxzpW59;
        Mon, 31 Oct 2022 16:08:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 16:12:13 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net] openvswitch: add missing resv_start_op initialization for dp_vport_genl_family
Date:   Mon, 31 Oct 2022 16:12:10 +0800
Message-ID: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a warning using the latest mainline codes to start vms as following:

===================================================
WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x6c/0x76c
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-00886-g882ad2a2a8ff #43
...
Call trace:
 genl_register_family+0x6c/0x76c
 dp_init+0xa8/0x124
 do_one_initcall+0x84/0x450

It is because that commit 9c5d03d36251 ("genetlink: start to validate
reserved header bytes") has missed the resv_start_op initialization
for dp_vport_genl_family, and commit ce48ebdd5651 ("genetlink: limit
the use of validation workarounds to old ops") add checking warning.

Add resv_start_op initialization for dp_vport_genl_family to fix it.

Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/openvswitch/datapath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 155263e73512..8b84869eb2ac 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2544,6 +2544,7 @@ struct genl_family dp_vport_genl_family __ro_after_init = {
 	.parallel_ops = true,
 	.small_ops = dp_vport_genl_ops,
 	.n_small_ops = ARRAY_SIZE(dp_vport_genl_ops),
+	.resv_start_op = OVS_VPORT_CMD_SET + 1,
 	.mcgrps = &ovs_dp_vport_multicast_group,
 	.n_mcgrps = 1,
 	.module = THIS_MODULE,
-- 
2.25.1

