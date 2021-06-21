Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FA73AE179
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhFUBld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhFUBlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:22 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFE9C061283;
        Sun, 20 Jun 2021 18:39:06 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id f70so26344716qke.13;
        Sun, 20 Jun 2021 18:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QeYkNlsQAUc0g3jSubDuw+9XlgHH10D5q9pEpDcDQCg=;
        b=D7/ejBjlaOfJo/KwgM1gqQP1GPXlQSO/93Ai5Zkit76hWfxMWDZeoPrhhOyNpYo7p5
         TqOr6YEEN0asrN2m8ViKMnr6qZr8F38S+rc23uvycH4yf61hzfpXsn5istUFnNjvc+OW
         ELQU9uJYA3xA2m4/64Jr1E2xFu1YAPFu+hHKYrT3AUwP1TBbZCPIYgLcRdCwaLL2O2cS
         aHw8QZTdCGdvJJ60VJPvsTwq7l8jfbwUVEOsWdIieS3TA5jBH4jbSAmBozwsXxOxW6My
         C9N3dYPmCf3CUJyMAfXL+t4eZfxHNqH1yWIL4wzawZDJRsR/ogdsRP9+rci3iskxA6TS
         SQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QeYkNlsQAUc0g3jSubDuw+9XlgHH10D5q9pEpDcDQCg=;
        b=t8fkkkJVtnQjfUP/IDFalPsQUn4vMasHuD2ThxuVaNw8sc2Zm2R5ltiq/4Wh6X/AeL
         6YzFiswqLCk7sCSbYjqtmDAu26fYJY7U1/glva6AK65gubrVvIPdshjUtTpCV2qDLaHY
         FfVLgWNWPqs4ZxBenxGhSzjnVGxIVAux4SrurIahCxrkdOIWJsHOv4d9LzIEw6hXh1Ix
         pIi8QbpjoPfq2uHwaXYRUk8cMgsfbOnlBbCCExHCxuRkr3BpkGVnoKpCClBfeIHPUMkK
         oXJO2/+PwuQ+0wfj6nayeUafNZlWOm8LZ3mH9EjN4dzL90fplbqEXsuJjljDXB5oQa8T
         Qj3A==
X-Gm-Message-State: AOAM531fe7wHw3FnEQ1nftfJix/hwW8mKrQk2hJhRpc93N8mS1F6oIf9
        exicRUU8DBtNz8kGhhkLqZAIc3gX95M4Sg==
X-Google-Smtp-Source: ABdhPJxLKwCjqaSY4gqUKvpSONWXGHYhG872CXi3OvMHxAwQm0nWqRnglYsxBCAGc/fcJ85B4VWPTg==
X-Received: by 2002:a37:b942:: with SMTP id j63mr21090735qkf.430.1624239545097;
        Sun, 20 Jun 2021 18:39:05 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c11sm9665275qth.29.2021.06.20.18.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:39:04 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 13/14] sctp: extract sctp_v4_err_handle function from sctp_v4_err
Date:   Sun, 20 Jun 2021 21:38:48 -0400
Message-Id: <3edcb79df827260f7b94559e1b6cfe58fca53f54.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extract sctp_v4_err_handle() from sctp_v4_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v4_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 106 ++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 9ffdbd6526e9..83d58d42ea45 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -556,6 +556,49 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 	sctp_transport_put(t);
 }
 
+static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
+{
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
+	int err = 0;
+
+	switch (type) {
+	case ICMP_PARAMETERPROB:
+		err = EPROTO;
+		break;
+	case ICMP_DEST_UNREACH:
+		if (code > NR_ICMP_UNREACH)
+			return;
+		if (code == ICMP_FRAG_NEEDED) {
+			sctp_icmp_frag_needed(sk, asoc, t, SCTP_TRUNC4(info));
+			return;
+		}
+		if (code == ICMP_PROT_UNREACH) {
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
+		}
+		err = icmp_err_convert[code].errno;
+		break;
+	case ICMP_TIME_EXCEEDED:
+		if (code == ICMP_EXC_FRAGTIME)
+			return;
+
+		err = EHOSTUNREACH;
+		break;
+	case ICMP_REDIRECT:
+		sctp_icmp_redirect(sk, t, skb);
+	default:
+		return;
+	}
+	if (!sock_owned_by_user(sk) && inet_sk(sk)->recverr) {
+		sk->sk_err = err;
+		sk->sk_error_report(sk);
+	} else {  /* Only an error on timeout */
+		sk->sk_err_soft = err;
+	}
+}
+
 /*
  * This routine is called by the ICMP module when it gets some
  * sort of error condition.  If err < 0 then the socket should
@@ -574,22 +617,19 @@ void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
 int sctp_v4_err(struct sk_buff *skb, __u32 info)
 {
 	const struct iphdr *iph = (const struct iphdr *)skb->data;
-	const int ihlen = iph->ihl * 4;
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
-	struct sock *sk;
-	struct sctp_association *asoc = NULL;
+	struct net *net = dev_net(skb->dev);
 	struct sctp_transport *transport;
-	struct inet_sock *inet;
+	struct sctp_association *asoc;
 	__u16 saveip, savesctp;
-	int err;
-	struct net *net = dev_net(skb->dev);
+	struct sock *sk;
 
 	/* Fix up skb to look at the embedded net header. */
 	saveip = skb->network_header;
 	savesctp = skb->transport_header;
 	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, ihlen);
+	skb_set_transport_header(skb, iph->ihl * 4);
 	sk = sctp_err_lookup(net, AF_INET, skb, sctp_hdr(skb), &asoc, &transport);
 	/* Put back, the original values. */
 	skb->network_header = saveip;
@@ -598,58 +638,10 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 		return -ENOENT;
 	}
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
 
-	switch (type) {
-	case ICMP_PARAMETERPROB:
-		err = EPROTO;
-		break;
-	case ICMP_DEST_UNREACH:
-		if (code > NR_ICMP_UNREACH)
-			goto out_unlock;
-
-		/* PMTU discovery (RFC1191) */
-		if (ICMP_FRAG_NEEDED == code) {
-			sctp_icmp_frag_needed(sk, asoc, transport,
-					      SCTP_TRUNC4(info));
-			goto out_unlock;
-		} else {
-			if (ICMP_PROT_UNREACH == code) {
-				sctp_icmp_proto_unreachable(sk, asoc,
-							    transport);
-				goto out_unlock;
-			}
-		}
-		err = icmp_err_convert[code].errno;
-		break;
-	case ICMP_TIME_EXCEEDED:
-		/* Ignore any time exceeded errors due to fragment reassembly
-		 * timeouts.
-		 */
-		if (ICMP_EXC_FRAGTIME == code)
-			goto out_unlock;
-
-		err = EHOSTUNREACH;
-		break;
-	case ICMP_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		/* Fall through to out_unlock. */
-	default:
-		goto out_unlock;
-	}
-
-	inet = inet_sk(sk);
-	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
-		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
-		sk->sk_err_soft = err;
-	}
-
-out_unlock:
+	sctp_v4_err_handle(transport, skb, type, code, info);
 	sctp_err_finish(sk, transport);
+
 	return 0;
 }
 
-- 
2.27.0

