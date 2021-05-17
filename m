Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BA2382249
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 02:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhEQA1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 20:27:11 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:60011 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhEQA1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 20:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621211156; x=1652747156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gyt1CQPX41Y2hG/KqJcCuoJehCJZx0XEIj7EiL7V73Q=;
  b=IWv50z7aaMxKKf3unxIvntcF9uijJx7rg3nFQVeg7fuLhGMrd0wPFmvM
   NI/tX3nnx2NZ2Bk4m0Vkv6hhiY0H8wLWPYET25yOtQnXCNsbGfCuzjEVn
   7h5x2GVosEa/jqHEs4DxQ3SqEvHbv3Nc3PmboFoKYrrfd6F+SOhHcrY3W
   o=;
X-IronPort-AV: E=Sophos;i="5.82,306,1613433600"; 
   d="scan'208";a="1587889"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 17 May 2021 00:25:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 5370DA11E3;
        Mon, 17 May 2021 00:25:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:25:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.28) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:25:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 bpf-next 10/11] libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Mon, 17 May 2021 09:22:57 +0900
Message-ID: <20210517002258.75019-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210517002258.75019-1-kuniyu@amazon.co.jp>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new section (sk_reuseport/migrate) and sets
expected_attach_type to two each section in BPF_PROG_TYPE_SK_REUSEPORT
program.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e2a3cf437814..48df7498226e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8820,7 +8820,10 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
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

