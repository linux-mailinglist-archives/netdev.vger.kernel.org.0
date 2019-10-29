Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C0E8D73
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390765AbfJ2Q71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:59:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40553 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390785AbfJ2Q71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:59:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id 15so9993698pgt.7;
        Tue, 29 Oct 2019 09:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KCNhk6Yyd07rDJH7lQx7kz/Ad42c+i5/xKh7Sj0sJEQ=;
        b=QR0rThkgr8CuA3Iz9x+OXG2n78b36W+SuAbts3NDbG0QugZD3+iKZfrjKTIxXbaBtC
         C+Y6ycxu2c4G1d7oH8fpdHVux43AaGxUNwIBbVKg0DEoKZPW9lbljtjM7PzUKBYcdmnX
         Uaj9bTD0PMb2Uo3W8VQrDFmvFlr5M2/G8GvxrJVWH0uEqqBWwE6Yp4ogLheYYTWe3bTF
         zXbM0V5Osw3sOkV/Iu7hp6w7CHkf5NzK4U7LU/sgSTT9EGYT6XYMb8IjDlN9+JcdMqcY
         qZWOEbR4QLn7OZ3sjjGgubCgxNyRQLrOMtKixAn0yUvUT3OOJiHm73RfCNkbqcK3mjES
         l47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCNhk6Yyd07rDJH7lQx7kz/Ad42c+i5/xKh7Sj0sJEQ=;
        b=qwa1TJaiooPtocFUXI79zeQTGMzkcgn5ce5DwHqUl9nkQJgvFg5Fnd06cDTD1QlCip
         qAcagkwLKiE3E0WpCxDe8feorCeGjdhoclHxap4wXkDf/jQLlNaiVT8tsK4G2oxhF4m5
         rKg8HFpSxHAn7x9SW2G28M7UyT6K9eARbWYjFjok7gWEyZKmQ7ZGtDSJz4W4ngV7Q1dr
         icLvmrGM9AhmvNqtCuT7bLgGIQvdzBonNkWfmnoX8lGeZ4D6KckQ5/RTaJr/I/GToZp8
         1pJtFaNU8jLaf0UlsxOaacOtI3Vx2zDN5nrgpTNgryugCaAEgNZNPAABRtsqR7iNwTZf
         qPcw==
X-Gm-Message-State: APjAAAXrPUjZbGr4uXEIBOx1mjM4QU33jUtyv7HVpGgZfkCfoGzQqWkC
        KLdtTds+WhB4HpWUYzcBdw==
X-Google-Smtp-Source: APXvYqwtndnUnpXGYFo0j440tyVgOz/e0L1PpTBpjkbheGFr1ZQ2ySKh0q94bQxxlwUJobKft2V6pA==
X-Received: by 2002:aa7:908b:: with SMTP id i11mr29026643pfa.140.1572368364864;
        Tue, 29 Oct 2019 09:59:24 -0700 (PDT)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id w6sm14384147pfw.84.2019.10.29.09.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 29 Oct 2019 09:59:24 -0700 (PDT)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, davem@davemloft.net, kadlec@netfilter.org,
        pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: [PATCH v2] [netfilter]: Fix skb->csum calculation when netfilter manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Date:   Tue, 29 Oct 2019 09:59:11 -0700
Message-Id: <1572368351-3156-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572368351-3156-1-git-send-email-pchaudhary@linkedin.com>
References: <1572368351-3156-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to update skb->csum in function inet_proto_csum_replace16(),
even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
header checksum field and change in IPV6 header cancels each other
for skb->csum calculation.

Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>

Reviewed-by: Florian Westphal <fw@strlen.de>
---
Changes in V2.
1.) Updating diff as per email discussion with Florian Westphal.
    Since inet_proto_csum_replace16() does incorrect calculation
    for skb->csum in all cases.
2.) Change in Commmit logs.
---
---
 net/core/utils.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51d..cec9924 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,12 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * No need to update skb->csum in this function, even if
+ * skb->ip_summed == CHECKSUM_COMPLETE, because change in
+ * L4 header checksum field and change in IPV6 header
+ * cancels each other for skb->csum calculation.
+ */
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr)
@@ -449,9 +455,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		*sum = csum_fold(csum_partial(diff, sizeof(diff),
 				 ~csum_unfold(*sum)));
-		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_partial(diff, sizeof(diff),
-						  ~skb->csum);
 	} else if (pseudohdr)
 		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
 				  csum_unfold(*sum)));
-- 
2.7.4

