Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B638F1B8CE9
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDZGf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 02:35:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2905 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726108AbgDZGf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 02:35:26 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0291ADC130B618297987;
        Sun, 26 Apr 2020 14:35:19 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 14:35:17 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <andrii.nakryiko@gmail.com>, <dan.carpenter@oracle.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH bpf-next v3 1/2] bpf: Change error code when ops is NULL
Date:   Sun, 26 Apr 2020 14:36:34 +0800
Message-ID: <20200426063635.130680-2-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200426063635.130680-1-maowenan@huawei.com>
References: <20200426063635.130680-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)

This is because CONFIG_BPF_STREAM_PARSER is not set, and
bpf_map_types[type] return invalid ops. It is not clear to show the
cause of config missing with return code -EINVAL.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d85f37239540..8ae78c98d91e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -113,7 +113,7 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
 	ops = bpf_map_types[type];
 	if (!ops)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	if (ops->map_alloc_check) {
 		err = ops->map_alloc_check(attr);
-- 
2.20.1

