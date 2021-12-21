Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5456647C2FB
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhLUPgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbhLUPgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:02 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26737C061574;
        Tue, 21 Dec 2021 07:36:02 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i22so27665272wrb.13;
        Tue, 21 Dec 2021 07:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wvTIec5KLzRjZYzsXsnhjT/wGUOjwWKFs3BDJ+O8UAE=;
        b=hCcv/uDRlbmGmkA/NE6LfCieO1Yf2GBtgbfiZAjTpUxrTVhAyiVdL2a8heQ+oxL0dK
         minxvJpIAn6TpIKSRvxdIxpma9g7QeefXOrfLJiVenmw+spBmz8ZQD5s8Y4Pf8ZkB59L
         bc6caKqxhneP0YenwHdicbsHo4fw+9LefkU2ZdoKlBLJAXdz43/ik08uvJcvoCnl/tO4
         yC2m1/0Od3wOmZDrc1gM1tFLeCkDjoOrnWFFxEJgA8szVcrxfEe2PdVAsAxZ+OZgTJJn
         NGPH0DqOjVJwMpF4Xycc/uBhGa74SUx1PD0ywv8rQkY25vzeREV3EeR6tNEjdyq0RmjS
         zRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wvTIec5KLzRjZYzsXsnhjT/wGUOjwWKFs3BDJ+O8UAE=;
        b=oCKYGtQGk4SNvf1msIMlpY+YCnQqnuGcVk+2gpE3NfVEz9YNgKfzZ7b8/fq3jf2lOb
         I6GezkIU/22GN1y7fW0A27YBYEfM19BGFVsG34Uv9vZyWM8TVJfBzUUXijpZ7UROLjO/
         7U5VZBFueJDSzx1pWNHjV1lKIeUnUssHwO9+Ow3WCKRkoZvKtgrnZ6MpTb9xDbka2rrV
         4Ag77l1vsNzbltHHvZA+5l75Zj9FG32IfYXhW864OGEVdSIoCFKwE30BPaFgrL0HPD41
         Maofwjhxo/EirlTMMxzFCPvkkZtqR9ZT6qIZWqR9GLGxgY7daOTGQnGOw9fbMjRcI9Fi
         iKUQ==
X-Gm-Message-State: AOAM530AV79PbffFYBheM9iehn3IM61Xq9ykdZ1u6W8lAmjT9J/kUoC7
        x3ALOlSMiNmzD4K7MoBa1+mYhHbiSlg=
X-Google-Smtp-Source: ABdhPJzy6vgnm90jvtv4pJn4T+wvd+XYnsTzspBiHMYfM2IONkCjPkOO7qBgMBufSCuCx+H6ylJeyg==
X-Received: by 2002:adf:80c2:: with SMTP id 60mr3103274wrl.609.1640100960583;
        Tue, 21 Dec 2021 07:36:00 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 08/19] ipv4: avoid partial copy for zc
Date:   Tue, 21 Dec 2021 15:35:30 +0000
Message-Id: <4c2bf8d68ffa06b212c9a4a4a095787fbdf05eb7.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even when zerocopy transmission is requested and possible,
__ip_append_data() will still copy a small chunk of data just because it
allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f820288092ab..5ec9e540a660 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1095,9 +1095,12 @@ static int __ip_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else {
+			else if (!zc) {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
+			} else {
+				alloclen = fragheaderlen + transhdrlen;
+				pagedlen = datalen - transhdrlen;
 			}
 
 			alloclen += alloc_extra;
-- 
2.34.1

