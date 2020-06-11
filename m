Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55231F5F3C
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFKAf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgFKAf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 20:35:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B07C08C5C1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i12so1522078pju.3
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EnCex6fEgRmrBg+t/B8Cf63HP+6qoRjPO2Akbn/Tppc=;
        b=SiABY7jq+7hrTAJn0iSxFmIfgIsUDmXsKXCiq4Wf5Lwa/o/2MD0Ttc3Py3SaJdI96t
         544/ODsnD837FzREjmqNaWXsG9DdUUKoML8il7+HygdGgQBfXagn+0ntvH08T1BaBMDw
         ItS+FEhDz+ii9RtCCAaDcX/pBl3ORbedtC5d4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EnCex6fEgRmrBg+t/B8Cf63HP+6qoRjPO2Akbn/Tppc=;
        b=GzVQPzdzo+MKJn6OMVUn+5Otp7HEaAZVJA5N55SwNWCaDlpKFxn5GoLwm9b+qwMuC1
         pl0Qf/hzpWMzMAT8obUIPvbm5RtLCePtegiW6+v3b18BxNy+WGJMcUtRkbA54pt501qS
         o42qw1l+Uy03YjrKOWZqKv8YZYsK2+5wNz961MJodaXquNyIAc6o9AllYxCzHhO3Doys
         bP5FPesZkQsyZKdkJ9UGeTx1XfHUyZc/eDR8xZPuqWA+20AraKk2SmHcBQECMOaMQ2cc
         7RcGV+dRq/PRwEYKDO5u2gKFRVuXW3AiKZ+4ulOAJG3jJQNe6kTPWSDVelNfPIrf8Brv
         2O9w==
X-Gm-Message-State: AOAM530xuqj/AHwI/q7Loe0Zpn5Tdrl1tsJmnngYU7trXwamtrgYGIHp
        ali9iAxIuL6/8ydrovBu6oMHRmyexmA=
X-Google-Smtp-Source: ABdhPJyvapmNovkhFKRKKeYTT9WBBPkK0ddMt5LJkuZLAnVfRMeM2gfr7HydSJe4wjrWKx/PO5hH4w==
X-Received: by 2002:a17:90a:73cb:: with SMTP id n11mr5859976pjk.234.1591835726884;
        Wed, 10 Jun 2020 17:35:26 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id h17sm1034503pfo.168.2020.06.10.17.35.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:35:26 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
Subject: [PATCH iproute2 net-next v2 1/2] ipnexthop: support for fdb nexthops
Date:   Wed, 10 Jun 2020 17:35:20 -0700
Message-Id: <1591835721-39497-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
References: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds support to add and delete
ecmp nexthops of type fdb. Such nexthops can
be linked to vxlan fdb entries.

$ip nexthop add id 12 via 172.16.1.2 fdb
$ip nexthop add id 13 via 172.16.1.3 fdb
$ip nexthop add id 102 group 12/13 fdb

$bridge fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 ip/ipnexthop.c        | 16 +++++++++++++++-
 man/man8/ip-nexthop.8 | 30 +++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 99f8963..421d4d0 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -20,6 +20,7 @@ static struct {
 	unsigned int ifindex;
 	unsigned int master;
 	unsigned int proto;
+	unsigned int fdb;
 } filter;
 
 enum {
@@ -39,7 +40,7 @@ static void usage(void)
 		"       ip nexthop { add | replace } id ID NH [ protocol ID ]\n"
 		"       ip nexthop { get| del } id ID\n"
 		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]\n"
-		"            [ groups ]\n"
+		"            [ groups ] [ fdb ]\n"
 		"NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]\n"
 		"      [ encap ENCAPTYPE ENCAPHDR ] | group GROUP ] }\n"
 		"GROUP := [ id[,weight]>/<id[,weight]>/... ]\n"
@@ -70,6 +71,12 @@ static int nh_dump_filter(struct nlmsghdr *nlh, int reqlen)
 			return err;
 	}
 
+	if (filter.fdb) {
+		err = addattr_l(nlh, reqlen, NHA_FDB, NULL, 0);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -259,6 +266,9 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (tb[NHA_OIF])
 		print_rt_flags(fp, nhm->nh_flags);
 
+	if (tb[NHA_FDB])
+		print_null(PRINT_ANY, "fdb", "fdb", NULL);
+
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	close_json_object();
 	fflush(fp);
@@ -385,6 +395,8 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 			addattr_l(&req.n, sizeof(req), NHA_BLACKHOLE, NULL, 0);
 			if (req.nhm.nh_family == AF_UNSPEC)
 				req.nhm.nh_family = AF_INET;
+		} else if (!strcmp(*argv, "fdb")) {
+			addattr_l(&req.n, sizeof(req), NHA_FDB, NULL, 0);
 		} else if (!strcmp(*argv, "onlink")) {
 			nh_flags |= RTNH_F_ONLINK;
 		} else if (!strcmp(*argv, "group")) {
@@ -487,6 +499,8 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 			if (get_unsigned(&proto, *argv, 0))
 				invarg("invalid protocol value", *argv);
 			filter.proto = proto;
+		} else if (!matches(*argv, "fdb")) {
+			filter.fdb = 1;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
 		} else {
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index 68164f3..4d55f4d 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -38,7 +38,8 @@ ip-nexthop \- nexthop object management
 .IR NAME " ] [ "
 .B  master
 .IR DEV " ] [ "
-.BR  groups " ] "
+.BR  groups " ] [ "
+.BR  fdb " ]"
 
 .ti -8
 .IR NH " := { "
@@ -49,9 +50,11 @@ ip-nexthop \- nexthop object management
 .IR DEV " ] [ "
 .BR onlink " ] [ "
 .B encap
-.IR ENCAP " ] | "
+.IR ENCAP " ] [ "
+.BR fdb " ] | "
 .B  group
-.IR GROUP " } "
+.IR GROUP " [ "
+.BR fdb " ] } "
 
 .ti -8
 .IR ENCAP " := [ "
@@ -125,6 +128,13 @@ weight (id,weight) and a '/' as a separator between entries.
 .TP
 .B blackhole
 create a blackhole nexthop
+.TP
+.B fdb
+nexthop and nexthop groups for use with layer-2 fdb entries.
+A fdb nexthop group can only have fdb nexthops.
+Example: Used to represent a vxlan remote vtep ip. layer-2 vxlan
+fdb entry pointing to an ecmp nexthop group containing multiple
+remote vtep ips.
 .RE
 
 .TP
@@ -148,6 +158,9 @@ show the nexthops using devices enslaved to given master device
 .TP
 .BI groups
 show only nexthop groups
+.TP
+.BI fdb
+show only fdb nexthops and nexthop groups
 .RE
 .TP
 ip nexthop flush
@@ -186,6 +199,17 @@ ip nexthop add id 4 group 1,5/2,11
 Adds a nexthop with id 4. The nexthop is a group using nexthops with ids
 1 and 2 with nexthop 1 at weight 5 and nexthop 2 at weight 11.
 .RE
+.PP
+ip nexthop add id 5 via 192.168.1.2 fdb
+.RS 4
+Adds a fdb nexthop with id 5.
+.RE
+.PP
+ip nexthop add id 7 group 5/6 fdb
+.RS 4
+Adds a fdb nexthop group with id 7. A fdb nexthop group can only have
+fdb nexthops.
+.RE
 .SH SEE ALSO
 .br
 .BR ip (8)
-- 
2.1.4

