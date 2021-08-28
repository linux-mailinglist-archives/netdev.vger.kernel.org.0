Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4C43FA550
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhH1LJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbhH1LJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:27 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FCBC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a25so19651681ejv.6
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qYKgnCLen4cBBm6S3pdRBThWsOr6RKmftJwo6Di15U=;
        b=xDcszBl7xxM60u/49fMgWq+GqKozQxyYq/qAHhBhnVqFcENhnpw5JIb1qI4hm7vR9T
         QyAQBxhgPf+20poudhcwn74AaO/uvujHJcibdWjxqKheFuKpAk69v10By25yCZJo74j0
         knzQwdJW1bJB48sBUabX/Xt5ag8J8iXqGKS+w4vRVtkFHUZ9uhOUmOKfyApRcqKexC0s
         XgF6xa1PTiBVJt5eHBQU35nIAPZM3MDG2jN1YRp1npca3UkrH6c0aDYv+hr0mT8MF3ZQ
         jwsuqqIiNwLzjvls5Wm3AtfEM9Bf+tEwPi+6gjF0XSeGUj1dp3dWpz8do8Duh7LxJYFZ
         k9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qYKgnCLen4cBBm6S3pdRBThWsOr6RKmftJwo6Di15U=;
        b=DSjNBuL3uNJTG/D7ZgvPR2NvskPbEnFRtsAxauQSI3Hw7TFQqgMz+AzdOTdNpA7C7t
         PjgXOvzJJxJpi03NPoCba75N7GWdHARvJOIzA36Y0+fGk9V5l6wK5mpEs/MCB+rVBja8
         Fs5IcUx6WZhVByGxMgMq7rCyHe3sLAtPqY/m+VQBG8AxhQ8yM8br8iH5JQEAm/P+h69M
         OifKin+JL+82wr/mNMYTzzsy2IfwQlIZHbnAEDf95L59SKFrRd4Em/BL+5xRvulnH2EB
         i8mHtrZCx8IEsVRG3SVnxbwp56QhzYGeArvIesDwMO2sNTmQOsb6IHLoNeQPPleMsQOd
         CxDQ==
X-Gm-Message-State: AOAM533RkdXE7ghNaY9yIsBqrfqPUT1gFnt99Pr/jGXzBsmmJOuoh1yP
        kG90FfrQ58aNf6dM962Mwa6XB/yTrH1oiJoC
X-Google-Smtp-Source: ABdhPJwpED+pg+wFuQT8ICrIo4SdtV009s9lbTjMYRdB67HBLjpAIneQz0IQ9146jLni7zCkaMlspA==
X-Received: by 2002:a17:906:1dd6:: with SMTP id v22mr14796984ejh.226.1630148914810;
        Sat, 28 Aug 2021 04:08:34 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:34 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 19/19] bridge: vlan: add support for dumping router ports
Date:   Sat, 28 Aug 2021 14:08:05 +0300
Message-Id: <20210828110805.463429-20-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add dump support for vlan multicast router ports and their details if
requested. If details are requested we print 1 entry per line, otherwise
we print all router ports on a single line similar to how mdb prints
them.

Looks like:
$ bridge vlan global show vid 100
 port              vlan-id
 bridge            100
                     mcast_snooping 1 mcast_querier 0 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000
                     router ports: ens20 ens16

Looks like (with -s):
 $ bridge -s vlan global show vid 100
 port              vlan-id
 bridge            100
                     mcast_snooping 1 mcast_querier 0 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000
                     router ports: ens20   187.57 temp
                                   ens16   118.27 temp

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |  1 +
 bridge/mdb.c       |  6 +++---
 bridge/vlan.c      | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 09f42c814918..610e83f65603 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -14,6 +14,7 @@ void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
 		   bool global_only);
+void br_print_router_port_stats(struct rtattr *pattr);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/mdb.c b/bridge/mdb.c
index b427d878677f..7b5863d31c46 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -59,7 +59,7 @@ static const char *format_timer(__u32 ticks, int align)
 	return tbuf;
 }
 
-static void __print_router_port_stats(FILE *f, struct rtattr *pattr)
+void br_print_router_port_stats(struct rtattr *pattr)
 {
 	struct rtattr *tb[MDBA_ROUTER_PATTR_MAX + 1];
 
@@ -101,13 +101,13 @@ static void br_print_router_ports(FILE *f, struct rtattr *attr,
 			print_string(PRINT_JSON, "port", NULL, port_ifname);
 
 			if (show_stats)
-				__print_router_port_stats(f, i);
+				br_print_router_port_stats(i);
 			close_json_object();
 		} else if (show_stats) {
 			fprintf(f, "router ports on %s: %s",
 				brifname, port_ifname);
 
-			__print_router_port_stats(f, i);
+			br_print_router_port_stats(i);
 			fprintf(f, "\n");
 		} else {
 			fprintf(f, "%s ", port_ifname);
diff --git a/bridge/vlan.c b/bridge/vlan.c
index afb5186d36de..bf3b440fa1b4 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -803,6 +803,36 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+static void print_vlan_router_ports(struct rtattr *rattr)
+{
+	int rem = RTA_PAYLOAD(rattr);
+	struct rtattr *i;
+
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	open_json_array(PRINT_ANY, is_json_context() ? "router_ports" :
+						       "router ports: ");
+	for (i = RTA_DATA(rattr); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		uint32_t *port_ifindex = RTA_DATA(i);
+		const char *port_ifname = ll_index_to_name(*port_ifindex);
+
+		open_json_object(NULL);
+		if (show_stats && i != RTA_DATA(rattr)) {
+			print_nl();
+			/* start: IFNAMSIZ + 4 + strlen("router ports: ") */
+			print_string(PRINT_FP, NULL,
+				     "%-" __stringify(IFNAMSIZ) "s    "
+				     "              ",
+				     "");
+		}
+		print_string(PRINT_ANY, "port", "%s ", port_ifname);
+		if (show_stats)
+			br_print_router_port_stats(i);
+		close_json_object();
+	}
+	close_json_array(PRINT_JSON, NULL);
+	print_nl();
+}
+
 static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1], *vattr;
@@ -902,6 +932,10 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     rta_getattr_u64(vattr));
 	}
 	print_nl();
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS]) {
+		vattr = RTA_DATA(vtb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS]);
+		print_vlan_router_ports(vattr);
+	}
 	close_json_object();
 }
 
-- 
2.31.1

