Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E182F24EE
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405363AbhALAZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403783AbhAKXGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:06:38 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBA7C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:05:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e74so471200ybh.19
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Qk10GgT+/yrIhTuRdpP09hyN5nT3qPv7TAoLnV3vR/E=;
        b=MHgCPyrsCgnJwBdjxnoqaQng3URa3gAxCNTizIcDMo8Hw0obCscvRzwIz+REbuL3F+
         yszsECWu60MN0wr0V9whz0uAODiOeNiVDuYax7VvcmilggjdquAYk18S8zLzeKZE1tRm
         pB75GcByXSK9MsJBrstTn3AyWsyYrU4Cww9gxvftkzc0xJkz6xcvt/LPCb+9WYg2wTbP
         6440mYQsO+uj8ok1leqym2PJZEtttbR029o4c7Hv0Xk5csQR4HOcGB1oRq4q1aR+ED23
         aPSRB/CKXWKua1V8uugpLtUBRaIEF9mlCenUfCtFzR/48j1gUUBLIHXL/BRmDP4aQ4E7
         Sdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Qk10GgT+/yrIhTuRdpP09hyN5nT3qPv7TAoLnV3vR/E=;
        b=APSUiOTa6UhjkFIrFolGxBcfMgCIjIsJtMFkg2kydZ+LAv2qT1qPtzVawtnwPFOFly
         u33ofW0C3IHNOUUuiz/ars8xy9n11dchLqhiavSeP/HGpLFhNVZjaqy6+NYVaKvtlKqQ
         HR+RkJDYLCNiBiOszbV5i32V/3FBQfSrXzoSGE8p0O+dDSMbmlkMD/eNbqOsfCDC3RFt
         65mJpf3dDg2h6BMoOzoL0mQCy6QMAXfSdjJEm6iEUPKUBDW9f+RGN2UGF9OctyZg+We6
         zwe7SpRkE34pe/oefgmGcsGbvufPJ09fI0vITktrrVjw9XhzXdraGp5XLcLU9vhdPpZM
         3bXQ==
X-Gm-Message-State: AOAM531O0TEvVcce4F3qnIQs/y/i45zLVy6z/G5agQZ1WakKdfQQJIRI
        U6/1mKkzSuHeenZKYPWdqvJa+PHLMS4=
X-Google-Smtp-Source: ABdhPJz1ALVk+8vBGrRIP6zz/vCDhhojamPygMkIT03ABgAEFsoKjwBeb03hOsuAAya78BwgKSVCrrKySE8=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a25:d38e:: with SMTP id e136mr2917048ybf.281.1610406356681;
 Mon, 11 Jan 2021 15:05:56 -0800 (PST)
Date:   Mon, 11 Jan 2021 15:05:52 -0800
Message-Id: <20210111230552.2704579-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next] tcp: assign skb hash after tcp_event_data_sent
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move skb_set_hash_from_sk s.t. it's called after instead of before
tcp_event_data_sent is called. This enables congestion control
modules to change the socket hash right before restarting from
idle (via the TX_START congestion event).

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f322e798a351..899d053cb10e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1319,7 +1319,6 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	skb_orphan(skb);
 	skb->sk = sk;
 	skb->destructor = skb_is_tcp_pure_ack(skb) ? __sock_wfree : tcp_wfree;
-	skb_set_hash_from_sk(skb, sk);
 	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 
 	skb_set_dst_pending_confirm(skb, sk->sk_dst_pending_confirm);
@@ -1390,6 +1389,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 			      tcp_skb_pcount(skb));
 
 	tp->segs_out += tcp_skb_pcount(skb);
+	skb_set_hash_from_sk(skb, sk);
 	/* OK, its time to fill skb_shinfo(skb)->gso_{segs|size} */
 	skb_shinfo(skb)->gso_segs = tcp_skb_pcount(skb);
 	skb_shinfo(skb)->gso_size = tcp_skb_mss(skb);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

