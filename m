Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76334C0912
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiBWCeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbiBWCdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F40C54687;
        Tue, 22 Feb 2022 18:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A098F61558;
        Wed, 23 Feb 2022 02:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBE7C340EB;
        Wed, 23 Feb 2022 02:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583461;
        bh=124lfYyWE+LaMgjw4Q4I4/7cB+m2kmkCj43VRGmBnI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN1xHdQYHya3PP5WCJGepIbV1ubaGK2TEsVPVDq7wPFTgNIK1lo/6bl0YbtMJBakn
         Y9sIW06B8Avy1LLospBiIGaBHsoe3IrYgh01xf4atmfK19AJM/aFaxATjE+VPnBb1w
         P9c8OiLaSTt/sGKvOmMu2oJmYBR8KSff+T9nJJm6KsRhUWCDFLcOYjq52hMbTxSsRm
         ywYV+V/Yf5RqatUdMzNo2b+4xVr872KiBPhIgvlStA7vFF/h5lR2RDkill1wvpOlF0
         mOB0unfry2G1CQEkR6Pj3bpcpnauI0O9AYmR5o+QjiaocU0IEoI0hi2AvIW32Dkrm8
         zpjyeWXL98bmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Yang <sherry.yang@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/18] selftests/seccomp: Fix seccomp failure by adding missing headers
Date:   Tue, 22 Feb 2022 21:30:29 -0500
Message-Id: <20220223023035.241551-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
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

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 21bffcb76ee2fbafc7d5946cef10abc9df5cfff7 ]

seccomp_bpf failed on tests 47 global.user_notification_filter_empty
and 48 global.user_notification_filter_empty_threaded when it's
tested on updated kernel but with old kernel headers. Because old
kernel headers don't have definition of macro __NR_clone3 which is
required for these two tests. Since under selftests/, we can install
headers once for all tests (the default INSTALL_HDR_PATH is
usr/include), fix it by adding usr/include to the list of directories
to be searched. Use "-isystem" to indicate it's a system directory as
the real kernel headers directories are.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Tested-by: Sherry Yang <sherry.yang@oracle.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 0ebfe8b0e147f..585f7a0c10cbe 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall
+CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
-- 
2.34.1

