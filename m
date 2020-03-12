Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADABE183D6B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCLXhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:37:02 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:55908 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgCLXhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:37:00 -0400
Received: by mail-pj1-f43.google.com with SMTP id mj6so3053846pjb.5;
        Thu, 12 Mar 2020 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q+7nF6nVOoQHy2nmXwbkXB+9YN/TEhzTzSSsF4UipwA=;
        b=BBqur5DqiVSIa7H7+fSclR+o0bFMu6vYr4M6Oncrc1jA3GtTdSMynXVZqeFZ/HTjAV
         JhNH5MmpP882KnnbXcTmD0oNKgxVxDRxo/U7/wbBrozgDWcEZXpQ7ixLlqdY/bKy9QkE
         z9mr4pcPNSdhSbcAovvHZzZQzk0T2+DXWbRxM5LR9KyE4QY+xTk94hPxTVvEuAR9fseS
         BddYlhH+9vqsfxADr3thAoJs2ETEtYvkkswVyfxc++a8P+ncCfgqvoqqs+tg9cdIcVGt
         IC0Y2JlFnQItYy9Sb0GoKyxs9XNUjaaXN7JZO8oX+zIJnjXT1owtsjlCMudo6mTqYC4k
         LFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=q+7nF6nVOoQHy2nmXwbkXB+9YN/TEhzTzSSsF4UipwA=;
        b=f3/zqeWyGZmq/8EBe7l4l2SES7oYaNsf8byvZ4fWSY+JEvwpHiRf90GljoLoEtfoCz
         SQkg/WfuX6KXEktrW1/ZV51fKByW/zVRvVcoFEE35YkKn0QB14xFnEfhTOoyjn/EweGN
         Nl3zLnvD5Xc8C0lA70h26U/LifwWyPoK4dt1M8wUjD+I/O3CaxuawrmDctztEsLfGhrV
         0IZw+E/lRDozEZSfH47lz/MYEvBWP3ZJ9q3cmBheJgctIB11/gmj+qvRrNXcvOojt36N
         3afzpgO54NUq0I98rNevdsguWNHqsQlsNzpJe+gjBnOQDNfo7ipLZ57YOxy8FYVDnVP9
         Nj4A==
X-Gm-Message-State: ANhLgQ2pyB5fezakDuYY98+XFQcWC42SwTtINPo4xIh2WxXKTj3du3S4
        QrmcXjUO3uE8lGrIAiXX4eY8Kxpe
X-Google-Smtp-Source: ADFU+vsiV1rAnVUayFArjCzCPxZdO0IExWf+tnI8CaSKBo8aKgbzimHBN1QfCLhdP0hTdS9OikJbqA==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr6809419pjn.8.1584056218674;
        Thu, 12 Mar 2020 16:36:58 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d6sm5075225pfn.214.2020.03.12.16.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 16:36:57 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com
Subject: [PATCH bpf-next 6/7] selftests: bpf: Extend sk_assign for address proxy
Date:   Thu, 12 Mar 2020 16:36:47 -0700
Message-Id: <20200312233648.1767-7-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312233648.1767-1-joe@wand.net.nz>
References: <20200312233648.1767-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the socket assign test program to also validate that connections
to foreign addresses may also be proxied to a user agent via this
mechanism.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
 tools/testing/selftests/bpf/test_sk_assign.c  | 13 +++++++++++++
 tools/testing/selftests/bpf/test_sk_assign.sh |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_sk_assign.c b/tools/testing/selftests/bpf/test_sk_assign.c
index cba5f8b2b7fd..4b7b9bbe7859 100644
--- a/tools/testing/selftests/bpf/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/test_sk_assign.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2018 Facebook
 // Copyright (c) 2019 Cloudflare
+// Copyright (c) 2020 Isovalent. Inc.
 
 #include <string.h>
 #include <stdlib.h>
@@ -17,6 +18,8 @@
 #include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
+#define TEST_DADDR (0xC0A80203)
+
 static int start_server(const struct sockaddr *addr, socklen_t len)
 {
 	int fd;
@@ -161,6 +164,16 @@ int main(int argc, char **argv)
 	addr4.sin_port = htons(4321);
 	addr6.sin6_port = htons(4321);
 
+	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
+		goto out;
+
+	if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
+		goto out;
+
+	/* Connect to unbound addresses */
+	addr4.sin_addr.s_addr = htonl(TEST_DADDR);
+	addr6.sin6_addr.s6_addr32[3] = htonl(TEST_DADDR);
+
 	if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
 		goto out;
 
diff --git a/tools/testing/selftests/bpf/test_sk_assign.sh b/tools/testing/selftests/bpf/test_sk_assign.sh
index 62eae9255491..de1df4e438de 100755
--- a/tools/testing/selftests/bpf/test_sk_assign.sh
+++ b/tools/testing/selftests/bpf/test_sk_assign.sh
@@ -12,6 +12,9 @@ if [[ -z $(ip netns identify $$) ]]; then
         exec ../net/in_netns.sh "$0" "$@"
 fi
 
+ip route add local default dev lo
+ip -6 route add local default dev lo
+
 tc qdisc add dev lo clsact
 tc filter add dev lo ingress bpf direct-action object-file ./test_sk_assign.o \
 	section "sk_assign_test"
-- 
2.20.1

