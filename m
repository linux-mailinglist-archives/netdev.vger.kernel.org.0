Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08933B5B1A
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhF1JVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 05:21:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5923 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhF1JVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 05:21:46 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GD25p5Czlz75DV;
        Mon, 28 Jun 2021 17:15:58 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 28
 Jun 2021 17:19:15 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>,
        <maciej.fijalkowski@intel.com>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] samples/bpf: Fix xdpsock with '-M' parameter missing unload process
Date:   Mon, 28 Jun 2021 17:18:15 +0800
Message-ID: <20210628091815.2373487-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Execute the following command and exit, then execute it again, the
following error will be reported.

$ sudo ./samples/bpf/xdpsock -i ens4f2 -M
^C
$ sudo ./samples/bpf/xdpsock -i ens4f2 -M
libbpf: elf: skipping unrecognized data section(16) .eh_frame
libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
libbpf: Kernel error message: XDP program already attached
ERROR: link set xdp fd failed

commit c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock")
removed the unload prog code because of the presence of bpf_link. This
is fine if XDP_SHARED_UMEM is disable, but if it is enable, unload prog
is still needed.

Fixes: c9d27c9e8dc7 ("samples: bpf: Do not unload prog within xdpsock")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 samples/bpf/xdpsock_user.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 53e300f860bb..33d0bdebbed8 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -96,6 +96,7 @@ static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
+static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
 
@@ -461,6 +462,23 @@ static void *poller(void *arg)
 	return NULL;
 }
 
+static void remove_xdp_program(void)
+{
+	u32 curr_prog_id = 0;
+
+	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
+		printf("bpf_get_link_xdp_id failed\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (prog_id == curr_prog_id)
+		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
+	else if (!curr_prog_id)
+		printf("couldn't find a prog id on a given interface\n");
+	else
+		printf("program on interface changed, not removing\n");
+}
+
 static void int_exit(int sig)
 {
 	benchmark_done = true;
@@ -471,6 +489,9 @@ static void __exit_with_error(int error, const char *file, const char *func,
 {
 	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
 		line, error, strerror(error));
+
+	if (opt_num_xsks > 1)
+		remove_xdp_program();
 	exit(EXIT_FAILURE);
 }
 
@@ -490,6 +511,9 @@ static void xdpsock_cleanup(void)
 		if (write(sock, &cmd, sizeof(int)) < 0)
 			exit_with_error(errno);
 	}
+
+	if (opt_num_xsks > 1)
+		remove_xdp_program();
 }
 
 static void swap_mac_addresses(void *data)
@@ -857,6 +881,10 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
 	if (ret)
 		exit_with_error(-ret);
 
+	ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
+	if (ret)
+		exit_with_error(-ret);
+
 	xsk->app_stats.rx_empty_polls = 0;
 	xsk->app_stats.fill_fail_polls = 0;
 	xsk->app_stats.copy_tx_sendtos = 0;
-- 
2.17.1

