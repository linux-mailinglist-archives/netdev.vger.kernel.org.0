Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F242503357
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348687AbiDPANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 20:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiDPANv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 20:13:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19AB4163A
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:20 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so8209166plh.1
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 17:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=voz66caexxFz/vB6IlDaiR7ZhtSqXFLJ+ZGvJbrFV5A=;
        b=SOTFGlzRziukjfc4y2wAXpERNAyn7O1fKk6FNoFFa4moDUK6FqiB3OI3lJbgrHCgPm
         ocLR7PnzrnUtu0Xr/FpfuXO9SYJmv+PSdFUL1CRQsh51ouAG5hpXewUNe29fx3L/LSMn
         HXKhPfibIudu1NIRtt393zTBWo4yvzT62qwmxORc99GGpX7tmWBfPkYdl5qdQRGjV/g7
         6kFrited3mDT9XGmUWa2cP5OmQMrE115xHtHgvMN5LI66UebtATCLhIEWgiT7+sXpELh
         jTlQK2VnGEJSqyVR7HR4s++8NJrdS9G4FkMw+3ZuvEuF5moXjlKg/rpfKmozKrwOinTg
         gbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=voz66caexxFz/vB6IlDaiR7ZhtSqXFLJ+ZGvJbrFV5A=;
        b=Cg12kFbJBxbQbgLYBAVWgkJKRWsxUQYT5CnONVIgrZfuzpav730D7QdN8L8ik+2wCg
         MR59u4Ok6IYyBsO63dztubNSMoQAFJMmQ+e/imIpJFtXRYZn6qPMYpvogE9lv1abc221
         DlUU5Y6HDDEU6YCTa/40WXUREUY+2x6i4dGzaDtbZ8rIQk6s2/LC1TCNPXFX+tZEJMb/
         3XWB6wkuk++RHt2byX6hAxT0D/8852sKlYOtuWYBIWY87oIOhxpUq4waJXqs06mEAMRD
         VmRnnwzr/qeUXqjncQf5RioB5TvvOMmDf4FbYIeCg49fGdis3VpxJ6eya8g39cOchwDq
         x+wg==
X-Gm-Message-State: AOAM533g+u43L6m0hFA3l1zaRHvfhLLfoVfltSzDareJYZiiRXWWl1J/
        w7b9gQWzPZHkcR2APHKuRz0=
X-Google-Smtp-Source: ABdhPJxISntoSBtL0AOhw3ZmQrmZGxKv/drJgfByNnfy7Nn6u+GBaYrWD4WjCfrslbtgEeYLSjySCA==
X-Received: by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id g24-20020a170902869800b0015899d46256mr1464799plo.104.1650067880004;
        Fri, 15 Apr 2022 17:11:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm5729514pjf.23.2022.04.15.17.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:11:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/10] tcp: add two drop reasons for tcp_ack()
Date:   Fri, 15 Apr 2022 17:10:44 -0700
Message-Id: <20220416001048.2218911-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220416001048.2218911-1-eric.dumazet@gmail.com>
References: <20220416001048.2218911-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add TCP_TOO_OLD_ACK and TCP_ACK_UNSENT_DATA drop
reasons so that tcp_rcv_established() can report
them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h     | 2 ++
 include/trace/events/skb.h | 3 +++
 net/ipv4/tcp_input.c       | 7 ++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6f1410b5ff1372d9e1f7a75c303f8d7876c83ef0..9ff5557b190905f716a25f67113c1db822707959 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -390,6 +390,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CLOSE,	/* TCP socket in CLOSE state */
 	SKB_DROP_REASON_TCP_FASTOPEN,	/* dropped by FASTOPEN request socket */
 	SKB_DROP_REASON_TCP_OLD_ACK,	/* TCP ACK is old, but in window */
+	SKB_DROP_REASON_TCP_TOO_OLD_ACK, /* TCP ACK is too old */
+	SKB_DROP_REASON_TCP_ACK_UNSENT_DATA, /* TCP ACK for data we haven't sent yet */
 	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed */
 	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by
 						 * BPF_PROG_TYPE_CGROUP_SKB
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index fbe21ad038bc6701ed04cb6be417c544de0dae84..eab0b09223f3c66255f930d44be61d45e83ca6e8 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -45,6 +45,9 @@
 	EM(SKB_DROP_REASON_TCP_CLOSE, TCP_CLOSE)		\
 	EM(SKB_DROP_REASON_TCP_FASTOPEN, TCP_FASTOPEN)		\
 	EM(SKB_DROP_REASON_TCP_OLD_ACK, TCP_OLD_ACK)		\
+	EM(SKB_DROP_REASON_TCP_TOO_OLD_ACK, TCP_TOO_OLD_ACK)	\
+	EM(SKB_DROP_REASON_TCP_ACK_UNSENT_DATA,			\
+	   TCP_ACK_UNSENT_DATA)					\
 	EM(SKB_DROP_REASON_IP_OUTNOROUTES, IP_OUTNOROUTES)	\
 	EM(SKB_DROP_REASON_BPF_CGROUP_EGRESS,			\
 	   BPF_CGROUP_EGRESS)					\
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 85fae79c894d4b96820747c658bb4d884981c49e..8a68785b04053b8e622404035284920e51cd953c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3766,7 +3766,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		if (before(ack, prior_snd_una - tp->max_window)) {
 			if (!(flag & FLAG_NO_CHALLENGE_ACK))
 				tcp_send_challenge_ack(sk);
-			return -1;
+			return -SKB_DROP_REASON_TCP_TOO_OLD_ACK;
 		}
 		goto old_ack;
 	}
@@ -3775,7 +3775,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	 * this segment (RFC793 Section 3.9).
 	 */
 	if (after(ack, tp->snd_nxt))
-		return -1;
+		return -SKB_DROP_REASON_TCP_ACK_UNSENT_DATA;
 
 	if (after(ack, prior_snd_una)) {
 		flag |= FLAG_SND_UNA_ADVANCED;
@@ -5962,7 +5962,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 		return;
 
 step5:
-	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
+	reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
+	if (reason < 0)
 		goto discard;
 
 	tcp_rcv_rtt_measure_ts(sk, skb);
-- 
2.36.0.rc0.470.gd361397f0d-goog

