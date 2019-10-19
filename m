Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7164DDD9CE
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfJSRh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 13:37:56 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:33693 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfJSRh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 13:37:56 -0400
Received: by mail-wr1-f47.google.com with SMTP id s1so658514wro.0
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 10:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+BpoA6ER0vfkjzQjASGdggR6UxT5IEBMRd0gIr7WGs=;
        b=VrKVoOxEFsExgI/7jiAlV6NcbmeucMk8Zwpue/Ol9Y6Z45vFPD6OeH37BZF88zZtuv
         SUVZc3isYgOrwzjgNn4RldIN9kuwsebZXFGFkATXenYVrmY7MaRLzQt0/QrvErEYVksS
         HgsWk+CwDVjc4qmpjzXragT/mY44uB3IreactQLOiUjiOdcrFnI/FEMlexv4VwLBiR4v
         dueuLv6MMeQueBUXVnlJubpH1iH6VbvDGVLn0O3jkXf6YGyWuK1wX3XbD/BFvOryq7bt
         YRmPRuNi2P25YItrRSfL6f+xMVv5OVnSncCVl9WgfkYQmq66gRmJi9MHKMmwl6o84F7w
         eKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+BpoA6ER0vfkjzQjASGdggR6UxT5IEBMRd0gIr7WGs=;
        b=YH1ke3e1S4LB4ygIW14/L1eI7h0mINu1Hp3ZgVX0IcdkUGFx2q/pWWhx6gTp1ViWYu
         D/oFMCtLnog8kw+WpHQOsJPYeaYu3lGzBQFlfv31mXF1jrAnW1tHEmH7bM7yD8xxzXkO
         aePjwEF8urEHLX+3N/Muoup7p7pSHCVew5RoiZOA6xh1L8dzg9k36MU5M6sFXhaMb5tX
         eOoMd7CxMzo1ujYRkNsQk9uqsHrSfT122GiaewuELKNiQu36fd6TnYQfnM5aBM0TDbfL
         /QJSH2AFka/OlYYr8iLQHP9PdVzbhJ+asfiERkokFYtueLEtPGg4nEDMEz3w3C51mVRw
         y4rw==
X-Gm-Message-State: APjAAAUB+jI9BQ8PPd6AL388ZLR1xSYb+4wBGq9lb8YzIgu1Zako+OXO
        Xl8CQDC/snlIklJ3qC8WNatuxvOqi3w=
X-Google-Smtp-Source: APXvYqwnlFC0flYGboJtpdZ4Fbf1IKyXOt+bfIfpAYRgTJWGolIn6nICdlz1yj4ivdEgzOxtwhebsQ==
X-Received: by 2002:adf:f30b:: with SMTP id i11mr11658393wro.377.1571506672879;
        Sat, 19 Oct 2019 10:37:52 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z1sm9246236wrn.57.2019.10.19.10.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 10:37:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v4 2/3] ip: add support for alternative name addition/deletion/list
Date:   Sat, 19 Oct 2019 19:37:48 +0200
Message-Id: <20191019173749.19068-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191019173749.19068-1-jiri@resnulli.us>
References: <20191019173749.19068-1-jiri@resnulli.us>
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

