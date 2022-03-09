Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E331F4D2958
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiCIHSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCIHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:30 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F566EB2A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:26 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id r4so2175560lfr.1
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=SeN7V6ALXfQ/BNJHLAkf4fXrAozjTe4gW76V88x08oXylpd1PyoMmCXug4+4EOM1+i
         P26Ek8faXE0blAx10Td0DgYlitsQ5QEUzkU8xYHuV9UYpitoqYrUVSQEmzIBpE2or+iS
         dQQfeb3LjbEkEgDvRmCwaRVO12yXGksxf2BP5ShvmreyDFoDf4UOfy9tJ0p8RIqXVsrU
         OsiIbWAUyMKl7YCJmzkGT4y7TgIJnOhdkjeC5djd7Aa1J23fHLBVZw6PFsWm/dZFy5Wk
         UhfJxDLTP4aFJWgXRe5oJLaIcDPcLmv2Vv/+YGg9R7x322noDv9gY6iE9efUNItY0mQX
         9m5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=cV0TMCE4WQs3eq6QKuqleFvu9Nmx36/Lyb73oczZ1jMch8r+A5Ryg2jlIwvGmhXhr4
         knQk0iYOhLHDQatobFzLyENnDdq7WY5jsxssD5sjuWeZVx8ukNbzTAW0vonWP3O/c6i9
         NrPpmLcbD2k+u0cOFA1fZ+6hA11T9he2us/4dI9W0S2v8KQHHYS317nkcVzLkDMNXu4f
         raJPtypfCao2wvC6XdWmzqj8jYwaOGNpe7cydiVBfSmGldcKBtdv8Wl2Ca0RYMfkcHo7
         SK1WjT7EtHBZMyN/l7djOXLS/r5w7NcCw9LUnv8BVWxNt8ECs2PwPyf2HiGx7n/OCIgD
         3uNQ==
X-Gm-Message-State: AOAM530JuLIE7rjgw9e1CANnsMGbXdb+lI2imr2j4LSZ5G3z+voRPSBE
        DtcAq9hQaeJU5/ngzy6Q6Ds2QyfI0jpUjQ==
X-Google-Smtp-Source: ABdhPJwkUk7rio72K07VhP/Gahi7EB3rexDxQu3NNBvGhSzO95md0vtiuI/0UgvpDHey6e2bSSSrJw==
X-Received: by 2002:ac2:5f65:0:b0:448:1ce9:13e1 with SMTP id c5-20020ac25f65000000b004481ce913e1mr12971022lfc.344.1646810244542;
        Tue, 08 Mar 2022 23:17:24 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:23 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 1/6] bridge: support for controlling flooding of broadcast per port
Date:   Wed,  9 Mar 2022 08:17:11 +0100
Message-Id: <20220309071716.2678952-2-troglobit@gmail.com>
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
 bridge/link.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index bc7837a9..407dc8ea 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -153,6 +153,9 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_MCAST_FLOOD])
 			print_on_off(PRINT_ANY, "mcast_flood", "mcast_flood %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_FLOOD]));
+		if (prtb[IFLA_BRPORT_BCAST_FLOOD])
+			print_on_off(PRINT_ANY, "bcast_flood", "bcast_flood %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_BCAST_FLOOD]));
 		if (prtb[IFLA_BRPORT_MCAST_TO_UCAST])
 			print_on_off(PRINT_ANY, "mcast_to_unicast", "mcast_to_unicast %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_TO_UCAST]));
@@ -265,6 +268,7 @@ static void usage(void)
 		"                               [ learning_sync {on | off} ]\n"
 		"                               [ flood {on | off} ]\n"
 		"                               [ mcast_flood {on | off} ]\n"
+		"                               [ bcast_flood {on | off} ]\n"
 		"                               [ mcast_to_unicast {on | off} ]\n"
 		"                               [ neigh_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
@@ -296,6 +300,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 flood = -1;
 	__s8 vlan_tunnel = -1;
 	__s8 mcast_flood = -1;
+	__s8 bcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
 	__s8 isolated = -1;
 	__s8 hairpin = -1;
@@ -354,6 +359,11 @@ static int brlink_modify(int argc, char **argv)
 			mcast_flood = parse_on_off("mcast_flood", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "bcast_flood") == 0) {
+			NEXT_ARG();
+			bcast_flood = parse_on_off("bcast_flood", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "mcast_to_unicast") == 0) {
 			NEXT_ARG();
 			mcast_to_unicast = parse_on_off("mcast_to_unicast", *argv, &ret);
@@ -456,6 +466,9 @@ static int brlink_modify(int argc, char **argv)
 	if (mcast_flood >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MCAST_FLOOD,
 			 mcast_flood);
+	if (bcast_flood >= 0)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_BCAST_FLOOD,
+			 bcast_flood);
 	if (mcast_to_unicast >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MCAST_TO_UCAST,
 			 mcast_to_unicast);
-- 
2.25.1

