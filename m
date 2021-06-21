Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3B43AE16C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFUBlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFUBlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:15 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1047C061574;
        Sun, 20 Jun 2021 18:39:01 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id t9so12264187qtw.7;
        Sun, 20 Jun 2021 18:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TSkpCo0zmT3nw+VWIO9DoVWpLrsx9rvrXEUy7z5BO8M=;
        b=LBghYToa0Rv8GpgUozmZA0m1gMxrV5IrKtmIfjfP+pHduK/J8F6NgaJ+rDMOJO6iIS
         PU0D/TN+bZRakYrVIJu1+RWFLFXOXiB0Jxo1USExZQjGWt+FFgZ+WJYJebIUqM/279iB
         cgwlo10UmfmE+IrL2AP3gLRUl6/XR/tlwml/XgoSZdUbFnU3XZ0PTwEX8kNZjMxXHU+R
         xpmT44sho3HBvGtHxHBTSqel2/mRQaDHOyfGUp0UX/NKC6+Uk/FCX2pbHBVfTY2OnZZD
         esSPwDpjSaTpunbc6YIFopPFXQFkqgWIR7zKH5TidZXnR8iF8WJyqy/vppUMX/HhUEZO
         b4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TSkpCo0zmT3nw+VWIO9DoVWpLrsx9rvrXEUy7z5BO8M=;
        b=t/mKzjRKK2aduy7tTV0u1Io8UGQavOV81MMPnWPeyS2douxdCxZd5s+DJPJOXYp9UG
         xw0C2pIWtP75jFfHSkMvfXLMTSnw4efljjR4oPozNj2BGlupLRi50/eY9BEB5omNOD48
         rg2DUvbl2zUeEvxp2R8VLg33MN+AU7sIr3i1LVqUBsBhMA7IAEf0FUDr7frFnwDiajVo
         bA56ZzZjG9NAn7v73F7PStKyfbc1D2q3vnaOwG19Mc7+pThyNLpvIHXKuTHtKtqOrUQW
         EMkkrnIwLXmwuU40j3LnEn/C4a7PKL5/LvGI6t7sY5WIyotjijCF4eFNsSRA3nSFlesx
         7L5Q==
X-Gm-Message-State: AOAM531Lu4cag8o7nU9RSpgKzkHfwZbgFkxlQ0ONpwFuf8KkMAtlulKQ
        j3WZEMDK58NrPxce1VkruANdXdd0FdheOA==
X-Google-Smtp-Source: ABdhPJyuDBb7SCJ6fg5Gaom9GvNAetsqc/Mju7NliEs7raX7FpY9ng3lLVludWtN3+nXEGKmZNCJ+Q==
X-Received: by 2002:ac8:5a55:: with SMTP id o21mr21391206qta.0.1624239540826;
        Sun, 20 Jun 2021 18:39:00 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 137sm8791016qkg.75.2021.06.20.18.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:39:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 09/14] sctp: do state transition when receiving an icmp TOOBIG packet
Date:   Sun, 20 Jun 2021 21:38:44 -0400
Message-Id: <079e91bfe9ea9f081df75d04e74253b099ce7a84.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
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

