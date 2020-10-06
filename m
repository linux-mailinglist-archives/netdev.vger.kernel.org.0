Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9932284E95
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgJFPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgJFPEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:33 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC73207EA;
        Tue,  6 Oct 2020 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996672;
        bh=WRMY6HYIfwv7dXbCKHaF0anv2O6St9fgY6n9r9CJ4zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kA4iuiv55vMKq74bBog/wOP2PK2HbQgTwyM1L3P0LjSiOF85BiDktuVe5/R9R3d6v
         S/+p6Lk4WZzn99fBFpWow7FzwYED3s6N5R4d0yjCS8GTCPHEfWEzUEHPmtpGDnUuE+
         hrdBaR3egkdxdn+m8Io/k8QGbeoitZpxOQ+IfeF4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 4/6] add support for stats in subcommands
Date:   Tue,  6 Oct 2020 08:04:23 -0700
Message-Id: <20201006150425.2631432-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new parameters (-I | --include-statistics) which will
control requesting statistic dumps from the kernel.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.8.in | 7 +++++++
 ethtool.c    | 8 ++++++++
 internal.h   | 1 +
 3 files changed, 16 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index f70edb5d9d39..866b4e940dc0 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -140,6 +140,9 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool [--json]
 .I args
 .HP
+.B ethtool [-I | --include-statistics]
+.I args
+.HP
 .B ethtool \-\-monitor
 [
 .I command
@@ -499,6 +502,10 @@ Output results in JavaScript Object Notation (JSON). Only a subset of
 options support this. Those which do not will continue to output
 plain text in the presence of this option.
 .TP
+.B \-I \-\-include\-statistics
+Include command-related statistics in the output. This option allows
+displaying relevant device statistics for selected get commands.
+.TP
 .B \-a \-\-show\-pause
 Queries the specified Ethernet device for pause parameter information.
 .TP
diff --git a/ethtool.c b/ethtool.c
index 403616bb7fa0..1d9067e774af 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6031,6 +6031,7 @@ static int show_usage(struct cmd_context *ctx __maybe_unused)
 	fprintf(stdout, "FLAGS:\n");
 	fprintf(stdout, "	--debug MASK	turn on debugging messages\n");
 	fprintf(stdout, "	--json		enable JSON output format (not supported by all commands)\n");
+	fprintf(stdout, "	-I|--include-statistics		request device statistics related to the command (not supported by all commands)\n");
 
 	return 0;
 }
@@ -6291,6 +6292,13 @@ int main(int argc, char **argp)
 			argc -= 1;
 			continue;
 		}
+		if (*argp && (!strcmp(*argp, "--include-statistics") ||
+			      !strcmp(*argp, "-I"))) {
+			ctx.show_stats = true;
+			argp += 1;
+			argc -= 1;
+			continue;
+		}
 		break;
 	}
 	if (*argp && !strcmp(*argp, "--monitor")) {
diff --git a/internal.h b/internal.h
index 935ebac3ca2e..27da8eac57bb 100644
--- a/internal.h
+++ b/internal.h
@@ -225,6 +225,7 @@ struct cmd_context {
 	char **argp;		/* arguments to the sub-command */
 	unsigned long debug;	/* debugging mask */
 	bool json;		/* Output JSON, if supported */
+	bool show_stats;	/* include command-specific stats */
 #ifdef ETHTOOL_ENABLE_NETLINK
 	struct nl_context *nlctx;	/* netlink context (opaque) */
 #endif
-- 
2.26.2

