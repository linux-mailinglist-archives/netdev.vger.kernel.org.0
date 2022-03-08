Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3051F4D1928
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiCHNac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiCHNaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:30:25 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C087A43AD1
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:29:28 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id w27so32237968lfa.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=QH42UoS4tT2EpsMPV75d+TIi4FGjYeSwCN3ysV1KsFS+0u5qHxswrUQt4f6xaCbSQF
         xKL5Tj9Gvds/DOwqwvW1RUWt+fSL8ig29kzubyutH5JzRJz0xmDbm3eZIgdFf82Lhdtj
         qJIboK5E5+SWw+lEbU1kKHQ8TThTPprpfaUsvQkSVIAp2JiMFV8+sPvzj+P9Em8WmzK0
         m3UVTHkN+WTbTB2+I+gDFJeL3OThMmGX51JcZGLZeDcdof+/NDJBTXKN/4k/kbiylf6O
         bwI5TXv8uXlkcqU8cEV6UM+K6NzyzypPUZr115E6HwA6rf6cA62G5DVuoVohv3dkoWHR
         F/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=J9zQ/i7h3nTC5iF2nY9LUB+xX+8nAY0Rq8DOm12ajW8enKIh1hnPYpemlyqwvPi44K
         OI78pGtBxH6OrCWq2simEIliSUrXUjUDXTApCDs2MV66vcMPpKjiiBdVb4iuWsUjHe9Z
         8eM9OjrHghmgbOxVNaOCZOQji6tHc0ocJxHEBUflwojqsKYkTy0I2LPYxWtXA1Vr6sBb
         +bxrtfXsjEELyO2MSVd99MtadI+c1GdTXhOxdgIseUsdhprkQdxivdFYI+AcgZuCqi7t
         OO89z6X7HmmXmmUglYBTx0RWK7BDLTarRx6NnOPEswD9ov1VnDfhvUys5HmjaF01t0tp
         XMTg==
X-Gm-Message-State: AOAM530f0FROFMuNBTqRPrU9YTMe7XPe5sow92YO0vnnH9pt623nQLI4
        q5ofU7CwEutv8e/v+Kf9RmrNnUkRyQc=
X-Google-Smtp-Source: ABdhPJyplmro/lr4uC/rrMcdzNVk1tZ41yjyTZAtVCUpa7o2JgQNKDcAOLEk3EQt7nDMmD1j8YxQBw==
X-Received: by 2002:a05:6512:2316:b0:446:a84a:173e with SMTP id o22-20020a056512231600b00446a84a173emr10599395lfu.73.1646746166596;
        Tue, 08 Mar 2022 05:29:26 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id c4-20020ac244a4000000b004482d916b47sm1578711lfm.253.2022.03.08.05.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:29:26 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 1/2] bridge: support for controlling flooding of broadcast per port
Date:   Tue,  8 Mar 2022 14:29:14 +0100
Message-Id: <20220308132915.2610480-2-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308132915.2610480-1-troglobit@gmail.com>
References: <20220308132915.2610480-1-troglobit@gmail.com>
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

