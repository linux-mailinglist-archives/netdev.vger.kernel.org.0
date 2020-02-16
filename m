Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59FC1606F9
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgBPWqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:46:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:33696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgBPWqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 17:46:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 05DA5AE52;
        Sun, 16 Feb 2020 22:46:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AB704E03D6; Sun, 16 Feb 2020 23:46:45 +0100 (CET)
Message-Id: <1e01f6e1890d816966a509a6257e84a48fe40533.1581892124.git.mkubecek@suse.cz>
In-Reply-To: <cover.1581892124.git.mkubecek@suse.cz>
References: <cover.1581892124.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 03/19] add --debug option to control debugging
 messages
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 16 Feb 2020 23:46:45 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce --debug option to control which debugging messages will be shown.
Argument is a number which is interpreted as bit mask; default value is
zero (i.e. no debug messages).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.8.in | 12 ++++++++++++
 ethtool.c    | 18 ++++++++++++++++--
 internal.h   |  6 ++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index 94364c626330..680cad9fbb8f 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -129,6 +129,10 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-\-version
 .HP
+.B ethtool
+.BN --debug
+.I args
+.HP
 .B ethtool \-a|\-\-show\-pause
 .I devname
 .HP
@@ -437,6 +441,14 @@ Shows a short help message.
 .B \-\-version
 Shows the ethtool version number.
 .TP
+.BI \-\-debug \ N
+Turns on debugging messages. Argument is interpreted as a mask:
+.TS
+nokeep;
+lB	l.
+0x01  Parser information
+.TE
+.TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
 .TP
diff --git a/ethtool.c b/ethtool.c
index acf183dc5586..dd0242b27a2f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5493,10 +5493,10 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 	fprintf(stdout, PACKAGE " version " VERSION "\n");
 	fprintf(stdout,
 		"Usage:\n"
-		"        ethtool DEVNAME\t"
+		"        ethtool [ --debug MASK ] DEVNAME\t"
 		"Display standard information about device\n");
 	for (i = 0; args[i].opts; i++) {
-		fputs("        ethtool ", stdout);
+		fputs("        ethtool [ --debug MASK ] ", stdout);
 		fprintf(stdout, "%s %s\t%s\n",
 			args[i].opts,
 			args[i].want_device ? "DEVNAME" : "\t",
@@ -5712,6 +5712,20 @@ int main(int argc, char **argp)
 	argp++;
 	argc--;
 
+	ctx.debug = 0;
+	if (*argp && !strcmp(*argp, "--debug")) {
+		char *eptr;
+
+		if (argc < 2)
+			exit_bad_args();
+		ctx.debug = strtoul(argp[1], &eptr, 0);
+		if (!argp[1][0] || *eptr)
+			exit_bad_args();
+
+		argp += 2;
+		argc -= 2;
+	}
+
 	/* First argument must be either a valid option or a device
 	 * name to get settings for (which we don't expect to begin
 	 * with '-').
diff --git a/internal.h b/internal.h
index 527245633338..9ec145f55dcb 100644
--- a/internal.h
+++ b/internal.h
@@ -107,6 +107,11 @@ static inline int test_bit(unsigned int nr, const unsigned long *addr)
 #define SIOCETHTOOL     0x8946
 #endif
 
+/* debugging flags */
+enum {
+	DEBUG_PARSE,
+};
+
 /* Internal values for old-style offload flags.  Values and names
  * must not clash with the flags defined for ETHTOOL_{G,S}FLAGS.
  */
@@ -197,6 +202,7 @@ struct cmd_context {
 	struct ifreq ifr;	/* ifreq suitable for ethtool ioctl */
 	int argc;		/* number of arguments to the sub-command */
 	char **argp;		/* arguments to the sub-command */
+	unsigned long debug;	/* debugging mask */
 };
 
 #ifdef TEST_ETHTOOL
-- 
2.25.0

