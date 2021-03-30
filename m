Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5634DDBE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhC3Bp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhC3Bpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:39 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1DBC061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:39 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id w1-20020a4adec10000b02901bc77feac3eso3425384oou.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=nEN3LUPUmCnQUtgtMr2jIaiP+3pVS7r/kKKspBTA1peTUUvnL4YDv2Tvnot1iiq9pV
         ZzmR1lwjhiefaHx/Uzkzo+dMUL54ZAnBD17wiusrX7RZfLzTE9dmYD0G6cEtsaV4cDD3
         p0AlxNqlSzcBnmy8Vg3s3/mrbSjWsmczGJDNwzW8CgcBZbyNseoGEtaXmaFmKaUNcX4k
         tgWXaMjMeSDEphWBgMMsc4Sb1OF6IXDZSkEOBqT3gRIyNf/orVR+TVnVnMOC8PWYUbwb
         zq+EeWj420/8opWVI/3k7jFT3OV9/1ez24KBA4R8KdnDcib7KIoHKaCRlWilhJpkDBnX
         YNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=h3NEFVgojYUvGWtoi4/5IyUwoO7vCinb856ruQyvbpCXpYQPrdpqUlXCnaFfRuWbUk
         +lCPBbKw3il83s1pYKCWTibZJVjLN9yDXlAvXHwQ54CEuzYNYeGYa2XnNHNYzbFJNdww
         7zeLOya88498+LnO3xmuwpYTRVOFwCZnZ6rQTaGiUhJfUloHu++Obf0bzNYFOq3ft0P2
         OLv9PPSP79rdjzCO4+o0GMQ2UGDeUzBoKATTAFaejWcz+c6A/bHHpW2CKFoEZGdcJrh8
         dzGo4v7nQ/fe1lG4nLG/7sNYpEDii1mSWrY6o1qr80aGNof60GLcvAejd+ztuSeLFVOI
         hnJQ==
X-Gm-Message-State: AOAM533YB58Zu1MC72reeGMTb4blx9BcDMc5SesK1XbHe/LwuGkoacU2
        Uar6U08jFlJy0Nod8k+g3Zhgb47ir0o=
X-Google-Smtp-Source: ABdhPJzzMzqvpDG6f8ESjY73TcTHQEaXMejxdpKYZb0pyxZkUJ/6wem0y4dOSegx/9TNjIEaQQUWDA==
X-Received: by 2002:a4a:bd1a:: with SMTP id n26mr23435245oop.45.1617068738934;
        Mon, 29 Mar 2021 18:45:38 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id 9sm3810560oid.17.2021.03.29.18.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:38 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 4/6] net: add support for sending RFC 8335 PROBE messages
Date:   Mon, 29 Mar 2021 18:45:36 -0700
Message-Id: <7354b0300e04d2987c63c3f22fc9c38c27773f0c.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the ping_supported function to support PROBE message types. This
allows tools such as the ping command in the iputils package to be
modified to send PROBE requests through the existing framework for
sending ping requests.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/ping.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 8b943f85fff9..1c9f71a37258 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -453,7 +453,9 @@ EXPORT_SYMBOL_GPL(ping_bind);
 static inline int ping_supported(int family, int type, int code)
 {
 	return (family == AF_INET && type == ICMP_ECHO && code == 0) ||
-	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0);
+	       (family == AF_INET && type == ICMP_EXT_ECHO && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_EXT_ECHO_REQUEST && code == 0);
 }
 
 /*
-- 
2.17.1

