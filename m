Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD741A43A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbhI1AbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbhI1AbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:31:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A995C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 17:29:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so1409054pjb.4
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 17:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ye2xCLDiZvt0HOOeSzRiznhqE2LqS4D6rouHO3hQeTY=;
        b=MhF2cn/PYfOH9vPVClZzSdxzyHoq5mjxxya61XGp9qtpgq2kbmxOag/keU3V+lhHi0
         tlTuyCgzK4+vqthoY3gMy2+PtHGBu+VBWVOhQ2v14olSaUjBgEw/UC/7HQt0VJZxIkLa
         btKwTsqJV82QaI6WDnNUDlM2tCJPiKz5GbH9H6QXkBM4T4UAKETHPcuabVoMEMk0EdLN
         tGYGIkXJaXHzalXnYi48Ymsayn1WD7nCo+4I4kO44moJfHVVp0BNBWAgdrasQAAalpZR
         E8LCtBlHtt0YLjvpwQGsOZm57mgWjF67nCWjFL4ErLR0duTDeNZjmOJA3Lb//08y94oH
         t0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ye2xCLDiZvt0HOOeSzRiznhqE2LqS4D6rouHO3hQeTY=;
        b=jhE4PuEWrFrx0KvPfitVGhtMssUoS1dTTp2N8DRwmy5e17mQBLO3SJtH28wbOxMVNY
         0bgdybnz2s2hW/nzAukPepMiyq7ZlAsFNJEuVuq37hqcBbG+XXv1myJvQrpCkJhFtHQY
         /YY6p9spZEtu//uve7ZNr9u97xKbEMflTFqXyclte9MH2et3JjZD6ZkTrpPa6gkIWOng
         j6UwI4ks7blFWkSU/uDKuM/GCP1qNlbaPpsbyq749a+RcU/MV5LBuQLn/kl0ScQxWJaq
         aKWfBnuVIE0tXS8YRU+uaQr9/Rdn+qIpeH6j+whOn986pKwp7PFCjyOeFLjHJUOLReOD
         fJKg==
X-Gm-Message-State: AOAM530v7z6xrlBeL/LrwXAwSe7B7AiLVYQHWnVAQViCOX6Xs+qq3ZDv
        RIjXJBXCtWorZusHkRDBP4Q=
X-Google-Smtp-Source: ABdhPJxsJZqZSXjOyWukZt5v9gDghp++cIOiXIZCPX4jHdsM/m3RqpNyxCQsCvUl86o4OsjpHe9qkw==
X-Received: by 2002:a17:902:e54f:b0:13c:a004:bc86 with SMTP id n15-20020a170902e54f00b0013ca004bc86mr2441539plf.78.1632788968305;
        Mon, 27 Sep 2021 17:29:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3295:1b18:9da8:fc63])
        by smtp.gmail.com with ESMTPSA id i19sm17983502pfo.101.2021.09.27.17.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:29:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] net: udp: annotate data race around udp_sk(sk)->corkflag
Date:   Mon, 27 Sep 2021 17:29:24 -0700
Message-Id: <20210928002924.629469-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

up->corkflag field can be read or written without any lock.
Annotate accesses to avoid possible syzbot/KCSAN reports.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/udp.c | 10 +++++-----
 net/ipv6/udp.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8851c9463b4b62c9017565f545250c4ffe22927c..2a7825a5b84254b70b2f06fc04d601719c2e0bc3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1053,7 +1053,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1361,7 +1361,7 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 	}
 
 	up->len += size;
-	if (!(up->corkflag || (flags&MSG_MORE)))
+	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
@@ -2662,9 +2662,9 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case UDP_CORK:
 		if (val != 0) {
-			up->corkflag = 1;
+			WRITE_ONCE(up->corkflag, 1);
 		} else {
-			up->corkflag = 0;
+			WRITE_ONCE(up->corkflag, 0);
 			lock_sock(sk);
 			push_pending_frames(sk);
 			release_sock(sk);
@@ -2787,7 +2787,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = up->corkflag;
+		val = READ_ONCE(up->corkflag);
 		break;
 
 	case UDP_ENCAP:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ea53847b5b7e8b82f1898fa442327a9ce060085f..e505bb007e9f97995bf64a37702e0dc44a8c4a5c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1303,7 +1303,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
 	int ulen = len;
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
-- 
2.33.0.685.g46640cef36-goog

