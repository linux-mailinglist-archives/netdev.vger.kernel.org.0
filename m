Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9947ECE7
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfD2Wqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:37 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:39925 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2Wqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:35 -0400
Received: by mail-pg1-f202.google.com with SMTP id m35so8048720pgl.6
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M/b9939hEXj6kjf8ixGTEF02G4AWtacrYADvTMlcODQ=;
        b=eCX8ipEFmVBo42wV9eYf50/M6osVOZla8K1zBDFC7II3q7WPmGbhklm+J9Gv6EAKXF
         hSQVl0rOpqDHFllav5RqeXvCsxmDcTIZFAyAJFxBbSH3RUk+ylDvVEg82vC9IVJxFRUq
         keKZj32LYDsySgyzjErFho8CKi6/coSmcH7PbRBzZ9h1WsJkE0WdeWfmVf+M3kr9gGwp
         Uxr5E6f2PNRdsSQZZ2KNvlLp40x456Q1LuLiFTYkoNywRzvUI3D2ei4tnAi8hC9lYnEO
         UnA8346EmBtG0RkZhNg4OV2Pn1G8bS6Zl3yLD2K9A9QVLsV/hK+GBrfEhZl0aq/KJNuS
         gWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M/b9939hEXj6kjf8ixGTEF02G4AWtacrYADvTMlcODQ=;
        b=SnN53QryDQr4LO2Y9vwixCJN1w1I1blXRe9pcku9KrLfyK7DNFwJ4CaVtaoc//Fnyo
         W8EGUO997L9yeqyzi4/LUDKYyh4GOyWmf2A6aGQr8LRhbUPK32OoBoWzyOHRBQZ58n8h
         bcUfwkgzDodfGO23/dfbGKSx5yA3KTOLi1OX6wDSj64Owbi+EYF6UWNrwD6hYrqavzxj
         +KVOZMAzFqZkGrWtUcvKeQ12tLJ3ASB9+bdf4/uolQb7QEhnjiYsvJNRprbgZVSug91z
         Qkvph2ha/+kPzLF7RLFIh11yDuO/UhLPyQEs3G7m70D2qznvY7DYmHLawFJNEE8AdEpA
         XoUQ==
X-Gm-Message-State: APjAAAUFVSXxojqylmpABsH70i4oDfXg2xrH/G3vtnnmSeb+6C7mUwrN
        DZyJBozMXbjjfCXYbIED7+bZhQ/FYrQ=
X-Google-Smtp-Source: APXvYqzoNpLt4CI9mJmqjO05WoiU6IA0nlXFMx7KgwvAnK04xNvbGgUTE1mlkXREfWXRoCTA+1ZnOdFZOeU=
X-Received: by 2002:a65:518d:: with SMTP id h13mr62912761pgq.259.1556577994940;
 Mon, 29 Apr 2019 15:46:34 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:15 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-4-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 3/8] tcp: better SYNACK sent timestamp
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detecting spurious SYNACK timeout using timestamp option requires
recording the exact SYNACK skb timestamp. Previously the SYNACK
sent timestamp was stamped slightly earlier before the skb
was transmitted. This patch uses the SYNACK skb transmission
timestamp directly.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c  | 2 +-
 net/ipv4/tcp_output.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 695f840acc14..30c6a42b1f5b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6319,7 +6319,7 @@ static void tcp_openreq_init(struct request_sock *req,
 	req->cookie_ts = 0;
 	tcp_rsk(req)->rcv_isn = TCP_SKB_CB(skb)->seq;
 	tcp_rsk(req)->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
-	tcp_rsk(req)->snt_synack = tcp_clock_us();
+	tcp_rsk(req)->snt_synack = 0;
 	tcp_rsk(req)->last_oow_ack_time = 0;
 	req->mss = rx_opt->mss_clamp;
 	req->ts_recent = rx_opt->saw_tstamp ? rx_opt->rcv_tsval : 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 32061928b054..0c4ed66dc1bf 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3247,7 +3247,11 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 		skb->skb_mstamp_ns = cookie_init_timestamp(req);
 	else
 #endif
+	{
 		skb->skb_mstamp_ns = tcp_clock_ns();
+		if (!tcp_rsk(req)->snt_synack) /* Timestamp first SYNACK */
+			tcp_rsk(req)->snt_synack = tcp_skb_timestamp_us(skb);
+	}
 
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
-- 
2.21.0.593.g511ec345e18-goog

