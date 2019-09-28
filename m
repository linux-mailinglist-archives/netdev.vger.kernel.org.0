Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336FCC0FD0
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 06:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfI1Esf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 00:48:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36313 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfI1Esf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 00:48:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id t14so4497276pgs.3
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 21:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pROfrfwb9bogNGkj4qrHxld6sukPc2LINKJEq9teVRY=;
        b=b2nge7Af6MIzZGhU5S0639UPT2CrxsWhD2cOS/SJhTWHxNjVNOWeGotbsMZcMBda9R
         f1xSN40qUbJMDaHdD94xIqcnEqnoQXlvRcHe/rHYPdskRTFKfX2bBFHJ1Dy/L31jNix9
         yLdLgbrbOZqgocQv7gUnTelhlfgbo7WEC+KdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pROfrfwb9bogNGkj4qrHxld6sukPc2LINKJEq9teVRY=;
        b=eDyKRiBfsTJpb+1312BL0fXyDn0xJsBNwwBFfrJnuKYDZYNK+s5bsAyR1pE+Lw22mb
         kvdFUX2Ii1uJR89u9QqkxgAs6bhukrSDCV7cnNE18XGNMhRHwhNxmCSZcbwtKWtVARkz
         NXrqlWFGnK9bUzXEWwJ/5v40sNUTUA7A3YYIp/SLo3bD+LtnO0s3EaMpa7fPbkfuXVco
         u2OMuwq9hJZW6g3r/9StAj5xrX16aoFHFYKvzYkxYf+7WQTjS553/m1HphUnD2EtVT2q
         qJh8BJIn4+BKWQPXbKhry/ZBkZ5iCMD6DIERYt02mvntUna9peIfaERh/SVMaK0acOsu
         10iw==
X-Gm-Message-State: APjAAAVl2X0yWrTBb0Nxm4/fkIvwS2jrOHOBpKI+f2+PAtG5ybF4UmFe
        D9bkVkPPv6wSl/0wXKKotZ/JVQ==
X-Google-Smtp-Source: APXvYqxPFRCxYtk6YFPr1XeYTMUaLHBdVrcgVhnIXqDfKstbfgncOdoqKOPyiUJx51ZDUrThT2QzBg==
X-Received: by 2002:a17:90b:8d1:: with SMTP id ds17mr13958485pjb.105.1569646114229;
        Fri, 27 Sep 2019 21:48:34 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id r185sm4335979pfr.68.2019.09.27.21.48.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 27 Sep 2019 21:48:33 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2 net-next 2/2] ipneigh: neigh get support
Date:   Fri, 27 Sep 2019 21:48:24 -0700
Message-Id: <1569646104-358-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1569646104-358-1-git-send-email-roopa@cumulusnetworks.com>
References: <1569646104-358-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds support to lookup a neigh entry
using recently added support in the kernel using RTM_GETNEIGH

example:
$ip neigh get 10.0.2.4 dev test-dummy0
10.0.2.4 dev test-dummy0 lladdr de:ad:be:ef:13:37 PERMANENT

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 ip/ipneigh.c            | 84 ++++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/ip-neighbour.8 | 29 +++++++++++++++++
 2 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index a3869c8..c88c346 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -55,6 +55,7 @@ static void usage(void)
 		"\n"
 		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
 		"				  [ vrf NAME ]\n"
+		"	ip neigh get { ADDR | proxy ADDR } dev DEV\n"
 		"\n"
 		"STATE := { permanent | noarp | stale | reachable | none |\n"
 		"           incomplete | delay | probe | failed }\n");
@@ -599,6 +600,83 @@ static int do_show_or_flush(int argc, char **argv, int flush)
 	return 0;
 }
 
+static int ipneigh_get(int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct ndmsg		ndm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ndmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_GETNEIGH,
+		.ndm.ndm_family = preferred_family,
+	};
+	struct nlmsghdr *answer;
+	char  *d = NULL;
+	int dst_ok = 0;
+	int dev_ok = 0;
+	inet_prefix dst;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+			dev_ok = 1;
+		} else if (matches(*argv, "proxy") == 0) {
+			NEXT_ARG();
+			if (matches(*argv, "help") == 0)
+				usage();
+			if (dst_ok)
+				duparg("address", *argv);
+			get_addr(&dst, *argv, preferred_family);
+			dst_ok = 1;
+			dev_ok = 1;
+			req.ndm.ndm_flags |= NTF_PROXY;
+		} else {
+			if (strcmp(*argv, "to") == 0)
+				NEXT_ARG();
+
+			if (matches(*argv, "help") == 0)
+				usage();
+			if (dst_ok)
+				duparg2("to", *argv);
+			get_addr(&dst, *argv, preferred_family);
+			dst_ok = 1;
+		}
+		argc--; argv++;
+	}
+
+	if (!dev_ok || !dst_ok || dst.family == AF_UNSPEC) {
+		fprintf(stderr, "Device and address are required arguments.\n");
+		return -1;
+	}
+
+	req.ndm.ndm_family = dst.family;
+	if (addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen) < 0)
+		return -1;
+
+	if (d) {
+		ll_init_map(&rth);
+		req.ndm.ndm_ifindex = ll_name_to_index(d);
+		if (!req.ndm.ndm_ifindex) {
+			fprintf(stderr, "Cannot find device \"%s\"\n", d);
+			return -1;
+		}
+	}
+
+	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+		return -2;
+
+	ipneigh_reset_filter(0);
+	if (print_neigh(answer, (void *)stdout) < 0) {
+		fprintf(stderr, "An error :-)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 int do_ipneigh(int argc, char **argv)
 {
 	if (argc > 0) {
@@ -611,10 +689,8 @@ int do_ipneigh(int argc, char **argv)
 			return ipneigh_modify(RTM_NEWNEIGH, NLM_F_CREATE|NLM_F_REPLACE, argc-1, argv+1);
 		if (matches(*argv, "delete") == 0)
 			return ipneigh_modify(RTM_DELNEIGH, 0, argc-1, argv+1);
-		if (matches(*argv, "get") == 0) {
-			fprintf(stderr, "Sorry, \"neigh get\" is not implemented :-(\n");
-			return -1;
-		}
+		if (matches(*argv, "get") == 0)
+			return ipneigh_get(argc-1, argv+1);
 		if (matches(*argv, "show") == 0 ||
 		    matches(*argv, "lst") == 0 ||
 		    matches(*argv, "list") == 0)
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index 4a672bb..bc77b43 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -38,6 +38,12 @@ ip-neighbour \- neighbour/arp tables management.
 .IR NAME " ] "
 
 .ti -8
+.B ip neigh get
+.IR ADDR
+.B  dev
+.IR DEV
+
+.ti -8
 .IR STATE " := {"
 .BR permanent " | " noarp " | " stale " | " reachable " | " none " |"
 .BR incomplete " | " delay " | " probe " | " failed " }"
@@ -231,6 +237,23 @@ twice,
 also dumps all the deleted neighbours.
 .RE
 
+.TP
+ip neigh get
+lookup a neighbour entry to a destination given a device
+.RS
+
+.TP
+.BI proxy
+indicates whether we should lookup a proxy neigbour entry
+
+.TP
+.BI to " ADDRESS " (default)
+the prefix selecting the neighbour to query.
+
+.TP
+.BI dev " NAME"
+get neighbour entry attached to this device.
+
 .SH EXAMPLES
 .PP
 ip neighbour
@@ -242,6 +265,12 @@ ip neigh flush dev eth0
 .RS
 Removes entries in the neighbour table on device eth0.
 .RE
+.PP
+ip neigh get 10.0.1.10 dev eth0
+.RS
+Performs a neighbour lookup in the kernel and returns
+a neighbour entry.
+.RE
 
 .SH SEE ALSO
 .br
-- 
2.1.4

