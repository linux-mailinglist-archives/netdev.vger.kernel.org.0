Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F0317DE65
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCILN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35620 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgCILNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so10553622wro.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCPLoXcP+lpHnWKxQvj+YI13qZvo01PQWJqE3eh/Ik4=;
        b=GClSFCOK/i7yD4ZQLIXnEWvmlsZPqbeOKuo0zI5fWUUn09VmLVjxF4GBSVX+YOfgom
         rz3fELsHAof9pkf615s9KWN/7iTehWLcklyUjFh3NeJc22XD1sJSK2oZ44DfG0dLFhZW
         Jrp6ysOu5yaJoeZVO+ssyMBUN+BtbcPSJxs3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCPLoXcP+lpHnWKxQvj+YI13qZvo01PQWJqE3eh/Ik4=;
        b=cThjPy2Y8aVUE3tDC14LuYh8qfZAx93NQohdQlVoIYwD89ELLtTl3hcISVhUUvzl//
         iq2bpX74FtqlPfHnlbazFK8vG4Jq21b/UM43KLqc2TS7zX23QkxIaicJfXcHKACsP/+t
         rb0NsKe8TdnF0TIYTabYRGl7T+q+HhhUpeYgT0AvDpL/ogNbuDTHW79KsXnGrBzzzbB8
         EakR+Tqr5io7M6gdx1ZWDum+lXpsj3Y4Halfy5oqzc0eHgox0OIUegNBycHsL4Ro3SBK
         VizpiCID0sDVAxwC4PpAxP4upYSZMMXK7sLBfGnVh8qc1e3CQlJUB22fKywFknkXtJDn
         AeWQ==
X-Gm-Message-State: ANhLgQ28HDb8H9dk9XrymEXuoItNUufjcOKh/X7WRkl6ix++wFidM29X
        zV3N9m9Slb7Sf42F6gpYdpTGVA==
X-Google-Smtp-Source: ADFU+vv08iVdGwkGLNH4/nhgz74hG4LCZtJBIYml6lPUnB0/kXp9/a3ESDCjiVyIpxamKHUlTIvVKg==
X-Received: by 2002:a5d:6141:: with SMTP id y1mr19541463wrt.146.1583752403214;
        Mon, 09 Mar 2020 04:13:23 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:22 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 08/12] bpf: sockmap: add UDP support
Date:   Mon,  9 Mar 2020 11:12:39 +0000
Message-Id: <20200309111243.6982-9-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
References: <20200309111243.6982-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow adding hashed UDP sockets to sockmaps.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index edfdce17b951..a7075b3b4489 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/jhash.h>
 #include <linux/sock_diag.h>
+#include <net/udp.h>
 
 struct bpf_stab {
 	struct bpf_map map;
@@ -147,7 +148,19 @@ static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 
 	sock_owned_by_me(sk);
 
-	prot = tcp_bpf_get_proto(sk, psock);
+	switch (sk->sk_type) {
+	case SOCK_STREAM:
+		prot = tcp_bpf_get_proto(sk, psock);
+		break;
+
+	case SOCK_DGRAM:
+		prot = udp_bpf_get_proto(sk, psock);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
 	if (IS_ERR(prot))
 		return PTR_ERR(prot);
 
@@ -162,7 +175,7 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (psock) {
-		if (sk->sk_prot->recvmsg != tcp_bpf_recvmsg) {
+		if (sk->sk_prot->close != sock_map_close) {
 			psock = ERR_PTR(-EBUSY);
 			goto out;
 		}
@@ -474,15 +487,31 @@ static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
 	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
 }
 
-static bool sock_map_sk_is_suitable(const struct sock *sk)
+static bool sk_is_tcp(const struct sock *sk)
 {
 	return sk->sk_type == SOCK_STREAM &&
 	       sk->sk_protocol == IPPROTO_TCP;
 }
 
+static bool sk_is_udp(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_DGRAM &&
+	       sk->sk_protocol == IPPROTO_UDP;
+}
+
+static bool sock_map_sk_is_suitable(const struct sock *sk)
+{
+	return sk_is_tcp(sk) || sk_is_udp(sk);
+}
+
 static bool sock_map_sk_state_allowed(const struct sock *sk)
 {
-	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (sk_is_tcp(sk))
+		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	else if (sk_is_udp(sk))
+		return sk_hashed(sk);
+
+	return false;
 }
 
 static int sock_map_update_elem(struct bpf_map *map, void *key,
-- 
2.20.1

