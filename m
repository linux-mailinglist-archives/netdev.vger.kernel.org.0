Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA9D12B66C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfL0Rmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbfL0Rmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5E0218AC;
        Fri, 27 Dec 2019 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468554;
        bh=inSHXxAmEMnLtfzgN61sGOZo9j+enNoa1EQvuFtC+xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6rAPHaVRkUH+wV59MSVeXDXe9dT0uYC5f/74nh8e0g1f+PcT+dfeC5a/h6LSZdEE
         cXXx5/G+cEGzE2FkjWi9xK6/nZXCFXjewJIxV6lqy3Wcref2iTSiOLlVdJQNmTRHS4
         U45UoS7eH/zkLQd3TdcWHpV6NdBuJeCfwpEEGLkY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 081/187] samples: bpf: fix syscall_tp due to unused syscall
Date:   Fri, 27 Dec 2019 12:39:09 -0500
Message-Id: <20191227174055.4923-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit fe3300897cbfd76c6cb825776e5ac0ca50a91ca4 ]

Currently, open() is called from the user program and it calls the syscall
'sys_openat', not the 'sys_open'. This leads to an error of the program
of user side, due to the fact that the counter maps are zero since no
function such 'sys_open' is called.

This commit adds the kernel bpf program which are attached to the
tracepoint 'sys_enter_openat' and 'sys_enter_openat'.

Fixes: 1da236b6be963 ("bpf: add a test case for syscalls/sys_{enter|exit}_* tracepoints")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/syscall_tp_kern.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 1d78819ffef1..630ce8c4d5a2 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -47,13 +47,27 @@ static __always_inline void count(void *map)
 SEC("tracepoint/syscalls/sys_enter_open")
 int trace_enter_open(struct syscalls_enter_open_args *ctx)
 {
-	count((void *)&enter_open_map);
+	count(&enter_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_enter_openat")
+int trace_enter_open_at(struct syscalls_enter_open_args *ctx)
+{
+	count(&enter_open_map);
 	return 0;
 }
 
 SEC("tracepoint/syscalls/sys_exit_open")
 int trace_enter_exit(struct syscalls_exit_open_args *ctx)
 {
-	count((void *)&exit_open_map);
+	count(&exit_open_map);
+	return 0;
+}
+
+SEC("tracepoint/syscalls/sys_exit_openat")
+int trace_enter_exit_at(struct syscalls_exit_open_args *ctx)
+{
+	count(&exit_open_map);
 	return 0;
 }
-- 
2.20.1

