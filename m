Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6879E3B0C8A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhFVSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB8EC09B090;
        Tue, 22 Jun 2021 11:05:12 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id g12so118687qtb.2;
        Tue, 22 Jun 2021 11:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OnRXTRYmDVMNJhGqPMN/aMNFAew5BRSCunG//LL/Y8I=;
        b=Au1Aa4vuOaBGSPn7r2l/Fnf5bMSn2jztIqYQTny6rlsclDo3vzjBdh/AK1BmjUryZL
         lxRgGBnQ5qtENIMUaJzxTjGiYpoSmIHXhlxqMsGVvzsO7jrq9BL5mctNKzFN5CLjxjHi
         P9ejsJ18dns+3sAytPUAmACNf65k7XGAELOxB8REU3Oah7olk7+Gfabjk7wKf6rvc9Ci
         GWDPJehTZu9B9j1krd4IGX1zpOjUwbWCpY3ykGiPHhCND003qcPeBQEcqGL+PVMbX+kS
         b03AC7mM2BQCCLxyywWoDySoO7C3pK+AysEyPVXjSBMr2FFPy7HqMvmWbaPNiQhzWHfv
         ZQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnRXTRYmDVMNJhGqPMN/aMNFAew5BRSCunG//LL/Y8I=;
        b=maPYEcCm/AWFQSGYzukGsZz+hN6LNPry9NxZqZ2LGCLGL5HBUG9W2wLxkXXsFJg9Rn
         Z9ECoRqHX18fV7SDDiO1w7NmV0YreTlc6Ex9icC7/QM34fYjbp5XDqGiNOyJzjX4vrUb
         pBKSs4aTskUw9mCk/1ThDbdsgLGX1jYUk+SmG2FPCJPpa17hAZxq63QQ9w4jXs2gLyXO
         9XCN1nvnXMIjR9sNXVGUKOyG9G9P5HIXp6Ofnf3KFv1mYQC7kYeJLxAl8YICBaNK/QvM
         5J5FwCwO0VarEBNttNFZXp9ZfAKRG2WBVMpiy+FX/ELgT48beFehMesWaMiiCpaUG3Xb
         a2MA==
X-Gm-Message-State: AOAM5339/lKp/hehQ4p1YxX2PRkFFrBLDw3cQOzglC8pGBDriKdO+O49
        Y/DKObCPmemLVBAZCxF+yfyEP0BlsJ23pA==
X-Google-Smtp-Source: ABdhPJyAqYfY2PZTNBHc6LBs6QT9GRcdMIn1CwzjQLtXgQDG0ti7FWNE1iNOv1kZsyHr7gjMbGNLeA==
X-Received: by 2002:ac8:7d48:: with SMTP id h8mr561qtb.317.1624385111288;
        Tue, 22 Jun 2021 11:05:11 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o126sm1777905qka.74.2021.06.22.11.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 09/14] sctp: do state transition when receiving an icmp TOOBIG packet
Date:   Tue, 22 Jun 2021 14:04:55 -0400
Message-Id: <59228a1024ccaa1ac1c98132f5df5697bf880cf7.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLPMTUD will short-circuit the old process for icmp TOOBIG packets.
This part is described in rfc8899#section-4.6.2 (PL_PTB_SIZE =
PTB_SIZE - other_headers_len). Note that from rfc8899#section-5.2
State Machine, each case below is for some specific states only:

  a) PL_PTB_SIZE < MIN_PLPMTU || PL_PTB_SIZE >= PROBED_SIZE,
     discard it, for any state

  b) MIN_PLPMTU < PL_PTB_SIZE < BASE_PLPMTU,
     Base -> Error, for Base state

  c) BASE_PLPMTU <= PL_PTB_SIZE < PLPMTU,
     Search -> Base or Complete -> Base, for Search and Complete states.

  d) PLPMTU < PL_PTB_SIZE < PROBED_SIZE,
     set pl.probe_size to PL_PTB_SIZE then verify it, for Search state.

The most important one is case d), which will help find the optimal
fast during searching. Like when pathmtu = 1392 for SCTP over IPv4,
the search will be (20 is iphdr_len):

  1. probe with 1200 - 20
  2. probe with 1232 - 20
  3. probe with 1264 - 20
  ...
  7. probe with 1388 - 20
  8. probe with 1420 - 20

When sending the probe with 1420 - 20, TOOBIG may come with PL_PTB_SIZE =
1392 - 20. Then it matches case d), and saves some rounds to try with the
1392 - 20 probe. But of course, PLPMTUD doesn't trust TOOBIG packets, and
it will go back to the common searching once the probe with the new size
can't be verified.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c     |  4 +++-
 net/sctp/transport.c | 51 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index d508f6f3dd08..9ffdbd6526e9 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -385,7 +385,9 @@ static int sctp_add_backlog(struct sock *sk, struct sk_buff *skb)
 void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 			   struct sctp_transport *t, __u32 pmtu)
 {
-	if (!t || (t->pathmtu <= pmtu))
+	if (!t ||
+	    (t->pathmtu <= pmtu &&
+	     t->pl.probe_size + sctp_transport_pl_hlen(t) <= pmtu))
 		return;
 
 	if (sock_owned_by_user(sk)) {
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 79ff5ca6b472..5cefb4eab8a0 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -343,10 +343,55 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
 	}
 }
 
+static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
+{
+	pr_debug("%s: PLPMTUD: transport: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n",
+		 __func__, t, t->pl.state, t->pl.pmtu, t->pl.probe_size, pmtu);
+
+	if (pmtu < SCTP_MIN_PLPMTU || pmtu >= t->pl.probe_size)
+		return false;
+
+	if (t->pl.state == SCTP_PL_BASE) {
+		if (pmtu >= SCTP_MIN_PLPMTU && pmtu < SCTP_BASE_PLPMTU) {
+			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
+
+			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+		}
+	} else if (t->pl.state == SCTP_PL_SEARCH) {
+		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
+			t->pl.state = SCTP_PL_BASE;  /* Search -> Base */
+			t->pl.probe_size = SCTP_BASE_PLPMTU;
+			t->pl.probe_count = 0;
+
+			t->pl.probe_high = 0;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+		} else if (pmtu > t->pl.pmtu && pmtu < t->pl.probe_size) {
+			t->pl.probe_size = pmtu;
+			t->pl.probe_count = 0;
+
+			return false;
+		}
+	} else if (t->pl.state == SCTP_PL_COMPLETE) {
+		if (pmtu >= SCTP_BASE_PLPMTU && pmtu < t->pl.pmtu) {
+			t->pl.state = SCTP_PL_BASE;  /* Complete -> Base */
+			t->pl.probe_size = SCTP_BASE_PLPMTU;
+			t->pl.probe_count = 0;
+
+			t->pl.probe_high = 0;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
+			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
+		}
+	}
+
+	return true;
+}
+
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
-	struct dst_entry *dst = sctp_transport_dst_check(t);
 	struct sock *sk = t->asoc->base.sk;
+	struct dst_entry *dst;
 	bool change = true;
 
 	if (unlikely(pmtu < SCTP_DEFAULT_MINSEGMENT)) {
@@ -357,6 +402,10 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 	}
 	pmtu = SCTP_TRUNC4(pmtu);
 
+	if (sctp_transport_pl_enabled(t))
+		return sctp_transport_pl_toobig(t, pmtu - sctp_transport_pl_hlen(t));
+
+	dst = sctp_transport_dst_check(t);
 	if (dst) {
 		struct sctp_pf *pf = sctp_get_pf_specific(dst->ops->family);
 		union sctp_addr addr;
-- 
2.27.0

