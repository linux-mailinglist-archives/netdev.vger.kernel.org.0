Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D303F8858
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbhHZNKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242049AbhHZNKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BD1C0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n11so4550935edv.11
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=euHTYu09/8UGxE1wYpepPEYohtnAyMYFjilIHBnoIeI=;
        b=Vm9hheItPRcqo3B9eye2cn9qpweQq3uAuES5ZyXcPaDcXo3r7pVEsbexfbzbsOvEk2
         oEP6UZ1vL+Q7+v8KA8dp0QWH+JUeCbuRKZOW8Ozu9aW/sPtdWFNefllfTMKMF7D3yEsG
         J/SOkozZeN2rbSiCvV3dvrPvvTeKpJcP8AOv6sniFiNBOcKwiBKwY2AGlTL1k340ADl0
         msdN7ni/GNDBeM7VJqqDjsAX+2FhBbEZtifHo3R6wsH3svM7a8RcGlgoAlutAt+oxGrR
         GUOWHMfmYFozokfc3BQW16RsiDs9IFRgfgyKdGLxA8VilolHD7iiFKuOWE9G2dk9CsVY
         dOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=euHTYu09/8UGxE1wYpepPEYohtnAyMYFjilIHBnoIeI=;
        b=ZpxYM3CWsoYBDc5+Qftrw2l1hSsM6jGKAVQ5OL9avHQqBxhYHV6iQqzAwLWqt+OvU5
         W5IxphpMilME6I/MH+6B4dR5uZW/GLe3TnO3RFHLCnyUJWbfH3bc+v+baqiqKRqIcM87
         3hkuNN+YYDOIwLjMfpDtK+qJ9W9wC4eZyX639LA0XfFzNqq79qjWEaXNZbXbyBnNV5bx
         /AW5RRs1en4amb2XC+1EtQpdm9TWl1k0j7+DT4umPt6r2LP3OOB99yDfzBDzNycIs0A9
         7CgFbB/L+ZMTT9nfgENgQh5yd16px1UaYDFZTTKmNBRNt444dxyneKU2mt3LzZtIPR7b
         8JYA==
X-Gm-Message-State: AOAM530hN7UVs1+QRrQgWcQsQWuWbGByN1vMpjT4OX6ziMngPg0DUGvF
        9yMP+ltcg4wcG7ghytEr9h8d7Xbc/iNhKxRM
X-Google-Smtp-Source: ABdhPJxVb4FfGDhcZH6uH4nV1jroG6lv90JqLsXX9rV5drhV4lmvLl0HXFsSfFQ/37Dv4N0yzqrIEw==
X-Received: by 2002:a05:6402:1d04:: with SMTP id dg4mr3989942edb.157.1629983359616;
        Thu, 26 Aug 2021 06:09:19 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 04/17] bridge: vlan: add support to set global vlan options
Date:   Thu, 26 Aug 2021 16:05:20 +0300
Message-Id: <20210826130533.149111-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change global vlan options via a new vlan global
set subcommand similar to the current vlan set subcommand. The man page
and help are updated accordingly. The command works only with bridge
devices. It doesn't support any options yet.

Syntax: $ bridge vlan global set vid VID dev DEV

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/bridge.8 | 20 ++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 69a1d3c295b6..34fba0a5bdfb 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -37,6 +37,7 @@ static void usage(void)
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
+		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -338,6 +339,83 @@ static int vlan_option_set(int argc, char **argv)
 	return 0;
 }
 
+static int vlan_global_option_set(int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct br_vlan_msg	bvm;
+		char			buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct br_vlan_msg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_NEWVLAN,
+		.bvm.family = PF_BRIDGE,
+	};
+	struct rtattr *afspec;
+	short vid_end = -1;
+	char *d = NULL;
+	short vid = -1;
+
+	afspec = addattr_nest(&req.n, sizeof(req),
+			      BRIDGE_VLANDB_GLOBAL_OPTIONS);
+	afspec->rta_type |= NLA_F_NESTED;
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+			req.bvm.ifindex = ll_name_to_index(d);
+			if (req.bvm.ifindex == 0) {
+				fprintf(stderr, "Cannot find network device \"%s\"\n",
+					d);
+				return -1;
+			}
+		} else if (strcmp(*argv, "vid") == 0) {
+			char *p;
+
+			NEXT_ARG();
+			p = strchr(*argv, '-');
+			if (p) {
+				*p = '\0';
+				p++;
+				vid = atoi(*argv);
+				vid_end = atoi(p);
+				if (vid >= vid_end || vid_end >= 4096) {
+					fprintf(stderr, "Invalid VLAN range \"%hu-%hu\"\n",
+						vid, vid_end);
+					return -1;
+				}
+			} else {
+				vid = atoi(*argv);
+			}
+			if (vid >= 4096) {
+				fprintf(stderr, "Invalid VLAN ID \"%hu\"\n",
+					vid);
+				return -1;
+			}
+			addattr16(&req.n, sizeof(req), BRIDGE_VLANDB_GOPTS_ID,
+				  vid);
+			if (vid_end != -1)
+				addattr16(&req.n, sizeof(req),
+					  BRIDGE_VLANDB_GOPTS_RANGE, vid_end);
+		} else {
+			if (matches(*argv, "help") == 0)
+				NEXT_ARG();
+		}
+		argc--; argv++;
+	}
+	addattr_nest_end(&req.n, afspec);
+
+	if (d == NULL || vid == -1) {
+		fprintf(stderr, "Device and VLAN ID are required arguments.\n");
+		return -1;
+	}
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
 /* In order to use this function for both filtering and non-filtering cases
  * we need to make it a tristate:
  * return -1 - if filtering we've gone over so don't continue
@@ -1016,6 +1094,8 @@ static int vlan_global(int argc, char **argv)
 		    matches(*argv, "lst") == 0 ||
 		    matches(*argv, "list") == 0)
 			return vlan_global_show(argc-1, argv+1);
+		else if (matches(*argv, "set") == 0)
+			return vlan_global_option_set(argc-1, argv+1);
 		else
 			usage();
 	} else {
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9ec4cb1dec67..796d20b662ab 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -152,6 +152,13 @@ bridge \- show / manipulate bridge addresses and devices
 .B dev
 .IR DEV " ]"
 
+.ti -8
+.BR "bridge vlan global set"
+.B dev
+.I DEV
+.B vid
+.IR VID " [ ]"
+
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
 .B dev
@@ -902,6 +909,19 @@ option, the command displays per-vlan traffic statistics.
 
 This command displays the current vlan tunnel info mapping.
 
+.SS bridge vlan global set - change vlan filter entry's global options
+
+This command changes vlan filter entry's global options.
+
+.TP
+.BI dev " NAME"
+the interface with which this vlan is associated. Only bridge devices are
+supported for global options.
+
+.TP
+.BI vid " VID"
+the VLAN ID that identifies the vlan.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

