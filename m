Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8E45AD71
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhKWUk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhKWUk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:40:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B98C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:37:20 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so312327pjb.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrG5VP/nWV0BOmiQLxtx0eaXhZPpbu9TfGTCZ8GSevE=;
        b=L46ECmsAfoyCS8mt4ww9COjC/LuxsFqoM/bAyjGb05IZ0VsVSioCRveq4Ux0J0TAJK
         XV8k4if360w9gURgewzGTP2x1dWKyN9D0hIidN1M/7X2pUJ5riDI3VYqd29ih34/XInf
         BPUHvcS6N7+mABliDrqWdoldSKlvtq7aWxtXzUlA8Iniz6mO1FQeVG3DRApCYPCfUrnz
         +qlkp0n0c9l4h7FaUZfCvvhKMHZ4a/c/4pPCvwLSQBeXt5TM2s4oe2ycR+zDnOa9zjlo
         BbSdBicZcpmB6LGNnvtU26FH6d7Ec4Obr0WnW2VgAIOm1zZGRLm15OTU36EbIMmhiLLn
         2KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrG5VP/nWV0BOmiQLxtx0eaXhZPpbu9TfGTCZ8GSevE=;
        b=D13Q520gj8lVRAV6poHNP3gn2+kqLU93h0fim/iJ6VqZCrzr93PgNe61ien2RvjNhx
         ZRNIFIeJN90VLBA5PHF9aJ71NdzQLqmWIM4mhZmKYw3pqJgQCQVF+TTPNBMUaZQIqkQC
         dAYLSlISDhACYHK1b9NHRLsdbHpAQF9wWocTcFcZc9hAt5J+94rNhqlUFUNHEqE39bAR
         ABCwWykbeBkhmxrUK82F5L7Vf+KOZi1UrmtjfEki6KRNqlJeAyYQEDyvGtQVrP0q7of1
         HvDmNDgxkA1CtMn1YpUxP/BkIDgD6aC5J5e5MWwp2ELl/akrcXbuFwEToKWmhOttDPLD
         tEhg==
X-Gm-Message-State: AOAM531h6MbbUUFgrkxogz6o1puPI40M4dKUMe877P9+fomoZtgIJB66
        UJ2EGXdPybM/P/wV7oczODHNNuyqS08Tpg==
X-Google-Smtp-Source: ABdhPJxC8Gi/zBw07u8Q3E/grxMvILlsEhvnN5F+tEj6T7Ox6UnQpavk+ipQJDc+yvx/mulpzCDzVw==
X-Received: by 2002:a17:902:ea0f:b0:143:e4e9:72b0 with SMTP id s15-20020a170902ea0f00b00143e4e972b0mr10471440plg.29.1637699839953;
        Tue, 23 Nov 2021 12:37:19 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:cd70:5ac2:9066:1bb8])
        by smtp.gmail.com with ESMTPSA id u3sm14244436pfk.32.2021.11.23.12.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:37:19 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>
Subject: [PATCH] net: allow SO_MARK with CAP_NET_RAW
Date:   Tue, 23 Nov 2021 12:37:15 -0800
Message-Id: <20211123203715.193413-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

A CAP_NET_RAW capable process can already spoof (on transmit) anything
it desires via raw packet sockets...  There is no good reason to not
allow it to also be able to play routing tricks on packets from its
own normal sockets.

There is a desire to be able to use SO_MARK for routing table selection
(via ip rule fwmark) from within a user process without having to run
it as root.  Granting it CAP_NET_RAW is much less dangerous than
CAP_NET_ADMIN (CAP_NET_RAW doesn't permit persistent state change,
while CAP_NET_ADMIN does - by for example allowing the reconfiguration
of the routing tables and/or bringing up/down devices).

Let's keep CAP_NET_ADMIN for persistent state changes,
while using CAP_NET_RAW for non-configuration related stuff.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1e49a127adef..4a499d255f40 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1281,7 +1281,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
+		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
 			break;
 		}
-- 
2.34.0.rc2.393.gf8c9666880-goog

