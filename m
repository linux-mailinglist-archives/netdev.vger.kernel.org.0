Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7183DD0F29
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfJIMtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:49:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35517 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbfJIMtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:49:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so2841319wrt.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+BpoA6ER0vfkjzQjASGdggR6UxT5IEBMRd0gIr7WGs=;
        b=lA3IxJGO+RhxvroAYc/WkCbEpRMR+6GD4kYoDpUS422uSComiB3p9wZQ4pU3alrNrq
         DAx6bbltVDi6vvzipcz9f0eXDeez+ET/KIPzVmsRjPv6MdjdsNQFNXQmfFENHYI9h0+G
         PMty9tOxKWvbhAx7wO8qXqO/JHzp+oxnYQfAHdQ5Dlafi5/GTNqczR8WU1ShvG9/hOt9
         h9lq/zSwJbvtgLS0QuJo/fQAuC28D1yB/hbINeb2CZ2Ayh9h9q2SBAGigRlXYjIas3fu
         gBFDZ/4cnW/ewLdkIhbu9xBA3aSMvIATp7XYIJBTkCQdfCdUaCIldpTT0mjvU/A0KUFb
         V3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+BpoA6ER0vfkjzQjASGdggR6UxT5IEBMRd0gIr7WGs=;
        b=bRPsm/JxkNGzmNxFU6mmEBRRBCvQpJ9yxZpoZdDIp/RAYPeHnhahgKXZFayCSzw6lO
         4uiJCHTCMNlIZp4tJTg3f6kvpESbV0khgFJsP23HI28o8PPGOZaUA9eCTHM2Tooz5nsd
         +dxNlbtXeRgXQ7zO9bFxRiM3Pjr5FYXWYGKQe9M7yNWaMgJtJKX/md7uDXQj3hPqz4Un
         t97PtYz0Oo04f6J8fJcyso7PdXZqJZdYgHrLeqaTo5o/KPfrMkCIy8+Y4JDtjO17P/qI
         C6IO4wpi2giPGf8TmQ/5IMWuDUr2UMfPZqQyCdkJ71h7KQciTY6kCLBL0rbSbvIkTFlF
         fZYg==
X-Gm-Message-State: APjAAAULcOqvA6OsukfS/x3x/HLgSPK/nF/KGBWmEFTHWc6pa98+NlLt
        9dNPc45ioS2BOqFAUFDj2zO94+0iGDk=
X-Google-Smtp-Source: APXvYqxOPv6Y+ImURcehQt0UzhXm6SK8R4N78/Ur4BhyGyfI/oAx8Qt9nQxyybvyBNdUZf7LpWqq1w==
X-Received: by 2002:adf:a141:: with SMTP id r1mr2865837wrr.122.1570625389560;
        Wed, 09 Oct 2019 05:49:49 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id n7sm2175142wrt.59.2019.10.09.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:49:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v3 1/2] ip: add support for alternative name addition/deletion/list
Date:   Wed,  9 Oct 2019 14:49:46 +0200
Message-Id: <20191009124947.27175-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191009124947.27175-1-jiri@resnulli.us>
References: <20191009124947.27175-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement addition/deletion of lists of properties, currently
alternative ifnames. Also extent the ip link show command to list them.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- s/prop/property/ on cmdline
- removed RTM_DELLINK flag set
v1->v2:
- s/\"NULL\"/NULL/ in print_string arg
rfc->v1:
- convert to generic property lists
- added patch description
- use ll_name_to_index() and ifindex as handle
- fixed parsing with nested flag on
- adjusted output
- added arg name to check_altifname header prototype
- added help and man parts
---
 include/utils.h       |  1 +
 ip/ipaddress.c        | 20 +++++++++--
 ip/iplink.c           | 81 ++++++++++++++++++++++++++++++++++++++++++-
 lib/utils.c           | 19 +++++++---
 man/man8/ip-link.8.in | 11 ++++++
 5 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 794d36053634..001491a1eb40 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -196,6 +196,7 @@ void duparg(const char *, const char *) __attribute__((noreturn));
 void duparg2(const char *, const char *) __attribute__((noreturn));
 int nodev(const char *dev);
 int check_ifname(const char *);
+int check_altifname(const char *name);
 int get_ifname(char *, const char *);
 const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
 bool matches(const char *prefix, const char *string);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index bc8f5ba13c33..b72eb7a1f808 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -879,7 +879,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	if (filter.up && !(ifi->ifi_flags&IFF_UP))
 		return -1;
 
-	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifi), len);
+	parse_rtattr_flags(tb, IFLA_MAX, IFLA_RTA(ifi), len, NLA_F_NESTED);
 
 	name = get_ifname_rta(ifi->ifi_index, tb[IFLA_IFNAME]);
 	if (!name)
@@ -1139,7 +1139,23 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		close_json_array(PRINT_JSON, NULL);
 	}
 
-	print_string(PRINT_FP, NULL, "%s", "\n");
+	if (tb[IFLA_PROP_LIST]) {
+		struct rtattr *i, *proplist = tb[IFLA_PROP_LIST];
+		int rem = RTA_PAYLOAD(proplist);
+
+		open_json_array(PRINT_JSON, "altnames");
+		for (i = RTA_DATA(proplist); RTA_OK(i, rem);
+		     i = RTA_NEXT(i, rem)) {
+			if (i->rta_type != IFLA_ALT_IFNAME)
+				continue;
+			print_string(PRINT_FP, NULL, "%s    altname ", _SL_);
+			print_string(PRINT_ANY, NULL,
+				     "%s", rta_getattr_str(i));
+		}
+		close_json_array(PRINT_JSON, NULL);
+	}
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
 	fflush(fp);
 	return 1;
 }
diff --git a/ip/iplink.c b/ip/iplink.c
index 212a088535da..bf90fad1b3ea 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -111,7 +111,9 @@ void iplink_usage(void)
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
-		"	ip link afstats [ dev DEVICE ]\n");
+		"	ip link afstats [ dev DEVICE ]\n"
+		"	ip link property add dev DEVICE [ altname NAME .. ]\n"
+		"	ip link property del dev DEVICE [ altname NAME .. ]\n");
 
 	if (iplink_have_newlink()) {
 		fprintf(stderr,
@@ -1617,6 +1619,80 @@ static int iplink_afstats(int argc, char **argv)
 	return 0;
 }
 
+static int iplink_prop_mod(int argc, char **argv, struct iplink_req *req)
+{
+	struct rtattr *proplist;
+	char *dev = NULL;
+	char *name;
+
+	proplist = addattr_nest(&req->n, sizeof(*req),
+				IFLA_PROP_LIST | NLA_F_NESTED);
+
+	while (argc > 0) {
+		if (matches(*argv, "altname") == 0) {
+			NEXT_ARG();
+			if (check_altifname(*argv))
+				invarg("not a valid altname", *argv);
+			name = *argv;
+			addattr_l(&req->n, sizeof(*req), IFLA_ALT_IFNAME,
+				  name, strlen(name) + 1);
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			if (strcmp(*argv, "dev") == 0)
+				NEXT_ARG();
+			if (dev)
+				duparg2("dev", *argv);
+			if (check_altifname(*argv))
+				invarg("\"dev\" not a valid ifname", *argv);
+			dev = *argv;
+		}
+		argv++; argc--;
+	}
+	addattr_nest_end(&req->n, proplist);
+
+	if (!dev) {
+		fprintf(stderr, "Not enough of information: \"dev\" argument is required.\n");
+		exit(-1);
+	}
+
+	req->i.ifi_index = ll_name_to_index(dev);
+	if (!req->i.ifi_index)
+		return nodev(dev);
+
+	if (rtnl_talk(&rth, &req->n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
+static int iplink_prop(int argc, char **argv)
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
+		req.n.nlmsg_type = RTM_NEWLINKPROP;
+	} else if (matches(*argv, "del") == 0) {
+		req.n.nlmsg_type = RTM_DELLINKPROP;
+	} else if (matches(*argv, "help") == 0) {
+		usage();
+	} else {
+		fprintf(stderr, "Operator required\n");
+		exit(-1);
+	}
+	return iplink_prop_mod(argc - 1, argv + 1, &req);
+}
+
 static void do_help(int argc, char **argv)
 {
 	struct link_util *lu = NULL;
@@ -1674,6 +1750,9 @@ int do_iplink(int argc, char **argv)
 		return 0;
 	}
 
+	if (matches(*argv, "property") == 0)
+		return iplink_prop(argc-1, argv+1);
+
 	if (matches(*argv, "help") == 0) {
 		do_help(argc-1, argv+1);
 		return 0;
diff --git a/lib/utils.c b/lib/utils.c
index 95d46ff210aa..bbb3bdcfa80b 100644
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
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d2b097..f800a18a45fc 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -244,6 +244,17 @@ ip-link \- network device configuration
 .IR VLAN-QOS " ] ["
 .B proto
 .IR VLAN-PROTO " ] ]"
+.in -8
+
+.ti -8
+.BI "ip link property add"
+.RB "[ " altname
+.IR NAME " .. ]"
+
+.ti -8
+.BI "ip link property del"
+.RB "[ " altname
+.IR NAME " .. ]"
 
 .SH "DESCRIPTION"
 .SS ip link add - add virtual link
-- 
2.21.0

