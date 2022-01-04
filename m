Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28394839E1
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiADBeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:34:09 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:58567 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260049; x=1672796049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+5X3R6S+hSJvjQc1xBSUxWYDX2AW6PU3oqKHQNj1a/A=;
  b=ExvjIyMv03BZs7ziop7K/zHYzFWDfzEoYa4RD3GR9T0PV7wPse4v0KaQ
   rFYu5KBbmAscHJs67vPr+NdV+qN17nLgL53b1W/DF6XmugrDn692E1dWF
   Fz7Nonv6r1+yEHXmUxirzZ/A3DI2wZN4eBB0od3Ts1aLwLZNZKGFzhA4w
   4=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="52418743"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 04 Jan 2022 01:34:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id CD33C42EE0;
        Tue,  4 Jan 2022 01:34:08 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 4/6] bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
Date:   Tue, 4 Jan 2022 10:31:51 +0900
Message-ID: <20220104013153.97906-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104013153.97906-1-kuniyu@amazon.co.jp>
References: <20220104013153.97906-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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
index dd6804086372..06c997fd6830 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3622,6 +3622,20 @@ static const struct bpf_iter_seq_info unix_seq_info = {
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
@@ -3629,6 +3643,7 @@ static struct bpf_iter_reg unix_reg_info = {
 		{ offsetof(struct bpf_iter__unix, unix_sk),
 		  PTR_TO_BTF_ID_OR_NULL },
 	},
+	.get_func_proto         = bpf_iter_unix_get_func_proto,
 	.seq_info		= &unix_seq_info,
 };
 
-- 
2.30.2

