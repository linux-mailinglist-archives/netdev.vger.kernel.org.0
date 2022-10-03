Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B53F5F2CFB
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJCJNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJCJNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:13:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C49EE0F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:12:37 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 130-20020a1c0288000000b003b494ffc00bso8116468wmc.0
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=54JWM5pLwKiTSAJLU69TQfpkRk7rLxcr8W/QvMNGq6w=;
        b=OtlcFl3WhWcku7oWZbD51TYhWHTCWq39FDrocBm/Toz5T6jXoaUi8488iElFLn35P+
         nNdrKHyCpD0SlaxMp2CmesQLZ+6T+5Bzt4YSawc4QNYRJNHpLSNVLGxcgP6sNMsNS9PF
         VXAbNQkNhfcbLoG01KIn3fy7uQyYBOnFdjrT4Dblz1SdVRxMiN3Rq1phfuS69Zyj8Igq
         u5k8PhD9HOGUuIhzqQNf6tSY/bE1LjBxz6JeGc62purOB+uf2M6LRmoeSbxIagjlF/rT
         RXe1QQzywjnQ21el07wuXd5+pRW5O/9CJmrzMcXowgtcgf68TJWzufeZ9RBO+kBbatSG
         c8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=54JWM5pLwKiTSAJLU69TQfpkRk7rLxcr8W/QvMNGq6w=;
        b=7CqHuKf+jl4hyYwmpp5paqkNLpyk5YbZbP7FLLRst9MGN2oEqENBktp153xeT9GN5W
         cozqPwrpFuZi+x9RKE70XeCFyOL8ep2H4+QZzGfNDpNA4ssHCY3Enj55nR34hAYODa6w
         kfj2B4ljCMu02jWjGSC8tGIQPsAdKmTGSDCneXubQv9ZiYaKZ5ih9X9AxRxeih306ytE
         W0iJTRfgTC8LJKK5owYb323/rqVyHclCH54Q3d94gFGk9jBQXTk8bdbYPGvUcG6l9UPB
         0HCU723aiCG82YeZ0tDnBtAWlSypjQ7JUaNKfO/oR6Q4iP2XV8WVm2MuXhQM5hidRXuP
         gYgw==
X-Gm-Message-State: ACrzQf0QguyGX+2PDAOjmMlGDnf1QHE+Ri9tQ3fEjCi8Riiag8/aijpe
        2DdVJF0dGF5oM68Heg/2yjtu6m+Av62H6A==
X-Google-Smtp-Source: AMsMyM4FPhSrdkIGcvIUaR0jMK8al1WN9OlHz5ViSnniVlVsrZQD+Wb1FGCGVTV4j9+BFcVnChjq2A==
X-Received: by 2002:a05:600c:247:b0:3b4:7644:42b4 with SMTP id 7-20020a05600c024700b003b4764442b4mr6450419wmj.5.1664788355574;
        Mon, 03 Oct 2022 02:12:35 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id bx10-20020a5d5b0a000000b00228fa832b7asm9512887wrb.52.2022.10.03.02.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:12:35 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        steffen.klassert@secunet.com, nicolas.dichtel@6wind.com,
        razor@blackwall.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2-next 2/2] ip: xfrm: support adding xfrm metadata as lwtunnel info in routes
Date:   Mon,  3 Oct 2022 12:12:12 +0300
Message-Id: <20221003091212.4017603-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003091212.4017603-1-eyal.birger@gmail.com>
References: <20221003091212.4017603-1-eyal.birger@gmail.com>
MIME-Version: 1.0
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

Support for xfrm metadata as lwtunnel metadata was added in kernel commit
2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")

This commit adds the respective support in lwt routes.

Example use (consider ipsec1 as an xfrm interface in "external" mode):

ip route add 10.1.0.0/24 dev ipsec1 encap xfrm if_id 1

Or in the context of vrf, one can also specify the "link" property:

ip route add 10.1.0.0/24 dev ipsec1 encap xfrm if_id 1 link_dev eth15

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/uapi/linux/lwtunnel.h | 10 +++++
 ip/iproute.c                  |  5 ++-
 ip/iproute_lwtunnel.c         | 83 +++++++++++++++++++++++++++++++++++
 man/man8/ip-route.8.in        | 11 +++++
 4 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 78f0ecd1..9d22961b 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
 	LWTUNNEL_ENCAP_RPL,
 	LWTUNNEL_ENCAP_IOAM6,
+	LWTUNNEL_ENCAP_XFRM,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
@@ -111,4 +112,13 @@ enum {
 
 #define LWT_BPF_MAX_HEADROOM 256
 
+enum {
+	LWT_XFRM_UNSPEC,
+	LWT_XFRM_IF_ID,
+	LWT_XFRM_LINK,
+	__LWT_XFRM_MAX,
+};
+
+#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
+
 #endif /* _LWTUNNEL_H_ */
diff --git a/ip/iproute.c b/ip/iproute.c
index 8b2d1fbe..b4b9d1b2 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -102,8 +102,8 @@ static void usage(void)
 		"TIME := NUMBER[s|ms]\n"
 		"BOOL := [1|0]\n"
 		"FEATURES := ecn\n"
-		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl | ioam6 ]\n"
-		"ENCAPHDR := [ MPLSLABEL | SEG6HDR | SEG6LOCAL | IOAM6HDR ]\n"
+		"ENCAPTYPE := [ mpls | ip | ip6 | seg6 | seg6local | rpl | ioam6 | xfrm ]\n"
+		"ENCAPHDR := [ MPLSLABEL | SEG6HDR | SEG6LOCAL | IOAM6HDR | XFRMINFO ]\n"
 		"SEG6HDR := [ mode SEGMODE ] segs ADDR1,ADDRi,ADDRn [hmac HMACKEYID] [cleanup]\n"
 		"SEGMODE := [ encap | encap.red | inline | l2encap | l2encap.red ]\n"
 		"SEG6LOCAL := action ACTION [ OPTIONS ] [ count ]\n"
@@ -116,6 +116,7 @@ static void usage(void)
 		"FLAVORS := { FLAVOR[,FLAVOR] }\n"
 		"FLAVOR := { psp | usp | usd | next-csid }\n"
 		"IOAM6HDR := trace prealloc type IOAM6_TRACE_TYPE ns IOAM6_NAMESPACE size IOAM6_TRACE_SIZE\n"
+		"XFRMINFO := if_id IF_ID [ link_dev LINK ]\n"
 		"ROUTE_GET_FLAGS := [ fibmatch ]\n");
 	exit(-1);
 }
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 86128c9b..bf4468b6 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -58,6 +58,8 @@ static const char *format_encap_type(int type)
 		return "rpl";
 	case LWTUNNEL_ENCAP_IOAM6:
 		return "ioam6";
+	case LWTUNNEL_ENCAP_XFRM:
+		return "xfrm";
 	default:
 		return "unknown";
 	}
@@ -96,6 +98,8 @@ static int read_encap_type(const char *name)
 		return LWTUNNEL_ENCAP_RPL;
 	else if (strcmp(name, "ioam6") == 0)
 		return LWTUNNEL_ENCAP_IOAM6;
+	else if (strcmp(name, "xfrm") == 0)
+		return LWTUNNEL_ENCAP_XFRM;
 	else if (strcmp(name, "help") == 0)
 		encap_type_usage();
 
@@ -814,6 +818,24 @@ static void print_encap_bpf(FILE *fp, struct rtattr *encap)
 			   " %u ", rta_getattr_u32(tb[LWT_BPF_XMIT_HEADROOM]));
 }
 
+static void print_encap_xfrm(FILE *fp, struct rtattr *encap)
+{
+	struct rtattr *tb[LWT_XFRM_MAX+1];
+
+	parse_rtattr_nested(tb, LWT_XFRM_MAX, encap);
+
+	if (tb[LWT_XFRM_IF_ID])
+		print_uint(PRINT_ANY, "if_id", "if_id %lu ",
+			   rta_getattr_u32(tb[LWT_XFRM_IF_ID]));
+
+	if (tb[LWT_XFRM_LINK]) {
+		int link = rta_getattr_u32(tb[LWT_XFRM_LINK]);
+
+		print_string(PRINT_ANY, "link_dev", "link_dev %s ",
+			     ll_index_to_name(link));
+	}
+}
+
 void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 			  struct rtattr *encap)
 {
@@ -854,6 +876,9 @@ void lwt_print_encap(FILE *fp, struct rtattr *encap_type,
 	case LWTUNNEL_ENCAP_IOAM6:
 		print_encap_ioam6(fp, encap);
 		break;
+	case LWTUNNEL_ENCAP_XFRM:
+		print_encap_xfrm(fp, encap);
+		break;
 	}
 }
 
@@ -2129,6 +2154,61 @@ static int parse_encap_bpf(struct rtattr *rta, size_t len, int *argcp,
 	return 0;
 }
 
+static void lwt_xfrm_usage(void)
+{
+	fprintf(stderr, "Usage: ip route ... encap xfrm if_id IF_ID [ link_dev LINK ]\n");
+	exit(-1);
+}
+
+static int parse_encap_xfrm(struct rtattr *rta, size_t len,
+			    int *argcp, char ***argvp)
+{
+	int if_id_ok = 0, link_ok = 0;
+	char **argv = *argvp;
+	int argc = *argcp;
+	int ret = 0;
+
+	while (argc > 0) {
+		if (!strcmp(*argv, "if_id")) {
+			__u32 if_id;
+
+			NEXT_ARG();
+			if (if_id_ok++)
+				duparg2("if_id", *argv);
+			if (get_u32(&if_id, *argv, 0) || if_id == 0)
+				invarg("\"if_id\" value is invalid\n", *argv);
+			ret = rta_addattr32(rta, len, LWT_XFRM_IF_ID, if_id);
+		} else if (!strcmp(*argv, "link_dev")) {
+			int link;
+
+			NEXT_ARG();
+			if (link_ok++)
+				duparg2("link_dev", *argv);
+			link = ll_name_to_index(*argv);
+			if (!link)
+				exit(nodev(*argv));
+			ret = rta_addattr32(rta, len, LWT_XFRM_LINK, link);
+		} else if (!strcmp(*argv, "help")) {
+			lwt_xfrm_usage();
+		}
+		if (ret)
+			break;
+		argc--; argv++;
+	}
+
+	if (!if_id_ok)
+		lwt_xfrm_usage();
+
+	/* argv is currently the first unparsed argument,
+	 * but the lwt_parse_encap() caller will move to the next,
+	 * so step back
+	 */
+	*argcp = argc + 1;
+	*argvp = argv - 1;
+
+	return ret;
+}
+
 int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
 		    int encap_attr, int encap_type_attr)
 {
@@ -2180,6 +2260,9 @@ int lwt_parse_encap(struct rtattr *rta, size_t len, int *argcp, char ***argvp,
 	case LWTUNNEL_ENCAP_IOAM6:
 		ret = parse_encap_ioam6(rta, len, &argc, &argv);
 		break;
+	case LWTUNNEL_ENCAP_XFRM:
+		ret = parse_encap_xfrm(rta, len, &argc, &argv);
+		break;
 	default:
 		fprintf(stderr, "Error: unsupported encap type\n");
 		break;
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index bd38b7d8..194dc780 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -738,6 +738,9 @@ is a string specifying the supported encapsulation type. Namely:
 .sp
 .BI ioam6
 - encapsulation type IPv6 IOAM
+.sp
+.BI xfrm
+- encapsulation type XFRM
 
 .in -8
 .I ENCAPHDR
@@ -1024,6 +1027,14 @@ mode.
 .B size
 .I IOAM6_TRACE_SIZE
 - Size, in octets, of the pre-allocated trace data block.
+.in -2
+
+.B xfrm
+.in +2
+.B if_id
+.I IF_ID
+.B  " [ link_dev
+.IR LINK_DEV " ] "
 .in -4
 
 .in -8
-- 
2.34.1

