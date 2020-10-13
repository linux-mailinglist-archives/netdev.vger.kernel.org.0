Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33CE28C950
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390243AbgJMH3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390040AbgJMH3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:29:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E84C0613D0;
        Tue, 13 Oct 2020 00:29:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w11so2462631pll.8;
        Tue, 13 Oct 2020 00:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=uFm0nPRdexEfeAeht+VaJhrfPzdGjqeuDyl8D61RPqeCrFkTjDYwF7Nd7cVmOwgqmx
         B1/+GSqy+xe/FTEUJFGd9MML+kXT+pcatMA+pVf5YPKNmvpU0ye+DOkyvntsdQPcD3KC
         kkgK4nGhtkiQ6FHdAYJqEK7M0V5eiQqBA1NHoeUf3cBmmjsXRvDVmTLUq4gjMI4Yb8uL
         gZAuL714Ys3yXk7LG/NOyu2sdUSJskTmJbU/8OQ8zVECLFhJkfXOfd42bfIfvrPD6+QH
         ehP4BW0Rm7/3qVh3JKeM8vUZ9y3Hpa+sCH6hwuhn6Ech1JCkw+1FF9dEAPHvZKhbhV3j
         B0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=QmZh8fKR8if1/MyIe9vLAPCDz2yd/dpx72HEtPfeanvc6T31REvtJZRsBkb6FyvIWv
         Hrg2Y398ugYMWJ1goK+SiWUIo2IlT/Fg9wkP4eTLO+4BX92fmxUp5P867cCcI8703I6x
         nVE7aCnTXsqsTcE3Z5ivxZFem99QQ8FLtCDqUI9rkcDa3S8m4WVXVTKl7aTBCga5aoJb
         7Np3hnWGHYXPc+EhVjsi807ujayD1mr/9sqbKTXCq6BLI0Hsi7NXWlcj3Ll4lnWN0XKl
         Eq1yuGMNtDEf4S1n1CSVcaPYmx4ErKkVtgaQ+3s7pMv/I3xLcGckwklGqbVyvVnU9pne
         cuaA==
X-Gm-Message-State: AOAM532BYhjcJmozv+3/AY4fRlsneXJZxA5xufai1p3KDnt3MoCdrw3e
        MMVsiSbwDr+s0+OqInROyWlNi4egbYw=
X-Google-Smtp-Source: ABdhPJx7cSDwY/jkqvWdz4StqIYA311wcRU9xIMgr4xZxpbTpEiFkF2GUFFn2ngtrRcvpdBAu0+Xgw==
X-Received: by 2002:a17:902:a5ca:b029:d3:7d11:2a80 with SMTP id t10-20020a170902a5cab02900d37d112a80mr26069707plq.58.1602574152358;
        Tue, 13 Oct 2020 00:29:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g1sm22098759pfm.124.2020.10.13.00.29.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:29:11 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 11/16] sctp: call sk_setup_caps in sctp_packet_transmit instead
Date:   Tue, 13 Oct 2020 15:27:36 +0800
Message-Id: <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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

