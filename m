Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530DD1F5F3B
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFKAf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgFKAf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 20:35:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846D4C08C5C2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j1so1881409pfe.4
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 17:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H6MvAbb7YiommUcD752aWVrjAsni30Cbo6fc3oxkAGw=;
        b=e8G0MHsUdsz8DRmEOxg03bY+Wl4Ak9WYPuFy0drlTz+DCVTeEMwA7IKbtTNulBQulT
         jGt/J1B0StDLyX3FU0hidDYYzzUQqImjZIt4S55fu9aw4FLhYSyB0Y4x1aRh/kxOy0Kk
         FxsGecG2HR1EFJ/lkmrEOp4Ycpu1UGBZOrkWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H6MvAbb7YiommUcD752aWVrjAsni30Cbo6fc3oxkAGw=;
        b=L8ZhsBxV9YE0HIS+hpm0gZctKmb/yWYaAQ+wIkpdVv3ACvLpk709rWaDRlh8UGVlBZ
         MW0sgo6dl4H2EeOf/1vOG6xMob2gmSBNbb4K2gPuZDYOe/6NDNQBeGEWXsd04U4vs8/Q
         Pgr/35L4Ru6YFdVo5m6KwTs80M+KvwS4tkCYGnY+fRjWYyMJHCkB3x6dTxSnMpaGetLN
         4kMW4JXHluaFvH39vQLqsxZafTec6s+7YnCuEEqYYWUOx54nWE4Sj97S8kYwm++RlJ8l
         84+665N00hmeLXSNme2THXTnmr/aISkbCKCZCLkeParQygEMb/jv00xqygXot+3oDdzr
         DEzw==
X-Gm-Message-State: AOAM530lfgCFamgnLQklQhOErwheny8USbuBdo9o/EZ6z6FI9LOpBDiA
        vC0IxgLmwlikHxfFOs472YiINQ==
X-Google-Smtp-Source: ABdhPJzyAUPDTnzg8zpGHSrKeN38tZwKNXsMSkNZ8Edws+3O5rqblbwPXomR9u9agTrcZg/luehoDg==
X-Received: by 2002:a63:de56:: with SMTP id y22mr4423309pgi.398.1591835728072;
        Wed, 10 Jun 2020 17:35:28 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id h17sm1034503pfo.168.2020.06.10.17.35.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2020 17:35:27 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        nikolay@cumulusnetworks.com
Subject: [PATCH iproute2 net-next v2 2/2] bridge: support for nexthop id in fdb entries
Date:   Wed, 10 Jun 2020 17:35:21 -0700
Message-Id: <1591835721-39497-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
References: <1591835721-39497-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds support to assign a nexthop group
id to an fdb entry.

$bridge fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 bridge/fdb.c      | 22 +++++++++++++++++++---
 man/man8/bridge.8 | 13 ++++++++++---
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 710dfc9..d2247e8 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -37,9 +37,9 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge fdb { add | append | del | replace } ADDR dev DEV\n"
 		"              [ self ] [ master ] [ use ] [ router ] [ extern_learn ]\n"
-		"              [ sticky ] [ local | static | dynamic ] [ dst IPADDR ]\n"
-		"              [ vlan VID ] [ port PORT] [ vni VNI ] [ via DEV ]\n"
-		"              [ src_vni VNI ]\n"
+		"              [ sticky ] [ local | static | dynamic ] [ vlan VID ]\n"
+		"              { [ dst IPADDR ] [ port PORT] [ vni VNI ] | [ nhid NHID ] }\n"
+		"	       [ via DEV ] [ src_vni VNI ]\n"
 		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ] [ state STATE ] ]\n"
 		"       bridge fdb get ADDR [ br BRDEV ] { brport |dev }  DEV [ vlan VID ]\n"
 		"              [ vni VNI ]\n");
@@ -237,6 +237,10 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 					   ll_index_to_name(ifindex));
 	}
 
+	if (tb[NDA_NH_ID])
+		print_uint(PRINT_ANY, "nhid", "nhid %u ",
+			   rta_getattr_u32(tb[NDA_NH_ID]));
+
 	if (tb[NDA_LINK_NETNSID])
 		print_uint(PRINT_ANY,
 				 "linkNetNsId", "link-netnsid %d ",
@@ -390,6 +394,7 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
 	unsigned int via = 0;
 	char *endptr;
 	short vid = -1;
+	__u32 nhid = 0;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dev") == 0) {
@@ -401,6 +406,10 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
 				duparg2("dst", *argv);
 			get_addr(&dst, *argv, preferred_family);
 			dst_ok = 1;
+		} else if (strcmp(*argv, "nhid") == 0) {
+			NEXT_ARG();
+			if (get_u32(&nhid, *argv, 0))
+				invarg("\"id\" value is invalid\n", *argv);
 		} else if (strcmp(*argv, "port") == 0) {
 
 			NEXT_ARG();
@@ -475,6 +484,11 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
 		return -1;
 	}
 
+	if (nhid && (dst_ok || port || vni != ~0)) {
+		fprintf(stderr, "dst, port, vni are mutually exclusive with nhid\n");
+		return -1;
+	}
+
 	/* Assume self */
 	if (!(req.ndm.ndm_flags&(NTF_SELF|NTF_MASTER)))
 		req.ndm.ndm_flags |= NTF_SELF;
@@ -496,6 +510,8 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
 
 	if (vid >= 0)
 		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
+	if (nhid > 0)
+		addattr32(&req.n, sizeof(req), NDA_NH_ID, nhid);
 
 	if (port) {
 		unsigned short dport;
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 71f2e89..fa8c004 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -68,16 +68,18 @@ bridge \- show / manipulate bridge addresses and devices
 .IR DEV " { "
 .BR local " | " static " | " dynamic " } [ "
 .BR self " ] [ " master " ] [ " router " ] [ " use " ] [ " extern_learn " ] [ " sticky " ] [ "
+.B src_vni
+.IR VNI " ] { ["
 .B dst
 .IR IPADDR " ] [ "
-.B src_vni
-.IR VNI " ] ["
 .B vni
 .IR VNI " ] ["
 .B port
 .IR PORT " ] ["
 .B via
-.IR DEVICE " ]"
+.IR DEVICE " ] | "
+.B nhid
+.IR NHID " } "
 
 .ti -8
 .BR "bridge fdb" " [ " show " ] [ "
@@ -583,6 +585,11 @@ device name of the outgoing interface for the
 VXLAN device driver to reach the
 remote VXLAN tunnel endpoint.
 
+.TP
+.BI nhid " NHID "
+ecmp nexthop group for the VXLAN device driver
+to reach remote VXLAN tunnel endpoints.
+
 .SS bridge fdb append - append a forwarding database entry
 This command adds a new fdb entry with an already known
 .IR LLADDR .
-- 
2.1.4

