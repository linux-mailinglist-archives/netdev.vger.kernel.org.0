Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE5348CFB2
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiAMAaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:30:09 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:23507 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiAMAaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033803; x=1673569803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qDd9pDTnsKpy40lje7XE+ujfCNRlQOHboMviCWERbLw=;
  b=KjDGOOut7eGqG4bGAgkw6SP4f9cSTVipg/9QxZ3H4d++MSLPBFfygdaU
   +SQanb2ORx3s+BcaHZaMkSF9RXfnhHwAlp7vJ30euxji0SnzKKB0Z6hSw
   QVA6Z7RWd39Lt+Opx9/Sv+YhNeZVaz6FWYJJNCaiCbto6ZMkW+OTsxnGG
   c=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="984424033"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 13 Jan 2022 00:30:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-10222bbc.us-east-1.amazon.com (Postfix) with ESMTPS id AE2851A0081;
        Thu, 13 Jan 2022 00:30:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:29:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:29:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 3/5] bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
Date:   Thu, 13 Jan 2022 09:28:47 +0900
Message-ID: <20220113002849.4384-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes bpf_(get|set)sockopt() available when iterating AF_UNIX
sockets.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d383d5f63b6b..3e0d6281fd1e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3633,6 +3633,20 @@ static const struct bpf_iter_seq_info unix_seq_info = {
 	.seq_priv_size		= sizeof(struct bpf_unix_iter_state),
 };
 
+static const struct bpf_func_proto *
+bpf_iter_unix_get_func_proto(enum bpf_func_id func_id,
+			     const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_setsockopt:
+		return &bpf_sk_setsockopt_proto;
+	case BPF_FUNC_getsockopt:
+		return &bpf_sk_getsockopt_proto;
+	default:
+		return NULL;
+	}
+}
+
 static struct bpf_iter_reg unix_reg_info = {
 	.target			= "unix",
 	.ctx_arg_info_size	= 1,
@@ -3640,6 +3654,7 @@ static struct bpf_iter_reg unix_reg_info = {
 		{ offsetof(struct bpf_iter__unix, unix_sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.get_func_proto         = bpf_iter_unix_get_func_proto,
 	.seq_info		= &unix_seq_info,
 };
 
-- 
2.30.2

