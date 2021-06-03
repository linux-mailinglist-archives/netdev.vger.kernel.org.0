Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7835F399963
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFCExI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:53:08 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:40532 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhFCExH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:53:07 -0400
Received: by mail-lj1-f177.google.com with SMTP id u22so5456397ljh.7;
        Wed, 02 Jun 2021 21:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYTcTtjZwGkx5E7kMKtJMXD4K6b64JEpdLABcMx78NQ=;
        b=CE20pSVwKLwe7CY/XHFAmVU/OGPJ1uYvAa5X7lrCRdoABAeS7Je4SFHfTB5NfhsCmW
         vEONblUWTJXMiT3oxhnPi0xC1/J4f763+SxVwc+oJXixTzglFTG4nx8kgrmjRZMi/2+G
         PagoyLwd8oPUTmRQO3hnBH0q9e7LjcDheePB48nWthXxMwoQq4OkSbSSz8eR6DlODnnB
         2Cg7ky2n8lZDIurXOKzwN1NcHaAjFzDg3I3qrdf5WHXn1qcdLnoWuyGXZnNA52WPsI3i
         fWkinYm4mbxSfl9M+n8dDxOutUyt0HNKdFoIDqp42hwtkl2WVyTpWml4FRpWxL7eVQMC
         s7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYTcTtjZwGkx5E7kMKtJMXD4K6b64JEpdLABcMx78NQ=;
        b=S5VKyaoDFt4rX8b2NO8Dd0MTzxVFaF3fiRNe3SKfTvnXm06aPtZxMHDDGmY3EbpwvO
         AN+5VSBKM2egDoxh13sLe6oAJZpj1BoiRmw06Y3h+sY82n+kL0nR/lInFWkYnj73dAm/
         hGDizP8HnO8gFweBODxCyV4nB2qHNMPSy/pEwX7EC2CumL/O7xKQybqqXQmi4Z6/uVEh
         NeQzIHgMbU5CWJhtvPRHYhbABwiyxOCwpbfp6gO4lM6JuEau9YFCtWsA16RJ8NemN/5e
         DWjneOlgx1mMQvoTfRCDOsPEKBU1BvsV06a1qxUacDYHpBAAX3oCO5nxzGZjq9HQoncm
         6cHA==
X-Gm-Message-State: AOAM53321BaYey4sZH+s7S6blCNfwsvJ0VZQzFgCH6JJIHmlsgTOKi+I
        7zzKPDTLJ+wyQLY9y+QShkw=
X-Google-Smtp-Source: ABdhPJxjQj5PILjjPSo6RIe5dOO5A4V7v+EFF0penkxLQ28ZVWlzKCeBAf7hMn9J/xVqAazTPq3C4A==
X-Received: by 2002:a2e:5cc4:: with SMTP id q187mr5100292ljb.177.1622695808920;
        Wed, 02 Jun 2021 21:50:08 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:08 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 6/6 iproute2] iplink: support for WWAN devices
Date:   Thu,  3 Jun 2021 07:49:54 +0300
Message-Id: <20210603044954.8091-7-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN subsystem has been extended to generalize the per data channel
network interfaces management. This change implements support for WWAN
links handling. And actively uses the earlier introduced ip-link
capability to specify the parent by its device name.

The WWAN interface for a new data channel should be created with a
command like this:

ip link add dev wwan0-2 parentdev-name wwan0 type wwan linkid 2

Where: wwan0 is the modem HW device name (should be taken from
/sys/class/wwan) and linkid is an identifier of the opened data
channel.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 ip/Makefile      |  2 +-
 ip/iplink.c      |  3 +-
 ip/iplink_wwan.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_wwan.c

diff --git a/ip/Makefile b/ip/Makefile
index 4cad619c..b03af29b 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o ipmptcp.o iplink_bareudp.o
+    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 190ce7d9..4073d6e8 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -56,7 +56,8 @@ void iplink_types_usage(void)
 		"          ipip | ipoib | ipvlan | ipvtap |\n"
 		"          macsec | macvlan | macvtap |\n"
 		"          netdevsim | nlmon | rmnet | sit | team | team_slave |\n"
-		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | xfrm }\n");
+		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | wwan |\n"
+		"          xfrm }\n");
 }
 
 void iplink_usage(void)
diff --git a/ip/iplink_wwan.c b/ip/iplink_wwan.c
new file mode 100644
index 00000000..3510477a
--- /dev/null
+++ b/ip/iplink_wwan.c
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdio.h>
+#include <linux/netlink.h>
+#include <linux/wwan.h>
+
+#include "utils.h"
+#include "ip_common.h"
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... wwan linkid LINKID\n"
+		"\n"
+		"Where: LINKID := 0-4294967295\n"
+	);
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static int wwan_parse_opt(struct link_util *lu, int argc, char **argv,
+			  struct nlmsghdr *n)
+{
+	while (argc > 0) {
+		if (matches(*argv, "linkid") == 0) {
+			__u32 linkid;
+
+			NEXT_ARG();
+			if (get_u32(&linkid, *argv, 0))
+				invarg("linkid", *argv);
+			addattr32(n, 1024, IFLA_WWAN_LINK_ID, linkid);
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "wwan: unknown command \"%s\"?\n",
+				*argv);
+			explain();
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	return 0;
+}
+
+static void wwan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+	if (!tb)
+		return;
+
+	if (tb[IFLA_WWAN_LINK_ID])
+		print_uint(PRINT_ANY, "linkid", "linkid %u ",
+			   rta_getattr_u32(tb[IFLA_WWAN_LINK_ID]));
+}
+
+static void wwan_print_help(struct link_util *lu, int argc, char **argv,
+			    FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util wwan_link_util = {
+	.id		= "wwan",
+	.maxattr	= IFLA_WWAN_MAX,
+	.parse_opt	= wwan_parse_opt,
+	.print_opt	= wwan_print_opt,
+	.print_help	= wwan_print_help,
+};
-- 
2.26.3

