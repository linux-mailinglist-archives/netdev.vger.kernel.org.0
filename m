Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7798B52A061
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbiEQL1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiEQL1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:27:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A7E34B87;
        Tue, 17 May 2022 04:27:15 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L2YjW2BQMzgYx5;
        Tue, 17 May 2022 19:26:39 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 17 May
 2022 19:27:13 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>
CC:     <weiyongjun1@huawei.com>, <shaozhengchao@huawei.com>,
        <yuehaibing@huawei.com>
Subject: [PATCH v2,bpf-next] samples/bpf: check detach prog exist or not in xdp_fwd
Date:   Tue, 17 May 2022 19:27:48 +0800
Message-ID: <20220517112748.358295-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before detach the prog, we should check detach prog exist or not.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 samples/bpf/xdp_fwd_user.c | 52 +++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 1828487bae9a..2294486ef10a 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -47,17 +47,51 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
 	return err;
 }
 
-static int do_detach(int idx, const char *name)
+static int do_detach(int idx, const char *name, const char *prog_name)
 {
-	int err;
+	int err = 1;
+	__u32 info_len, curr_prog_id;
+	struct bpf_prog_info prog_info = {};
+	int prog_fd;
+	char namepad[BPF_OBJ_NAME_LEN];
+
+	if (bpf_xdp_query_id(idx, xdp_flags, &curr_prog_id)) {
+		printf("ERROR: bpf_xdp_query_id failed\n");
+		return err;
+	}
+
+	if (!curr_prog_id) {
+		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
+			xdp_flags, name);
+		return err;
+	}
 
-	err = bpf_xdp_detach(idx, xdp_flags, NULL);
-	if (err < 0)
-		printf("ERROR: failed to detach program from %s\n", name);
+	info_len = sizeof(prog_info);
+	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);
+	if (prog_fd < 0 && errno == ENOENT) {
+		printf("ERROR: bpf_prog_get_fd_by_id failed\n");
+		return err;
+	}
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
+	if (err) {
+		printf("ERROR: bpf_obj_get_info_by_fd failed\n");
+		return err;
+	}
+	snprintf(namepad, sizeof(namepad), "%s_prog", prog_name);
+
+	if (strcmp(prog_info.name, namepad)) {
+		printf("ERROR: %s isn't attached to %s\n", prog_name, name);
+	} else {
+		err = bpf_xdp_detach(idx, xdp_flags, NULL);
+		if (err < 0)
+			printf("ERROR: failed to detach program from %s\n",
+				name);
+		/* TODO: Remember to cleanup map, when adding use of shared map
+		 *  bpf_map_delete_elem((map_fd, &idx);
+		 */
+	}
 
-	/* TODO: Remember to cleanup map, when adding use of shared map
-	 *  bpf_map_delete_elem((map_fd, &idx);
-	 */
 	return err;
 }
 
@@ -169,7 +203,7 @@ int main(int argc, char **argv)
 			return 1;
 		}
 		if (!attach) {
-			err = do_detach(idx, argv[i]);
+			err = do_detach(idx, argv[i], prog_name);
 			if (err)
 				ret = err;
 		} else {
-- 
2.17.1

