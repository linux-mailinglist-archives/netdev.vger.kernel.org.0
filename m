Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE061FA048
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgFOTa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbgFOTa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:30:58 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE955C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 12:30:57 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c12so10244931lfc.10
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 12:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SVG0R77GDADcbwul/NNZuZ7RQBEGHIOWp6UvdEZeJZA=;
        b=u5+tSdMGq7ll4ev8vV7palhrjeMZ1muBog/qdTGcjz6qPxY/hi7VIgBsEkLEErFeeI
         tRqHGyQuEf07y8VNDrqLq+VuKYWy888uMbNIEdzW8CUkZqSDfrQ0I1iQWzoOa7kTieLP
         BknMCglE3PLODwobGG6Ug4HiaY6kU6SLXPYnaEs4jM2s3cb6UlGnAqSKkH2+gY74kbg0
         hqvpv/BUlS+vne5i/PFVc/CYHF2Mv4vZGRytneVgna3pgUzT19vUrHi/Rkb+Au2hI66t
         TStHfyR9Ur4DpogYcLW52eCy3ZkT6P3hnDW95k1UPgCKNsukJFr1SG8Vbzg2zjcXb7vh
         p7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SVG0R77GDADcbwul/NNZuZ7RQBEGHIOWp6UvdEZeJZA=;
        b=ALt8x6G3ec1AuDJOw/qME5iGedTupHniSsMoKj5fD9JRYPEt41RjBgt8gzwsi5k5Fd
         CvBSYdUoerClOIdKgFdM7j/osXzdo6+pLg6EwB0wQFXHBb2GksmxaDpbN93bi2O+T3DX
         77HWKrt2qoAZkY116AqA5OykNt7l03FjCFIUcKj5iQve0sFP7hRsi40R4OTL++rvIKda
         +f3c6IthLjfkA3E+JC511uvwV0ZZz1Lyt7WEt6nbIGxgBG2JNAuS1VpdQ+21CIy/IQpn
         v9IhmV8k92YYl/V1oJLIjaI1In30FhgaXLJX02DRh565uDepXYqSuPPAdFVpFqtWqCy0
         I3SA==
X-Gm-Message-State: AOAM530/LTVDxyfToJlQ81NusAxx0w6sqhr7oQ2mJlZOYad3sHK4Gt0D
        8vOCnwoS5Xc9Ll7i4mQimDOzWJiGYcQ=
X-Google-Smtp-Source: ABdhPJw6vX50gXi9856w337tYg5gb49EcqYmrGUiM7hN2YTjFRaVIJHSN3a/A7/SvTgaJsnDGTvYQg==
X-Received: by 2002:a05:6512:328d:: with SMTP id p13mr4029029lfe.139.1592249455725;
        Mon, 15 Jun 2020 12:30:55 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id w15sm4729020lfl.51.2020.06.15.12.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 12:30:55 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH iproute2] tc: qdisc: filter qdisc's by parent/handle specification
Date:   Mon, 15 Jun 2020 22:29:28 +0300
Message-Id: <20200615192928.6667-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There wasn't a way to get a qdisc info by handle or parent, only full
dump of qdisc's with following grep/sed usage.

The 'qdisc get' command have been added.

tc qdisc { show | get } [ dev STRING ] [ QDISC_ID ] [ invisible ]
  QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }

This change doesn't require any changes in the kernel.

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 man/man8/tc.8 |   8 +++-
 tc/tc_qdisc.c | 109 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 82 insertions(+), 35 deletions(-)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8e0cd0f..8753088f 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -77,9 +77,13 @@ tc \- show / manipulate traffic control settings
 .B tc
 .RI "[ " OPTIONS " ]"
 .RI "[ " FORMAT " ]"
-.B qdisc show [ dev
+.B qdisc { show | get } [ dev
 \fIDEV\fR
-.B ]
+.B ] [ root | ingress | handle
+\fIQHANDLE\fR
+.B | parent
+\fICLASSID\fR
+.B ] [ invisible ]
 .P
 .B tc
 .RI "[ " OPTIONS " ]"
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 181fe2f0..45b78462 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -35,11 +35,12 @@ static int usage(void)
 		"       [ ingress_block BLOCK_INDEX ] [ egress_block BLOCK_INDEX ]\n"
 		"       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n"
 		"\n"
-		"       tc qdisc show [ dev STRING ] [ ingress | clsact ] [ invisible ]\n"
+		"       tc qdisc { show | get } [ dev STRING ] [ QDISC_ID ] [ invisible ]\n"
 		"Where:\n"
 		"QDISC_KIND := { [p|b]fifo | tbf | prio | cbq | red | etc. }\n"
 		"OPTIONS := ... try tc qdisc add <desired QDISC_KIND> help\n"
-		"STAB_OPTIONS := ... try tc qdisc add stab help\n");
+		"STAB_OPTIONS := ... try tc qdisc add stab help\n"
+		"QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }\n");
 	return -1;
 }
 
@@ -212,6 +213,8 @@ static int tc_qdisc_modify(int cmd, unsigned int flags, int argc, char **argv)
 }
 
 static int filter_ifindex;
+static __u32 filter_parent;
+static __u32 filter_handle;
 
 int print_qdisc(struct nlmsghdr *n, void *arg)
 {
@@ -235,6 +238,12 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 	if (filter_ifindex && filter_ifindex != t->tcm_ifindex)
 		return 0;
 
+	if (filter_handle && filter_handle != t->tcm_handle)
+		return 0;
+
+	if (filter_parent && filter_parent != t->tcm_parent)
+		return 0;
+
 	parse_rtattr_flags(tb, TCA_MAX, TCA_RTA(t), len, NLA_F_NESTED);
 
 	if (tb[TCA_KIND] == NULL) {
@@ -344,21 +353,68 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 
 static int tc_qdisc_list(int argc, char **argv)
 {
-	struct tcmsg t = { .tcm_family = AF_UNSPEC };
+	struct {
+		struct nlmsghdr n;
+		struct tcmsg t;
+		char buf[256];
+	} req = {
+		.n.nlmsg_type = RTM_GETQDISC,
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.t.tcm_family = AF_UNSPEC,
+	};
+
 	char d[IFNAMSIZ] = {};
+	bool arg_error = false;
 	bool dump_invisible = false;
+	__u32 handle;
 
-	while (argc > 0) {
+	while (argc > 0 && !arg_error) {
 		if (strcmp(*argv, "dev") == 0) {
 			NEXT_ARG();
 			strncpy(d, *argv, sizeof(d)-1);
+		} else if (strcmp(*argv, "root") == 0) {
+			if (filter_parent || filter_handle) {
+				fprintf(stderr, "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			filter_parent = TC_H_ROOT;
 		} else if (strcmp(*argv, "ingress") == 0 ||
 			   strcmp(*argv, "clsact") == 0) {
-			if (t.tcm_parent) {
-				fprintf(stderr, "Duplicate parent ID\n");
-				usage();
+			if (filter_parent || filter_handle) {
+				fprintf(stderr, "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			filter_parent = TC_H_INGRESS;
+		} else if (matches(*argv, "parent") == 0) {
+			if (filter_parent || filter_handle) {
+				fprintf(stderr, "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			NEXT_ARG();
+			if(get_tc_classid(&handle, *argv)) {
+				invarg("invalid parent ID", *argv);
+				arg_error = true;
+				break;
+			} else {
+				filter_parent = handle;
+			}
+		} else if (matches(*argv, "handle") == 0) {
+			if (filter_parent || filter_handle) {
+				fprintf(stderr, "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			NEXT_ARG();
+			if(get_qdisc_handle(&handle, *argv)) {
+				invarg("invalid handle ID", *argv);
+				arg_error = true;
+				break;
+			} else {
+				filter_handle = handle;
 			}
-			t.tcm_parent = TC_H_INGRESS;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else if (strcmp(*argv, "invisible") == 0) {
@@ -371,35 +427,26 @@ static int tc_qdisc_list(int argc, char **argv)
 		argc--; argv++;
 	}
 
+	if (arg_error) {
+		/* argument error message should be already displayed above */
+		return -1;
+	}
+
 	ll_init_map(&rth);
 
 	if (d[0]) {
-		t.tcm_ifindex = ll_name_to_index(d);
-		if (!t.tcm_ifindex)
+		req.t.tcm_ifindex = ll_name_to_index(d);
+		if (!req.t.tcm_ifindex)
 			return -nodev(d);
-		filter_ifindex = t.tcm_ifindex;
+		filter_ifindex = req.t.tcm_ifindex;
 	}
 
 	if (dump_invisible) {
-		struct {
-			struct nlmsghdr n;
-			struct tcmsg t;
-			char buf[256];
-		} req = {
-			.n.nlmsg_type = RTM_GETQDISC,
-			.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg)),
-		};
-
-		req.t.tcm_family = AF_UNSPEC;
-
 		addattr(&req.n, 256, TCA_DUMP_INVISIBLE);
-		if (rtnl_dump_request_n(&rth, &req.n) < 0) {
-			perror("Cannot send dump request");
-			return 1;
-		}
+	}
 
-	} else if (rtnl_dump_request(&rth, RTM_GETQDISC, &t, sizeof(t)) < 0) {
-		perror("Cannot send dump request");
+	if (rtnl_dump_request_n(&rth, &req.n) < 0) {
+		perror("Cannot send request");
 		return 1;
 	}
 
@@ -427,12 +474,8 @@ int do_qdisc(int argc, char **argv)
 		return tc_qdisc_modify(RTM_NEWQDISC, NLM_F_REPLACE, argc-1, argv+1);
 	if (matches(*argv, "delete") == 0)
 		return tc_qdisc_modify(RTM_DELQDISC, 0,  argc-1, argv+1);
-#if 0
-	if (matches(*argv, "get") == 0)
-		return tc_qdisc_get(RTM_GETQDISC, 0,  argc-1, argv+1);
-#endif
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
-	    || matches(*argv, "lst") == 0)
+	    || matches(*argv, "lst") == 0 || matches(*argv, "get") == 0 )
 		return tc_qdisc_list(argc-1, argv+1);
 	if (matches(*argv, "help") == 0) {
 		usage();
-- 
2.26.2

