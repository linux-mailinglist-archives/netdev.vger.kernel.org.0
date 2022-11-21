Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B344631BE5
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiKUIwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiKUIwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:52:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755F782217;
        Mon, 21 Nov 2022 00:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669020721; x=1700556721;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PRZcPQKEh9lZYS6k17IpBGFrKOu26GUNvPvApWrz/lc=;
  b=h2xPBvv6bNCoJlna2SRRXh4LmTgnNuMLJpOaf4C5CFsEB0R3LlCjLEuc
   mvmP20HCxKj8XCDEXAOA6Bf2/DSMBcc5q8e1RDsjaC1GKKKbqiNYJgxem
   ZJpNX5HVpxWB1VNYzrjjViQatWXIpn6CjoXqRPcdTtmGznZvQF3cf2+tP
   d2F+hsOsPPsER7e0QmYBluGc13V57JEbkyMAaJWruJGiVXzIz3NbPQUbT
   OoMN2BAiuSqKv1PgyCCUKKwkp9c6vlPI3uYCL/KEvr+NFaRlhkAJtvUAj
   HcmSPApBanNPWXwz8h0sKqqqNadrVrTQ34Z+KbDZIznFn7Gma4BGfdTLx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="313536858"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="313536858"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 00:52:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="709730243"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="709730243"
Received: from a0cec8d9c8fc.jf.intel.com ([10.45.77.137])
  by fmsmga004.fm.intel.com with ESMTP; 21 Nov 2022 00:51:46 -0800
From:   Chen Hu <hu1.chen@intel.com>
Cc:     hu1.chen@intel.com, jpoimboe@kernel.org, memxor@gmail.com,
        bpf@vger.kernel.org, Pengfei Xu <pengfei.xu@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf] selftests/bpf: Fix "missing ENDBR" BUG for destructor kfunc
Date:   Mon, 21 Nov 2022 00:51:13 -0800
Message-Id: <20221121085113.611504-1-hu1.chen@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
following BUG:

  traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
  ------------[ cut here ]------------
  kernel BUG at arch/x86/kernel/traps.c:254!
  invalid opcode: 0000 [#1] PREEMPT SMP
  <TASK>
   asm_exc_control_protection+0x26/0x50
  RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
  Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
       <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
   bpf_map_free_kptrs+0x2e/0x70
   array_map_free+0x57/0x140
   process_one_work+0x194/0x3a0
   worker_thread+0x54/0x3a0
   ? rescuer_thread+0x390/0x390
   kthread+0xe9/0x110
   ? kthread_complete_and_exit+0x20/0x20

This is because there are no compile-time references to the destructor
kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
them sealable and ENDBR in the functions were sealed (converted to NOP)
by apply_ibt_endbr().

This fix creates dummy compile-time references to destructor kfuncs so
ENDBR stay there.

Signed-off-by: Chen Hu <hu1.chen@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 include/linux/btf_ids.h | 7 +++++++
 net/bpf/test_run.c      | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 2aea877d644f..6c6b520ea58f 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
 
 extern u32 btf_tracing_ids[];
 
+#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
+#define BTF_IBT_NOSEAL(name)					\
+	asm(IBT_NOSEAL(#name));
+#else
+#define BTF_IBT_NOSEAL(name)
+#endif /* CONFIG_X86_KERNEL_IBT */
+
 #endif
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..465952e5de11 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1653,6 +1653,8 @@ BTF_ID(struct, prog_test_ref_kfunc)
 BTF_ID(func, bpf_kfunc_call_test_release)
 BTF_ID(struct, prog_test_member)
 BTF_ID(func, bpf_kfunc_call_memb_release)
+BTF_IBT_NOSEAL(bpf_kfunc_call_test_release)
+BTF_IBT_NOSEAL(bpf_kfunc_call_memb_release)
 
 static int __init bpf_prog_test_run_init(void)
 {
-- 
2.34.1

