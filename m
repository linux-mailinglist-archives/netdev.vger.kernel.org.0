Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CFE4DE726
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 09:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbiCSI7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 04:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiCSI7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 04:59:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADE1CF485
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 01:57:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d10so20986372eje.10
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 01:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koG5Ct0rje3/qucRfHca6ky7zIV0c0s0Ns/rGGW7utE=;
        b=KOR4R1TeYClXEj7p54SzBfi8AmOrfU3vTwI022bUIYcp9eZvlD/4xnAPQCTwhsRySU
         /uyaup3eDYX1cVfEFVz0ena+5r8X/jS1yn10bhUnii91HKdLX79nHcQJed2rpSQINL+t
         hljvD88bLBqDD2FUr3Bb0ejXjxco9UBY5Pzf8BucIf6SSP6auY2EX7x3MvEcG9VbtW2A
         Z369xs452KQ1um3+y1IzevLKZp/tcjVeK3gFaAWfTT5jVimwitbqKloYi6foqAPusbI2
         iOg3PUwDfmmvS/ZOeQqTdeg5VSPLLpVpptU9oItqMcWCx+UZU9AA5ZgDXjZVf4EiBgOG
         4/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koG5Ct0rje3/qucRfHca6ky7zIV0c0s0Ns/rGGW7utE=;
        b=yzQpcxClPMr1LYl20/6P6Rz3N6XiGxfOssCfWi03vh2Zf8lpvaABKYxIKqDx3Mmt+t
         K3Pu203mo5iMnbR5/m/NjcjX2oP4SevID/lxJgiZxtpezNjpqS2pDQAoE60lqT1Vg1a/
         qCnvOD/ZihwxQavhsjbBFqP7wsPsQhF5UaYLS3J1NxCH6tbn86pSv05xTMWYQe9vL6Tc
         MrN46ajei0vAAeTa0AtFkvuEgzZJzikc5B8fQtLpHkNK5tvdNISvnQuiHUBQOOJJb9a8
         Z0mLBzLMJxhlgG6BOkn7ywHW8eXEBr4JoRbYrV/k6VQR+094GSsyd/1noWMEnUib2Zzg
         +MOw==
X-Gm-Message-State: AOAM532QI2lDUM0DfkS0yOhrpBBWyeFI0RBZJOCS6XUtawvUFD3gAW6T
        /M5J1XyhsNvGxkU8EaqCi6c0UfitUNQ1PQ==
X-Google-Smtp-Source: ABdhPJwI3str+RPU+wmk7GEz803168X/cqRM95Xz5KdMexD9D2zvbkeaUeGCPP+KvGogN1pgDGjUUg==
X-Received: by 2002:a17:906:974e:b0:6bb:4f90:a6ae with SMTP id o14-20020a170906974e00b006bb4f90a6aemr12863630ejy.452.1647680277135;
        Sat, 19 Mar 2022 01:57:57 -0700 (PDT)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id n19-20020a1709067b5300b006ce36e2f6fdsm4639659ejo.159.2022.03.19.01.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 01:57:56 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2-next] ip/geneve: add support for IFLA_GENEVE_INNER_PROTO_INHERIT
Date:   Sat, 19 Mar 2022 10:57:40 +0200
Message-Id: <20220319085740.1833561-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
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

Add support for creating devices with this property.
Since it cannot be changed, not adding a [no] option.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/uapi/linux/if_link.h |  1 +
 ip/iplink_geneve.c           | 13 +++++++++++++
 man/man8/ip-link.8.in        |  6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5f36ff8e..8d2f23d3 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -840,6 +840,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_INNER_PROTO_INHERIT,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index 78fc818e..a0d3ed61 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -31,6 +31,7 @@ static void print_explain(FILE *f)
 		"		[ [no]udpcsum ]\n"
 		"		[ [no]udp6zerocsumtx ]\n"
 		"		[ [no]udp6zerocsumrx ]\n"
+		"		[ innerprotoinherit ]\n"
 		"\n"
 		"Where:	VNI   := 0-16777215\n"
 		"	ADDR  := IP_ADDRESS\n"
@@ -72,6 +73,7 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u64 attrs = 0;
 	bool set_op = (n->nlmsg_type == RTM_NEWLINK &&
 		       !(n->nlmsg_flags & NLM_F_CREATE));
+	bool inner_proto_inherit = false;
 
 	inet_prefix_reset(&daddr);
 
@@ -182,6 +184,10 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 			check_duparg(&attrs, IFLA_GENEVE_UDP_ZERO_CSUM6_RX,
 				     *argv, *argv);
 			udp6zerocsumrx = 0;
+		} else if (!matches(*argv, "innerprotoinherit")) {
+			check_duparg(&attrs, IFLA_GENEVE_INNER_PROTO_INHERIT,
+				     *argv, *argv);
+			inner_proto_inherit = true;
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -231,6 +237,8 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 		addattr16(n, 1024, IFLA_GENEVE_PORT, htons(dstport));
 	if (metadata)
 		addattr(n, 1024, IFLA_GENEVE_COLLECT_METADATA);
+	if (inner_proto_inherit)
+		addattr(n, 1024, IFLA_GENEVE_INNER_PROTO_INHERIT);
 	if (GENEVE_ATTRSET(attrs, IFLA_GENEVE_UDP_CSUM))
 		addattr8(n, 1024, IFLA_GENEVE_UDP_CSUM, udpcsum);
 	if (GENEVE_ATTRSET(attrs, IFLA_GENEVE_UDP_ZERO_CSUM6_TX))
@@ -365,6 +373,11 @@ static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			fputs("udp6zerocsumrx ", f);
 		}
 	}
+
+	if (tb[IFLA_GENEVE_INNER_PROTO_INHERIT]) {
+		print_bool(PRINT_ANY, "inner_proto_inherit",
+			   "innerprotoinherit ", true);
+	}
 }
 
 static void geneve_print_help(struct link_util *lu, int argc, char **argv,
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 93106d7f..5713a872 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1255,6 +1255,8 @@ the following additional arguments are supported:
 .RB [ no ] udp6zerocsumtx
 ] [
 .RB [ no ] udp6zerocsumrx
+] [
+.B innerprotoinherit
 ]
 
 .in +8
@@ -1318,6 +1320,10 @@ options.
 .RB [ no ] udp6zerocsumrx
 - allow incoming UDP packets over IPv6 with zero checksum field.
 
+.sp
+.B innerprotoinherit
+- use IPv4/IPv6 as inner protocol instead of Ethernet.
+
 .in -8
 
 .TP
-- 
2.32.0

