Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD78433C052
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhCOPqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhCOPqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:46:34 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DEFC06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:46:34 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id j8so7234632otc.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4fl+whUwXBcMIK42PoE39zhmZsaj/uqEpkjHXU4Fi7g=;
        b=LONPaLYauvyl3qOugYhtN94Mdpzvg5xwHf489IwaeeZWa+OV7sOTeFSq7vjx0OuxtH
         czmjwpaF/U+Ir7MKjmLzzzU/f41J3/1ACXAvWk05P/h2YaBaiIYpFYO472H0KpQjBn0v
         kOzvWnZCt8tCZjznBekiChvq+NKPGmJckHGnUAUCEui/mj5tbp2eTVb9SgEa730Q0y7D
         Eo3WqLi4JOwPY3fYZAzzJ5ga3pjNbrEtxPagGawEVZ7z9SetwlbT1+fTbTDYO+Z1t7wu
         QJUo4cyeYCJ0eWKEkhVtWs1QztfYxunsELAK4qRrLBwHtPe++5JH9GDy6H/flLO57aLR
         zA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4fl+whUwXBcMIK42PoE39zhmZsaj/uqEpkjHXU4Fi7g=;
        b=WpKqOgPhyKgBUKDR2wfRYSwoskr8UYWYpHCUMsQOPFyPBnRSZ4Y9aHk/Chsp7sn8N+
         DZoByN9dKjrTZaQt+YJIvColfo0fYbtoDbGwsDAvbHEJPANYogzb4K6L8j4tbFhTgMRw
         AobyUyFbD1b8t53yMjQqKoGhvXTCfAQT2kQOM/c1ui7A+cjqCmE6piZLBY4yQZto3jTJ
         YXtk4KTApRGo6ElqP2EaFdEVsXtUGeVw+ZeCzyfErLLaBOLJnMeNCm6gAJd0CPIp2/kd
         XZBjSqhCqnqG8onZIN61jL5cN3+IQbMMlGQOSI7S2yGYxU/4+zuOHtCad94hbtDmY4pw
         vfTw==
X-Gm-Message-State: AOAM530j5ZUacnzMVmNOmEuwWOpyr3q+YhEO/FWJl5LzF5uifCZT80/K
        TlTjClnZkYSplj9oRR9reAwMujllY25q7g==
X-Google-Smtp-Source: ABdhPJw5Hqf2yqw6XZLT3DUI6YcFAjwuoxil6eQ9Pv6d4J+c9Oq7hKtAhmTz754TkSX3RjNejkn+/w==
X-Received: by 2002:a9d:63d6:: with SMTP id e22mr12810911otl.188.1615823193144;
        Mon, 15 Mar 2021 08:46:33 -0700 (PDT)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id h2sm7230243otn.43.2021.03.15.08.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:46:32 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
Date:   Mon, 15 Mar 2021 10:46:29 -0500
Message-Id: <20210315154629.652824-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
flags from the default of ingress-aggregate only.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- s/ifla_vlan_flags/ifla_rmnet_flags/ in print_opt

 ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
index 1d16440c6900..a847c838def2 100644
--- a/ip/iplink_rmnet.c
+++ b/ip/iplink_rmnet.c
@@ -16,6 +16,10 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... rmnet mux_id MUXID\n"
+		"                 [ingress-deaggregation]\n"
+		"                 [ingress-commands]\n"
+		"                 [ingress-chksumv4]\n"
+		"                 [egress-chksumv4]\n"
 		"\n"
 		"MUXID := 1-254\n"
 	);
@@ -29,6 +33,7 @@ static void explain(void)
 static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			   struct nlmsghdr *n)
 {
+	struct ifla_rmnet_flags flags = { };
 	__u16 mux_id;
 
 	while (argc > 0) {
@@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u16(&mux_id, *argv, 0))
 				invarg("mux_id is invalid", *argv);
 			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
+		} else if (matches(*argv, "ingress-deaggregation") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
+		} else if (matches(*argv, "ingress-commands") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
+		} else if (matches(*argv, "ingress-chksumv4") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
+		} else if (matches(*argv, "egress-chksumv4") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--, argv++;
 	}
 
+	if (flags.mask)
+		addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
+
 	return 0;
 }
 
+static void rmnet_print_flags(FILE *fp, __u32 flags)
+{
+	if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
+	if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
+	if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
+	if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
+		print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
+}
+
 static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	struct ifla_rmnet_flags *flags;
+
 	if (!tb)
 		return;
 
@@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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
2.28.0

