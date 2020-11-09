Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5244A2AB185
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgKIHBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:01:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7471 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgKIHBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:01:07 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CV22h64k8zhjPL;
        Mon,  9 Nov 2020 15:01:00 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 15:01:02 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <toke@redhat.com>, <quentin@isovalent.com>,
        <danieltimlee@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] tools: bpftool: Add missing close before bpftool net attach exit
Date:   Mon, 9 Nov 2020 15:04:10 +0800
Message-ID: <20201109070410.65833-1-wanghai38@huawei.com>
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
 tools/bpf/bpftool/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 910e7bac6e9e..3e9b40e64fb0 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -600,12 +600,14 @@ static int do_attach(int argc, char **argv)
 	if (err < 0) {
 		p_err("interface %s attach failed: %s",
 		      attach_type_strings[attach_type], strerror(-err));
+		close(progfd);
 		return err;
 	}
 
 	if (json_output)
 		jsonw_null(json_wtr);
 
+	close(progfd);
 	return 0;
 }
 
-- 
2.17.1

