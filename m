Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385742CA631
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403999AbgLAOr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:47:28 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:5495 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403991AbgLAOr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:47:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834047; x=1638370047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=TmovmZFg0uGwgULxNT+qzpNNcmmliehv0wNj2j0+gi0=;
  b=KvAw6aUCHc/716dOdupPYvAJtlZ+wQEQGdqJbFKMXRbKg0NWowF3Eoh8
   hS6RPxUyI9sGz/SjUrV6AhGJi8or9v5KGLczAHz5OT2HaH3kI0OYSt7ie
   JohLu7mvwZ0xpyJ9/+uMZ0Kgu34Ninwel72QIfs/RzcBtm4k9tiwS1s3v
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="66687217"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-41350382.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 01 Dec 2020 14:46:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-41350382.us-west-2.amazon.com (Postfix) with ESMTPS id D4D33C2CDA;
        Tue,  1 Dec 2020 14:46:42 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:42 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:46:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 07/11] libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Tue, 1 Dec 2020 23:44:14 +0900
Message-ID: <20201201144418.35045-8-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201201144418.35045-1-kuniyu@amazon.co.jp>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
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
index 28baee7ba1ca..bbb3902a0e41 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8237,7 +8237,10 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
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
2.17.2 (Apple Git-113)

