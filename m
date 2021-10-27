Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04D43D2BB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhJ0UV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbhJ0UV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:21:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418B2C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2985144pjb.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YYFZN15iq+8xSqsk2/NEMj9yDVNiprtcJf2OiTV6b9w=;
        b=D/49T+T+2+JB5/uPIq0L0ng/FULXyK2w1LiTM1dPZFj0/YHqejiq0HD/KFTLG8IGXe
         puWz6xuUXyUJw0TLExqtpzRloKvWOQaKi6u7zlHxUyo//K0Xst1uo8k/H2lRCabCS1u+
         6lXE9aNQ52vMjQJfW1yBX9fyijyRmEa89RzdSAivVgn+gwHGiZpg7sJGrUl0682tRXCd
         Ija4NMWmEAzYGO62PE3TAIHCTc4poVUNgYtGTrOBLr6ytM0M9mA92jfM36+AAjdf7al7
         Bvaz97bZFOhOVqTJXL+yO53wpGL0Gf1M9APVoSoegpPqtQW3qUvO+VfoK1dKq8pu6PQs
         rJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YYFZN15iq+8xSqsk2/NEMj9yDVNiprtcJf2OiTV6b9w=;
        b=b4TGESTHxI122TYInVBUBXntuzY2t3MvVosXRPJm8ykU7LGkqyMiDE8hsKMuKzF9cJ
         AikzkJxtrXnbn0AR2PQh0KH/+4X4t1xjQoGKN4Vn0YnvCpAGVW88ma9nD2Hp5dhB9N26
         jxutJqp6fQTn0DGx2wm/xl8tbFK2TZYPVcjFveUVE0xkLJO0DEOYDo259QNnNTf2y2AG
         K/5VIDGmeIymC7OcuX2klBQ5zXCZTNKmQEK+iz4xu2cqxzZxi+OUP3BFsNVYcK3nZ8yc
         PVCN+/6JJvenN97WBpvXx2C+UH9RG93hTm04woq2kSfkTSwgZaUYIy7/3K7eDEVPU+YR
         LgHg==
X-Gm-Message-State: AOAM5333ZwreCN1wzhrRiN73yiA6cgIuLnFhh416dOdnMA+zA6ibmVV/
        Ts9D1DTCPZSCD+JXQ5LS5ZMwuY0Q3go=
X-Google-Smtp-Source: ABdhPJzWwi3Dcu0xYPxDqlJbLc1BaiPasb5N9j4/bXcEWUjkbl0MvIb5FaQyWkdxkERRL5jTyPXqJQ==
X-Received: by 2002:a17:902:e84a:b0:141:5fda:4fca with SMTP id t10-20020a170902e84a00b001415fda4fcamr9219308plg.74.1635365970886;
        Wed, 27 Oct 2021 13:19:30 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/7] tcp: remove dead code from tcp_collapse_retrans()
Date:   Wed, 27 Oct 2021 13:19:19 -0700
Message-Id: <20211027201923.4162520-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP sendmsg() no longer puts payload in skb->head,
remove some dead code from tcp_collapse_retrans().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c0c55a8be8f79857e176714f240fddcb0580fa6b..e1dcc93d5b6daf34e41817658c4f2029d429e82b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3045,13 +3045,9 @@ static bool tcp_collapse_retrans(struct sock *sk, struct sk_buff *skb)
 
 	BUG_ON(tcp_skb_pcount(skb) != 1 || tcp_skb_pcount(next_skb) != 1);
 
-	if (next_skb_size) {
-		if (next_skb_size <= skb_availroom(skb))
-			skb_copy_bits(next_skb, 0, skb_put(skb, next_skb_size),
-				      next_skb_size);
-		else if (!tcp_skb_shift(skb, next_skb, 1, next_skb_size))
-			return false;
-	}
+	if (next_skb_size && !tcp_skb_shift(skb, next_skb, 1, next_skb_size))
+		return false;
+
 	tcp_highest_sack_replace(sk, next_skb, skb);
 
 	/* Update sequence range on original skb. */
-- 
2.33.0.1079.g6e70778dc9-goog

