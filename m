Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A3F1E19C2
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 05:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgEZDP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 23:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388460AbgEZDP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 23:15:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBFEC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 20:15:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v1so19088553ybo.23
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 20:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8agX0shDRmCjP6wxw/PC1aFFve3cAljlU6Cfp1jYFZs=;
        b=dSrLrbL9UWYLzviE7lM7O7b/npgNvasQfAv0mOh84TjY/IL5UXtSUlONsQw6b+Bf77
         BDcXKiOyQ2JMqqzLsFKmNHDY+HmOk66nNvCAh9CEx72BroZnJpH/odmuwJGC4QMv+b6K
         I7Vu6opi2DWcjEy//N74crNDxab72JxqdQK/FxXJ8YV8Gulmu18F2msHqaVTztdFjkpf
         OehhnimmnQFc16+Nmn1is3LpC4LqStKEboi1ncP5gdKvu4/CQq66jpSOu+2Kpnth78Hb
         GUZ6uIluLEkGWJdqhBM01hnw7C9y2SYz9fQyHYyGEf4gR3uxcAPYjLp47vv1tnFWjAGs
         Zk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8agX0shDRmCjP6wxw/PC1aFFve3cAljlU6Cfp1jYFZs=;
        b=h+bs6nQz1o/RwUWfSDZW2thx3okq4UnGlx0xuSQSkvOVOA2q1iWWJbXZs6K78muDns
         580Rffc7DdPxcZNyNAsHw9CeXQknzjDJitrG/tjy3Mm0WfZgGT207wL6XPfbKgjL9rwX
         2jjjljyya1qQ300Wzxkjc2KwazeJLuUgFRgdiJZoSL8F5CBBNnayP6VWN2amsJ/1u8Bu
         fnvvZ5JLC75UVRjLQPSM7yF5kY9lu6KEilN5pGOqLfHjnI9VvFaSFtUHr5zNlbmyvUuI
         qJscq837rq1gMrO6MdUpxrCxcezvyEGpxCRwSqPrz+PpySdyRxup0odYxliePd4bHTiD
         /K9Q==
X-Gm-Message-State: AOAM533fIlk3yumRwEGZbHz6hMyJZXx1rUzebM9/j54Nn9xqVIor3t2d
        6KPNm6Qjrkhmz4192tan62TbWpBseISfqA==
X-Google-Smtp-Source: ABdhPJxbRy3kikkUfLjjSyH2b5HpMAtqNtBUmYf59AwbjFsFztIWqRzEph4pXsw3MOWsCW77jEfo04aSJyTGAQ==
X-Received: by 2002:a25:f507:: with SMTP id a7mr48307235ybe.176.1590462927392;
 Mon, 25 May 2020 20:15:27 -0700 (PDT)
Date:   Mon, 25 May 2020 20:15:24 -0700
Message-Id: <20200526031524.72257-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next] tcp: tcp_v4_err() icmp skb is named icmp_skb
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed the fact that tcp_v4_err() differs from tcp_v6_err().

After commit 4d1a2d9ec1c1 ("Rename skb to icmp_skb in tcp_v4_err()")
the skb argument has been renamed to icmp_skb only in one function.

I will in a future patch reconciliate these functions to avoid
this kind of confusion.

Fixes: 45af29ca761c ("tcp: allow traceroute -Mtcp for unpriv users")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 900c6d154cbcf04fb09d71f1445d0723bcf3c409..6789671f0f5a02aa760e12d7b4282b620b4e928f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -573,7 +573,7 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		if (fastopen && !fastopen->sk)
 			break;
 
-		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
+		ip_icmp_error(sk, icmp_skb, err, th->dest, info, (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err = err;
-- 
2.27.0.rc0.183.gde8f92d652-goog

