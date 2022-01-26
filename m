Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBABE49D317
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiAZUFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiAZUFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:05:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F21C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:30 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id e6so662469pfc.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e7xKQw9LCCFkwszPcol/Zo58jb9a8WR2eJ8kO0jBQ4o=;
        b=FZGXLH7fadZolyczsaKtYkkqFVdz7WUQ1oeAflQ6EqD0GU20fUXIV1RB8uuvCh0toP
         qsIRjjytUQoWqXLfBn9B0imdGka7X70O1afYWV+9NRfd8u4gsBlWDN5rUQJHqkKoz/NV
         88KtVxIQT6POWpAh37QGQRbicar2o8aUyII0ByEtiufOO4CkWcEEBS2Fgw7QsdHV0Bf4
         zyUbqlXhDzy7ozUC+dVDYbnPQ0jTU4wKasqvd3FMKaPkrrBgm5/+nE7EVBmiEkm3FUlo
         ub1dYqJyEh16qkW9llWqWLgBiLAreZYq6WRNLngkgvoxH8jy035eXYtwu01ckTsrE3YS
         nlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7xKQw9LCCFkwszPcol/Zo58jb9a8WR2eJ8kO0jBQ4o=;
        b=O+6Oh9kj17LYkdfN4UKqlx+Ypkh9m1pUmWqnbqwg4M+wSg9iEuIjQnq9+Ak8HVqm3s
         MqKqBZyblbL6QyVCaful7IZgscdBT3NmD+xjy7LAmJrD94G14psmLGjOl4rY/VqIl46R
         D7PdOvNKadOfzeer7nzRCBpGrEJjejiH6u0CcPLMNlVSdmSo0jgKWgte2piNvTIE6Gru
         96YZPpnQGVouZzCRS0xAMw16yX47ZXYND0H+rlH+6dJMokE0iLQxItUI5wIp3KJ+2R/f
         usnZRTEE3BrMMAmw1+0OST5mWlNcACM2bV06p6UFI7fNxroiHYne4cX3x9m53VuHmvvA
         Uvmw==
X-Gm-Message-State: AOAM53131uUuRe5NQKlDbrUkpPvQKyd9PHytz8qnvI1x5LRQzwLiMXEx
        cm5+KosOMcDPo5HmqaCY++c=
X-Google-Smtp-Source: ABdhPJwIHDuLhce2q6/kPhSjuc/UEKKr/rwLVV4TM1BL55WjnKlRrtJTYEKplqs1OX6w5uZF7sFbqA==
X-Received: by 2002:a63:2c16:: with SMTP id s22mr349700pgs.297.1643227529981;
        Wed, 26 Jan 2022 12:05:29 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id s8sm2708497pfw.158.2022.01.26.12.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:05:29 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ray Che <xijiache@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH net 2/2] ipv4: avoid using shared IP generator for connected sockets
Date:   Wed, 26 Jan 2022 12:05:18 -0800
Message-Id: <20220126200518.990670-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220126200518.990670-1-eric.dumazet@gmail.com>
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
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

