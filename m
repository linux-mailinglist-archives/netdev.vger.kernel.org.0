Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA398457BB2
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 06:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhKTFXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 00:23:03 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:61101 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhKTFXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 00:23:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yunbo.xufeng@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UxMw1x3_1637385585;
Received: from localhost.localdomain(mailfrom:yunbo.xufeng@linux.alibaba.com fp:SMTPD_---0UxMw1x3_1637385585)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Nov 2021 13:19:47 +0800
From:   Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
To:     jolsa@kernel.org, kpsingh@google.com, andriin@fb.com,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, yunbo.xufeng@linux.alibaba.com
Subject: [RFC] [PATCH bpf-next 1/1] bpf: Clear the noisy tail buffer for bpf_d_path() helper
Date:   Sat, 20 Nov 2021 13:18:39 +0800
Message-Id: <20211120051839.28212-2-yunbo.xufeng@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20211120051839.28212-1-yunbo.xufeng@linux.alibaba.com>
References: <20211120051839.28212-1-yunbo.xufeng@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Xufeng Zhang" <yunbo.xufeng@linux.alibaba.com>

The motivation behind this change is to use the returned full path
for lookup keys in BPF_MAP_TYPE_HASH map.
bpf_d_path() prepend the path string from the end of the input
buffer, and call memmove() to copy the full path from the tail
buffer to the head of buffer before return. So although the
returned buffer string is NULL terminated, there is still
noise data at the tail of buffer.
If using the returned full path buffer as the key of hash map,
the noise data is also calculated and makes map lookup failed.
To resolve this problem, we could memset the noisy tail buffer
before return.

Signed-off-by: Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25ea521fb8f1..ec4a6823c024 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -903,6 +903,8 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
 	} else {
 		len = buf + sz - p;
 		memmove(buf, p, len);
+		/* Clear the noisy tail buffer before return */
+		memset(buf + len, 0, sz - len);
 	}
 
 	return len;
-- 
2.20.1 (Apple Git-117)

