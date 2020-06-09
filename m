Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18A01F32B2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 05:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgFIDqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 23:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgFIDq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 23:46:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3253EC03E97C
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 20:46:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so7497751plt.5
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 20:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6FlJnHIhYsLkZKdnhnAmYrqlyw6UbDVBGxxIRQRd9dw=;
        b=I4jFhdUjKLRyMPR5iKS72gQ44xJCh/F+Kr4UyTEf9Xd7/U60XfOlscZxCC3Ruwf0lH
         5Qt0f9TGfk3F9zB8Vtur2Y7y8pYS20H+kF3IjlJbDj2kkDjGQ1cmn8XdCbKWuTNQDBiR
         WjkclxxZekX2oyUpasRGp8ijK9Y5HiOnSqAKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6FlJnHIhYsLkZKdnhnAmYrqlyw6UbDVBGxxIRQRd9dw=;
        b=BBj1M1+lCo0pQAzLAaoA072daJQWYMhcrzQpaB7Li9aryrlppNDpEaXFst1HK52Q2h
         STnWZ3RDL/JaCGtXwoQqso5i8h8pFxg8d5Db12e9CtuI1UnAmZDAijFi4HR7N5LSjrer
         ScPn8slIsGVi3utVD/UFsO5uQag0YqOWkowErKfghn2vMAcR6UK5dJeZ81chZ3htfqlW
         ho0NNT0/TXsEsAYa1baNa2AlTHmSRw4xvqciOHCwmvCS/XNlcnR8HfHmE3NjuLMuWajX
         2cl5QRSN2qiRt1kqtp5eL8MTln2o0hjMh8wFgpyboRKVYe2yYgHyjJau35BVXX/061JC
         dV5A==
X-Gm-Message-State: AOAM531Xj2D2N16974iMFUD6TgmAPhcbjNakau3S0y9TJ3+1+5jB22a7
        H6z8KvDrl6klwZiAjUqQfV/1YuKrzeU=
X-Google-Smtp-Source: ABdhPJzS8QKO94CGBAm9dTVdLyUC+rQEu3cF1tWIwc5pVRxke7kxGaOTYQlkl3bV5Mvjq5OHdL5TJQ==
X-Received: by 2002:a17:902:e78f:: with SMTP id cp15mr1611468plb.41.1591674388620;
        Mon, 08 Jun 2020 20:46:28 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id nl11sm1696385pjb.0.2020.06.08.20.46.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 20:46:28 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
Subject: [PATCH iproute2 net-next 1/2] ipnexthop: support for fdb nexthops
Date:   Mon,  8 Jun 2020 20:46:22 -0700
Message-Id: <1591674383-20545-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1591674383-20545-1-git-send-email-roopa@cumulusnetworks.com>
References: <1591674383-20545-1-git-send-email-roopa@cumulusnetworks.com>
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
 ip/ipnexthop.c        | 17 ++++++++++++++++-
 man/man8/ip-nexthop.8 | 30 +++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 99f8963..e4d84d8 100644
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
+		addattr_l(nlh, reqlen, NHA_FDB, NULL, 0);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -131,6 +138,7 @@ static int ipnh_flush(unsigned int all)
 		filter.groups = 1;
 		filter.ifindex = 0;
 		filter.master = 0;
+		filter.fdb = 1;
 	}
 
 	if (rtnl_open(&rth_del, 0) < 0) {
@@ -259,6 +267,9 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (tb[NHA_OIF])
 		print_rt_flags(fp, nhm->nh_flags);
 
+	if (tb[NHA_FDB])
+		print_null(PRINT_ANY, "fdb", "fdb", NULL);
+
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	close_json_object();
 	fflush(fp);
@@ -385,6 +396,8 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 			addattr_l(&req.n, sizeof(req), NHA_BLACKHOLE, NULL, 0);
 			if (req.nhm.nh_family == AF_UNSPEC)
 				req.nhm.nh_family = AF_INET;
+		} else if (!strcmp(*argv, "fdb")) {
+			addattr_l(&req.n, sizeof(req), NHA_FDB, NULL, 0);
 		} else if (!strcmp(*argv, "onlink")) {
 			nh_flags |= RTNH_F_ONLINK;
 		} else if (!strcmp(*argv, "group")) {
@@ -487,6 +500,8 @@ static int ipnh_list_flush(int argc, char **argv, int action)
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

