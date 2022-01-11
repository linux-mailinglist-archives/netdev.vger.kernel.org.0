Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9F548A4EE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346239AbiAKBYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243319AbiAKBYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:48 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B74C06173F;
        Mon, 10 Jan 2022 17:24:47 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t28so23330793wrb.4;
        Mon, 10 Jan 2022 17:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iXKHyNdsJkHtXxLMMhcsr/bT4YBYrcmkq9r0J3HN/VY=;
        b=Wyh0Bhtr8fyJg3IvYngkUcib5GcXPaO7i0Fdhbrfvs8FB3UFQHPnnlAPnKZy0HVP1y
         Cz0JTp6B3jNUN6Fh0SK2AkEDPch0+RFyo0XTEhtSQYBrofbcUHnyNnU9ZYPIRA5U9oxf
         Gro0YDhve01rAG1ZGHDwiiTHmDRbNXMEtAmpF6cazMEujL/SOiVGYZ7KRCW0sSJGgqvG
         LRC2ttoA4CdCbnhbg5/yYXZk9yyTTQwSbaMjb2fQP68H/mJJLMW9qn/vn3ySwzBZ/Hp+
         Fb/TqjkgYXMR6OeMh7AMZAUqGS6nufCSLQ0cMCYDuZ7CGnlyz2lYNKGA4VYTqzK37x47
         6kRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iXKHyNdsJkHtXxLMMhcsr/bT4YBYrcmkq9r0J3HN/VY=;
        b=WBqhrgjv8FtFNgL0QjlWzjXKa962ZbY6mmaUrONPX7bsUC0dL84w+jYvLp4hPEgc9i
         ahcfPfb+IHrYVBKVgV61ryyx7h/U2Y0h0xOp60eIspFNefWSvQWn68yCKGXxGf4uMVNm
         pA3RC+nlzwAkeEC/Q9NaBoP5kBO8YQJXIirtIPvA8QniUn3aNi3AyFKAuwA1nV4vLYcs
         QcuqP0ojOz8o1wQZKwQaJZCqzIzkwNo8YA6PYGyiIEMNUgNgGvzlb3iVFIKKyHeIDaUJ
         NN49XYIRl56DTTLMgHPQJVSQOO5XHnF/H50vL0U1ABYKH52fWDqoamgzkDaDTUDKrUhD
         0gsw==
X-Gm-Message-State: AOAM532NqBePeC/5pyz1v3OZGFQCnbKCIbNFu53l7yagGPMHY5wBojHR
        Vz8rt3Ae6XeB7qoqqxWWe3OhmRpw5YM=
X-Google-Smtp-Source: ABdhPJwZRmBEgpMyBiAes8CLq7Oip1EJwcKI8iUuMXoSjdS9TNGhjbnef0VNV/GagU/spQXhEfyCYw==
X-Received: by 2002:adf:e444:: with SMTP id t4mr1720893wrm.325.1641864285785;
        Mon, 10 Jan 2022 17:24:45 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 02/14] ipv6: shuffle up->pending AF_INET bits
Date:   Tue, 11 Jan 2022 01:21:34 +0000
Message-Id: <1f9024b0d64b9008cca1c6383c69c8e5854817da.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corked AF_INET for ipv6 socket doesn't appear to be the hottest case,
so move it out of the common path under up->pending check to remove
overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index df216268cb02..0c10ee0124b5 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1363,9 +1363,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	if (up->pending == AF_INET)
-		return udp_sendmsg(sk, msg, len);
-
 	/* Rough check on arithmetic overflow,
 	   better check is made in ip6_append_data().
 	   */
@@ -1374,6 +1371,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
+		if (up->pending == AF_INET)
+			return udp_sendmsg(sk, msg, len);
 		/*
 		 * There are pending frames.
 		 * The socket lock must be held while it's corked.
-- 
2.34.1

