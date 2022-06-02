Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15453BAF2
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiFBOiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiFBOiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CD81248CD;
        Thu,  2 Jun 2022 07:38:06 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT5r2P5yz67bVY;
        Thu,  2 Jun 2022 22:33:36 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:38:04 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 1/9] libbpf: Introduce bpf_map_get_fd_by_id_flags()
Date:   Thu, 2 Jun 2022 16:37:40 +0200
Message-ID: <20220602143748.673971-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602143748.673971-1-roberto.sassu@huawei.com>
References: <20220602143748.673971-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_map_get_fd_by_id_flags(), to let a caller specify the open
flags needed for the operation. This could make an operation succeed, if
access to a map is restricted (i.e. it allows only certain operations).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/lib/bpf/bpf.c      | 8 +++++++-
 tools/lib/bpf/bpf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 240186aac8e6..33bac2006043 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -1047,18 +1047,24 @@ int bpf_prog_get_fd_by_id(__u32 id)
 	return libbpf_err_errno(fd);
 }
 
-int bpf_map_get_fd_by_id(__u32 id)
+int bpf_map_get_fd_by_id_flags(__u32 id, __u32 flags)
 {
 	union bpf_attr attr;
 	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_id = id;
+	attr.open_flags = flags;
 
 	fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
+int bpf_map_get_fd_by_id(__u32 id)
+{
+	return bpf_map_get_fd_by_id_flags(id, 0);
+}
+
 int bpf_btf_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index cabc03703e29..20e4c852362d 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -438,6 +438,7 @@ LIBBPF_API int bpf_map_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_btf_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_link_get_next_id(__u32 start_id, __u32 *next_id);
 LIBBPF_API int bpf_prog_get_fd_by_id(__u32 id);
+LIBBPF_API int bpf_map_get_fd_by_id_flags(__u32 id, __u32 flags);
 LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
 LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 38e284ff057d..019278e66836 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -466,6 +466,7 @@ LIBBPF_1.0.0 {
 		libbpf_bpf_link_type_str;
 		libbpf_bpf_map_type_str;
 		libbpf_bpf_prog_type_str;
+		bpf_map_get_fd_by_id_flags;
 
 	local: *;
 };
-- 
2.25.1

