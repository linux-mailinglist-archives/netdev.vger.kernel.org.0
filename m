Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D03FA541
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhH1LJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhH1LJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:13 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4A2C061796
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:23 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lc21so19673398ejc.7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+/dH1RUzHQbYPGZADuO/5z2krp3b1Uxq6uqezknPhM=;
        b=K/WvTp4B/oshlUrro67kKihnB8DoHGHZ+fxjgC4aS52lnebWpdMSZJonA8wDW257Tt
         5AjOYYQkNeZYKhuHuhjTKINhTdNvCFWB5Asc3FIO2UsVUEnZX2Ap6u5fwK9l1oZmIjet
         dKF10/vSUBO9RKY4j1msNKgm/QnVvMS9856q0SsmIqSXdC997xp45hDUZ473mh+L6CYz
         64ClVa15BHYpEuXVC4fiUOUrFZPYWiOjYb+dfWzOL8m8mwu7TPxUKFsvKrhKHF2ySdLo
         N2peHAA3zS8hYXSZZb9SPnQ5w3FuYlePly/CHPT6f26JzYYSCqA4tHhIuaN6mqnuEdES
         ikhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+/dH1RUzHQbYPGZADuO/5z2krp3b1Uxq6uqezknPhM=;
        b=rDIEsSWc4OACRDRnT0kQ0Sk4AnfK03jbzIyaCrjnoX0sA/KQ6gNjex9zYyWeOCU7ET
         zqqIU8y0fK3b03MzZ/FPUQ96ytrGtYSoTHQERjvoImCHwIzfUURNKADX3gKSudMWjijO
         VOXeFnYYhL6x0NBDWf4/d/GV3Es7snYtRIRJnge7blg56e+P7MFY/8UDnFk7dgEZyJ9v
         WIpsegKArykXtDyX5RFUkgHo+Pv0pc0bcll/b0lNq+s0Me+KpXJhmxwNy+eI7vflK67H
         bX2P4WsJJn+ysJUWpX86gjxnoyzVWyHZlUxTSmsQ3TSL+QfjJ14m2B+JPZCuiF8keTkX
         loVQ==
X-Gm-Message-State: AOAM532TJXki78wJ5Wi5rG2wvPT43Fu9qFyHJZOehayBCRkfWlNiOFWE
        aY6tugHizUa+XRu9JE5Na5BTATQrDfhol+uK
X-Google-Smtp-Source: ABdhPJyr1XOCm7YnJZ9i7ioN7RCDyFSpWub4MT+cwtWqPaj7ZFC/b2axRWs+sYhyg9cGpYm/vrLgog==
X-Received: by 2002:a17:907:266f:: with SMTP id ci15mr14710554ejc.509.1630148901224;
        Sat, 28 Aug 2021 04:08:21 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 06/19] bridge: vlan: add support to set global vlan options
Date:   Sat, 28 Aug 2021 14:07:52 +0300
Message-Id: <20210828110805.463429-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
v2: use strcmp instead of matches

 bridge/vlan.c     | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/bridge.8 | 20 ++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 77db90d8a617..c9b445bc65aa 100644
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
+			if (strcmp(*argv, "help") == 0)
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
 		    strcmp(*argv, "lst") == 0 ||
 		    strcmp(*argv, "list") == 0)
 			return vlan_global_show(argc-1, argv+1);
+		else if (strcmp(*argv, "set") == 0)
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

