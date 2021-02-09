Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1859031577C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhBIUI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhBITq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 14:46:58 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5AC061222
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:20:34 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id my11so1876105pjb.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uuBlVS8j8WwfkY9QXcefvXFO0/2RQL2/qFI64Gw+Bpw=;
        b=OiYTudiewq2wtTt7n2gK8nGtoBAO56G1Fk1cV7EPccVQPZWMoZhj6PWW88vvOxnKSm
         e3XxwyQTLewfoWVKJyn1VhvQo0mqN/bmEb/wTb/4z76wGymOKYp/KjGTwOAPNW/FpmiB
         R51AGF1CHXc0MpkaXVPXKZPtkCUl7Ji5nCxnllB0Ke+7GD7zRcw94Siv07v95X8OUIRN
         Q6s8vbhP68QnqEOJltlLLAI+kRmjp+9LlfEzzJcdmIIrZcXoejK3dn1sxJw9kcyQiR0t
         0wQlDsTDZ0tHZvNeAxdqlTLMEMkXIvgpVfjK/CtUILQGn2MkIx9K5wfOCj+GJHmWFMPs
         XARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uuBlVS8j8WwfkY9QXcefvXFO0/2RQL2/qFI64Gw+Bpw=;
        b=nA1wtqUrKGKAQaHnFpXho6gSn75g2DtMcpaaLImhnmX6YYDw4Upe8DKQ6AGqBZcSfc
         9HgwGQlBWL8mbwO3Z3+KUlga+sRGeeg9uvnuvkH2bYtRZIdgUAeowS1uZUcpk5EjPNdi
         jcCNcgreNlQVgImoRxhyVRkQpfsm9xmNpX2CQ/1gpEqwebicq11n5JlAI4+nC707Ixi4
         5ca8CNGcp+Lk+1Hp8D4egc3jkGBtp8qKzbrAZeC0OhYlPocHmj/ZBrLiUjFsuuR7+0JF
         E5Juc59/12ctERG//9SouDfo+Mg3eHb7HWOsflkrma6I7KLoxWv/Lon6hDqvf2T99xyo
         FMIQ==
X-Gm-Message-State: AOAM533fil4Y6Orrxp4plRgRzTlT0P1Abbz4m7clmvb95cUR5xoIVZ8h
        GG9pFBCyyEZeYYBKZnrsW0TA90kVjGQ=
X-Google-Smtp-Source: ABdhPJxy01Mc2/wfcv5/ypn19zEp83FYIa3EEHqx/rl/GLFSgvsulRURmyRFilzIAkM12hhKF9Nu9Q==
X-Received: by 2002:a17:902:eccb:b029:de:8483:505d with SMTP id a11-20020a170902eccbb02900de8483505dmr23014047plh.63.1612898434434;
        Tue, 09 Feb 2021 11:20:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3965:c391:f1c0:1de0])
        by smtp.gmail.com with ESMTPSA id p12sm3252390pju.35.2021.02.09.11.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:20:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 1/2] tcp: change source port randomizarion at connect() time
Date:   Tue,  9 Feb 2021 11:20:27 -0800
Message-Id: <20210209192028.3350290-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210209192028.3350290-1-eric.dumazet@gmail.com>
References: <20210209192028.3350290-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

RFC 6056 (Recommendations for Transport-Protocol Port Randomization)
provides good summary of why source selection needs extra care.

David Dworken reminded us that linux implements Algorithm 3
as described in RFC 6056 3.3.3

Quoting David :
   In the context of the web, this creates an interesting info leak where
   websites can count how many TCP connections a user's computer is
   establishing over time. For example, this allows a website to count
   exactly how many subresources a third party website loaded.
   This also allows:
   - Distinguishing between different users behind a VPN based on
       distinct source port ranges.
   - Tracking users over time across multiple networks.
   - Covert communication channels between different browsers/browser
       profiles running on the same computer
   - Tracking what applications are running on a computer based on
       the pattern of how fast source ports are getting incremented.

Section 3.3.4 describes an enhancement, that reduces
attackers ability to use the basic information currently
stored into the shared 'u32 hint'.

This change also decreases collision rate when
multiple applications need to connect() to
different destinations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/inet_hashtables.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 45fb450b45227ce05cc5a2fd8b8a32089ad5c476..12808dac923a4c29cb152201140757c69ba165e5 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -709,6 +709,17 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+/* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
+ * Note that we use 32bit integers (vs RFC 'short integers')
+ * because 2^16 is not a multiple of num_ephemeral and this
+ * property might be used by clever attacker.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
+ * we use 256 instead to really give more isolation and
+ * privacy, this only consumes 1 KB of kernel memory.
+ */
+#define INET_TABLE_PERTURB_SHIFT 8
+static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u32 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
@@ -722,8 +733,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
 	int l3mdev;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -750,7 +761,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = (hint + port_offset) % remaining;
+	net_get_random_once(table_perturb, sizeof(table_perturb));
+	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+
+	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -804,7 +818,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
-- 
2.30.0.478.g8a0d178c01-goog

