Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943AD3A4EC9
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhFLMhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:37:19 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:13637 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhFLMhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501320; x=1655037320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ePETh8kwkGe12QJMmZ+B2awIq/2ssnWj8Y7wAoShBSs=;
  b=Sxfma6QyQKp+qyT7/3ke8DVpimRLYXWsHx2gprirBx9JYTePO9rxFHMv
   NDjHzACkdc0FtdcW+sTeXNCYM/yQzdvNlNTRyTAfP84sw46t6e1GaTwwh
   QljduOyodBBzr0P5Z8KuYL1lpHN/7QNqLCHp8MfjzBjZM1geIgnw5v8Ef
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="118356126"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 Jun 2021 12:35:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 91BA5A1D57;
        Sat, 12 Jun 2021 12:35:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:35:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:35:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 10/11] libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Sat, 12 Jun 2021 21:32:23 +0900
Message-ID: <20210612123224.12525-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new section (sk_reuseport/migrate) and sets
expected_attach_type to two each section in BPF_PROG_TYPE_SK_REUSEPORT
program.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 128715b8794b..f6b91fb0c857 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9075,7 +9075,10 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
 static const struct bpf_sec_def section_defs[] = {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
-	BPF_PROG_SEC("sk_reuseport",		BPF_PROG_TYPE_SK_REUSEPORT),
+	BPF_EAPROG_SEC("sk_reuseport/migrate",	BPF_PROG_TYPE_SK_REUSEPORT,
+						BPF_SK_REUSEPORT_SELECT_OR_MIGRATE),
+	BPF_EAPROG_SEC("sk_reuseport",		BPF_PROG_TYPE_SK_REUSEPORT,
+						BPF_SK_REUSEPORT_SELECT),
 	SEC_DEF("kprobe/", KPROBE,
 		.attach_fn = attach_kprobe),
 	BPF_PROG_SEC("uprobe/",			BPF_PROG_TYPE_KPROBE),
-- 
2.30.2

