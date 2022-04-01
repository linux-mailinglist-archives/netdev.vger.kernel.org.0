Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293564EF069
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbiDAOf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347398AbiDAOcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60171EC606;
        Fri,  1 Apr 2022 07:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB43E61CA5;
        Fri,  1 Apr 2022 14:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFF5C2BBE4;
        Fri,  1 Apr 2022 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823333;
        bh=NVhgl5DRA9+6XmU+6e5/svfpSnBLUwoq6XR+Koivd/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1wpOOIGMt/eN8NOwhu8+VkacgQkaMCwk6fd5SeSOE0T0oSH+845w5O7agCCTlUUP
         yxbKFtuEQ36wCYTRFTcKkGZ3n7yGwFEea5iM8ZLJ3OXI9gcJrX7ENggtq42r1+pW/y
         ziOLn8Zg1aUnzhxnCZEJ221tVBnB1X4LRK8rhlXzSe20jfd696k1NO7v9cCHxUPO/X
         Fh0eqnIWo9/OHuKC2Rd0TdR5Oqw1+4ykh7Luk3aCRSVOQcbqXjdoqAFfmhqktne2fP
         sjH4MbyIUp7GKWOmIHHXuczr2E8rt9z9ZcuuVqotFpk70WCC9cUG6HQS5NWuUSsjP3
         edmGd9ht3oydA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 061/149] libbpf: Fix accessing the first syscall argument on arm64
Date:   Fri,  1 Apr 2022 10:24:08 -0400
Message-Id: <20220401142536.1948161-61-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit fbca4a2f649730b67488a8b36140ce4d2cf13c63 ]

On arm64, the first syscall argument should be accessed via orig_x0
(see arch/arm64/include/asm/syscall.h). Currently regs[0] is used
instead, leading to bpf_syscall_macro test failure.

orig_x0 cannot be added to struct user_pt_regs, since its layout is a
part of the ABI. Therefore provide access to it only through
PT_REGS_PARM1_CORE_SYSCALL() by using a struct pt_regs flavor.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-10-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index d40b87c0e4b9..ad62c17919cf 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -140,6 +140,10 @@
 
 #elif defined(bpf_target_arm64)
 
+struct pt_regs___arm64 {
+	unsigned long orig_x0;
+};
+
 /* arm64 provides struct user_pt_regs instead of struct pt_regs to userspace */
 #define __PT_REGS_CAST(x) ((const struct user_pt_regs *)(x))
 #define __PT_PARM1_REG regs[0]
@@ -152,6 +156,8 @@
 #define __PT_RC_REG regs[0]
 #define __PT_SP_REG sp
 #define __PT_IP_REG pc
+#define PT_REGS_PARM1_SYSCALL(x) ({ _Pragma("GCC error \"use PT_REGS_PARM1_CORE_SYSCALL() instead\""); 0l; })
+#define PT_REGS_PARM1_CORE_SYSCALL(x) BPF_CORE_READ((const struct pt_regs___arm64 *)(x), orig_x0)
 
 #elif defined(bpf_target_mips)
 
-- 
2.34.1

