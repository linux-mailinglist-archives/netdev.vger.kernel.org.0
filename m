Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1511FE35B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgFRCIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbgFRBWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6616920B1F;
        Thu, 18 Jun 2020 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443322;
        bh=OC9h1BBLtnbRbYuhuP/ImaI0glFnt5/0DlTZ4avqXGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySdtmu9xljEVE/9YnUBTxC2JTplt3yFzxXjDGVpwf3YACdwNv51jzDOWSXhfnRFlH
         YjwzpaFdD8Snrm52YL0u+pW1LKlufaggvaCHigaHEH+YNPzLkNhVbSSp5AE03MYO+a
         CK4qZ+We4tx4iIRPPSzDqjKYQWJtZ3g8HrEKVU8c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 256/266] tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes
Date:   Wed, 17 Jun 2020 21:16:21 -0400
Message-Id: <20200618011631.604574-256-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 22d5bd6867364b41576a712755271a7d6161abd6 ]

Commit 60d53e2c3b75 ("tracing/probe: Split trace_event related data from
trace_probe") removed the trace_[ku]probe structure from the
trace_event_call->data pointer. As bpf_get_[ku]probe_info() were
forgotten in that change, fix them now. These functions are currently
only used by the bpf_task_fd_query() syscall handler to collect
information about a perf event.

Fixes: 60d53e2c3b75 ("tracing/probe: Split trace_event related data from trace_probe")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/bpf/20200608124531.819838-1-jean-philippe@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 kernel/trace/trace_uprobe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index fba4b48451f6..26de9c654956 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1464,7 +1464,7 @@ int bpf_get_kprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tk = find_trace_kprobe(pevent, group);
 	else
-		tk = event->tp_event->data;
+		tk = trace_kprobe_primary_from_call(event->tp_event);
 	if (!tk)
 		return -EINVAL;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2619bc5ed520..5294843de6ef 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1405,7 +1405,7 @@ int bpf_get_uprobe_info(const struct perf_event *event, u32 *fd_type,
 	if (perf_type_tracepoint)
 		tu = find_probe_event(pevent, group);
 	else
-		tu = event->tp_event->data;
+		tu = trace_uprobe_primary_from_call(event->tp_event);
 	if (!tu)
 		return -EINVAL;
 
-- 
2.25.1

