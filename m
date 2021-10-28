Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B343DDDD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJ1JjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhJ1JjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:39:12 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB25C061570;
        Thu, 28 Oct 2021 02:36:45 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g10so22007674edj.1;
        Thu, 28 Oct 2021 02:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MagIzwlMg0pBulaBVZB5v/rWaq1H9cpvWyZ+olzH6Z0=;
        b=Ua6RxpR5CNPz52SoqpgOfnSGwgK4Yrv9S2CfeQcPHK610CIgS09JTTKDLxH1OCxDq5
         O6nQlyUA1TWq2g1cjVyinEHu3b0+q03TrbA1Q8haj6lAmr0qktzV7UI7DPS+/T9yfDo1
         DSU2d+yj6Tb86kKR+F1Td+Pgd71TmX2+VcwhjslYFduWTn8abol/kO6kvDZ2upTgoVXR
         WT3OXsIKOtmXH1G897sqSPN6qf5geNIDQ5Lbjb5TYfkczFJ5BSO+MKE/CgqbS8ZxAsf2
         NqDFLcPkWimIkMN7Y/+gqqSkTRbUAydL9xgGi0H2vTtyEjEUqC0FMUDJjWVK5lVNcdr1
         nL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MagIzwlMg0pBulaBVZB5v/rWaq1H9cpvWyZ+olzH6Z0=;
        b=uhOxHhrr23Q5MQyx9Ykv4Z+ZB5ycbZDgWI1Ugm1Hp1fuxXBcvaf98zUUej+X4MbD3L
         SrYDNYJCq21sYgDpaV2ay0ELLsUwqMIeiDL6ZOkRUIABgQLJdAWa71ZtCsOfVwE3gfbN
         FJqybx8donFrYIIgf/omIcraRlYhk2rvFLt0DQq1drbtvKTgN4gxcD6EKt5F+ohY0Qu0
         fmAJbs4GIP6LDw6G9AXvh74bwII1jwYoFcSQlpH/jnDFtEoNA9j56qSuUQpnHAq2V3dZ
         c4DNUI1G4LZ8POVTRAkMBm0MsA8BQGN8bow75GIph28t6Bl2aXuTzBtIGudjD4BUXk4p
         ayFg==
X-Gm-Message-State: AOAM5338mC2v8XCsHbvrxaB6tYY8Y6Peed63Fx8PqUkhLjTZcOhXzb4Y
        VFmmxsJIGeK3UNAGYma1f/fyWpVG4qARfQ==
X-Google-Smtp-Source: ABdhPJzm8c9jtrBZWjbKeRSFYn1DdeDdHyx6SlYUtqyyTtZr6OR8QdBbURRzgeuNxKOKgftAKDwCWw==
X-Received: by 2002:a05:6402:d0a:: with SMTP id eb10mr4611796edb.292.1635413803999;
        Thu, 28 Oct 2021 02:36:43 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s12sm1379865edc.48.2021.10.28.02.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:36:43 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 1/4] sctp: allow IP fragmentation when PLPMTUD enters Error state
Date:   Thu, 28 Oct 2021 05:36:01 -0400
Message-Id: <8a59f3bd9d43063f77c7b8db88f6722be44c6034.1635413715.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635413715.git.lucien.xin@gmail.com>
References: <cover.1635413715.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when PLPMTUD enters Error state, transport pathmtu will be set
to MIN_PLPMTU(512) while probe is continuing with BASE_PLPMTU(1200). It
will cause pathmtu to stay in a very small value, even if the real pmtu
is some value like 1000.

RFC8899 doesn't clearly say how to set the value in Error state. But one
possibility could be keep using BASE_PLPMTU for the real pmtu, but allow
to do IP fragmentation when it's in Error state.

As it says in rfc8899#section-5.4:

   Some paths could be unable to sustain packets of the BASE_PLPMTU
   size.  The Error State could be implemented to provide robustness to
   such paths.  This allows fallback to a smaller than desired PLPMTU
   rather than suffer connectivity failure.  This could utilize methods
   such as endpoint IP fragmentation to enable the PL sender to
   communicate using packets smaller than the BASE_PLPMTU.

This patch is to set pmtu to BASE_PLPMTU instead of MIN_PLPMTU for Error
state in sctp_transport_pl_send/toobig(), and set packet ipfragok for
non-probe packets when it's in Error state.

Fixes: 1dc68c194571 ("sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c    | 13 ++++++++-----
 net/sctp/transport.c |  4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 4dfb5ea82b05..cdfdbd353c67 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -581,13 +581,16 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	chunk = list_entry(packet->chunk_list.next, struct sctp_chunk, list);
 	sk = chunk->skb->sk;
 
-	/* check gso */
 	if (packet->size > tp->pathmtu && !packet->ipfragok && !chunk->pmtu_probe) {
-		if (!sk_can_gso(sk)) {
-			pr_err_once("Trying to GSO but underlying device doesn't support it.");
-			goto out;
+		if (tp->pl.state == SCTP_PL_ERROR) { /* do IP fragmentation if in Error state */
+			packet->ipfragok = 1;
+		} else {
+			if (!sk_can_gso(sk)) { /* check gso */
+				pr_err_once("Trying to GSO but underlying device doesn't support it.");
+				goto out;
+			}
+			gso = 1;
 		}
-		gso = 1;
 	}
 
 	/* alloc head skb */
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index a3d3ca6dd63d..1f2dfad768d5 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -269,7 +269,7 @@ bool sctp_transport_pl_send(struct sctp_transport *t)
 		if (t->pl.probe_size == SCTP_BASE_PLPMTU) { /* BASE_PLPMTU Confirmation Failed */
 			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
 
-			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 			sctp_assoc_sync_pmtu(t->asoc);
 		}
@@ -366,7 +366,7 @@ static bool sctp_transport_pl_toobig(struct sctp_transport *t, u32 pmtu)
 		if (pmtu >= SCTP_MIN_PLPMTU && pmtu < SCTP_BASE_PLPMTU) {
 			t->pl.state = SCTP_PL_ERROR; /* Base -> Error */
 
-			t->pl.pmtu = SCTP_MIN_PLPMTU;
+			t->pl.pmtu = SCTP_BASE_PLPMTU;
 			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
 		}
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
-- 
2.27.0

