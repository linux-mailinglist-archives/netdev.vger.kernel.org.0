Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2EC3EA8B5
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhHLQrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:47:11 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:35809 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhHLQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628786806; x=1660322806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XTQyhIg+p8W2qjHGhUr/3gQzziAwKZkkFVQJ98BWkqU=;
  b=UY45S4ODBgPreJQg4fG7xOZr/h2FLVxZNMcGfgODW9Ki+tAJ2ZRlu0Y0
   dUoOnUW44lTKDY2cAfeViJKMlnr9u83jD2ftWq3PqG8lfZC5O6F/eKHVf
   jqOAgwiXLoX0NxobvQdZk9K4tS22F4/zS3DfY38DCzWILSqEwfKxSF1lG
   M=;
X-IronPort-AV: E=Sophos;i="5.84,316,1620691200"; 
   d="scan'208";a="132067829"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 Aug 2021 16:46:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 3B509A25D8;
        Thu, 12 Aug 2021 16:46:43 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:42 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 12 Aug 2021 16:46:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 bpf-next 2/4] bpf: Support "%c" in bpf_bprintf_prepare().
Date:   Fri, 13 Aug 2021 01:45:55 +0900
Message-ID: <20210812164557.79046-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812164557.79046-1-kuniyu@amazon.co.jp>
References: <20210812164557.79046-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13d09UWA003.ant.amazon.com (10.43.160.227) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
the name of the abstract UNIX domain socket.  The following selftest uses
it, so this patch adds support for "%c".  Note that it does not support
wide character ("%lc" and "%llc") for simplicity.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/helpers.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 15746f779fe1..6d3aaf94e9ac 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -907,6 +907,20 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			tmp_buf += err;
 			num_spec++;
 
+			continue;
+		} else if (fmt[i] == 'c') {
+			if (!tmp_buf)
+				goto nocopy_fmt;
+
+			if (tmp_buf_end == tmp_buf) {
+				err = -ENOSPC;
+				goto out;
+			}
+
+			*tmp_buf = raw_args[num_spec];
+			tmp_buf++;
+			num_spec++;
+
 			continue;
 		}
 
-- 
2.30.2

