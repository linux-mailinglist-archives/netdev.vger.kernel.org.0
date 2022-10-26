Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59660DD14
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiJZIcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJZIcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:32:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4BB792EF
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:32:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9so3131611pll.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LzpD6X5yqvE45UKONWSdYvYubDRxYc85pppx4zi0gZ0=;
        b=fQtdLK108JdYz7P07L0CxTPL46cr4OkZXG/avWS6/iyvabwxAUOfsO9yrhy5+TUOHu
         K1zgLmUYTrvbN3SJ9NiMrUUE2GtDlNHBq0bFlWL6dzUppOKBScOndj0pimlkpe86ntAf
         RrSlKH5qu3/vIRLsx5j7ZKjZGTlGfBO77orZWinABfD9NmMCw4A1XPw/QoVUMERfBScT
         CfYvMP5DahFCEwGXE5YVttZ3fKwOZxoKaUMPHZFY01I4zvsBndQfWJbQnpS1Vybmrofs
         l8ButIpNwcETp1GhVOiBZK1uPKqNik7uC3Qes5yvoQCZZnZjWeZy6qQ4DhYr1JNgOnPL
         u6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LzpD6X5yqvE45UKONWSdYvYubDRxYc85pppx4zi0gZ0=;
        b=PPoHmy8EfwZe6/WExW8tk24MVS84ot3IxlgjmysA9yhaLrtlFSu3hAaepEFkdBDt4N
         OLa6n1NzYb7esjAQLXq4sZOfTKIQaDsNtziilHG9c/0Nc57QtR+ttFDVXFZDMGc1ahUT
         a83JwtI3PmM3zgzxLV8kPI4EJcIl1pONgfN8G5v5pLtn5+B7GMegQuEakHHQiqs2IMZ1
         6H+XSJ6Eu5Om9mXHdQO1X4fdRcjqChB60ZSJTn5YSV3iNz+obaNoepqo3k1o0o6Y8ZiU
         6QLuhS5QkD7JRsgqMmra6B9VGDbYCLHnl3s7sH9C2lTbkMxU9VD/0g+IPt44L86hJ5j0
         cq1g==
X-Gm-Message-State: ACrzQf2BZJY1RzTeEfVp6dd/xr3wlrSUly2976AL7fcV58R/FnzNl7l6
        +mqbyzcrkBke7HkmVrA4ZDAz8WHuaMP6sxO+
X-Google-Smtp-Source: AMsMyM5yLtbGWLn7h9Bs5VYot2agADXwwlRBoputijV77bBTdtxqyctBq/bCBM+CTW7uq7C++gRMjA==
X-Received: by 2002:a17:90b:4c02:b0:20a:7d26:149 with SMTP id na2-20020a17090b4c0200b0020a7d260149mr3088644pjb.134.1666773137720;
        Wed, 26 Oct 2022 01:32:17 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:46bd:9f78:73e7:4f9a])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902e54f00b0016d4f05eb95sm2401754plf.272.2022.10.26.01.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 01:32:17 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets
Date:   Wed, 26 Oct 2022 01:32:03 -0700
Message-Id: <20221026083203.2214468-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
such a socket would use the newly added xfrm6_udp_encap_rcv()
which only handles IPv6 packets.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/xfrm6_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 04cbeefd8982..2d1c75b42709 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -86,6 +86,9 @@ int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	__be32 *udpdata32;
 	__u16 encap_type = up->encap_type;
 
+	if (skb->protocol == htons(ETH_P_IP))
+		xfrm4_udp_encap_rcv(sk, skb);
+
 	/* if this is not encapsulated socket, then just return now */
 	if (!encap_type)
 		return 1;
-- 
2.38.0.135.g90850a2211-goog

