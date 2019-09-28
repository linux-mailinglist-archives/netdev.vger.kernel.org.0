Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA38C121C
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfI1UWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:22:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45462 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfI1UWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:22:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id q7so5180776pgi.12
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nQ9+uF3leeBucJEv5nFCPTNpM/MxL0PqNPxMCdQycRg=;
        b=HeQgV8qcIhAF4T6kvX2cOwbvzAv/2q3H+D7Pp5eO3h/2yRt8fLgUMEKSZ6gu8RjZlt
         gDKCQBZh9Kttcfvwzr9GaldBSFsOVos1RZsWd3GaQn1RpnyeMxdcCPsUTcLkqgqF6ThY
         hmyJUaGBoHyasbngPdDxAVaMlbj4bt+71mDv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nQ9+uF3leeBucJEv5nFCPTNpM/MxL0PqNPxMCdQycRg=;
        b=itDB56E1NPprY12SskhM2p5nIrv4nm/GvtivV2TLJlO/ean/JXfwtHUtKyzhZ+U9k2
         SrRxXrC32+78b8I+ftJDxPOJs8m2wUMlBU+x0fcakW4Y9oZKC/wjurxt2IJfGfM6lqPC
         +uMJZz3YYoyRlTc6yoVD+AbFwZqkb2EdIee3WVq8qMRP19pAxndJRu7il1UFVK2Grx6C
         I157Uwrk9EJl+Xy7ll8EsSqyx3HPZaRgYSLRZPcqxf9Vr/XnRd1QSHMr4WUzioHdsG5Y
         DAffaK22DIdwiMIGdCMf9l9Z2HxzngNVE5hhRdJJiYhjYsGV+U9tZrwNtVfzyfqdmO1h
         Jp9A==
X-Gm-Message-State: APjAAAWfYqgFk+DhzvMQQa2i0QF4fHWjlApderSrWTKJyVsgJVqzn9OS
        YcQaXKbONSHQ4y31F5HjSAvmpg==
X-Google-Smtp-Source: APXvYqwGLbDyOGXeBF/OD/5eWkICuu4UL1d6HRYz5C14mYoOxUdVYs6MDCDnTc9F9Dzdl9a+5OOggA==
X-Received: by 2002:a62:5248:: with SMTP id g69mr12512101pfb.218.1569702136115;
        Sat, 28 Sep 2019 13:22:16 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id f3sm8325160pgj.62.2019.09.28.13.22.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 28 Sep 2019 13:22:15 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2 net-next v2 1/2] bridge: fdb get support
Date:   Sat, 28 Sep 2019 13:22:09 -0700
Message-Id: <1569702130-46433-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds support to lookup a bridge fdb entry
using recently added support in the kernel using RTM_GETNEIGH
(and AF_BRIDGE family).

example:
$bridge fdb get 02:02:00:00:00:03 dev test-dummy0 vlan 1002
02:02:00:00:00:03 dev test-dummy0 vlan 1002 master bridge

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 bridge/fdb.c      | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/bridge.8 |  40 +++++++++++++++++++
 2 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 941ce2d..804fa36 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -40,7 +40,9 @@ static void usage(void)
 		"              [ sticky ] [ local | static | dynamic ] [ dst IPADDR ]\n"
 		"              [ vlan VID ] [ port PORT] [ vni VNI ] [ via DEV ]\n"
 		"              [ src_vni VNI ]\n"
-		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ] [ state STATE ] ]\n");
+		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ] [ state STATE ] ]\n"
+		"       bridge fdb get ADDR [ br BRDEV ] { brport |dev }  DEV [ vlan VID ]\n"
+		"              [ vni VNI ]\n");
 	exit(-1);
 }
 
@@ -518,6 +520,113 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
 	return 0;
 }
 
+static int fdb_get(int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct ndmsg		ndm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ndmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_GETNEIGH,
+		.ndm.ndm_family = AF_BRIDGE,
+	};
+	struct nlmsghdr *answer;
+	char *addr = NULL;
+	char  *d = NULL, *br = NULL;
+	char abuf[ETH_ALEN];
+	unsigned long vni = ~0;
+	int br_ifindex = 0;
+	char *endptr;
+	short vlan = -1;
+
+	while (argc > 0) {
+		if ((strcmp(*argv, "brport") == 0) || strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+		} else if (strcmp(*argv, "br") == 0) {
+			NEXT_ARG();
+			br = *argv;
+		} else if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+		} else if (strcmp(*argv, "vni") == 0) {
+			NEXT_ARG();
+			vni = strtoul(*argv, &endptr, 0);
+			if ((endptr && *endptr) ||
+			    (vni >> 24) || vni == ULONG_MAX)
+				invarg("invalid VNI\n", *argv);
+		} else if (strcmp(*argv, "self") == 0) {
+			req.ndm.ndm_flags |= NTF_SELF;
+		} else if (matches(*argv, "master") == 0) {
+			req.ndm.ndm_flags |= NTF_MASTER;
+		} else if (matches(*argv, "vlan") == 0) {
+			if (vlan >= 0)
+				duparg2("vlan", *argv);
+			NEXT_ARG();
+			vlan = atoi(*argv);
+		} else {
+			if (strcmp(*argv, "to") == 0)
+				NEXT_ARG();
+
+			if (matches(*argv, "help") == 0)
+				usage();
+			if (addr)
+				duparg2("to", *argv);
+			addr = *argv;
+		}
+		argc--; argv++;
+	}
+
+	if ((d == NULL && br == NULL) || addr == NULL) {
+		fprintf(stderr, "Device or master and address are required arguments.\n");
+		return -1;
+	}
+
+	if (sscanf(addr, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
+		   abuf, abuf+1, abuf+2,
+		   abuf+3, abuf+4, abuf+5) != 6) {
+		fprintf(stderr, "Invalid mac address %s\n", addr);
+		return -1;
+	}
+
+	addattr_l(&req.n, sizeof(req), NDA_LLADDR, abuf, ETH_ALEN);
+
+	if (vlan >= 0)
+		addattr16(&req.n, sizeof(req), NDA_VLAN, vlan);
+
+	if (vni != ~0)
+		addattr32(&req.n, sizeof(req), NDA_VNI, vni);
+
+	if (d) {
+		req.ndm.ndm_ifindex = ll_name_to_index(d);
+		if (!req.ndm.ndm_ifindex) {
+			fprintf(stderr, "Cannot find device \"%s\"\n", d);
+			return -1;
+		}
+	}
+
+	if (br) {
+		br_ifindex = ll_name_to_index(br);
+		if (!br_ifindex) {
+			fprintf(stderr, "Cannot find bridge device \"%s\"\n", br);
+			return -1;
+		}
+		addattr32(&req.n, sizeof(req), NDA_MASTER, br_ifindex);
+	}
+
+	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+		return -2;
+
+	if (print_fdb(answer, stdout) < 0) {
+		fprintf(stderr, "An error :-)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 int do_fdb(int argc, char **argv)
 {
 	ll_init_map(&rth);
@@ -531,6 +640,8 @@ int do_fdb(int argc, char **argv)
 			return fdb_modify(RTM_NEWNEIGH, NLM_F_CREATE|NLM_F_REPLACE, argc-1, argv+1);
 		if (matches(*argv, "delete") == 0)
 			return fdb_modify(RTM_DELNEIGH, 0, argc-1, argv+1);
+		if (matches(*argv, "get") == 0)
+			return fdb_get(argc-1, argv+1);
 		if (matches(*argv, "show") == 0 ||
 		    matches(*argv, "lst") == 0 ||
 		    matches(*argv, "list") == 0)
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index bb4fb52..10f6cf0 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -93,6 +93,17 @@ bridge \- show / manipulate bridge addresses and devices
 .IR STATE " ]"
 
 .ti -8
+.B bridge fdb get
+.I LLADDR " [ "
+.B dev
+.IR DEV " ] [ "
+.B br
+.IR BRDEV " ] [ "
+.B vlan
+.IR VID  " ] ["
+.BR self " ] [ " master " ]"
+
+.ti -8
 .BR "bridge mdb" " { " add " | " del " } "
 .B dev
 .IR DEV
@@ -550,6 +561,35 @@ With the
 option, the command becomes verbose. It prints out the last updated
 and last used time for each entry.
 
+.SS bridge fdb get - get bridge forwarding entry.
+
+lookup a bridge forwarding table entry.
+
+.TP
+.BI "LLADDR"
+the Ethernet MAC address.
+
+.TP
+.BI dev " DEV"
+the interface to which this address is associated.
+
+.TP
+.BI brport " DEV"
+the bridge port to which this address is associated. same as dev above.
+
+.TP
+.BI br " DEV"
+the bridge to which this address is associated.
+
+.TP
+.B self
+- the address is associated with the port drivers fdb. Usually hardware.
+
+.TP
+.B master
+- the address is associated with master devices fdb. Usually software (default).
+.sp
+
 .SH bridge mdb - multicast group database management
 
 .B mdb
-- 
2.1.4

