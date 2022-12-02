Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD163FF7B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiLBE3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBE3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:29:42 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE4BBF669;
        Thu,  1 Dec 2022 20:29:41 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NNg1h5QMXzmWK1;
        Fri,  2 Dec 2022 12:28:56 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 2 Dec
 2022 12:29:39 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <sara.sharon@intel.com>, <luciano.coelho@intel.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH v2] wifi: mac80211: fix memory leak in ieee80211_register_hw()
Date:   Fri, 2 Dec 2022 12:38:38 +0800
Message-ID: <20221202043838.2324539-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ieee80211_init_rate_ctrl_alg() failed in ieee80211_register_hw(),
it doesn't release local->fq. The memory leakage information is as
follows:
unreferenced object 0xffff888109cad400 (size 512):
  comm "insmod", pid 15145, jiffies 4295005736 (age 3670.100s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d1eb4a9f>] __kmalloc+0x3e/0xb0
    [<00000000befc3e34>] ieee80211_txq_setup_flows+0x1fe/0xa10
    [<00000000b13f1457>] ieee80211_register_hw+0x1b64/0x3950
    [<00000000ba9f4e99>] 0xffffffffa02214db
    [<00000000833435c0>] 0xffffffffa024048d
    [<00000000a4ddd6ef>] do_one_initcall+0x10f/0x630
    [<0000000068f29e16>] do_init_module+0x19f/0x5e0
    [<00000000f52609b6>] load_module+0x64b7/0x6eb0
    [<00000000b628a5b3>] __do_sys_finit_module+0x140/0x200
    [<00000000c7f35d15>] do_syscall_64+0x35/0x80
    [<0000000044d8d0fd>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: a50e5fb8db83 ("mac80211: fix a kernel panic when TXing after TXQ teardown")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: Don't remove flows clear action in ieee80211_remove_interfaces()
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 02b5abc7326b..18edf0591c2e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1326,6 +1326,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 					      hw->rate_control_algorithm);
 	rtnl_unlock();
 	if (result < 0) {
+		ieee80211_txq_teardown_flows(local);
 		wiphy_debug(local->hw.wiphy,
 			    "Failed to initialize rate control algorithm\n");
 		goto fail_rate;
@@ -1364,6 +1365,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 		sband = kmemdup(sband, sizeof(*sband), GFP_KERNEL);
 		if (!sband) {
+			ieee80211_txq_teardown_flows(local);
 			result = -ENOMEM;
 			goto fail_rate;
 		}
-- 
2.34.1

