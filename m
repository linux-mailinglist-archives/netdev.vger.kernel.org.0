Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03A9C2CB7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 06:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfJAEwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 00:52:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37572 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJAEwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 00:52:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id u20so4858839plq.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 21:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pX7q7JAPibdetk6P+aRYj1xtfmDc4hHG/mojBUaXwv8=;
        b=PS1rzmQQ0DaGokUyzhRU+eJvzzmKy5Ruz6t3Nbj5oMBIw3C4QB7/8nLi1vAAuPnstG
         wgwZstrf3HMzrRMkJ5oBq9vzeeo9fZH5gmqHNMeElBUjMbRjv07MdFJwIuv9auyVIPtp
         JU9z88MdZmw6NM9GveygJrJ/DmHa2y6O6WWRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pX7q7JAPibdetk6P+aRYj1xtfmDc4hHG/mojBUaXwv8=;
        b=fqf2bnnYoAH5QGw52+95ckpaX6JLjnLDx3sz3OzZdXVrllNzn96Na7htVnvP84/vG5
         LC/hrHNeS+sODO2bu827iLwx3/RyRmvMQBfa4Hmu1qH8kuAoiP082UdWqhaa0A15fBG5
         //mYS1cC2S7yeJ86zmelTgX+Q622n8benEk9sgnW3Vm4+IQLd8i/DkMRpgfRXyv4NPdH
         6oqbXApyLofBC4PzUFtqeowfhnGVElxKG+Qh39hQJmbhHdQzs6RLQUoBwJbhEUIYReQQ
         ctHenJwO5RbF5jBIKr+wJRQh5/yRhzB4UBxhYtHHQx33V6iuQ49ahbMbUfoIV6CIzlgF
         RycA==
X-Gm-Message-State: APjAAAXYGWcK7cytWm1gNtMI6LIlVjAcTAtYbSOye9ljgoc6iSP7q1F0
        twPNjwQs1temBnDvJY6yPyeHZExla+Y=
X-Google-Smtp-Source: APXvYqxwA5QAOKYxi8Pbter/EHWQL6Y3hXb07kLq2SFyPzmocAY2Sw92aluINvXpY8NEf96EyXHsOA==
X-Received: by 2002:a17:902:7b82:: with SMTP id w2mr6698491pll.118.1569905550240;
        Mon, 30 Sep 2019 21:52:30 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id h66sm1896638pjb.0.2019.09.30.21.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Sep 2019 21:52:29 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, ivecera@redhat.com,
        nikolay@cumulusnetworks.com, stephen@networkplumber.org
Subject: [PATCH iproute2 net-next v3 2/2] ipneigh: neigh get support
Date:   Mon, 30 Sep 2019 21:52:23 -0700
Message-Id: <1569905543-33478-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
References: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
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
Tested-by: Ivan Vecera <ivecera@redhat.com>
---
 ip/ipneigh.c            | 83 ++++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/ip-neighbour.8 | 29 +++++++++++++++++
 2 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index a3869c8..678b403 100644
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
@@ -599,6 +600,82 @@ static int do_show_or_flush(int argc, char **argv, int flush)
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
+	if (print_neigh(answer, stdout) < 0) {
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
@@ -611,10 +688,8 @@ int do_ipneigh(int argc, char **argv)
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

