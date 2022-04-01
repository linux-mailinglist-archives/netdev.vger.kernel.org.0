Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D260C4EF0C3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347808AbiDAOgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347402AbiDAOcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:32:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214851EB83E;
        Fri,  1 Apr 2022 07:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA1DB824AF;
        Fri,  1 Apr 2022 14:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B315C34114;
        Fri,  1 Apr 2022 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823331;
        bh=zel5AscGqfMdJemGDD3WKGXXWhNB8nDc3/pFoOF9KFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQEtTCqR/kxYUcDjplAiz/b6qFKIEjESC4/MBhBM9PsIfs/M4Qj0Jik2F78QxNFqe
         Nu6YV59YRa95/NpV5rPaMPL6PVwfBUTFf2oau1794QCmMvvnwF0pbms9hzkLvkiDqn
         bklqrpG+2xTZCblDQUyu4mUBtB0+VrZiX6x94wWFk0RToZmmPa3Ip4ZxFpvo8bSyjx
         7YoIVWNgZ3yr/FIY1WgoDDI0EP5LuquPZSgoYUujDI7Rxb/td3Gh+aCBjlkatfXtJY
         lqpiDTszsGYRhrZI7T8hZeRhbnX4uNI+7RojfLuajDlkl+tspz47uZj5TWfa0mP6YC
         IvkhQY+umW8ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 060/149] libbpf: Fix accessing syscall arguments on powerpc
Date:   Fri,  1 Apr 2022 10:24:07 -0400
Message-Id: <20220401142536.1948161-60-sashal@kernel.org>
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

[ Upstream commit f07f1503469b11b739892d50c836992ffbe026ee ]

powerpc does not select ARCH_HAS_SYSCALL_WRAPPER, so its syscall
handlers take "unpacked" syscall arguments. Indicate this to libbpf
using PT_REGS_SYSCALL_REGS macro.

Reported-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Link: https://lore.kernel.org/bpf/20220209021745.2215452-5-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 90f56b0f585f..d40b87c0e4b9 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -178,6 +178,8 @@
 #define __PT_RC_REG gpr[3]
 #define __PT_SP_REG sp
 #define __PT_IP_REG nip
+/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER. */
+#define PT_REGS_SYSCALL_REGS(ctx) ctx
 
 #elif defined(bpf_target_sparc)
 
-- 
2.34.1

