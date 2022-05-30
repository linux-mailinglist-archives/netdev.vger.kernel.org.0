Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1537D5376D9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiE3Ip4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiE3Ipz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:45:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCA74D601;
        Mon, 30 May 2022 01:45:54 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LBTW66dLXz67Y9y;
        Mon, 30 May 2022 16:45:06 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 10:45:52 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 1/2] libbpf: Retry map access with read-only permission
Date:   Mon, 30 May 2022 10:45:13 +0200
Message-ID: <20220530084514.10170-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220530084514.10170-1-roberto.sassu@huawei.com>
References: <20220530084514.10170-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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

Retry map access with read-only permission, if access was denied when all
permissions were requested (open_flags is set to zero). Write access might
have been denied by the bpf_map security hook.

Some operations, such as show and dump, don't need write permissions, so
there is a good chance of success with retrying.

Prefer this solution to extending the API, as otherwise a new mechanism
would need to be implemented to determine the right permissions for an
operation.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/lib/bpf/bpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 240186aac8e6..b4eec39021a4 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -1056,6 +1056,11 @@ int bpf_map_get_fd_by_id(__u32 id)
 	attr.map_id = id;
 
 	fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+	if (fd < 0) {
+		attr.open_flags = BPF_F_RDONLY;
+		fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+	}
+
 	return libbpf_err_errno(fd);
 }
 
-- 
2.25.1

