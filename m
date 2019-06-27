Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E816C575A2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfF0Aa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfF0Aay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:54 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F602083B;
        Thu, 27 Jun 2019 00:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595454;
        bh=EoVevRrncZLwzRFqE1UttWd6FrNKzV+ovzUOIn7khe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjUPdg8XmdOhHZu7grKIjVpIPnqvA271FbHIfFfqB9oafi2rUfsUD4icMxMCXjrrr
         iaCMSdoztvIHD7sVN692kYC2P6c8aT5ADkxiBvBL2GE4BdeRXU3sSEJksgfrqJv8En
         PWwWnzCx7faxovz/++9E8Y/pRD+tMOdfOYLUlWY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matteo Croce <mcroce@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 10/95] samples, bpf: suppress compiler warning
Date:   Wed, 26 Jun 2019 20:28:55 -0400
Message-Id: <20190627003021.19867-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit a195cefff49f60054998333e81ee95170ce8bf92 ]

GCC 9 fails to calculate the size of local constant strings and produces a
false positive:

samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
samples/bpf/task_fd_query_user.c:242:67: warning: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 215 [-Wformat-truncation=]
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |                                                                   ^~
  243 |    event_type, event_alias);
      |                ~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:242:2: note: ‘snprintf’ output between 45 and 300 bytes into a destination of size 256
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  243 |    event_type, event_alias);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~

Workaround this by lowering the buffer size to a reasonable value.
Related GCC Bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83431

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index aff2b4ae914e..e39938058223 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -216,7 +216,7 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 {
 	const char *event_type = "uprobe";
 	struct perf_event_attr attr = {};
-	char buf[256], event_alias[256];
+	char buf[256], event_alias[sizeof("test_1234567890")];
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
 	int err, res, kfd, efd;
-- 
2.20.1

