Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB8817D01E
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgCGU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 15:59:24 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44090 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgCGU7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 15:59:24 -0500
Received: by mail-qt1-f193.google.com with SMTP id h16so4340047qtr.11
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 12:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RiFhmcgCINxyIXLhMbWdVg6YO1YFeczrJ4qEQHd/QRs=;
        b=AtD23S9E2E6JK+iwN83Rxz3cVWZrOv4ko43IBkhv9gJXzuV9fbe2sVW+/zePCXJdaq
         Yzr9oynEYV1TqstDYWnMCp+A0onF2sxF8ODSMyw2JfTTyZbqEEVnsBbpMTHjCCD1rxWJ
         zLNdfTauPGZf5bnuyMgpRz1QADAOOQ/Wsydec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RiFhmcgCINxyIXLhMbWdVg6YO1YFeczrJ4qEQHd/QRs=;
        b=IZNgv2try+9ACstdeuz0x2UCQZXl+u8FYMhlDTYqQd4vuB5xbLWwY2YtntGo1gZQID
         xgfm+D3crjMUEL+NRB0bDA9gzkgIW28N+5pFYbehqcOhht5f15L9icWHbDmgW0VOFG7B
         rpU4L1PYuMGOL9SCKIrP1k4NRvZGDjKqUSpAnlLb/PuFVPiznOBhyvL41t+8xK2YGXXl
         cgyBKYez7lTdSsnZd6UjWqMIQIEmwssTsOd2AsV8a7irDSbmTA8/3HmZSNo/bBvBgM7i
         /YoN+SM+tTm8PfJOtxVkvGsMD3Brm3CBvai5SyuGz2EPwzZ2K9ED/7OnfckAHIHZnyUs
         G44A==
X-Gm-Message-State: ANhLgQ0ftTh/aSMXJtCPA7TV6HfLc5/OGZEyhYWOPoD7e9vb0kzaNw7e
        ah0LtpvXdbInj896nUZiHvU2qi9Sb5M=
X-Google-Smtp-Source: ADFU+vuJn2cSqWjmsclrKsHbX5a71YBQKxigyyQWa4PGMuokwBFS5+YTd1hcKvOkJf3TqKgqnTddqg==
X-Received: by 2002:ac8:740d:: with SMTP id p13mr8416259qtq.322.1583614762501;
        Sat, 07 Mar 2020 12:59:22 -0800 (PST)
Received: from eva.nc.rr.com (2606-a000-111d-8179-6cd1-b9da-8f7b-5f20.inf6.spectrum.com. [2606:a000:111d:8179:6cd1:b9da:8f7b:5f20])
        by smtp.googlemail.com with ESMTPSA id e38sm369551qtc.89.2020.03.07.12.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 12:59:21 -0800 (PST)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org,
        roopa@cumulusnetworks.com, sworley@cumulusnetworks.com
Subject: [PATCH] ip link: Prevent duplication of table id for vrf tables
Date:   Sat,  7 Mar 2020 15:59:16 -0500
Message-Id: <20200307205916.15646-1-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creation of different vrf's with duplicate table id's creates
a situation where two different routing entities believe
they have exclusive access to a particular table.  This
leads to situations where different routing processes
clash for control of a route due to inadvertent table
id overlap.  Prevent end user from making this mistake
on accident.

sharpd@eva ~/i/ip (master)> ip vrf show
Name              Table
-----------------------
BLUE              1300
GREEN             1301
sharpd@eva ~/i/ip (master)> sudo ./ip link add ORANGE type vrf table 1300
Error: argument "1300" is wrong: table specified is already being used

sharpd@eva ~/i/ip (master) [255]> sudo ./ip link add ORANGE type vrf table 1302
sharpd@eva ~/i/ip (master)> ip vrf show
Name              Table
-----------------------
BLUE              1300
GREEN             1301
ORANGE            1302

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 ip/ip_common.h  |  2 ++
 ip/iplink_vrf.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 ip/ipvrf.c      |  4 ++--
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 879287e3..4cc825e9 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -148,6 +148,8 @@ void xdp_dump(FILE *fp, struct rtattr *tb, bool link, bool details);
 
 /* iplink_vrf.c */
 __u32 ipvrf_get_table(const char *name);
+__u32 vrf_table_linkinfo(struct rtattr *li[]);
+int ipvrf_filter_req(struct nlmsghdr *nhl, int reqlen);
 int name_is_vrf(const char *name);
 
 #ifndef	INFINITY_LIFE_TIME
diff --git a/ip/iplink_vrf.c b/ip/iplink_vrf.c
index 5d20f29d..968593f6 100644
--- a/ip/iplink_vrf.c
+++ b/ip/iplink_vrf.c
@@ -29,17 +29,64 @@ static void explain(void)
 	vrf_explain(stderr);
 }
 
+static bool vrf_find_table(struct nlmsghdr *n, __u32 table)
+{
+	struct ifinfomsg *ifi = NLMSG_DATA(n);
+	struct rtattr *tb[IFLA_MAX + 1];
+	struct rtattr *li[IFLA_INFO_MAX + 1];
+	int len = n->nlmsg_len;
+	__u32 vrf_table;
+
+	len -= NLMSG_LENGTH(sizeof(*ifi));
+	if (len < 0)
+		return false;
+
+	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifi), len);
+
+	if (!tb[IFLA_LINKINFO])
+		return false;
+
+	parse_rtattr_nested(li, IFLA_INFO_MAX, tb[IFLA_LINKINFO]);
+
+	if (!li[IFLA_INFO_KIND])
+		return false;
+
+	vrf_table = vrf_table_linkinfo(li);
+
+	if (vrf_table == table)
+		return true;
+
+	return false;
+}
+
 static int vrf_parse_opt(struct link_util *lu, int argc, char **argv,
 			    struct nlmsghdr *n)
 {
 	while (argc > 0) {
 		if (matches(*argv, "table") == 0) {
 			__u32 table;
+			bool found = false;
+			struct nlmsg_chain linfo = { NULL, NULL };
 
 			NEXT_ARG();
 
 			if (rtnl_rttable_a2n(&table, *argv))
 				invarg("invalid table ID\n", *argv);
+
+			if (ip_link_list(ipvrf_filter_req, &linfo) == 0) {
+				struct nlmsg_list *l;
+
+				for (l = linfo.head; l; l = l->next) {
+					if (vrf_find_table(&l->h, table)) {
+						found = true;
+						break;
+					}
+				}
+			}
+			if (found)
+				invarg("table specified is already being used\n",
+				       *argv);
+
 			addattr32(n, 1024, IFLA_VRF_TABLE, table);
 		} else if (matches(*argv, "help") == 0) {
 			explain();
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index b9a43675..ff0c492c 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -477,7 +477,7 @@ void vrf_reset(void)
 	vrf_switch("default");
 }
 
-static int ipvrf_filter_req(struct nlmsghdr *nlh, int reqlen)
+int ipvrf_filter_req(struct nlmsghdr *nlh, int reqlen)
 {
 	struct rtattr *linkinfo;
 	int err;
@@ -497,7 +497,7 @@ static int ipvrf_filter_req(struct nlmsghdr *nlh, int reqlen)
 }
 
 /* input arg is linkinfo */
-static __u32 vrf_table_linkinfo(struct rtattr *li[])
+__u32 vrf_table_linkinfo(struct rtattr *li[])
 {
 	struct rtattr *attr[IFLA_VRF_MAX + 1];
 
-- 
2.25.1

