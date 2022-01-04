Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5614839DA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiADBdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:33:25 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:65495 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260004; x=1672796004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rmb/R6oMtGGMDmvdErs1mXPBxqIuUx8tkxO1ksstC80=;
  b=BTN5RhiZGnB35adBzFajmDTw8O5pgj4skIJhUjkBxXKdaZ6FWHUvLB96
   5RmuNvSwyyKa89BgRJxeReDqYVuQQeVG6owSIiDWjQiMyMg8UZkRhtv4h
   b7KD8p1GUFNbcpYx2xND4XbFkegEf66tK62rwc9VTTXHrzcJToui5MDuC
   A=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="52429779"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-0085f2c8.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 04 Jan 2022 01:33:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-0085f2c8.us-west-2.amazon.com (Postfix) with ESMTPS id 0117A42E93;
        Tue,  4 Jan 2022 01:33:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Guillaume Nault <gnault@redhat.com>
Subject: [PATCH bpf-next 1/6] bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
Date:   Tue, 4 Jan 2022 10:31:48 +0900
Message-ID: <20220104013153.97906-2-kuniyu@amazon.co.jp>
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

The commit 4057765f2dee ("sock: consistent handling of extreme
SO_SNDBUF/SO_RCVBUF values") added a change to prevent underflow
in setsockopt() around SO_SNDBUF/SO_RCVBUF.

This patch adds the same change to _bpf_setsockopt().

Fixes: 4057765f2dee ("sock: consistent handling of extreme SO_SNDBUF/SO_RCVBUF values")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC: Guillaume Nault <gnault@redhat.com>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 606ab5a98a1a..368fe28c8dc6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4741,12 +4741,14 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		switch (optname) {
 		case SO_RCVBUF:
 			val = min_t(u32, val, sysctl_rmem_max);
+			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 			WRITE_ONCE(sk->sk_rcvbuf,
 				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
 			val = min_t(u32, val, sysctl_wmem_max);
+			val = min_t(int, val, INT_MAX / 2);
 			sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 			WRITE_ONCE(sk->sk_sndbuf,
 				   max_t(int, val * 2, SOCK_MIN_SNDBUF));
-- 
2.30.2

