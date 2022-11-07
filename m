Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286CF61EEC2
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiKGJXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiKGJXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:23:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17139B7CA;
        Mon,  7 Nov 2022 01:23:49 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5QlD4VnTzmVkC;
        Mon,  7 Nov 2022 17:23:36 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [PATCH bpf v2 1/5] bpf: Adapt 32-bit return value kfunc for 32-bit ARM when zext extension
Date:   Mon, 7 Nov 2022 17:20:28 +0800
Message-ID: <20221107092032.178235-2-yangjihong1@huawei.com>
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

For ARM32 architecture, if data width of kfunc return value is 32 bits,
need to do explicit zero extension for high 32-bit, insn_def_regno should
return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7f0a9f6cb889..bac37757ffca 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2404,6 +2404,9 @@ static int insn_def_regno(const struct bpf_insn *insn)
 {
 	switch (BPF_CLASS(insn->code)) {
 	case BPF_JMP:
+		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
+			return insn->dst_reg;
+		fallthrough;
 	case BPF_JMP32:
 	case BPF_ST:
 		return -1;
-- 
2.30.GIT

