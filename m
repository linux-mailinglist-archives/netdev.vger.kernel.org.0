Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A471F24C9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbgFHXWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730966AbgFHXWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1415020842;
        Mon,  8 Jun 2020 23:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658550;
        bh=E/5UJz2BshS2E+sqIdC3MSbzqLf/j0KyC3ZSbqD3Vyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmgs4+hTJbILiZ++6ZLcSBUznPStQ5ijQfMTDStiklFOzWXO0TQz9hL+ZNoXQp/V8
         4J9EOENsrpAguZVBB/XNF83KVicB8sAG7kYtOVP1YqhXFkudVA1v3dgi6++mfkjfuV
         I6sc3WzmBMreN5nmJ3Jtd8Kini7OomvEXTzrQlPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 170/175] bpf: Refactor sockmap redirect code so its easy to reuse
Date:   Mon,  8 Jun 2020 19:18:43 -0400
Message-Id: <20200608231848.3366970-170-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit ca2f5f21dbbd5e3a00cd3e97f728aa2ca0b2e011 ]

We will need this block of code called from tls context shortly
lets refactor the redirect logic so its easy to use. This also
cleans up the switch stmt so we have fewer fallthrough cases.

No logic changes are intended.

Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 55 ++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ded2d5227678..8e538a28fe0d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -686,13 +686,43 @@ static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
 	return container_of(parser, struct sk_psock, parser);
 }
 
-static void sk_psock_verdict_apply(struct sk_psock *psock,
-				   struct sk_buff *skb, int verdict)
+static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
 	bool ingress;
 
+	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	if (unlikely(!sk_other)) {
+		kfree_skb(skb);
+		return;
+	}
+	psock_other = sk_psock(sk_other);
+	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
+	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	ingress = tcp_skb_bpf_ingress(skb);
+	if ((!ingress && sock_writeable(sk_other)) ||
+	    (ingress &&
+	     atomic_read(&sk_other->sk_rmem_alloc) <=
+	     sk_other->sk_rcvbuf)) {
+		if (!ingress)
+			skb_set_owner_w(skb, sk_other);
+		skb_queue_tail(&psock_other->ingress_skb, skb);
+		schedule_work(&psock_other->work);
+	} else {
+		kfree_skb(skb);
+	}
+}
+
+static void sk_psock_verdict_apply(struct sk_psock *psock,
+				   struct sk_buff *skb, int verdict)
+{
+	struct sock *sk_other;
+
 	switch (verdict) {
 	case __SK_PASS:
 		sk_other = psock->sk;
@@ -711,25 +741,8 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		goto out_free;
 	case __SK_REDIRECT:
-		sk_other = tcp_skb_bpf_redirect_fetch(skb);
-		if (unlikely(!sk_other))
-			goto out_free;
-		psock_other = sk_psock(sk_other);
-		if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
-		    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED))
-			goto out_free;
-		ingress = tcp_skb_bpf_ingress(skb);
-		if ((!ingress && sock_writeable(sk_other)) ||
-		    (ingress &&
-		     atomic_read(&sk_other->sk_rmem_alloc) <=
-		     sk_other->sk_rcvbuf)) {
-			if (!ingress)
-				skb_set_owner_w(skb, sk_other);
-			skb_queue_tail(&psock_other->ingress_skb, skb);
-			schedule_work(&psock_other->work);
-			break;
-		}
-		/* fall-through */
+		sk_psock_skb_redirect(psock, skb);
+		break;
 	case __SK_DROP:
 		/* fall-through */
 	default:
-- 
2.25.1

