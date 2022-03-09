Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D5D4D3A37
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiCITZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiCITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:58 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B7F2BDA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:39 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u3so4734175ljd.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=8cdr6JcxYfveAV3I/8PrMKcEHbA24yDDjma9KaoJIpA=;
        b=IGRVbN600V8u/igN2wxGtGj3alV2cNbYMfQSIcrcb/BbeH5XXdwVYOo9MhKjWFfa0u
         q4dabOQvk691HUxxPfgrtxo1G1WO5YwwjPA0DtBt1sRFl5Yelruo+9kjK5d/CBzUhX4q
         dERIwvnltLw/4vtWAYYqoxvigYV1V0cDQ8KfDapy0adrhFqev8h0N7CkgOaAPbzww5QH
         Pnn8/d2XfzGqsMRkK4XVHWvgHg3aEnTxMa/xmTRvsEg+4J6wc6RQ74szy3u3tcYfFWyP
         4g7VTFq5SCOzAcSOts6CjJ3Mh2G2Te3aL9fOzneptMURalHNxRtTAFMAcbm/MFm1KczS
         VuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=8cdr6JcxYfveAV3I/8PrMKcEHbA24yDDjma9KaoJIpA=;
        b=l/sng9eYhj18Gv3AzwScDARhBIBalYjdtBDZ5O7hDYVRnAJWfrDgBQqn/pN2YYhhnv
         NRs82iz2EmdLCDiwJtk2TiPeGNNHSoycCPnhui1RpPrt2WzamQdyfxY7MSjHQJqkfuBU
         6YwuytACCBAcBUyqkZw/sBvIiLdTMk61laa7IWbHpdHWnFO78HDvRZH5yQ33E+ZEPIge
         1NDw6eOZqpu2CfSjKLlUUcmm4a9JSRJaOIS5JNVUP42gZk7V44VpsqVgbD5t4LItUxov
         E3QytrBZE52If6i1XEWK8l0HvBymIe/D/wOVbxlh6ZBEN83DSdxcw9mZisn9I/ZZcTtU
         2FTg==
X-Gm-Message-State: AOAM531Sgruh40JwnvqCjai0tIusbtkBcHkIXruJaslTDakhARDLZkbl
        mST4ytE/Ko2U4czSeM6nfgQ35DLt78rEqQ==
X-Google-Smtp-Source: ABdhPJw4ohOvUiz9YlAoYCJ0FIDX5H7kjzs5ipMvvFy6sPJSq6Yaexh8gwNz5LGM2yJWWR9qd4HjDg==
X-Received: by 2002:a2e:2ac4:0:b0:247:eae2:66f3 with SMTP id q187-20020a2e2ac4000000b00247eae266f3mr686516ljq.414.1646853817390;
        Wed, 09 Mar 2022 11:23:37 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:36 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 4/7] ip: iplink_bridge_slave: support for broadcast flooding
Date:   Wed,  9 Mar 2022 20:23:13 +0100
Message-Id: <20220309192316.2918792-5-troglobit@gmail.com>
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

