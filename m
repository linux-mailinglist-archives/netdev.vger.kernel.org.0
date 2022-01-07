Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170FF4878CF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347769AbiAGOUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiAGOUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:20:33 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9A2C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 06:20:33 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id i31so15969043lfv.10
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 06:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rkq8agh4tjk67sRDRuaodjlD6tuUMbjIOtNg8F/N2S4=;
        b=It1rSC75DwetGxqV7YrHd9jSbdquwu4U6N2S+g2AUHOOl31/6vLWKGCo7ws6WHaHtM
         MslgjaOOUiLta+kcjNdrJ+R68yzNTfj5sJZq1z7Yyt8JODnBFpGEL252aI8x6H8z6al1
         HbHYf4mCbgyq6CSLlk743ryf1n6iX9CiQiRlqeEjoVKZmTLT21mSDSe0edv/9BAph4Fv
         R63Hmea58szlIcxywK2L99vgXzk3XGgNPN0SDEkWIs3GwXRx75RTP9zsdFtJSN7ylvAR
         aCMIAh9udNEfCBEA2oZt4HtUBWs1QgLjcR3L318jh9LdZmrQiWcbdgfDMPym8HZBELUe
         8sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rkq8agh4tjk67sRDRuaodjlD6tuUMbjIOtNg8F/N2S4=;
        b=yc7qd8Lqkfu99aSYcHOF07pdQBZD9KLyVHQ9PI9K63TxgQFNGcLeLMGU8TJw1S0g2o
         Ib8pyAkkBhekNj+8wtX+IT07WySB/U9JRSdTd/dEvUj3r7r33EkSfcGKTQ9KWaz+xG7k
         MnPgf2mnX8RELo6vV+6kIOCIUxHgVT2/X+JaUWLjNyWHfimpmfuqu1xtDughdn2IoG5B
         0FOnJrotzM5Yk1iHSfJkvDoilwZ0MUWTNGHHZ/rzCeMrbnXt461IMMezTkDqhuGQ2QtS
         mGVZr6+XbmgObUNMoZDkyXCxJts2kQeT3A0kgjHf+XIXh8/dytoizwoF6PrlK68M1VYG
         HODg==
X-Gm-Message-State: AOAM530gGeaCYkd0JFqfe/BVMeMrKbDM6Ml95Qz7FQDJH0z8sj2Q7P4J
        vzmZGAvy/WaBC+ezYkYV5qJx3Z90sl4=
X-Google-Smtp-Source: ABdhPJypfKWS9v3k8eazYtDHRxp77Rm+Gtm/+qE/0GzfwEYvt5C8ok27AYzqpffdDLn4GjYxw1YxKA==
X-Received: by 2002:a05:6512:2825:: with SMTP id cf37mr55570583lfb.145.1641565231794;
        Fri, 07 Jan 2022 06:20:31 -0800 (PST)
Received: from dau-work-pc.corp.zonatelecom.ru ([185.17.67.197])
        by smtp.googlemail.com with ESMTPSA id v22sm628008ljh.129.2022.01.07.06.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 06:20:31 -0800 (PST)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     stephen@networkplumber.org
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH iproute2] ip: Extend filter links/addresses
Date:   Fri,  7 Jan 2022 17:17:38 +0300
Message-Id: <20220107141736.11147-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves the filtering of links/addresses with the next features:
1. Additional types: ether, loopback, ppp
2. Exclude of specific interface types with 'exclude_type' option

Examples:
ip link show type ether
ip address show exclude_type ppp

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 ip/ip_common.h           |  1 +
 ip/ipaddress.c           | 39 ++++++++++++++++++++++++++++++++++++---
 ip/iplink.c              |  2 +-
 man/man8/ip-address.8.in | 16 +++++++++++++++-
 man/man8/ip-link.8.in    | 13 ++++++++++---
 5 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ea04c8ff..38377be4 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -26,6 +26,7 @@ struct link_filter {
 	int master;
 	char *kind;
 	char *slave_kind;
+	char *exclude_kind;
 	int target_nsid;
 };
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 4109d8bd..4db27c92 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -60,7 +60,7 @@ static void usage(void)
 		"       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]\n"
 		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
 		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
-		"                         [ nomaster ]\n"
+		"                         [ nomaster ] [ exclude_type TYPE ]\n"
 		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
 		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
 		"       ip address {showdump|restore}\n"
@@ -1023,7 +1023,28 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	} else if (filter.master > 0)
 		return -1;
 
-	if (filter.kind && match_link_kind(tb, filter.kind, 0))
+	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
+	    !strcmp(filter.exclude_kind, "ether") && ifi->ifi_type == ARPHRD_ETHER)
+		return -1;
+	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
+	    !strcmp(filter.exclude_kind, "loopback") && ifi->ifi_type == ARPHRD_LOOPBACK)
+		return -1;
+	if (filter.exclude_kind && match_link_kind(tb, filter.exclude_kind, 0) == -1 &&
+	    !strcmp(filter.exclude_kind, "ppp") && ifi->ifi_type == ARPHRD_PPP)
+		return -1;
+	if (filter.exclude_kind && !match_link_kind(tb, filter.exclude_kind, 0))
+		return -1;
+
+	if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
+	    !strcmp(filter.kind, "ether") && ifi->ifi_type == ARPHRD_ETHER)
+		;
+	else if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
+		 !strcmp(filter.kind, "loopback") && ifi->ifi_type == ARPHRD_LOOPBACK)
+		;
+	else if (filter.kind && match_link_kind(tb, filter.kind, 0) == -1 &&
+		 !strcmp(filter.kind, "ppp") && ifi->ifi_type == ARPHRD_PPP)
+		;
+	else if (filter.kind && match_link_kind(tb, filter.kind, 0))
 		return -1;
 
 	if (filter.slave_kind && match_link_kind(tb, filter.slave_kind, 1))
@@ -1971,7 +1992,9 @@ static int iplink_filter_req(struct nlmsghdr *nlh, int reqlen)
 			return err;
 	}
 
-	if (filter.kind) {
+	if (filter.kind && !strcmp(filter.kind, "ether") &&
+	    !strcmp(filter.kind, "loopback") && !strcmp(filter.kind, "ppp")) {
+
 		struct rtattr *linkinfo;
 
 		linkinfo = addattr_nest(nlh, reqlen, IFLA_LINKINFO);
@@ -2137,6 +2160,16 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			} else {
 				filter.kind = *argv;
 			}
+		} else if (strcmp(*argv, "exclude_type") == 0) {
+			int soff;
+
+			NEXT_ARG();
+			soff = strlen(*argv) - strlen("_slave");
+			if (!strcmp(*argv + soff, "_slave")) {
+				invarg("Not a valid type for exclude\n", *argv);
+			} else {
+				filter.exclude_kind = *argv;
+			}
 		} else {
 			if (strcmp(*argv, "dev") == 0)
 				NEXT_ARG();
diff --git a/ip/iplink.c b/ip/iplink.c
index a3ea775d..e0d49cab 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -120,7 +120,7 @@ void iplink_usage(void)
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
-		"		[nomaster]\n"
+		"		[exclude_type TYPE] [nomaster]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 65f67e06..21de3d77 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -45,6 +45,8 @@ ip-address \- protocol address management
 .IR PATTERN " ] [ "
 .B  master
 .IR DEVICE " ] [ "
+.B  exclude_type
+.IR TYPE " ] [ "
 .B  type
 .IR TYPE " ] [ "
 .B vrf
@@ -138,7 +140,10 @@ ip-address \- protocol address management
 .BR ipvlan " |"
 .BR lowpan " |"
 .BR geneve " |"
-.BR macsec " ]"
+.BR macsec " |"
+.BR ether " |"
+.BR loopback " |"
+.BR ppp " ]"
 
 .SH "DESCRIPTION"
 The
@@ -337,6 +342,10 @@ interface list by comparing it with the relevant attribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to empty
 output.
 
+.TP
+.BI exclude_type " TYPE"
+don't list linterfaces of the given type.
+
 .TP
 .B up
 only list running interfaces.
@@ -441,6 +450,11 @@ Same as above except that only addresses assigned to active network interfaces
 are shown.
 .RE
 .PP
+ip address show type ether
+.RS 4
+Shows IPv4 and IPv6 addresses assigned to all physical ethernetl interfaces
+.RE
+.PP
 ip address show dev eth0
 .RS 4
 Shows IPv4 and IPv6 addresses assigned to network interface eth0.
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 1d67c9a4..dc8a1abf 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -176,10 +176,12 @@ ip-link \- network device configuration
 .BR up " ] ["
 .B master
 .IR DEVICE " ] ["
-.B type
-.IR ETYPE " ] ["
 .B vrf
 .IR NAME " ] ["
+.B type
+.IR ETYPE " ] ["
+.B exclude_type
+.IR ETYPE " ] ["
 .BR nomaster " ]"
 
 .ti -8
@@ -237,7 +239,7 @@ ip-link \- network device configuration
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
-.BR bridge_slave " | " bond_slave " ]"
+.BR ether " | " loopback " | " ppp " | " bridge_slave " | " bond_slave " ]"
 
 .ti -8
 .IR VFVLAN-LIST " := [ "  VFVLAN-LIST " ] " VFVLAN
@@ -2630,6 +2632,11 @@ ip link show type vlan
 Shows the vlan devices.
 .RE
 .PP
+ip link show exclude_type ppp
+.RS 4
+List the network interfaces except PPP devices.
+.RE
+.PP
 ip link show master br0
 .RS 4
 Shows devices enslaved by br0
-- 
2.20.1

