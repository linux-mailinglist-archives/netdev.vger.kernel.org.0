Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9ADE1432D1
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgATUSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 15:18:33 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:51589 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATUSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 15:18:30 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 1ABBE1BF209;
        Mon, 20 Jan 2020 20:18:28 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next 2/2] macsec: add support for changing the offloading mode
Date:   Mon, 20 Jan 2020 21:18:23 +0100
Message-Id: <20200120201823.887937-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120201823.887937-1-antoine.tenart@bootlin.com>
References: <20200120201823.887937-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MacSEC can now be offloaded to specialized hardware devices. Offloading
is off by default when creating a new MACsec interface, but the mode can
be updated at runtime. This patch adds a new subcommand,
`ip macsec offload`, to allow users to select the offloading mode of a
MACsec interface. It takes the mode to switch to as an argument, which
can for now either be 'off' or 'phy':

  # ip macsec offload macsec0 phy
  # ip macsec offload macsec0 off

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 ip/ipmacsec.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index db7202ceb0a7..28272bc25a19 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -98,6 +98,7 @@ static void ipmacsec_usage(void)
 		"       ip macsec del DEV rx SCI sa { 0..3 }\n"
 		"       ip macsec show\n"
 		"       ip macsec show DEV\n"
+		"       ip macsec offload DEV [ off | phy ]\n"
 		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
 		"       ID   := 128-bit hex string\n"
 		"       KEY  := 128-bit or 256-bit hex string\n"
@@ -359,6 +360,7 @@ enum cmd {
 	CMD_ADD,
 	CMD_DEL,
 	CMD_UPD,
+	CMD_OFFLOAD,
 	__CMD_MAX
 };
 
@@ -375,6 +377,9 @@ static const enum macsec_nl_commands macsec_commands[__CMD_MAX][2][2] = {
 		[0] = {-1, MACSEC_CMD_DEL_RXSC},
 		[1] = {MACSEC_CMD_DEL_TXSA, MACSEC_CMD_DEL_RXSA},
 	},
+	[CMD_OFFLOAD] = {
+		[0] = {-1, MACSEC_CMD_UPD_OFFLOAD },
+	},
 };
 
 static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
@@ -534,6 +539,44 @@ static int do_modify(enum cmd c, int argc, char **argv)
 	return -1;
 }
 
+static int do_offload(enum cmd c, int argc, char **argv)
+{
+	enum macsec_offload offload;
+	struct rtattr *attr;
+	int ifindex, ret;
+
+	if (argc == 0)
+		ipmacsec_usage();
+
+	ifindex = ll_name_to_index(*argv);
+	if (!ifindex) {
+		fprintf(stderr, "Device \"%s\" does not exist.\n", *argv);
+		return -1;
+	}
+	argc--; argv++;
+
+	if (argc == 0)
+		ipmacsec_usage();
+
+	ret = one_of("offload", *argv, offload_str, ARRAY_SIZE(offload_str),
+		     (int *)&offload);
+	if (ret)
+		ipmacsec_usage();
+
+	MACSEC_GENL_REQ(req, MACSEC_BUFLEN, macsec_commands[c][0][1], NLM_F_REQUEST);
+
+	addattr32(&req.n, MACSEC_BUFLEN, MACSEC_ATTR_IFINDEX, ifindex);
+
+	attr = addattr_nest(&req.n, MACSEC_BUFLEN, MACSEC_ATTR_OFFLOAD);
+	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_OFFLOAD_ATTR_TYPE, offload);
+	addattr_nest_end(&req.n, attr);
+
+	if (rtnl_talk(&genl_rth, &req.n, NULL) < 0)
+		return -2;
+
+	return 0;
+}
+
 /* dump/show */
 static struct {
 	int ifindex;
@@ -1086,6 +1129,8 @@ int do_ipmacsec(int argc, char **argv)
 		return do_modify(CMD_UPD, argc-1, argv+1);
 	if (matches(*argv, "delete") == 0)
 		return do_modify(CMD_DEL, argc-1, argv+1);
+	if (matches(*argv, "offload") == 0)
+		return do_offload(CMD_OFFLOAD, argc-1, argv+1);
 
 	fprintf(stderr, "Command \"%s\" is unknown, try \"ip macsec help\".\n",
 		*argv);
-- 
2.24.1

