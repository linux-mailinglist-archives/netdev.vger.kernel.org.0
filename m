Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE406E4A8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfGSLDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:03:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39304 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGSLDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:03:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so18261717wmc.4
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9qps2IpxsbsIM+k8oDH4R3gAqJbdv28ekXuIbYkxeI=;
        b=JKUbLO4fOcNfl70sfOHVw4RGhRyph/p/yI9CnuBFwnr63bVv9fZimGok5WlFWFfPgI
         BTqvOdIotQktkClxglAUOb9XGeViHyRA1L8aWe3FxTsfQQfgBRacKnW5BZlxlobG7vEu
         hz8y8MgWikRvZmVrAvjZbq0Hibe2n7mbuszhdnB4h3qA9zqmxDVeFvd202jxE1e0rz0E
         Czb09eT8DrQDvglEV7N7SjTULWt5Gx2RkzBsh7Pf7s5BvZUKbi6q4koZDWLcwewmAmOp
         SjYgfBe2baiuYzeO90FqbzEg/DD/qBhtqI6IqIkVvEinrUr3k7SCXdao1q3GBlpid3Gf
         sh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9qps2IpxsbsIM+k8oDH4R3gAqJbdv28ekXuIbYkxeI=;
        b=VyRGFy3x42AFsBbwRAZzbbhO9wrQkzH8RFT25JR9EDgjthSO725N4xtxmTdSKejn8w
         DruKBFXlsc41ADpDWATX75EDwsrmzl4f0cbPOXwj5SXcW2Fb/9YUE+roef0acAWFlIqO
         qkMc1cH1sHje5wXqegiiKx5c0SK570wimYEhvrcypoXgkTjgDAKt7D8wr+2OPabKW3bx
         m8F2gkzumZpqUIbIUbiz9ymd6WaonVcVPHlOmDlBCZM8akxpzLMfckvk9RSWKx2d6CIm
         H+DT913PA9koul+qyv7JZflzqIWolJI8ZOyiSuAdPCWmeMRoOHzZWeCQfWytar6Y+dm4
         uK3A==
X-Gm-Message-State: APjAAAXpBIkwcXzkegrXJgc/TMhY3i734bJ9ute871vGFd9pBxvGmEFv
        nFBG0FkJuU792hi+LO5tcKnURhpJ
X-Google-Smtp-Source: APXvYqzCHX6bG+tI6rVKMDDHemsXPsaEbhbeFADz/VSV7bm2jD/ko9rhEtOZ+beSsWA2zh/V5eakXg==
X-Received: by 2002:a1c:99c6:: with SMTP id b189mr37968671wme.57.1563534190779;
        Fri, 19 Jul 2019 04:03:10 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id s63sm26145419wme.17.2019.07.19.04.03.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:03:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch iproute2 rfc 1/2] ip: add support for alternative name addition/deletion/list
Date:   Fri, 19 Jul 2019 13:03:08 +0200
Message-Id: <20190719110309.29731-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/if_link.h   |  3 ++
 include/uapi/linux/rtnetlink.h |  7 +++
 include/utils.h                |  1 +
 ip/ipaddress.c                 | 14 ++++++
 ip/iplink.c                    | 81 ++++++++++++++++++++++++++++++++++
 lib/utils.c                    | 19 +++++---
 6 files changed, 120 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d36919fb4024..2386a3e94082 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,9 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_ALT_IFNAME_MOD, /* Alternative ifname to add/delete */
+	IFLA_ALT_IFNAME_LIST, /* nest */
+	IFLA_ALT_IFNAME, /* Alternative ifname */
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 358e83ee134d..38a4f5b55e17 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -164,6 +164,13 @@ enum {
 	RTM_GETNEXTHOP,
 #define RTM_GETNEXTHOP	RTM_GETNEXTHOP
 
+	RTM_NEWALTIFNAME = 108,
+#define RTM_NEWALTIFNAME	RTM_NEWALTIFNAME
+	RTM_DELALTIFNAME,
+#define RTM_DELALTIFNAME	RTM_DELALTIFNAME
+	RTM_GETALTIFNAME,
+#define RTM_GETALTIFNAME	RTM_GETALTIFNAME
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/include/utils.h b/include/utils.h
index 794d36053634..2dd6443fc6ff 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -196,6 +196,7 @@ void duparg(const char *, const char *) __attribute__((noreturn));
 void duparg2(const char *, const char *) __attribute__((noreturn));
 int nodev(const char *dev);
 int check_ifname(const char *);
+int check_altifname(const char *);
 int get_ifname(char *, const char *);
 const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
 bool matches(const char *prefix, const char *string);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index bc8f5ba13c33..8060161dcf1a 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1139,6 +1139,20 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		close_json_array(PRINT_JSON, NULL);
 	}
 
+	if (tb[IFLA_ALT_IFNAME_LIST]) {
+		struct rtattr *i, *alt_ifname_list = tb[IFLA_ALT_IFNAME_LIST];
+		int rem = RTA_PAYLOAD(alt_ifname_list);
+
+		open_json_array(PRINT_JSON, "altifnames");
+		for (i = RTA_DATA(alt_ifname_list); RTA_OK(i, rem);
+		     i = RTA_NEXT(i, rem)) {
+			print_nl();
+			print_string(PRINT_ANY, NULL,
+				     "    altname %s", rta_getattr_str(i));
+		}
+		close_json_array(PRINT_JSON, NULL);
+	}
+
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	fflush(fp);
 	return 1;
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088535da..45f975f1dce9 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1617,6 +1617,84 @@ static int iplink_afstats(int argc, char **argv)
 	return 0;
 }
 
+static int iplink_altname_mod(int argc, char **argv, struct iplink_req *req)
+{
+	char *name = NULL;
+	char *dev = NULL;
+
+	while (argc > 0) {
+		if (matches(*argv, "name") == 0) {
+			NEXT_ARG();
+			if (check_altifname(*argv))
+				invarg("not a valid altifname", *argv);
+			name = *argv;
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			if (strcmp(*argv, "dev") == 0)
+				NEXT_ARG();
+			if (dev)
+				duparg2("dev", *argv);
+			if (check_altifname(*argv))
+				invarg("\"dev\" not a valid altifname", *argv);
+			dev = *argv;
+		}
+		argv++; argc--;
+	}
+
+	if (!dev) {
+		fprintf(stderr, "Not enough of information: \"dev\" argument is required.\n");
+		exit(-1);
+	}
+
+	if (!name) {
+		if (req->n.nlmsg_type != RTM_NEWALTIFNAME) {
+			name = dev;
+		} else {
+			fprintf(stderr, "Not enough of information: \"name\" argument is required.\n");
+			exit(-1);
+		}
+	}
+
+	addattr_l(&req->n, sizeof(*req), IFLA_ALT_IFNAME,
+		  dev, strlen(dev) + 1);
+	addattr_l(&req->n, sizeof(*req), IFLA_ALT_IFNAME_MOD,
+		  name, strlen(name) + 1);
+
+	if (rtnl_talk(&rth, &req->n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
+static int iplink_altname(int argc, char **argv)
+{
+	struct iplink_req req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.i.ifi_family = preferred_family,
+	};
+
+	if (argc <= 0) {
+		usage();
+		exit(-1);
+	}
+
+	if (matches(*argv, "add") == 0) {
+		req.n.nlmsg_flags |= NLM_F_EXCL | NLM_F_CREATE | NLM_F_APPEND;
+		req.n.nlmsg_type = RTM_NEWALTIFNAME;
+	} else if (matches(*argv, "del") == 0) {
+		req.n.nlmsg_flags |= RTM_DELLINK;
+		req.n.nlmsg_type = RTM_DELALTIFNAME;
+	} else if (matches(*argv, "help") == 0) {
+		usage();
+	} else {
+		fprintf(stderr, "Operator required\n");
+		exit(-1);
+	}
+	return iplink_altname_mod(argc - 1, argv + 1, &req);
+}
+
 static void do_help(int argc, char **argv)
 {
 	struct link_util *lu = NULL;
@@ -1674,6 +1752,9 @@ int do_iplink(int argc, char **argv)
 		return 0;
 	}
 
+	if (matches(*argv, "altname") == 0)
+		return iplink_altname(argc-1, argv+1);
+
 	if (matches(*argv, "help") == 0) {
 		do_help(argc-1, argv+1);
 		return 0;
diff --git a/lib/utils.c b/lib/utils.c
index 9ea21fa16503..80e025e96a5a 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -824,14 +824,10 @@ int nodev(const char *dev)
 	return -1;
 }
 
-int check_ifname(const char *name)
+static int __check_ifname(const char *name)
 {
-	/* These checks mimic kernel checks in dev_valid_name */
 	if (*name == '\0')
 		return -1;
-	if (strlen(name) >= IFNAMSIZ)
-		return -1;
-
 	while (*name) {
 		if (*name == '/' || isspace(*name))
 			return -1;
@@ -840,6 +836,19 @@ int check_ifname(const char *name)
 	return 0;
 }
 
+int check_ifname(const char *name)
+{
+	/* These checks mimic kernel checks in dev_valid_name */
+	if (strlen(name) >= IFNAMSIZ)
+		return -1;
+	return __check_ifname(name);
+}
+
+int check_altifname(const char *name)
+{
+	return __check_ifname(name);
+}
+
 /* buf is assumed to be IFNAMSIZ */
 int get_ifname(char *buf, const char *name)
 {
-- 
2.21.0

