Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ABA365C87
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhDTPqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:46:05 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:55192 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhDTPqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:46:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1618933529; x=1650469529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iIy0X5VzbdSfIbWEFtVsvNri3U7WPuNVZw6axuTAwFM=;
  b=ozDwfZlw/ObX9KTayxRzMZRoOm9Bs7A/ZPDXWwhN8eqWIH1CzAVf9bkP
   Y5CMDpjH9JGUimW6VUDFEchbjJ+at5dCj9Sc6N8y5av6NgAKi8cj64A0i
   SZm08Vn27D9FTdoMpJXGP+cz+Atxktu9fpRANDjCQpNDVyb+DweMVUYKm
   o=;
X-IronPort-AV: E=Sophos;i="5.82,237,1613433600"; 
   d="scan'208";a="927523537"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 20 Apr 2021 15:45:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 27C73A18A6;
        Tue, 20 Apr 2021 15:45:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:45:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:45:23 +0000
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
Subject: [PATCH v3 bpf-next 10/11] libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Wed, 21 Apr 2021 00:41:39 +0900
Message-ID: <20210420154140.80034-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420154140.80034-1-kuniyu@amazon.co.jp>
References: <20210420154140.80034-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13P01UWB001.ant.amazon.com (10.43.161.59) To
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
index 7aad78dbb4b4..6ba84111e143 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8765,7 +8765,10 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
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

