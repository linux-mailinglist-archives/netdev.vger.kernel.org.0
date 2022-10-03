Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B86B5F2CFA
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJCJNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJCJNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:13:22 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06880E03D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:12:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a3so3461330wrt.0
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggTkD+Yqw0Fv0Bh205GoC9DmyUFhUon4k03CUdcVnYo=;
        b=Ra1dAAy1YOW/r9W6AjPqG3casFoMej+VZcZuXMVvv0DpCd5JoO59THDl43z7nkgKGm
         h3o3+K4gHaXGbfzSq5Qe1Qa+SVEB10aiGQrITE06pXx2HQeAxcDQPUQ9VzBvIgBqumkt
         Hd52rAnXJYh6h+HxQA9ctOGQtvUi0xtM0MNUfshh5PHwb6SH4l47MOSidI985gf1xkW+
         VpqCQLHA1G2uFdTwJkS9+L5V6pDcuzyo8qo8swHZn7Mh1aO+dM/xQUH0X6BssQTBEeeh
         S3TtQrtteIwOz8ktILC/cabXb6HaTu9ZpW+KkvzFG9TYC722BJVNxwybikwcCI0apxub
         YHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggTkD+Yqw0Fv0Bh205GoC9DmyUFhUon4k03CUdcVnYo=;
        b=LnuJFl56MnXdy4Z26s1tk7y03fHyZKh0l4GhQXHpf4/r6bR9POIFcMWEBj+z/NV1jl
         pFU/ycoP2GWO06qJ1RbymOtAvbAuoogLODdwGEVy4s5R3ghmSeus39qHKalYhl9qIiBV
         iCoMKSzB+TMaL860tFHBkqaqPBhiTNqcTea+657u/O5hiuycOD0SPInqg0FkL9y/VZMs
         09O0PpfnvxmwTTuq5sTXTdIzJglu5reeT8EOBe2TnOLb6bjpTWga4N7yY7i89KzZSPjC
         bqrdY8Ow5hUIZjMhzirhQOFOde89H4iH25/VXWhwAuALhqSPxqHwdQwwReyAQa64XmNW
         jD4A==
X-Gm-Message-State: ACrzQf04UKz/lCljBItXQ5zD27nBRFROjdb4P1Zq3RS59egT4Cm2f93l
        DfX1JDTHT1/hYCEMgzLq7o3NRbcEakCllg==
X-Google-Smtp-Source: AMsMyM5KyXkvcAqrZcFaWizPVq5jTZQGR1YOo562Y+BMEXKt+kPof+KZA+8O5GbHxAUtnS13zzXw7w==
X-Received: by 2002:a05:6000:1f1d:b0:22a:feb9:18a7 with SMTP id bv29-20020a0560001f1d00b0022afeb918a7mr11635156wrb.152.1664788353918;
        Mon, 03 Oct 2022 02:12:33 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id bx10-20020a5d5b0a000000b00228fa832b7asm9512887wrb.52.2022.10.03.02.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 02:12:33 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        steffen.klassert@secunet.com, nicolas.dichtel@6wind.com,
        razor@blackwall.org, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2-next 1/2] ip: xfrm: support "external" (`collect_md`) mode in xfrm interfaces
Date:   Mon,  3 Oct 2022 12:12:11 +0300
Message-Id: <20221003091212.4017603-2-eyal.birger@gmail.com>
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

Support for collect metadata mode was introduced in kernel commit
abc340b38ba2 ("xfrm: interface: support collect metadata mode")

This commit adds support for creating xfrm interfaces in this
mode.

Example use:

ip link add ipsec1 type xfrm external

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/uapi/linux/if_link.h |  1 +
 ip/link_xfrm.c               | 18 ++++++++++++++++++
 man/man8/ip-link.8.in        |  7 +++++++
 3 files changed, 26 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 7494cffb..153fcb96 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -693,6 +693,7 @@ enum {
 	IFLA_XFRM_UNSPEC,
 	IFLA_XFRM_LINK,
 	IFLA_XFRM_IF_ID,
+	IFLA_XFRM_COLLECT_METADATA,
 	__IFLA_XFRM_MAX
 };
 
diff --git a/ip/link_xfrm.c b/ip/link_xfrm.c
index f6c961e6..7046eb99 100644
--- a/ip/link_xfrm.c
+++ b/ip/link_xfrm.c
@@ -18,6 +18,7 @@ static void xfrm_print_help(struct link_util *lu, int argc, char **argv,
 {
 	fprintf(f,
 		"Usage: ... %-4s dev [ PHYS_DEV ] [ if_id IF-ID ]\n"
+		"		[ external ]\n"
 		"\n"
 		"Where: IF-ID := { 0x1..0xffffffff }\n",
 		lu->id);
@@ -27,6 +28,7 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 			  struct nlmsghdr *n)
 {
 	unsigned int link = 0;
+	bool metadata = false;
 	__u32 if_id = 0;
 
 	while (argc > 0) {
@@ -43,6 +45,8 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("if_id value is invalid", *argv);
 			else
 				addattr32(n, 1024, IFLA_XFRM_IF_ID, if_id);
+		} else if (!matches(*argv, "external")) {
+			metadata = true;
 		} else {
 			xfrm_print_help(lu, argc, argv, stderr);
 			return -1;
@@ -50,6 +54,15 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--; argv++;
 	}
 
+	if (metadata) {
+		if (if_id || link) {
+			fprintf(stderr, "xfrmi: both 'external' and if_id/link cannot be specified\n");
+			return -1;
+		}
+		addattr(n, 1024, IFLA_XFRM_COLLECT_METADATA);
+		return 0;
+	}
+
 	if (!if_id)
 		missarg("IF_ID");
 
@@ -65,6 +78,11 @@ static void xfrm_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (!tb)
 		return;
 
+	if (tb[IFLA_XFRM_COLLECT_METADATA]) {
+		print_bool(PRINT_ANY, "external", "external ", true);
+		return;
+	}
+
 	if (tb[IFLA_XFRM_IF_ID]) {
 		__u32 id = rta_getattr_u32(tb[IFLA_XFRM_IF_ID]);
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fc9d62fc..6dcc8504 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1957,6 +1957,7 @@ For a link of type
 the following additional arguments are supported:
 
 .BI "ip link add " DEVICE " type xfrm dev " PHYS_DEV " [ if_id " IF_ID " ]"
+.BR "[ external ]"
 
 .in +8
 .sp
@@ -1969,6 +1970,12 @@ the following additional arguments are supported:
 policies. Policies must be configured with the same key. If not set, the key defaults to
 0 and will match any policies which similarly do not have a lookup key configuration.
 
+.sp
+.BI external
+- make this device externally controlled. This flag is mutually exclusive with the
+.BR dev " and " if_id
+options.
+
 .in -8
 
 .TP
-- 
2.34.1

