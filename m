Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F17EECE9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbfD2Wqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:42 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:37156 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfD2Wqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:40 -0400
Received: by mail-yw1-f74.google.com with SMTP id c67so10298712ywb.4
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uG8p6b3QYAoW3XIKk1ywZtEVd4eZ0n/Wv/shp1jrEvs=;
        b=DCycpuZUajjnHPgYF9YgL/lVAGEFbSk3M4nmuoXqCkBSoUR0r3uGAdlPqOLVJyVgNP
         zLgEk41mJzrdV30PpowUdNaFekmCSl6WkLf3APXeSFbLfRDc6kC2YfI37xOrsPyHkCZE
         a4/UVnea7KwI8xM0ve3RpDVSvXkTxAGxZlKHjB7KHI1yv4YWG3oSzgAAqlj2AHZilWQI
         QVEkXSGjMYMEHEgBtnLmfwsnjEWeN8vVjmftLHV81BxdWCSa1A8uJa5bxmNyC8Zs3QG9
         WaTzKyAAybaaEDtx/rORBOcVvFOW0MeRexgSf6roXluHSG9aGZKBaJXNJB4KE5uM7nOI
         wPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uG8p6b3QYAoW3XIKk1ywZtEVd4eZ0n/Wv/shp1jrEvs=;
        b=ju9ih/8JqSknfC9+gJmnNmt0UgUoSJbmeytNTatKNxts3FWcR5DvwxViZe52CLMLT0
         BTRn4dNMnjka5j7gETfPXpgv/Am799Px8tCo++yNK9M7VL7cJxkMYcBsgZ9loX85ysFP
         tEBmySzZJhJMF69OiVVJiJXPDSATsuZZeVx5S5tniIWtCJEuAng8cGo7kJU50cI6vnbx
         0ftLF5EhUehnOC1OCyPQn9KychUJcBTciG0tlPBEcrwXYZM4tgcJPU8XWlY5yYRwOPMl
         UZ5xm8vFHt8jHqodaGg1LL33ZJSDqRCWST38LmCvhtKCi3TDKKppUqUOgm838KPHrlhL
         +9ww==
X-Gm-Message-State: APjAAAUZs7GZ1hZpRrztpB3aoLBuEhfCbedk4EAW07EQenMny0coj7nU
        hpSphd+mBeC9G4JtPx+uBiwBP1SIxwM=
X-Google-Smtp-Source: APXvYqzQi1sk3Xf88DPVna1D9TVBa5doKP/arkrSncBpADBbUNBY8jaz13QXUuP4ioWVnn+HA379POufeVI=
X-Received: by 2002:a0d:e1c3:: with SMTP id k186mr28499576ywe.355.1556578000008;
 Mon, 29 Apr 2019 15:46:40 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:17 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-6-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 5/8] tcp: lower congestion window on Fast Open SYNACK timeout
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP sender would use congestion window of 1 packet on the second SYN
and SYNACK timeout except passive TCP Fast Open. This makes passive
TFO too aggressive and unfair during congestion at handshake. This
patch fixes this issue so TCP (fast open or not, passive or active)
always conforms to the RFC6298.

Note that tcp_enter_loss() is called only once during recurring
timeouts.  This is because during handshake, high_seq and snd_una
are the same so tcp_enter_loss() would incorrect set the undo state
variables multiple times.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index f0c86398e6a7..2ac23da42dd2 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -393,6 +393,9 @@ static void tcp_fastopen_synack_timer(struct sock *sk)
 		tcp_write_err(sk);
 		return;
 	}
+	/* Lower cwnd after certain SYNACK timeout like tcp_init_transfer() */
+	if (icsk->icsk_retransmits == 1)
+		tcp_enter_loss(sk);
 	/* XXX (TFO) - Unlike regular SYN-ACK retransmit, we ignore error
 	 * returned from rtx_syn_ack() to make it more persistent like
 	 * regular retransmit because if the child socket has been accepted
-- 
2.21.0.593.g511ec345e18-goog

