Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CBC49D726
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiA0BKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbiA0BKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:10:32 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99901C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:32 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c9so1096793plg.11
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wZqamSXQdRZNh6wy+T2qmO4sS9HEmI6QarsYg3R2dAY=;
        b=aMXqtWe+7tfdXj7gt6l8gguCuvnQY3XLLE6tyox0/GbARxaLKbMUTwzCyElRgDORQ0
         T3JojCEfG6NK5YxFhkI3dhB9y33bFyCHQZaQy00rUCdOoVrAv6TgyoCsmw7sxSVVB9a7
         xjRyBxtwSCDU+B+2RrbOn0+dZkeYeY2139xbrb4mwm0gggsPup2nEXpEyIUZ9jA1cY8d
         bTtCdgtLEvqwCn5uy0R+8MxOG8cvr3KbCmEfJ+ZIg+su2xZlEqFcntTnYC+gilMpGMe5
         /+/wrnhSTqpIxnLIYgWd4/Fvr5A0Xgpioqw5AV8IAvpNKDVIhwTsmJ/6MkA0Lt02x3Ly
         E6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wZqamSXQdRZNh6wy+T2qmO4sS9HEmI6QarsYg3R2dAY=;
        b=nP5sM6ZE1yBNFtiYIJLnC7loW08omeYfwb0d9/qqPBPY9mTyKK07fYBIdDa3WNOlhs
         nIvuv03fvo0LTYUEMPXP0vCTyF0yjiY+k6V1h95toX3w4QieZL6rlP32jL7XDCBhkq7k
         Wtk3ZvGG/ntVTY70G4AGqWXMJBzCsODzqMPYLjuruV97BYsw1cfFfnb7ZqXIqxD7OwwE
         yn5l37bsi22RML1AkHyE+pYUjjN1aWSgSFXM6/WON+f4acO1kfJeMPOZQW7vhxTTCQgx
         Szdnwnc79lJbdnQKTrG1euriJfnozbe+DQ0f91+50qvPSTmX/Ze56mqUy8N5JkpHONSp
         BQ+A==
X-Gm-Message-State: AOAM533UJspRc7BRaI1thwlSg/u8fd/tIc/HpIjC19hlqR0JtbQWdhQB
        lgQkAx/A1aR3IdY9qMQn2S8=
X-Google-Smtp-Source: ABdhPJy3m73FcJ9nBNx+vqxbl8ho4xTxXMMiLVJi75uHMv/5yoS/U2Y4m/vm9oKRkkcuDyFrsNXMTw==
X-Received: by 2002:a17:90b:388d:: with SMTP id mu13mr1662926pjb.226.1643245832161;
        Wed, 26 Jan 2022 17:10:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id y42sm3563617pfa.5.2022.01.26.17.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:10:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ray Che <xijiache@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH v2 net 2/2] ipv4: avoid using shared IP generator for connected sockets
Date:   Wed, 26 Jan 2022 17:10:22 -0800
Message-Id: <20220127011022.1274803-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127011022.1274803-1-eric.dumazet@gmail.com>
References: <20220127011022.1274803-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ip_select_ident_segs() has been very conservative about using
the connected socket private generator only for packets with IP_DF
set, claiming it was needed for some VJ compression implementations.

As mentioned in this referenced document, this can be abused.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

Before switching to pure random IPID generation and possibly hurt
some workloads, lets use the private inet socket generator.

Not only this will remove one vulnerability, this will also
improve performance of TCP flows using pmtudisc==IP_PMTUDISC_DONT

Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reported-by: Ray Che <xijiache@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
---
 include/net/ip.h | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 81e23a102a0d5edec859b78239b81e6dcd82c54d..b51bae43b0ddb00735a09718530aa3fff4a04872 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -525,19 +525,18 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	/* We had many attacks based on IPID, use the private
+	 * generator as much as we can.
+	 */
+	if (sk && inet_sk(sk)->inet_daddr) {
+		iph->id = htons(inet_sk(sk)->inet_id);
+		inet_sk(sk)->inet_id += segs;
+		return;
+	}
 	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
-		/* This is only to work around buggy Windows95/2000
-		 * VJ compression implementations.  If the ID field
-		 * does not change, they drop every other packet in
-		 * a TCP stream using header compression.
-		 */
-		if (sk && inet_sk(sk)->inet_daddr) {
-			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += segs;
-		} else {
-			iph->id = 0;
-		}
+		iph->id = 0;
 	} else {
+		/* Unfortunately we need the big hammer to get a suitable IPID */
 		__ip_select_ident(net, iph, segs);
 	}
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

