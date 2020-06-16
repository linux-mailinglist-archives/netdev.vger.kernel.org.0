Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CA1FA8E0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 08:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFPGjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 02:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgFPGjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 02:39:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1E2C05BD43
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 23:39:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z9so22108314ljh.13
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 23:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=82zitYFPEUrvyxA0MyYOETzDCNMmVBObeH1ajgGhq4A=;
        b=SnGECu6Tkmktgw8EicBIyiYmVfm+bEirDt57jrJPPJmCOK3YAZaTAXwoxONUN82qKd
         gZfclA1IVsXVbso1zPokhSvo5kOh8nXviLR02Olb+rBbc+b4FvJq8s0td/16d9MDoBfC
         khthStykFj5RNDLc1ZugGOXpvDps7wtK24oOUIEEpAyUPKiZubxGHRQDihA8ygFQOiBS
         kgRiSVuD/g8ZejH+fHmLKcSONFnNUZ76jiqZ0rqfApW3+8OCF/ij4q6XNAtpSVsmQRpu
         Xq2eyXxvMOm3UbsN3TCNx19Sgz2a2DOVfGzTJ5Hv1axwkoihn0RNigPxsFhY17p9PmYN
         H5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=82zitYFPEUrvyxA0MyYOETzDCNMmVBObeH1ajgGhq4A=;
        b=Wz8UbAqWgUWJQJ5navcZdoOGvN5n7oIFs5my79qCo4vxcBDd4j5zJBkDwbrcLrglKm
         6DaxjZwl+3jgYmMHW+q/bGTjtA2+62f/+nK23PH6emExWtvaK1ERtaq6kRQjAjgZxenL
         n0VNNDBKusfRaA4N6pGdHRW+xeKcz7FgcpxSgULKBfcWAzxO3m52YoIfy6c0IyYFGP/J
         qKNnh/fMUy9k8QDI2IMvJ/DauIp09a7K399hdkLilTn5J7QIQYwk/Pgx76iYcN1B7sEG
         9sZO4cPQ5yYD3mORqK4hPA3sAn7/FDhshyPmh+HBcz+HmTa8xNtYP2bcQ4KTLxktA9u6
         0k+w==
X-Gm-Message-State: AOAM532myBZlmYkxtVwJFxbkHPKes9FIDIF0rfXbZmspfBh86IIH/7Hl
        XGwnHfUrELl0LmEP0yw5FBtsvDTRYqo=
X-Google-Smtp-Source: ABdhPJyxv707KhBUfR8uKC9tbzn2Gac/CeyL/R+MAYWqb7dZjQx0rcn9eyTWV8q3AgAi7wE5WV9kHw==
X-Received: by 2002:a2e:7219:: with SMTP id n25mr613256ljc.168.1592289558106;
        Mon, 15 Jun 2020 23:39:18 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id a23sm1333540lfb.10.2020.06.15.23.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 23:39:17 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH v2] tc: qdisc: filter qdisc's by parent/handle specification
Date:   Tue, 16 Jun 2020 09:39:02 +0300
Message-Id: <20200616063902.15605-1-littlesmilingcloud@gmail.com>
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

changes since v1:
  coding style fixes

---
 man/man8/tc.8 |   8 +++-
 tc/tc_qdisc.c | 111 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 84 insertions(+), 35 deletions(-)

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
index 181fe2f0..af2dd1c8 100644
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
@@ -344,21 +353,70 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 
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
+				fprintf(stderr,
+					"only one of parent/handle/root/ingress can be specified\n");
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
+				fprintf(stderr,
+				    "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
 			}
-			t.tcm_parent = TC_H_INGRESS;
+			filter_parent = TC_H_INGRESS;
+		} else if (matches(*argv, "parent") == 0) {
+			if (filter_parent || filter_handle) {
+				fprintf(stderr,
+				    "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			NEXT_ARG();
+			if (get_tc_classid(&handle, *argv)) {
+				invarg("invalid parent ID", *argv);
+				arg_error = true;
+				break;
+			}
+			filter_parent = handle;
+		} else if (matches(*argv, "handle") == 0) {
+			if (filter_parent || filter_handle) {
+				fprintf(stderr,
+				    "only one of parent/handle/root/ingress can be specified\n");
+				arg_error = true;
+				break;
+			}
+			NEXT_ARG();
+			if (get_qdisc_handle(&handle, *argv)) {
+				invarg("invalid handle ID", *argv);
+				arg_error = true;
+				break;
+			}
+			filter_handle = handle;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else if (strcmp(*argv, "invisible") == 0) {
@@ -371,35 +429,26 @@ static int tc_qdisc_list(int argc, char **argv)
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
 
@@ -427,12 +476,8 @@ int do_qdisc(int argc, char **argv)
 		return tc_qdisc_modify(RTM_NEWQDISC, NLM_F_REPLACE, argc-1, argv+1);
 	if (matches(*argv, "delete") == 0)
 		return tc_qdisc_modify(RTM_DELQDISC, 0,  argc-1, argv+1);
-#if 0
-	if (matches(*argv, "get") == 0)
-		return tc_qdisc_get(RTM_GETQDISC, 0,  argc-1, argv+1);
-#endif
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
-	    || matches(*argv, "lst") == 0)
+	    || matches(*argv, "lst") == 0 || matches(*argv, "get") == 0)
 		return tc_qdisc_list(argc-1, argv+1);
 	if (matches(*argv, "help") == 0) {
 		usage();
-- 
2.26.2

