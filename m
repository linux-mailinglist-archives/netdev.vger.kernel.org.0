Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD4D287571
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgJHNu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730432AbgJHNuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:54 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F1FC0613D3
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i5so5921757edr.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2x/ESsYVh+Qv7/zPt/adzjQT5jGDbu/ldM3cecFuoE=;
        b=P8MPYqNKTGziDgF8c/7UKruoXkCictdJ9+1x6R8R3cSmqTG+snb0GOp43ZniF9vkSR
         Gil8XZhVYMJzsJs0aaVl1HWoQOD93Zib5j6QJyjVWbGDMMQsXe/Hb8UcD0O+dxSW9jVY
         6PhLYND1P7GTGlI2pabLRAGnCl/2UMFUcTjyrhqjukAPFxPPTm2mzhKeoUXv8PU6kt8J
         L0IDoqmkPk57ziL3dwhvR3Oi/YLc1zuCmirefZtsFKFmEv4ad0dlnKSVmHWvS1uuvY/w
         VNHfwaylsDVS6er6GlAFBEQYdjjbkv6MeqsdrISo044XhquKl5sYwcy2wlUUPI5EhqPu
         W7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2x/ESsYVh+Qv7/zPt/adzjQT5jGDbu/ldM3cecFuoE=;
        b=UAGlnWlvQTHFYzJWuzGgaMLNTCiGSpgojilka3v+01s2Ytnv0Hyjtqqg9VR3J2gsna
         mvU3fannZuWambFY3fFpdsxw32ZsmG3h5hR6DnozW8A/gIg5z0EXqUHvtdaHbBnyYBdb
         eAmn/36/iW65II4wtCk0Lzy2MM+szmgOncdM5KrwMllXssKxePEch0dalRGPW5Xq3vh1
         YBPbDsIDVj5oA1+8vrj+kgmjtzkr3sToA5Kkeg0y5Qy/qHLSmWbRL2aC/2u5d+CiwoFJ
         JO5C0ASqMXSSDJ+4ipEFc6gyIB0nE0H4xeE9u3Lpz+z9jXKd5QeKx7ZMJrjTC3svYWmP
         2o0w==
X-Gm-Message-State: AOAM531lCZyXOjPdLWsUhM1I3L0c8QQiNbD5lkjK0wjwUXawM5W6plnM
        MR59Z+dRrKrhmhxnMa48Bz+8uZImDXl4BRs9
X-Google-Smtp-Source: ABdhPJxn8JFzZ66j9scsc2ZWGAlLNG8jhJuQ+e29w5041CzK9l5SnEug5BM0SOD+5xyYeUW+YXLzCw==
X-Received: by 2002:a50:d94d:: with SMTP id u13mr8798382edj.365.1602165051128;
        Thu, 08 Oct 2020 06:50:51 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:50 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 5/6] bridge: mdb: print source list when available
Date:   Thu,  8 Oct 2020 16:50:23 +0300
Message-Id: <20201008135024.1515468-6-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Print the mdb entry's source list when it's available if the user
requested to show details (-d). Each source has an associated timer
which controls if traffic should be forwarded to that S,G entry (if the
timer is non-zero traffic is forwarded, otherwise it's not).
Currently the source list is kernel controlled and can't be changed by
user-space.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c | 75 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index c0cb4fd1421e..b3b58a2385ca 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -41,15 +41,20 @@ static bool is_temp_mcast_rtr(__u8 type)
 	return type == MDB_RTR_TYPE_TEMP_QUERY || type == MDB_RTR_TYPE_TEMP;
 }
 
-static const char *format_timer(__u32 ticks)
+static const char *format_timer(__u32 ticks, int align)
 {
 	struct timeval tv;
 	static char tbuf[32];
 
 	__jiffies_to_tv(&tv, ticks);
-	snprintf(tbuf, sizeof(tbuf), "%4lu.%.2lu",
-		 (unsigned long)tv.tv_sec,
-		 (unsigned long)tv.tv_usec / 10000);
+	if (align)
+		snprintf(tbuf, sizeof(tbuf), "%4lu.%.2lu",
+			 (unsigned long)tv.tv_sec,
+			 (unsigned long)tv.tv_usec / 10000);
+	else
+		snprintf(tbuf, sizeof(tbuf), "%lu.%.2lu",
+			 (unsigned long)tv.tv_sec,
+			 (unsigned long)tv.tv_usec / 10000);
 
 	return tbuf;
 }
@@ -65,7 +70,7 @@ static void __print_router_port_stats(FILE *f, struct rtattr *pattr)
 		__u32 timer = rta_getattr_u32(tb[MDBA_ROUTER_PATTR_TIMER]);
 
 		print_string(PRINT_ANY, "timer", " %s",
-			     format_timer(timer));
+			     format_timer(timer, 1));
 	}
 
 	if (tb[MDBA_ROUTER_PATTR_TYPE]) {
@@ -115,6 +120,31 @@ static void br_print_router_ports(FILE *f, struct rtattr *attr,
 	close_json_array(PRINT_JSON, NULL);
 }
 
+static void print_src_entry(struct rtattr *src_attr, int af, const char *sep)
+{
+	struct rtattr *stb[MDBA_MDB_SRCATTR_MAX + 1];
+	SPRINT_BUF(abuf);
+	const char *addr;
+	__u32 timer_val;
+
+	parse_rtattr_nested(stb, MDBA_MDB_SRCATTR_MAX, src_attr);
+	if (!stb[MDBA_MDB_SRCATTR_ADDRESS] || !stb[MDBA_MDB_SRCATTR_TIMER])
+		return;
+
+	addr = inet_ntop(af, RTA_DATA(stb[MDBA_MDB_SRCATTR_ADDRESS]), abuf,
+			 sizeof(abuf));
+	if (!addr)
+		return;
+	timer_val = rta_getattr_u32(stb[MDBA_MDB_SRCATTR_TIMER]);
+
+	open_json_object(NULL);
+	print_string(PRINT_FP, NULL, "%s", sep);
+	print_color_string(PRINT_ANY, ifa_family_color(af),
+			   "address", "%s", addr);
+	print_string(PRINT_ANY, "timer", "/%s", format_timer(timer_val, 0));
+	close_json_object();
+}
+
 static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			    struct nlmsghdr *n, struct rtattr **tb)
 {
@@ -149,12 +179,30 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	}
 	print_string(PRINT_ANY, "state", " %s",
 			   (e->state & MDB_PERMANENT) ? "permanent" : "temp");
+	if (show_details && tb) {
+		if (tb[MDBA_MDB_EATTR_GROUP_MODE]) {
+			__u8 mode = rta_getattr_u8(tb[MDBA_MDB_EATTR_GROUP_MODE]);
 
-	if (show_details && tb && tb[MDBA_MDB_EATTR_GROUP_MODE]) {
-		__u8 mode = rta_getattr_u8(tb[MDBA_MDB_EATTR_GROUP_MODE]);
-
-		print_string(PRINT_ANY, "filter_mode", " filter_mode %s",
-			     mode == MCAST_INCLUDE ? "include" : "exclude");
+			print_string(PRINT_ANY, "filter_mode", " filter_mode %s",
+				     mode == MCAST_INCLUDE ? "include" :
+							     "exclude");
+		}
+		if (tb[MDBA_MDB_EATTR_SRC_LIST]) {
+			struct rtattr *i, *attr = tb[MDBA_MDB_EATTR_SRC_LIST];
+			const char *sep = " ";
+			int rem;
+
+			open_json_array(PRINT_ANY, is_json_context() ?
+								"source_list" :
+								" source_list");
+			rem = RTA_PAYLOAD(attr);
+			for (i = RTA_DATA(attr); RTA_OK(i, rem);
+			     i = RTA_NEXT(i, rem)) {
+				print_src_entry(i, af, sep);
+				sep = ",";
+			}
+			close_json_array(PRINT_JSON, NULL);
+		}
 	}
 
 	open_json_array(PRINT_JSON, "flags");
@@ -175,7 +223,7 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
 		print_string(PRINT_ANY, "timer", " %s",
-			     format_timer(timer));
+			     format_timer(timer, 1));
 	}
 
 	print_nl();
@@ -193,8 +241,9 @@ static void br_print_mdb_entry(FILE *f, int ifindex, struct rtattr *attr,
 	rem = RTA_PAYLOAD(attr);
 	for (i = RTA_DATA(attr); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 		e = RTA_DATA(i);
-		parse_rtattr(etb, MDBA_MDB_EATTR_MAX, MDB_RTA(RTA_DATA(i)),
-			     RTA_PAYLOAD(i) - RTA_ALIGN(sizeof(*e)));
+		parse_rtattr_flags(etb, MDBA_MDB_EATTR_MAX, MDB_RTA(RTA_DATA(i)),
+				   RTA_PAYLOAD(i) - RTA_ALIGN(sizeof(*e)),
+				   NLA_F_NESTED);
 		print_mdb_entry(f, ifindex, e, n, etb);
 	}
 }
-- 
2.25.4

