Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDD36BE03
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhD0DvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:51:22 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:17917 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0DvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1619495437; x=1651031437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqC496C337beUNNmGmonZvSwADhcguklhzGYClsS5NU=;
  b=goAMOo6DKtvhh6LvGxBYCxMGOlXO/aTaacr6x/kQ+RGN3i4Hi4xOu0mn
   HbrgQAync7k7OK3eujFdHNPPXVi1Ftz54QdT1xicG74clsCKhiFGibhi1
   4cAYUmeWE4Sae783ceXSrVR7EGSvLHSDXb2xvoFHy0apoOY379Fe2L9Be
   U=;
X-IronPort-AV: E=Sophos;i="5.82,254,1613433600"; 
   d="scan'208";a="104127413"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 27 Apr 2021 03:49:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id CC0BBC00A8;
        Tue, 27 Apr 2021 03:49:33 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 27 Apr 2021 03:49:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.93) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 27 Apr 2021 03:49:27 +0000
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
Subject: [PATCH v4 bpf-next 10/11] libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Tue, 27 Apr 2021 12:46:22 +0900
Message-ID: <20210427034623.46528-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427034623.46528-1-kuniyu@amazon.co.jp>
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D18UWC002.ant.amazon.com (10.43.162.88) To
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
index a1cddd17af7d..538849fb6bb7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8818,7 +8818,10 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
 
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

