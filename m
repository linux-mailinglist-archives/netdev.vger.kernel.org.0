Return-Path: <netdev+bounces-1524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9046FE185
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9B00280E27
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE7716423;
	Wed, 10 May 2023 15:24:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCF36AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:24:42 +0000 (UTC)
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 242D12703
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2yzgQ
	4p7hv35QWMBOwaEEOs6ds9jnhTyzfXBp3Q6lNc=; b=ek1G7QREdWJW2kb6HLA2b
	2UPHmhr9DcJLs51e+CvgIIPxUVLnf+W1qhJfzDkdVDilzm93471s27aKk1mQgsUu
	6AjfUYy0XgHiNnXxLX56gnkch7W7E9F9uUcvreuU3i1y2UXh6TkbiinpB8j6KqGJ
	c1W3IIo0vwh8RJX2GhtTDc=
Received: from localhost.localdomain (unknown [113.200.76.118])
	by zwqz-smtp-mta-g3-1 (Coremail) with SMTP id _____wDHLpcst1tky6ABBg--.9673S2;
	Wed, 10 May 2023 23:24:29 +0800 (CST)
From: zhaoshuang <izhaoshuang@163.com>
To: netdev@vger.kernel.org
Subject: [PATCH] iproute2: optimize code and fix some mem-leak risk
Date: Wed, 10 May 2023 23:24:26 +0800
Message-Id: <20230510152426.23612-1-izhaoshuang@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230510133616.7717-1-izhaoshuang@163.com>
References: <20230510133616.7717-1-izhaoshuang@163.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHLpcst1tky6ABBg--.9673S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3XF4kWw4DurW7XryrCry3Arb_yoWfWF1rpw
	sIgas8Xrs7trWUAF1fZa18uFn8XwsIq3W7urZrC3y8Ar47Xr1kZw1Ika4IgF98CFWrG3yF
	vF4qy3W5CrWDCrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U24iUUUUUU=
X-Originating-IP: [113.200.76.118]
X-CM-SenderInfo: 5l2kt0pvkxt0rj6rljoofrz/1tbiRRJruGDuzwNk0wAAsx
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: zhaoshuang <zhaoshuang@uniontech.com>

Signed-off-by: zhaoshuang <zhaoshuang@uniontech.com>
Signed-off-by: zhaoshuang <izhaoshuang@163.com>
---
 bridge/mdb.c      |  4 ++++
 devlink/devlink.c | 21 +++++++++------------
 ip/ipaddrlabel.c  |  1 +
 ip/ipfou.c        |  1 +
 ip/ipila.c        |  1 +
 ip/ipnetconf.c    |  1 +
 ip/ipnexthop.c    |  4 ++++
 ip/iproute.c      |  6 ++++++
 ip/iprule.c       |  1 +
 ip/iptuntap.c     |  1 +
 ip/tunnel.c       |  2 ++
 tc/tc_class.c     |  1 +
 tc/tc_filter.c    |  1 +
 tc/tc_qdisc.c     |  1 +
 14 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index dcc08235..fbb4f704 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -466,12 +466,14 @@ static int mdb_show(int argc, char **argv)
 	/* get mdb entries */
 	if (rtnl_mdbdump_req(&rth, PF_BRIDGE) < 0) {
 		perror("Cannot send dump request");
+		delete_json_obj();
 		return -1;
 	}
 
 	open_json_array(PRINT_JSON, "mdb");
 	if (rtnl_dump_filter(&rth, print_mdbs, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return -1;
 	}
 	close_json_array(PRINT_JSON, NULL);
@@ -479,12 +481,14 @@ static int mdb_show(int argc, char **argv)
 	/* get router ports */
 	if (rtnl_mdbdump_req(&rth, PF_BRIDGE) < 0) {
 		perror("Cannot send dump request");
+		delete_json_obj();
 		return -1;
 	}
 
 	open_json_object("router");
 	if (rtnl_dump_filter(&rth, print_rtrs, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return -1;
 	}
 	close_json_object();
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 019ffc23..26513142 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -205,6 +205,14 @@ struct ifname_map {
 	char *ifname;
 };
 
+static void ifname_map_free(struct ifname_map *ifname_map)
+{
+	free(ifname_map->ifname);
+	free(ifname_map->dev_name);
+	free(ifname_map->bus_name);
+	free(ifname_map);
+}
+
 static struct ifname_map *ifname_map_alloc(const char *bus_name,
 					   const char *dev_name,
 					   uint32_t port_index,
@@ -221,23 +229,12 @@ static struct ifname_map *ifname_map_alloc(const char *bus_name,
 	ifname_map->ifname = strdup(ifname);
 	if (!ifname_map->bus_name || !ifname_map->dev_name ||
 	    !ifname_map->ifname) {
-		free(ifname_map->ifname);
-		free(ifname_map->dev_name);
-		free(ifname_map->bus_name);
-		free(ifname_map);
+		ifname_map_free(ifname_map);
 		return NULL;
 	}
 	return ifname_map;
 }
 
-static void ifname_map_free(struct ifname_map *ifname_map)
-{
-	free(ifname_map->ifname);
-	free(ifname_map->dev_name);
-	free(ifname_map->bus_name);
-	free(ifname_map);
-}
-
 static int ifname_map_update(struct ifname_map *ifname_map, const char *ifname)
 {
 	char *new_ifname;
diff --git a/ip/ipaddrlabel.c b/ip/ipaddrlabel.c
index 46f68c41..b045827a 100644
--- a/ip/ipaddrlabel.c
+++ b/ip/ipaddrlabel.c
@@ -113,6 +113,7 @@ static int ipaddrlabel_list(int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_addrlabel, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/ip/ipfou.c b/ip/ipfou.c
index ed99a548..760cfee2 100644
--- a/ip/ipfou.c
+++ b/ip/ipfou.c
@@ -318,6 +318,7 @@ static int do_show(int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&genl_rth, print_fou_mapping, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/ip/ipila.c b/ip/ipila.c
index 335d15f6..4f6d578f 100644
--- a/ip/ipila.c
+++ b/ip/ipila.c
@@ -150,6 +150,7 @@ static int do_list(int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&genl_rth, print_ila_mapping, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/ip/ipnetconf.c b/ip/ipnetconf.c
index 7ddaefb4..9ae6c45e 100644
--- a/ip/ipnetconf.c
+++ b/ip/ipnetconf.c
@@ -209,6 +209,7 @@ dump:
 			 */
 			if (errno == EOPNOTSUPP &&
 			    filter.family == AF_UNSPEC) {
+				delete_json_obj();
 				filter.family = AF_INET;
 				goto dump;
 			}
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9f16b809..abbf4d45 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -1021,6 +1021,7 @@ static int ipnh_get_id(__u32 id)
 	new_json_obj(json);
 
 	if (print_nexthop_nocache(answer, (void *)stdout) < 0) {
+		delete_json_obj();
 		free(answer);
 		return -1;
 	}
@@ -1106,6 +1107,7 @@ static int ipnh_list_flush(int argc, char **argv, int action)
 	new_json_obj(json);
 
 	if (rtnl_dump_filter(&rth, print_nexthop_nocache, stdout) < 0) {
+		delete_json_obj();
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
@@ -1181,6 +1183,7 @@ static int ipnh_bucket_list(int argc, char **argv)
 	new_json_obj(json);
 
 	if (rtnl_dump_filter(&rth, print_nexthop_bucket, stdout) < 0) {
+		delete_json_obj();
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
@@ -1221,6 +1224,7 @@ static int ipnh_bucket_get_id(__u32 id, __u16 bucket_index)
 	new_json_obj(json);
 
 	if (print_nexthop_bucket(answer, (void *)stdout) < 0) {
+		delete_json_obj();
 		free(answer);
 		return -1;
 	}
diff --git a/ip/iproute.c b/ip/iproute.c
index a7cd9543..7909c4a2 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1977,6 +1977,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 	if (rtnl_dump_filter_errhndlr(&rth, filter_fn, stdout,
 				      save_route_errhndlr, NULL) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return -2;
 	}
 
@@ -2172,18 +2173,21 @@ static int iproute_get(int argc, char **argv)
 
 		if (print_route(answer, (void *)stdout) < 0) {
 			fprintf(stderr, "An error :-)\n");
+			delete_json_obj();
 			free(answer);
 			return -1;
 		}
 
 		if (answer->nlmsg_type != RTM_NEWROUTE) {
 			fprintf(stderr, "Not a route?\n");
+			delete_json_obj();
 			free(answer);
 			return -1;
 		}
 		len -= NLMSG_LENGTH(sizeof(*r));
 		if (len < 0) {
 			fprintf(stderr, "Wrong len %d\n", len);
+			delete_json_obj();
 			free(answer);
 			return -1;
 		}
@@ -2195,6 +2199,7 @@ static int iproute_get(int argc, char **argv)
 			r->rtm_src_len = 8*RTA_PAYLOAD(tb[RTA_PREFSRC]);
 		} else if (!tb[RTA_SRC]) {
 			fprintf(stderr, "Failed to connect the route\n");
+			delete_json_obj();
 			free(answer);
 			return -1;
 		}
@@ -2217,6 +2222,7 @@ static int iproute_get(int argc, char **argv)
 
 	if (print_route(answer, (void *)stdout) < 0) {
 		fprintf(stderr, "An error :-)\n");
+		delete_json_obj();
 		free(answer);
 		return -1;
 	}
diff --git a/ip/iprule.c b/ip/iprule.c
index 458607ef..e503e5c6 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -714,6 +714,7 @@ static int iprule_list_flush_or_save(int argc, char **argv, int action)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index ab7d5d87..552599e9 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -441,6 +441,7 @@ static int do_show(int argc, char **argv)
 
 	if (rtnl_dump_filter(&rth, print_tuntap, NULL) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return -1;
 	}
 
diff --git a/ip/tunnel.c b/ip/tunnel.c
index 75cb0b51..c5c7a31f 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -419,11 +419,13 @@ int do_tunnels_list(struct tnl_print_nlmsg_info *info)
 	new_json_obj(json);
 	if (rtnl_linkdump_req(&rth, preferred_family) < 0) {
 		perror("Cannot send dump request\n");
+		delete_json_obj();
 		return -1;
 	}
 
 	if (rtnl_dump_filter(&rth, print_nlmsg_tunnel, info) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return -1;
 	}
 	delete_json_obj();
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 096fa2ec..65776180 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -453,6 +453,7 @@ static int tc_class_list(int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_class, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 700a09f6..12a21433 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -734,6 +734,7 @@ static int tc_filter_list(int cmd, int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_filter, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 92ceb4c2..b137517b 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -433,6 +433,7 @@ static int tc_qdisc_list(int argc, char **argv)
 	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_qdisc, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
+		delete_json_obj();
 		return 1;
 	}
 	delete_json_obj();
-- 
2.20.1


