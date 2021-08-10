Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE953E56DC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbhHJJ3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:29:25 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45477 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbhHJJ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628587743; x=1660123743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sZsQpW+Xl4bDqxL6EClTQGWl1FTe1Lq6AgjjgeiW8EE=;
  b=ZeQlZ/ho8rBbYNHuM9NQycN70zLPzTR7E6FL/IingvnP6aX5DjwNWW8i
   hB8XpcyjzITuAJb4sQEBXOEAUvVYDtrpXHuR1AiSdUEHQy8hFsV8Hrhsw
   kwikjQmji2SbMFFAmgHdjEh6QxZrtvpZJxW65kM+0ZsYGF8ohjCxgkDLW
   U=;
X-IronPort-AV: E=Sophos;i="5.84,310,1620691200"; 
   d="scan'208";a="132824593"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 10 Aug 2021 09:29:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 3FD8DC0C4D;
        Tue, 10 Aug 2021 09:28:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 10 Aug 2021 09:28:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.189) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 10 Aug 2021 09:28:52 +0000
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
Subject: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in bpf_bprintf_prepare().
Date:   Tue, 10 Aug 2021 18:28:06 +0900
Message-ID: <20210810092807.13190-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810092807.13190-1-kuniyu@amazon.co.jp>
References: <20210810092807.13190-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.189]
X-ClientProxiedBy: EX13D08UWC001.ant.amazon.com (10.43.162.110) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
the name of the abstract UNIX domain socket.  The following selftest uses
it, so this patch adds support for "%c".  Note that it does not support
wide character ("%lc" and "%llc") for simplicity.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
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

