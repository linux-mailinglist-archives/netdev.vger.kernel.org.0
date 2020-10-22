Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A9D2960F3
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900869AbgJVOdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443602AbgJVOdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:33:54 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057E2C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:33:53 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id i22so1605417qkn.9
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 07:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFLk1Uj1baSpLcW5iFaf4mSz7Gv/dskCvZlVDpwjXzA=;
        b=O1Ly+DCIgbv35vly+9MEV8GT8D0Bv/7xV71Kyi4f4KdlEDM8rq0CCQmBVroUwCFTKu
         xudTtlXF1ZEPCC0RGZLRDO3M3o3tdNHzMuEI322150bC1V6s7MWfJ+ysBoDgGtLCK4IX
         oKk1VhvDHvK/VynqMAGA1uTwpDDnzrSFBaYjUXT/UxSApIZKn4gShF8VS6fn6lf3hHIT
         0pCPTOr5tFs1zeqZQw9fkp6yROMtWOSgxmtfkaSwoSPlxc90Tzuteg+VIT17MTJmO8WQ
         gBCU0X17i5Q8Bjy06glYPkhhxUDB3bzNPvMdzfKNHJwzXRijt5jDSpHWdAdEOH90FzzP
         s4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFLk1Uj1baSpLcW5iFaf4mSz7Gv/dskCvZlVDpwjXzA=;
        b=k8R+4I0FZPqmDS02jZS+mic+qw4+JiaH8f5jvdV0Cc5ymrYed7vf8WKHhWI8wf6cDo
         Pm1wIQg1w1lKxbY4zTvOSbQrTew0P1oVGBHa74+MI9fXme38JdbEE57DsejAhqab2YPW
         st6bouFk+/ysDSPfQF/JqECPR4vdm7f+qRS4KDJ1bFXow+r1R8TCW0eGcZIw5gBMUrnF
         39yZT6YHMZtCvWwjsbWxltdhT4+ItQSDpWEWhOX4qxmk8EJQlWkTCB1etjPEkBhPYcHI
         MlQkd6ZNT0SAHO5YZSjLIqXdj1LMC+eVxz8Mers9KdJ2c8EOxziEzPZieTAQMN6/uGqS
         kT4A==
X-Gm-Message-State: AOAM5312tZpaweHvepd99QCA8pNxE4glBkPuMXUURRhpScjM4TXpZ0Kc
        My8CeJBzglbDw823ep+gVzY=
X-Google-Smtp-Source: ABdhPJwt8jXwUSELGlkyxzYaCrYvKQi8XOkUkxszWlt+v09wRzKEKohVk1ZSpWQYTswgarTxtJ2xLQ==
X-Received: by 2002:a37:a48e:: with SMTP id n136mr2610824qke.34.1603377232219;
        Thu, 22 Oct 2020 07:33:52 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id 19sm1049353qki.33.2020.10.22.07.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 07:33:51 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast path
Date:   Thu, 22 Oct 2020 10:33:31 -0400
Message-Id: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

In the header prediction fast path for a bulk data receiver, if no
data is newly acknowledged then we do not call tcp_ack() and do not
call tcp_ack_update_window(). This means that a bulk receiver that
receives large amounts of data can have the incoming sequence numbers
wrap, so that the check in tcp_may_update_window fails:
   after(ack_seq, tp->snd_wl1)

If the incoming receive windows are zero in this state, and then the
connection that was a bulk data receiver later wants to send data,
that connection can find itself persistently rejecting the window
updates in incoming ACKs. This means the connection can persistently
fail to discover that the receive window has opened, which in turn
means that the connection is unable to send anything, and the
connection's sending process can get permanently "stuck".

The fix is to update snd_wl1 in the header prediction fast path for a
bulk data receiver, so that it keeps up and does not see wrapping
problems.

This fix is based on a very nice and thorough analysis and diagnosis
by Apollon Oikonomopoulos (see link below).

This is a stable candidate but there is no Fixes tag here since the
bug predates current git history. Just for fun: looks like the bug
dates back to when header prediction was added in Linux v2.1.8 in Nov
1996. In that version tcp_rcv_established() was added, and the code
only updates snd_wl1 in tcp_ack(), and in the new "Bulk data transfer:
receiver" code path it does not call tcp_ack(). This fix seems to
apply cleanly at least as far back as v3.2.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reported-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
Tested-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
Link: https://www.spinics.net/lists/netdev/msg692430.html
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 67f10d3ec240..fc445833b5e5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5827,6 +5827,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				tcp_data_snd_check(sk);
 				if (!inet_csk_ack_scheduled(sk))
 					goto no_ack;
+			} else {
+				tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
 			}
 
 			__tcp_ack_snd_check(sk, 0);
-- 
2.29.0.rc1.297.gfa9743e501-goog

