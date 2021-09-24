Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9523E416A71
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 05:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbhIXDes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 23:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243927AbhIXDer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 23:34:47 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86742C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 20:33:15 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id a3so12678025oid.6
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 20:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8g1HntPwXofOZfAfceUHenxROe42qpNbAXrw7y59eUc=;
        b=Ltw9t4U1qK32ZZdSbEQQ2IlHcGJnSSMWCDooKNwBdvbewxc27mS+9s+zQxzDppwQfF
         dekHbdkmYbhtYPYcT+YcsrmS0y3QXxyAutcHt6OBgg+IpSinPPzRIjGzKBbaA0G6RLKg
         eACEpRkqYTnWpWIxGk4QYQaqfXNs9YYB7zhX3dJcnZghd3dw6pa+mNCNHFtkqBOfssh0
         dVvozpFNrnfxw5L7Dysl1OyxR9M8+rwxa5hFIIusPynMngLYYc5bOlVexV+IM36w8Xpg
         52qlHXv75ZPbWSUuGNKrzlQ0DTdidEyWlZNKhYZ0NxthqoMlx3O5Ap62ach3fQGra0sJ
         m8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8g1HntPwXofOZfAfceUHenxROe42qpNbAXrw7y59eUc=;
        b=fIRIr2yYwj3S2ZmClwpbjHjZ7sM58GDPGDGeFLD9QCFOrxUwWlQu3j9p9ucRRWaVro
         Zz9PfA2ymEVmC8IvkRZR3FBHI/M2dYMzXJQzesBxZe3SiygFjtiYLW2c0T02nigyXcMp
         H/a9RmH1btTg5j1aVmKm0A2aUTzuou0veaQwGUn2020myQVbYkC+QYdt18jlkIQmz7ce
         ET9KuJux1k4zizYRvKk7bzldVjXcsvW3Y2IuNaIl+2mjvdpVxOyHanxqtr+qv13RI1Ef
         KZQcByeyS5xHIrAL78TpGaJ2zFi15rqehGAqqCNCUByh371q4bn1NaBWHKyq/yVFHEUE
         VgJQ==
X-Gm-Message-State: AOAM533IMW9x5/7ahJABGTF8Ycs+wcmnDc0mQvnkmZ0wOIYqyxGOWIdP
        2T9njO6zjTQoqp+mmlQw3ri2o3kSOFEqPg==
X-Google-Smtp-Source: ABdhPJy0x9xrM8UNnxjWuxCK6uZICnad57CnxtCly+5PZcfLoo3rNXIUhy432IDWOexciAR1h1VIeQ==
X-Received: by 2002:aca:e142:: with SMTP id y63mr6589052oig.112.1632454394783;
        Thu, 23 Sep 2021 20:33:14 -0700 (PDT)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id d68sm103984otb.55.2021.09.23.20.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 20:33:14 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Daniele Palmas <dnlplm@gmail.com>, Alex Elder <elder@linaro.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
Date:   Thu, 23 Sep 2021 20:33:51 -0700
Message-Id: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the rmnet option parser to allow enabling and disabling
IFLA_RMNET_FLAGS using ip link and add the flags to the pint_op to allow
inspecting the current settings.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- Landed ABI change to allow setting/clearing individual bits
- Changed parser to take on/off arguments
- Added the new v5 chksum bits
- Made print_flags fancier, with some inspiration from iplink_vlan

 ip/iplink_rmnet.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
index 1d16440c6900..f629ca9976d9 100644
--- a/ip/iplink_rmnet.c
+++ b/ip/iplink_rmnet.c
@@ -16,6 +16,12 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... rmnet mux_id MUXID\n"
+		"                 [ingress-deaggregation { on | off } ]\n"
+		"                 [ingress-commands { on | off } ]\n"
+		"                 [ingress-chksumv4 { on | off } ]\n"
+		"                 [ingress-chksumv5 { on | off } ]\n"
+		"                 [egress-chksumv4 { on | off } ]\n"
+		"                 [egress-chksumv5 { on | off } ]\n"
 		"\n"
 		"MUXID := 1-254\n"
 	);
@@ -26,9 +32,16 @@ static void explain(void)
 	print_explain(stderr);
 }
 
+static int on_off(const char *msg, const char *arg)
+{
+	fprintf(stderr, "Error: argument of \"%s\" must be \"on\" or \"off\", not \"%s\"\n", msg, arg);
+	return -1;
+}
+
 static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			   struct nlmsghdr *n)
 {
+	struct ifla_rmnet_flags flags = { };
 	__u16 mux_id;
 
 	while (argc > 0) {
@@ -37,6 +50,60 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u16(&mux_id, *argv, 0))
 				invarg("mux_id is invalid", *argv);
 			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
+		} else if (matches(*argv, "ingress-deaggregation") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_INGRESS_DEAGGREGATION;
+			else
+				return on_off("ingress-deaggregation", *argv);
+		} else if (matches(*argv, "ingress-commands") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_COMMANDS;
+			else
+				return on_off("ingress-commands", *argv);
+		} else if (matches(*argv, "ingress-chksumv4") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
+			else
+				return on_off("ingress-chksumv4", *argv);
+		} else if (matches(*argv, "ingress-chksumv5") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_INGRESS_MAP_CKSUMV5;
+			else
+				return on_off("ingress-chksumv5", *argv);
+		} else if (matches(*argv, "egress-chksumv4") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+			else
+				return on_off("egress-chksumv4", *argv);
+		} else if (matches(*argv, "egress-chksumv5") == 0) {
+			NEXT_ARG();
+			flags.mask |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
+			if (strcmp(*argv, "on") == 0)
+				flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
+			else if (strcmp(*argv, "off") == 0)
+				flags.flags &= ~RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
+			else
+				return on_off("egress-chksumv5", *argv);
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -48,11 +115,33 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--, argv++;
 	}
 
+	if (flags.mask)
+		addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
+
 	return 0;
 }
 
+static void rmnet_print_flags(FILE *fp, __u32 flags)
+{
+	open_json_array(PRINT_ANY, is_json_context() ? "flags" : "<");
+#define _PF(f, s) if (flags & RMNET_FLAGS_##f) {			\
+		flags &= ~RMNET_FLAGS_##f;				\
+		print_string(PRINT_ANY, NULL, flags ? "%s," : "%s", s); \
+	}
+	_PF(INGRESS_DEAGGREGATION, "ingress-deaggregation");
+	_PF(INGRESS_MAP_COMMANDS, "ingress-commands");
+	_PF(INGRESS_MAP_CKSUMV4, "ingress-chksumv4");
+	_PF(INGRESS_MAP_CKSUMV5, "ingress-chksumv5");
+	_PF(EGRESS_MAP_CKSUMV4, "egress-chksumv4");
+	_PF(EGRESS_MAP_CKSUMV5, "egress-chksumv5");
+#undef _PF
+	close_json_array(PRINT_ANY, "> ");
+}
+
 static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	struct ifla_vlan_flags *flags;
+
 	if (!tb)
 		return;
 
@@ -64,6 +153,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		   "mux_id",
 		   "mux_id %u ",
 		   rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
+
+	if (tb[IFLA_RMNET_FLAGS]) {
+		if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
+			return;
+		flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
+
+		rmnet_print_flags(f, flags->flags);
+	}
 }
 
 static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.33.0

