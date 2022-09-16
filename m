Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E145BA525
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIPDem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIPDej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:34:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8299F60D7
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:34:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so806771pjb.0
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=HIbSLFf/KO6wFkYlAwa9HlUUJBhDSGh6JiO87oNdBuY=;
        b=MGfDZn7x+K9Wj8JJRr2o3lAyakPYCMAxqJBU5YdkUhgOg5+XMM+HGQ3omZs065x7NX
         QELgYST/BRRRrY4ja/J/GxRVHmWWaigBVz6rEMxvPgwy9KAcFaJBEbz6pHz6tWQeKAFa
         idFSZLVU+rLBYnNH+ePbjEWTJFaKqwK2obiicqxd/1vGCCzBIkCdssSjzSRtR5D8levy
         EZBZt2wEZLkjMtUcQY4gn9xu7RCUcl1b/PEJZtajU4iZHgn5w1x5MUuL81fK8WCgTSoM
         ZOrvcKopouq6HiIg0Awpod+7TlONWmGzw6aMXVFSamrlx0qpK2IoUdlDIN3rsBq/6XRi
         3IZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HIbSLFf/KO6wFkYlAwa9HlUUJBhDSGh6JiO87oNdBuY=;
        b=qaZvqc23fkJqRtkTu+IrSfOySMsGc9kUmXLhD/MoxezXt4Rf9wIXQlaF5d7MO2747X
         r+5YmUoffPpFdfpVvez8vKwNbIkcPVM8ydEymrGArUNeBqYkiggobZQ3QNmmg1AO8uZI
         hMpYW3I4QAZKNHtHRBcgyORtbcI5wd/4J912zbudfBzIH7WSyOlkY3fmcDuVUhJYVCi5
         QrkiTSqE54nTGcL86vjYq8PZcZjCGj6MrUrA60s7YDhGrXee9c0yfF2dThubwogT74du
         OyRNnR/PnZqoik/NfK7mso0Ixzf43C2nSiVnq11+7DEhAIOFZJA3dO9akr0cPqqSmqDY
         X6IQ==
X-Gm-Message-State: ACrzQf1CF4FmDtBq331Kqro9Ol8JA7YSmzIPEyGDTxWqXDcs253X6zj8
        aUlttzDFRp/EpUcq5UEQN48qIscoisLkxA==
X-Google-Smtp-Source: AA6agR6BOBFIuZeOZ9iAMlXUlWoef1tCTJmbYlf1iQLWoOVR7QaGE62MCRVaClWF8KRg3huhYMKr2Q==
X-Received: by 2002:a17:90a:a003:b0:200:7642:a6e5 with SMTP id q3-20020a17090aa00300b002007642a6e5mr13883650pjp.10.1663299276745;
        Thu, 15 Sep 2022 20:34:36 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 2-20020a621902000000b0054aa69bc192sm437885pfz.72.2022.09.15.20.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 20:34:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next 1/1] ip: add NLM_F_ECHO support
Date:   Fri, 16 Sep 2022 11:34:28 +0800
Message-Id: <20220916033428.400131-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916033428.400131-1-liuhangbin@gmail.com>
References: <20220916033428.400131-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user space configures the kernel with netlink messages, it can set the
NLM_F_ECHO flag to request the kernel to send the applied configuration back
to the caller. This allows user space to retrieve configuration information
that are filled by the kernel (either because these parameters can only be
set by the kernel or because user space let the kernel choose a default
value).

NLM_F_ACK is also supplied incase the kernel doesn't support NLM_F_ECHO
and we will wait for the reply forever. Just like the update in
iplink.c, which I plan to post a patch to kernel later.

A new parameter -echo is added when user want to get feedback from kernel.
e.g.

  # ip -echo addr add 192.168.0.1/24 dev eth1
  3: eth1    inet 192.168.0.1/24 scope global eth1
         valid_lft forever preferred_lft forever
  # ip -j -p -echo addr del 192.168.0.1/24 dev eth1
  [ {
          "deleted": true,
          "index": 3,
          "dev": "eth1",
          "family": "inet",
          "local": "192.168.0.1",
          "prefixlen": 24,
          "scope": "global",
          "label": "eth1",
          "valid_life_time": 4294967295,
          "preferred_life_time": 4294967295
      } ]

Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/utils.h |  1 +
 ip/ip.c         |  3 +++
 ip/ipaddress.c  | 23 +++++++++++++++++++++--
 ip/iplink.c     | 20 +++++++++++++++++++-
 ip/ipnexthop.c  | 21 ++++++++++++++++++++-
 ip/iproute.c    | 21 ++++++++++++++++++++-
 ip/iprule.c     | 21 ++++++++++++++++++++-
 man/man8/ip.8   |  4 ++++
 8 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index eeb23a64..2eb80b3e 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -36,6 +36,7 @@ extern int max_flush_loops;
 extern int batch_mode;
 extern int numeric;
 extern bool do_all;
+extern int echo_request;
 
 #ifndef CONFDIR
 #define CONFDIR		"/etc/iproute2"
diff --git a/ip/ip.c b/ip/ip.c
index 82282bab..863e42aa 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -39,6 +39,7 @@ int oneline;
 int brief;
 int json;
 int timestamp;
+int echo_request;
 int force;
 int max_flush_loops = 10;
 int batch_mode;
@@ -293,6 +294,8 @@ int main(int argc, char **argv)
 			++numeric;
 		} else if (matches(opt, "-all") == 0) {
 			do_all = true;
+		} else if (strcmp(opt, "-echo") == 0) {
+			++echo_request;
 		} else {
 			fprintf(stderr,
 				"Option \"%s\" is unknown, try \"ip -help\".\n",
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 45955e1c..3a30c9c0 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1586,7 +1586,7 @@ int print_addrinfo(struct nlmsghdr *n, void *arg)
 	if (!brief) {
 		const char *name;
 
-		if (filter.oneline || filter.flushb) {
+		if (filter.oneline || filter.flushb || echo_request) {
 			const char *dev = ll_index_to_name(ifa->ifa_index);
 
 			if (is_json_context()) {
@@ -2416,6 +2416,11 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 	__u32 preferred_lft = INFINITY_LIFE_TIME;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
 	unsigned int ifa_flags = 0;
+	struct nlmsghdr *answer;
+	int ret;
+
+	if (echo_request)
+		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "peer") == 0 ||
@@ -2597,9 +2602,23 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 		return -1;
 	}
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (echo_request)
+		ret = rtnl_talk(&rth, &req.n, &answer);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret < 0)
 		return -2;
 
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_addrinfo(answer, stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
 	return 0;
 }
 
diff --git a/ip/iplink.c b/ip/iplink.c
index b98c1694..15214f47 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1073,12 +1073,16 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.i.ifi_family = preferred_family,
 	};
+	struct nlmsghdr *answer;
 	int ret;
 
 	ret = iplink_parse(argc, argv, &req, &type);
 	if (ret < 0)
 		return ret;
 
+	if (echo_request)
+		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
+
 	if (type) {
 		struct link_util *lu;
 		struct rtattr *linkinfo;
@@ -1123,9 +1127,23 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 		return -1;
 	}
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (echo_request)
+		ret = rtnl_talk(&rth, &req.n, &answer);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret < 0)
 		return -2;
 
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_linkinfo(answer, stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
 	/* remove device from cache; next use can refresh with new data */
 	ll_drop_by_index(req.i.ifi_index);
 
diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 2f448449..7523e490 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -919,7 +919,12 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.nhm.nh_family = preferred_family,
 	};
+	struct nlmsghdr *answer;
 	__u32 nh_flags = 0;
+	int ret;
+
+	if (echo_request)
+		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
 
 	while (argc > 0) {
 		if (!strcmp(*argv, "id")) {
@@ -999,9 +1004,23 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
 	req.nhm.nh_flags = nh_flags;
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (echo_request)
+		ret = rtnl_talk(&rth, &req.n, &answer);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret < 0)
 		return -2;
 
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_nexthop_nocache(answer, (void *)stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
 	return 0;
 }
 
diff --git a/ip/iproute.c b/ip/iproute.c
index a1cdf953..42035d21 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1121,6 +1121,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	};
 	char  mxbuf[256];
 	struct rtattr *mxrta = (void *)mxbuf;
+	struct nlmsghdr *answer;
 	unsigned int mxlock = 0;
 	char  *d = NULL;
 	int gw_ok = 0;
@@ -1131,6 +1132,7 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	int raw = 0;
 	int type_ok = 0;
 	__u32 nhid = 0;
+	int ret;
 
 	if (cmd != RTM_DELROUTE) {
 		req.r.rtm_protocol = RTPROT_BOOT;
@@ -1138,6 +1140,9 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 		req.r.rtm_type = RTN_UNICAST;
 	}
 
+	if (echo_request)
+		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
+
 	mxrta->rta_type = RTA_METRICS;
 	mxrta->rta_len = RTA_LENGTH(0);
 
@@ -1584,9 +1589,23 @@ static int iproute_modify(int cmd, unsigned int flags, int argc, char **argv)
 	if (!type_ok && req.r.rtm_family == AF_MPLS)
 		req.r.rtm_type = RTN_UNICAST;
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (echo_request)
+		ret = rtnl_talk(&rth, &req.n, &answer);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret < 0)
 		return -2;
 
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_route(answer, (void *)stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
 	return 0;
 }
 
diff --git a/ip/iprule.c b/ip/iprule.c
index 2d39e01b..2b4ce7fa 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -787,6 +787,11 @@ static int iprule_modify(int cmd, int argc, char **argv)
 		.frh.family = preferred_family,
 		.frh.action = FR_ACT_UNSPEC,
 	};
+	struct nlmsghdr *answer;
+	int ret;
+
+	if (echo_request)
+		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;
 
 	if (cmd == RTM_NEWRULE) {
 		if (argc == 0) {
@@ -1016,9 +1021,23 @@ static int iprule_modify(int cmd, int argc, char **argv)
 	if (!table_ok && cmd == RTM_NEWRULE)
 		req.frh.table = RT_TABLE_MAIN;
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (echo_request)
+		ret = rtnl_talk(&rth, &req.n, &answer);
+	else
+		ret = rtnl_talk(&rth, &req.n, NULL);
+
+	if (ret < 0)
 		return -2;
 
+	if (echo_request) {
+		new_json_obj(json);
+		open_json_object(NULL);
+		print_rule(answer, stdout);
+		close_json_object();
+		delete_json_obj();
+		free(answer);
+	}
+
 	return 0;
 }
 
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index f6adbc77..72227d44 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -237,6 +237,10 @@ The default JSON format is compact and more efficient to parse but
 hard for most users to read.  This flag adds indentation for
 readability.
 
+.TP
+.BR "\-echo"
+Request the kernel to send the applied configuration back.
+
 .SH IP - COMMAND SYNTAX
 
 .SS
-- 
2.37.2

