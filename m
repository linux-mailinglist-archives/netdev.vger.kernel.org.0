Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29C4D2959
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiCIHSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiCIHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:30 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF721DF
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:29 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id q10so1746482ljc.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=8cdr6JcxYfveAV3I/8PrMKcEHbA24yDDjma9KaoJIpA=;
        b=UIJJgvfvXONsLgvnxZB3tqlTd5KKk3Gs1Ev6cwFBd77C+YMZ5TqoWOoi/trROQpn1B
         H7yglHuLg3+/FItiwBlRxZWk7IkrBrzd5dV8bvRhkv6gRido5c9yzsrAtAnR276u1IxI
         g7jxsYk6hmmhamB/i2EaBFmFUeMAEru44sYsIcP2EndkGghwBbARNCVDH1+g3ZzpCDAN
         eBD1jEcRa7FW9Hyf2VJ/fYsV2jTugpKOowx7h2QTBjEEpgkH/DbKm8VCMw0dcoP1DKHq
         q14cPH/fiT15XSSQA2VwM/91AT1bnzdvKGXljrokZd4uw0fHcws2zHeZylFjkm3lZkho
         tskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=8cdr6JcxYfveAV3I/8PrMKcEHbA24yDDjma9KaoJIpA=;
        b=wl7iNjM/Yb3rrLM2yES3h6GBKITdsTBQu8fJGpKu8fS5p16fA/1udQzlq5I52W+2gS
         w5I42iP03pZWf9GNk+gPlsLF9XLtfKUAQeSG82bPJoZe16vBtX0OfdXSVa0a1gle/bLR
         8X84hsEpCMCblak27rrBVeQjs48wxjUQD/ZYnJdU6kiLI4CMbwecialcil/q8f3gwKYL
         oO0cmiK32ERVP/BmlttTh7e45qA5CSM1APpeeNVIqvRFPV04w3aAbABa8KA4o299Uwzl
         AqttbOy86/1r7H6ILau3r1VF7uFLPP7+lDjvoO1qWdtZ5lCjF5PLwKPKQXTIzQc4/6M6
         3f/w==
X-Gm-Message-State: AOAM532PRQV0W2bmPyX4vHadoBzQhUUOpblA0xG+CrIOySuByGA9Xdlg
        0W4IAh/XoeAUWfkH7vQy9ansvOiG0mgcdg==
X-Google-Smtp-Source: ABdhPJzz739bvoDAW5hgFoIxUGFWuTXhcMy5rB2qvKkoBfBj5SgJOCm7vsmwXohTLDw3qsRg/Q3szg==
X-Received: by 2002:a05:651c:54e:b0:247:e3a6:1e33 with SMTP id q14-20020a05651c054e00b00247e3a61e33mr9174266ljp.126.1646810247674;
        Tue, 08 Mar 2022 23:17:27 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:27 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 3/6] ip: iplink_bridge_slave: support for broadcast flooding
Date:   Wed,  9 Mar 2022 08:17:13 +0100
Message-Id: <20220309071716.2678952-4-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309071716.2678952-1-troglobit@gmail.com>
References: <20220309071716.2678952-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per-port support for controlling flooding of broadcast traffic.
Similar to unicast and multcast flooding that already exist.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 ip/iplink_bridge_slave.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 71787586..0cf3422d 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -37,6 +37,7 @@ static void print_explain(FILE *f)
 		"			[ mcast_router MULTICAST_ROUTER ]\n"
 		"			[ mcast_fast_leave {on | off} ]\n"
 		"			[ mcast_flood {on | off} ]\n"
+		"			[ bcast_flood {on | off} ]\n"
 		"			[ mcast_to_unicast {on | off} ]\n"
 		"			[ group_fwd_mask MASK ]\n"
 		"			[ neigh_suppress {on | off} ]\n"
@@ -250,6 +251,10 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 		print_on_off(PRINT_ANY, "mcast_flood", "mcast_flood %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_MCAST_FLOOD]));
 
+	if (tb[IFLA_BRPORT_BCAST_FLOOD])
+		print_on_off(PRINT_ANY, "bcast_flood", "bcast_flood %s ",
+			     rta_getattr_u8(tb[IFLA_BRPORT_BCAST_FLOOD]));
+
 	if (tb[IFLA_BRPORT_MCAST_TO_UCAST])
 		print_on_off(PRINT_ANY, "mcast_to_unicast", "mcast_to_unicast %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_MCAST_TO_UCAST]));
@@ -350,6 +355,10 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			bridge_slave_parse_on_off("mcast_flood", *argv, n,
 						  IFLA_BRPORT_MCAST_FLOOD);
+		} else if (matches(*argv, "bcast_flood") == 0) {
+			NEXT_ARG();
+			bridge_slave_parse_on_off("bcast_flood", *argv, n,
+						  IFLA_BRPORT_BCAST_FLOOD);
 		} else if (matches(*argv, "mcast_to_unicast") == 0) {
 			NEXT_ARG();
 			bridge_slave_parse_on_off("mcast_to_unicast", *argv, n,
-- 
2.25.1

