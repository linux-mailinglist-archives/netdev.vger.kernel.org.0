Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC27292747
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgJSM1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbgJSM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC108C0613D0;
        Mon, 19 Oct 2020 05:27:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r10so1126729plx.3;
        Mon, 19 Oct 2020 05:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=DyVHhRozNAWDkboXTLRB1V5z+YPNnvIQX9/lfIncYO/7jqcMxIynJyVq9ZDW6TdIqK
         H4ql7DJSLAmL009kw4dEQD7QnOZDCDMk6zBk3YhVE3m0jsohziveJx8oRyjaXylLD9J3
         VDIuo8EDtoVsS1qfYIWG/TpO8NgrCqdPXUcGpyYwV6otq6U1GmoVRY/WVFKVVBBH3/h6
         jDGL7kNOTxvgaLsiDgAjWMP6XvvGc6FpuyKzsPqSt6doVNX94rb0uEFTJ19Dy3kbmjR3
         yu1mrwDu+C+aoCvDc1OQRY3IYgwEEeaUcmRtevHMOR1PfzSG2zVBzzkhqL2l5YRZPmr9
         m1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=scv8xFvxzrDY91HWidSjNcMjK4lDXxpxYcTu2TOH7NM3NR7TEwsYd24U7wvHeSc8fw
         35fSKP1j6Va6P939yploCRzstUD0j1Tvqc8xXt1n2UAhRO1cvpTqMXEDjgjDKvfwCN2k
         QsLhNc18GdbW2Id3gC7pCwc+GSON7rQZEOduJ5LX8gEkbCnA0T3IMLW8UtxRlZZHD/UW
         KKULi0XO7RraqefGHbD63XamM2Zj2+u3Wbo/fvZIEmPAJ8cNjFgZK0RXGlLTithhuqTI
         VCTCU+n5W60/+u9NLejUtADGR4pTmG6aaWBwhxIXRe23ob2QtpjW45QpaJrpE7OUcOZP
         hgHQ==
X-Gm-Message-State: AOAM533Dp2SD/TCGUshOx8aqM5TjFRub8ebnmwJUkKnkTwIFqYxwPO8L
        roemBsGCmNqBCx6gVo8eES1oArXoTMo=
X-Google-Smtp-Source: ABdhPJzNsD/WOhx8G4t2hEN7WtPnBYt3rvcSktR0B3JWE7UXIf6Ww0HJzR6kxlFcWofw1euRG/80Mg==
X-Received: by 2002:a17:90a:ff12:: with SMTP id ce18mr15992572pjb.223.1603110424313;
        Mon, 19 Oct 2020 05:27:04 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f5sm11106349pgi.86.2020.10.19.05.27.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 11/16] sctp: call sk_setup_caps in sctp_packet_transmit instead
Date:   Mon, 19 Oct 2020 20:25:28 +0800
Message-Id: <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
Add GSO support"), as:

  "We have to refresh this in case we are xmiting to more than one
   transport at a time"

This actually happens in the loop of sctp_outq_flush_transports(),
and it shouldn't be tied to gso, so move it out of gso part and
before sctp_packet_pack().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf..fb16500 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -508,12 +508,6 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 					sizeof(struct inet6_skb_parm)));
 		skb_shinfo(head)->gso_segs = pkt_count;
 		skb_shinfo(head)->gso_size = GSO_BY_FRAGS;
-		rcu_read_lock();
-		if (skb_dst(head) != tp->dst) {
-			dst_hold(tp->dst);
-			sk_setup_caps(sk, tp->dst);
-		}
-		rcu_read_unlock();
 		goto chksum;
 	}
 
@@ -593,6 +587,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	}
 	skb_dst_set(head, dst);
 
+	rcu_read_lock();
+	if (__sk_dst_get(sk) != tp->dst) {
+		dst_hold(tp->dst);
+		sk_setup_caps(sk, tp->dst);
+	}
+	rcu_read_unlock();
+
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
-- 
2.1.0

