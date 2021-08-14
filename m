Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEB43EBF79
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhHNB6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:58:42 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:18837 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhHNB6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628906295; x=1660442295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5fmB+CiLdp8Iqkbjv1hv02KAzlSsFfGAyTiSNddRc+Q=;
  b=QJDKbxhT4zbUZ+93fJdKNog9hfIBQM7cE1qHUQZnQzg6xswGNfzDK8JP
   P2miTu7U62Av0Li9GxKc4f9jA5rrEEA3Ruh589M+U53q58wPXgKOvroNe
   EvwuWYWMAwV+iL5BlsxeElQpWLmnMos4rfuofAKGsAp3bCvjtHsc2U0vm
   U=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="19223552"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Aug 2021 01:58:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id AF9EB100047;
        Sat, 14 Aug 2021 01:58:09 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:03 +0000
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
Subject: [PATCH v6 bpf-next 2/4] bpf: Support "%c" in bpf_bprintf_prepare().
Date:   Sat, 14 Aug 2021 10:57:16 +0900
Message-ID: <20210814015718.42704-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210814015718.42704-1-kuniyu@amazon.co.jp>
References: <20210814015718.42704-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
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
index 32761be48143..4e8540716187 100644
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

