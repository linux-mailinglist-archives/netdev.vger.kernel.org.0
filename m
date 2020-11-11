Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD85C2AF291
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKKNvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:51:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7883 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbgKKNvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:51:33 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CWR3536z3z75dk;
        Wed, 11 Nov 2020 21:51:13 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 21:51:21 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <john.fastabend@gmail.com>, <quentin@isovalent.com>,
        <mrostecki@opensuse.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <toke@redhat.com>,
        <danieltimlee@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 bpf] tools: bpftool: Add missing close before bpftool net attach exit
Date:   Wed, 11 Nov 2020 21:54:25 +0800
Message-ID: <20201111135425.56533-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
it should be closed.

Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v2->v3: add 'err = 0' before successful return
v1->v2: use cleanup tag instead of repeated closes
 tools/bpf/bpftool/net.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 910e7bac6e9e..f927392271cc 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
 
 	ifindex = net_parse_dev(&argc, &argv);
 	if (ifindex < 1) {
-		close(progfd);
-		return -EINVAL;
+		err = -EINVAL;
+		goto cleanup;
 	}
 
 	if (argc) {
@@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
 			overwrite = true;
 		} else {
 			p_err("expected 'overwrite', got: '%s'?", *argv);
-			close(progfd);
-			return -EINVAL;
+			err = -EINVAL;
+			goto cleanup;
 		}
 	}
 
@@ -597,16 +597,20 @@ static int do_attach(int argc, char **argv)
 		err = do_attach_detach_xdp(progfd, attach_type, ifindex,
 					   overwrite);
 
-	if (err < 0) {
+	if (err) {
 		p_err("interface %s attach failed: %s",
 		      attach_type_strings[attach_type], strerror(-err));
-		return err;
+		goto cleanup;
 	}
 
 	if (json_output)
 		jsonw_null(json_wtr);
 
-	return 0;
+	err = 0;
+
+cleanup:
+	close(progfd);
+	return err;
 }
 
 static int do_detach(int argc, char **argv)
-- 
2.17.1

