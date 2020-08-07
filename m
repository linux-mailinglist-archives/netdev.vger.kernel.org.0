Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A88123F4E5
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgHGWbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGWbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:31:38 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC802C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 15:31:37 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b25so2508397qto.2
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 15:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yZ2zAuIlKqsdRAy3Buw2UTitczlkMHV5b4wy5ExPRJc=;
        b=cOMf9TMRktQ2vpk/bVL8sqoTCx4wk5Qy8OYDFCzjmyYOc5o7C/GvuBhxfy6qcO9rLI
         HHi8TKVpIttEEfy1UEImN/Qi/9i0igqxaQp7xzDVkoztQqmtPtJRoUL47ybHy9L5Auia
         1pXbT9yrxCLl6n92wc/JeyActf0nJNE9cYtwS4mMCGxjJG63VXHW4bUzWkD/kD6j0SJm
         i4yV6ucUn35PWRmv3LGdlovTS/3aya9hT/KcJWn0yB0UYnW01+YKtpK4c4TQYIXLW/bk
         TD6i6LfJebV/vZydAex9AjDgujqLmgDqUFIQ2CFO9JT1tFnXY8ZzuAyMF+3TQxwyXtGW
         ZDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yZ2zAuIlKqsdRAy3Buw2UTitczlkMHV5b4wy5ExPRJc=;
        b=mzVQFebKkjBCq8upWaGayC+zWpmRGJu6tKrkP8QloAG7hcbbaymhcdW7HSfQCcB2rA
         Iv0nSRzLBlpoGez7cA4YXqi7wpSzKHHfVqtABmhwdFDr3MeCfKAjDYPRgrvr1+zPLpZh
         V2KO+A83ha/KAZj+JsiYXBJ//ccInYz7fJQ6Q8lT4zmni/oucuUSQ5VwolDkdw1CqKSS
         KagKwxg+otUxEtg36vclY4Qmcm4mQYgitLFNunNMlskwGmgDC7RpmBDrlimFYnS8MZUo
         xEWC6xEfhb6s4CmzG6d6StD5p99ycXtoEczZZC9YaogLI5I9aEqq53VXwsdTlKK28ARw
         95tQ==
X-Gm-Message-State: AOAM530/STGzZ7ickxAk57DHC91jnAgR3wDDoo0JC2lXi9/gyEgPxM33
        j5uEIBtadgaxubsOpjzzAd2T0w==
X-Google-Smtp-Source: ABdhPJxxW9a7Z4VUVBGDppu9pTnfvWVdTYCnOw+bon1wr8lNVh99TpBSaIJComxIcqdCladtz9EGBQ==
X-Received: by 2002:ac8:3a84:: with SMTP id x4mr15197788qte.361.1596839496942;
        Fri, 07 Aug 2020 15:31:36 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.gmail.com with ESMTPSA id s184sm8117017qkf.50.2020.08.07.15.31.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2020 15:31:36 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        lariel@mellanox.com, Jamal Hadi Salim <hadi@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 1/1] tc: introduce skbhash classifier
Date:   Fri,  7 Aug 2020 18:31:10 -0400
Message-Id: <20200807223110.24857-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <hadi@mojatatu.com>

This classifier - in the same spirit as the tc skb mark classifier - provides
a generic (fast lookup) approach to filter on the hash value and optional
mask.

like skb->mark, skb->hash could be set by multiple entities in the datapath
including but not limited to hardware offloaded classification policies,
hardware RSS (which already sets it today), XDP, ebpf programs
and even by other tc actions like skbedit and IFE.

Example use:

$TC qdisc add  dev $DEV1 ingress
... offloaded to hardware using flower ...
$TC filter add dev $DEV1 ingress protocol ip prio 1 flower hash 0x1f/0xff skip_sw flowid 1:1 \
action ok
... and when it shows up in s/w tagged from hardware, do something funky...
$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 handle 0x11/0xff skbhash flowid 1:11 \
action mirred egress redirect dev $DEV2
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 0x12 skbhash flowid 1:12 \
action mirred egress redirect dev $DEV3

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/uapi/linux/pkt_cls.h |  13 ++++
 tc/Makefile                  |   1 +
 tc/f_skbhash.c               | 140 +++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+)
 create mode 100644 tc/f_skbhash.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 7576209d..da22bf87 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -767,4 +767,17 @@ enum {
 	TCF_EM_OPND_LT
 };
 
+/* skbhash filter */
+
+enum {
+	TCA_SKBHASH_UNSPEC,
+	TCA_SKBHASH_CLASSID,
+	TCA_SKBHASH_POLICE,
+	TCA_SKBHASH_ACT,
+	TCA_SKBHASH_MASK,
+	__TCA_SKBHASH_MAX
+};
+
+#define TCA_SKBHASH_MAX (__TCA_SKBHASH_MAX - 1)
+
 #endif
diff --git a/tc/Makefile b/tc/Makefile
index 79c9c1dd..8c78f922 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -29,6 +29,7 @@ TCMODULES += f_bpf.o
 TCMODULES += f_flow.o
 TCMODULES += f_cgroup.o
 TCMODULES += f_flower.o
+TCMODULES += f_skbhash.o
 TCMODULES += q_dsmark.o
 TCMODULES += q_gred.o
 TCMODULES += f_tcindex.o
diff --git a/tc/f_skbhash.c b/tc/f_skbhash.c
new file mode 100644
index 00000000..b2537acd
--- /dev/null
+++ b/tc/f_skbhash.c
@@ -0,0 +1,140 @@
+/*
+ * f_skbhash.c		SKBHASH filter.
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	J Hadi Salim <jhs@mojatatu.com>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+#include <linux/if.h> /* IFNAMSIZ */
+#include "utils.h"
+#include "tc_util.h"
+
+static void explain(void)
+{
+	fprintf(stderr,
+		"Usage: ... skbhash [ classid CLASSID ] [ indev DEV ] [ action ACTION_SPEC ]\n"
+		"	CLASSID := Push matching packets to the class identified by CLASSID with format X:Y\n"
+		"		CLASSID is parsed as hexadecimal input.\n"
+		"	ACTION_SPEC := Apply an action on matching packets.\n"
+		"	NOTE: handle is represented as HANDLE[/SKBHASHMASK].\n"
+		"		SKBHASHMASK is 0xffffffff by default.\n");
+}
+
+static int skbhash_parse_opt(struct filter_util *qu, char *handle, int argc,
+			     char **argv, struct nlmsghdr *n)
+{
+	struct tcmsg *t = NLMSG_DATA(n);
+	struct rtattr *tail;
+	__u32 mask = 0;
+	int mask_set = 0;
+
+	if (handle) {
+		char *slash;
+
+		if ((slash = strchr(handle, '/')) != NULL)
+			*slash = '\0';
+		if (get_u32(&t->tcm_handle, handle, 0)) {
+			fprintf(stderr, "Illegal \"handle\"\n");
+			return -1;
+		}
+		if (slash) {
+			if (get_u32(&mask, slash+1, 0)) {
+				fprintf(stderr, "Illegal \"handle\" mask\n");
+				return -1;
+			}
+			mask_set = 1;
+		}
+	}
+
+	if (argc == 0)
+		return 0;
+
+	tail = addattr_nest(n, 4096, TCA_OPTIONS);
+
+	if (mask_set)
+		addattr32(n, MAX_MSG, TCA_SKBHASH_MASK, mask);
+
+	while (argc > 0) {
+		if (matches(*argv, "classid") == 0 ||
+		    matches(*argv, "flowid") == 0) {
+			unsigned int handle;
+
+			NEXT_ARG();
+			if (get_tc_classid(&handle, *argv)) {
+				fprintf(stderr, "Illegal \"classid\"\n");
+				return -1;
+			}
+			addattr_l(n, 4096, TCA_SKBHASH_CLASSID, &handle, 4);
+		} else if (matches(*argv, "action") == 0) {
+			NEXT_ARG();
+			if (parse_action(&argc, &argv, TCA_SKBHASH_ACT, n)) {
+				fprintf(stderr, "Illegal skbhash \"action\"\n");
+				return -1;
+			}
+			continue;
+		} else if (strcmp(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+	addattr_nest_end(n, tail);
+	return 0;
+}
+
+static int skbhash_print_opt(struct filter_util *qu, FILE *f,
+			     struct rtattr *opt, __u32 handle)
+{
+	struct rtattr *tb[TCA_SKBHASH_MAX+1];
+
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_SKBHASH_MAX, opt);
+
+	if (handle || tb[TCA_SKBHASH_MASK]) {
+		__u32 mark = 0, mask = 0;
+
+		if (handle)
+			mark = handle;
+		if (tb[TCA_SKBHASH_MASK] &&
+		    (mask = rta_getattr_u32(tb[TCA_SKBHASH_MASK])) != 0xFFFFFFFF)
+			fprintf(f, "handle 0x%x/0x%x ", mark, mask);
+		else
+			fprintf(f, "handle 0x%x ", handle);
+	}
+
+	if (tb[TCA_SKBHASH_CLASSID]) {
+		SPRINT_BUF(b1);
+		fprintf(f, "classid %s ", sprint_tc_classid(rta_getattr_u32(tb[TCA_SKBHASH_CLASSID]), b1));
+	}
+
+	if (tb[TCA_SKBHASH_ACT]) {
+		fprintf(f, "\n");
+		tc_print_action(f, tb[TCA_SKBHASH_ACT], 0);
+	}
+	return 0;
+}
+
+struct filter_util skbhash_filter_util = {
+	.id = "skbhash",
+	.parse_fopt = skbhash_parse_opt,
+	.print_fopt = skbhash_print_opt,
+};
-- 
2.20.1

