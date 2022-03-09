Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620214D3A32
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiCITZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiCITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:58 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E2B30F4D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:34 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id q10so4641848ljc.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=b0zyAMSwqjswXu2qnYP44TBhVg4dB1wl0SnCuKfWudYlyHHmsUfK75AxIy/EIbmH+y
         tVhFAGLeUI50R03HZwKbHyXSqsJY/RZA9nro7P1YSpSWglRUlwZtF8CL1tPhEORT78zO
         S4V2GYGIEoezzGwiqZUu5GkBkgiRAycsDP51sLq8E0A2+E6NvtmugCTl4mN6s66RyTvM
         /xeF5s/zaEh/3QVlaKGiwD0a73b3WX8JYi4W7/CWTHTqbmVHrM0bHl5x+60yCB8mKjSu
         u7E+fEICcwVjkNxc1S6SeEW0xWLfkdw6bIUQEs5mWuuo7cFtzvpkF9vIXqWR7n4EyJxd
         oLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=vKI9hOdRsycB1cOoFMiddNOLZ6leR1+qJXbgkTLjIxg=;
        b=5qeLpU7iuCUnigk2CTqMjKExkMGMwnr7RZ9fOqIQfoZpznvYykklBC3WAt/2Do8SHp
         hYaG4Aj6jTrCUCkFWeuzukWiTlgK1apkbJpfur2uV/6qNNJRDZHjVR1s3x2pPvxCJ7Te
         ys9ybfllJq0KlQjr2zXlZk0Vbq/MAQw+0J/YGFRf8le6TWspXLaRbIxdT8I2eJC7YSWe
         QjPbC1SOoD1u3CD5qY6eAgJevmLTsEsdhkRvSgU83uhMDilCk5KMuE8OSCuIvXu3K8WV
         tdD1BEmz6sNyrdxP/oOtDFrN7YSX+WlugCBNVth9Uk5/XRRVCTma1wMK6zoWuThlbmRo
         OQ2g==
X-Gm-Message-State: AOAM530BIluO9OtZqAfUHkjyUDKvhW79mHOiZB+L8+VwsPm4jqd+DDN3
        h0NCHtptRfNdK4j4g0EunceyPmlUz9PaGQ==
X-Google-Smtp-Source: ABdhPJzY/MB6CxYwLXSOQQYBXM10BOcT493/Ar4NIq2HnNnpBpWYkRF+XA+7KYMuZanNHbcHcP1y+Q==
X-Received: by 2002:a2e:2202:0:b0:248:684:4476 with SMTP id i2-20020a2e2202000000b0024806844476mr691421lji.64.1646853812433;
        Wed, 09 Mar 2022 11:23:32 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:31 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 1/7] bridge: support for controlling flooding of broadcast per port
Date:   Wed,  9 Mar 2022 20:23:10 +0100
Message-Id: <20220309192316.2918792-2-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
References: <20220309192316.2918792-1-troglobit@gmail.com>
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

