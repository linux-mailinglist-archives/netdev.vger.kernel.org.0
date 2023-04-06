Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556E86D8F88
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 08:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbjDFGfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 02:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbjDFGfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 02:35:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377193C7;
        Wed,  5 Apr 2023 23:34:59 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PsWq11TJ7zSkWK;
        Thu,  6 Apr 2023 14:31:09 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 6 Apr
 2023 14:34:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <corbet@lwn.net>, <dsahern@kernel.org>,
        <kuniyu@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
Date:   Thu, 6 Apr 2023 14:34:50 +0800
Message-ID: <20230406063450.19572-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
shift exponent 255 is too large for 32-bit type 'int'
CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x136/0x150
 __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
 tcp_init_transfer.cold+0x3a/0xb9
 tcp_finish_connect+0x1d0/0x620
 tcp_rcv_state_process+0xd78/0x4d60
 tcp_v4_do_rcv+0x33d/0x9d0
 __release_sock+0x133/0x3b0
 release_sock+0x58/0x1b0

'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 Documentation/networking/ip-sysctl.rst | 2 ++
 net/ipv4/sysctl_net_ipv4.c             | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 87dd1c5283e6..58a78a316697 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -340,6 +340,8 @@ tcp_app_win - INTEGER
 	Reserve max(window/2^tcp_app_win, mss) of window for application
 	buffer. Value 0 is special, it means that nothing is reserved.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 31
 
 tcp_autocorking - BOOLEAN
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0d0cc4ef2b85..40fe70fc2015 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -25,6 +25,7 @@ static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
+static int tcp_app_win_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
@@ -1198,6 +1199,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_app_win_max,
 	},
 	{
 		.procname	= "tcp_adv_win_scale",
-- 
2.34.1

