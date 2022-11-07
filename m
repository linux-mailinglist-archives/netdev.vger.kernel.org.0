Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8261EECA
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiKGJX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiKGJXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:23:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFA717068;
        Mon,  7 Nov 2022 01:23:51 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5QgH0zSyzpWDJ;
        Mon,  7 Nov 2022 17:20:11 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:47 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 17:23:46 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <asavkov@redhat.com>, <delyank@fb.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf v2 2/5] bpf: Adjust sk size check for sk in bpf_skb_is_valid_access for CO_RE in 32-bit arch
Date:   Mon, 7 Nov 2022 17:20:29 +0800
Message-ID: <20221107092032.178235-3-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20221107092032.178235-1-yangjihong1@huawei.com>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code -EACCES is returned when bpf prog is tested in 32-bit arch.
This is because bpf_object__relocate modifies instruction to change memory
size to 4 bytes, as shown in the following messages:

libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4

As a result, the bpf_skb_is_valid_access check fails, for 32-bit arch,
adjust check sk size.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 net/core/filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..47cbad2e609f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8269,7 +8269,13 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 			return false;
 		break;
 	case offsetof(struct __sk_buff, sk):
-		if (type == BPF_WRITE || size != sizeof(__u64))
+		/* CO_RE adjusts pointer accesses from 8-byte read to
+		 * 4-byte reads in 32-bit host arch, so 32-bit can only
+		 * read the 32-bit pointer or the full 64-bit value,
+		 * and 64-bit can read write the 64-bit pointer.
+		 */
+		if (type == BPF_WRITE ||
+		    (size != sizeof(struct bpf_sock *) && size != sizeof(__u64)))
 			return false;
 		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
 		break;
-- 
2.30.GIT

