Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF24EF109
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347995AbiDAOgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347411AbiDAOcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:32:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7257B1EC617;
        Fri,  1 Apr 2022 07:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C48BB8250D;
        Fri,  1 Apr 2022 14:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B04C3410F;
        Fri,  1 Apr 2022 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823334;
        bh=VxRjH+yePUztBpyRJiPML7F1J4TddIPIrzTvUM1JGE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/q/YFw14T6YKzP7qYP/MhYEhYguTJsuDGMIPZtZEhmI4/FloN0JBIrTvdvt/QKQF
         yhySXqiIwD2u6ioQvuwqucbN5K5XiwOWWWgpRs8yBCTnYByBH2u3bSjOE4mQWl2s5Z
         R/TyYMDHL65BBI5wCcpoB8sR+yWN7DMd9BqEtha0d1ZrbgSbDBphw+zDliCSj4jmhp
         K7vS/L1s0uK5UjENmcQVEgT/nPom3LGFyCisGLbr1na98wVvBaChUE7d3UB+ltgyuK
         9ggBTQJdtMCJtktMyzZBIhCbskYGLPqKha67E6qA2glTDDDFwl+fujP4PLSytdasnn
         bvGF5OG2+fG/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 062/149] libbpf: Fix accessing the first syscall argument on s390
Date:   Fri,  1 Apr 2022 10:24:09 -0400
Message-Id: <20220401142536.1948161-62-sashal@kernel.org>
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

[ Upstream commit 1f22a6f9f9a0f50218a11a0554709fd34a821fa3 ]

On s390, the first syscall argument should be accessed via orig_gpr2
(see arch/s390/include/asm/syscall.h). Currently gpr[2] is used
instead, leading to bpf_syscall_macro test failure.

orig_gpr2 cannot be added to user_pt_regs, since its layout is a part
of the ABI. Therefore provide access to it only through
PT_REGS_PARM1_CORE_SYSCALL() by using a struct pt_regs flavor.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-11-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index ad62c17919cf..92bf90e716ea 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -112,6 +112,10 @@
 
 #elif defined(bpf_target_s390)
 
+struct pt_regs___s390 {
+	unsigned long orig_gpr2;
+};
+
 /* s390 provides user_pt_regs instead of struct pt_regs to userspace */
 #define __PT_REGS_CAST(x) ((const user_pt_regs *)(x))
 #define __PT_PARM1_REG gprs[2]
@@ -124,6 +128,8 @@
 #define __PT_RC_REG gprs[2]
 #define __PT_SP_REG gprs[15]
 #define __PT_IP_REG psw.addr
+#define PT_REGS_PARM1_SYSCALL(x) ({ _Pragma("GCC error \"use PT_REGS_PARM1_CORE_SYSCALL() instead\""); 0l; })
+#define PT_REGS_PARM1_CORE_SYSCALL(x) BPF_CORE_READ((const struct pt_regs___s390 *)(x), orig_gpr2)
 
 #elif defined(bpf_target_arm)
 
-- 
2.34.1

