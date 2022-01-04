Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244354839DC
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiADBdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:33:41 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:18179 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:33:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260021; x=1672796021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LQWfwkrBbzLGRdtfjOSXoStsHvuGU7dEpT9LtV0m5IY=;
  b=JLSTlH7gRUADNNnxgdXa+srYZF9kgO2jsefhEZwrfFts9g0gfBQs1atS
   3nVGkbhMjKx3UPd4Gf0k1cKrFZ0jwRCWvwyd8m02f7jusclxWcnxH41YQ
   kDbRCUNDBDYMVachaEcKo4IjEpk16yct5h8tTQC5Dyoy01grylW1IsMmu
   U=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="167488243"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 04 Jan 2022 01:33:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com (Postfix) with ESMTPS id 4D43642935;
        Tue,  4 Jan 2022 01:33:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 2/6] bpf: Add SO_RCVBUF/SO_SNDBUF in _bpf_getsockopt().
Date:   Tue, 4 Jan 2022 10:31:49 +0900
Message-ID: <20220104013153.97906-3-kuniyu@amazon.co.jp>
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

This patch exposes SO_RCVBUF/SO_SNDBUF through bpf_getsockopt().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/filter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 368fe28c8dc6..cac2be559ab0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4969,6 +4969,12 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 			goto err_clear;
 
 		switch (optname) {
+		case SO_RCVBUF:
+			*((int *)optval) = sk->sk_rcvbuf;
+			break;
+		case SO_SNDBUF:
+			*((int *)optval) = sk->sk_sndbuf;
+			break;
 		case SO_MARK:
 			*((int *)optval) = sk->sk_mark;
 			break;
-- 
2.30.2

