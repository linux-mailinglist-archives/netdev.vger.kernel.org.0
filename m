Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A153EBB42
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhHMRUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhHMRUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11D6610F7;
        Fri, 13 Aug 2021 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875186;
        bh=NiOVLorQ0fo+GJMVv9D5vtnTb7PM9CBJlmYrV2SQj50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k23tHUDEFFtuJjhuY/sUN8HpjYtVHtZU0kscOdG0XNzn26Nm+IAQojF2MAalcMJgV
         F6bsxgbxniUnyaNeyXa2mROEyJpdgi9Ll6UJTWoGLpoudCvcnl+4umhzEeUMkGFILT
         DtbCEfnpkBrZRNMQbNkopw5hmLjlOkkOY0pXp+a4y49rslw1dCHV3QI+QpyC7II2Rm
         Ty7BwLObCjdWom+GFZeu87el99LaB+LFP7t31MSPWh16+l3ccQEuDaWMy9DKGticWl
         yK/nCY9Lj1xFR7Pl0m5mReKhKpCx76OBlmJUP9ofR1OyLgqdoI7RF5ovRk140QyJiC
         CjK0fHnN3J5Kg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dcavalca@fb.com, filbranden@fb.com,
        michel@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool 3/3] ethtool: return error if command does not support --json
Date:   Fri, 13 Aug 2021 10:19:38 -0700
Message-Id: <20210813171938.1127891-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813171938.1127891-1-kuba@kernel.org>
References: <20210813171938.1127891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --json switch is currently best effort, which is similar
to how other networking utilities treat it. Change to returning
an error if selected command does not support --json.

ethtool is more complex than other utilities because the JSON
support depends on both user space and kernel version. Older
kernel make ethtool use the IOCTL and none of the IOCTL handlers
support JSON.

The current behavior is counter-productive when trying to query
statistics - user has to check (1) if stats (-I) are supported,
(2) if json is supported (--json) and then (3) if underlying
device populates the statistic. Making --json fail if not supported
allows (1) and (2) to both be taken care of with simple check
of ethtool's exit code.

Link: https://pagure.io/centos-sig-hyperscale/package-bugs/issue/6
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 ethtool.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 9e02fe4f09a5..bd6242ed383e 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5619,6 +5619,7 @@ static int show_usage(struct cmd_context *ctx);
 struct option {
 	const char	*opts;
 	bool		no_dev;
+	bool		json;
 	int		(*func)(struct cmd_context *);
 	nl_chk_t	nlchk;
 	nl_func_t	nlfunc;
@@ -5655,6 +5656,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-a|--show-pause",
+		.json	= true,
 		.func	= do_gpause,
 		.nlfunc	= nl_gpause,
 		.help	= "Show pause options"
@@ -5779,6 +5781,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-S|--statistics",
+		.json	= true,
 		.func	= do_gnicstats,
 		.nlchk	= nl_gstats_chk,
 		.nlfunc	= nl_gstats,
@@ -5990,6 +5993,7 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "--show-fec",
+		.json	= true,
 		.func	= do_gfec,
 		.nlfunc	= nl_gfec,
 		.help	= "Show FEC settings",
@@ -6010,11 +6014,13 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "--cable-test",
+		.json	= true,
 		.nlfunc	= nl_cable_test,
 		.help	= "Perform a cable test",
 	},
 	{
 		.opts	= "--cable-test-tdr",
+		.json	= true,
 		.nlfunc	= nl_cable_test_tdr,
 		.help	= "Print cable test time domain reflectrometery data",
 		.xhelp	= "		[ first N ]\n"
@@ -6361,10 +6367,15 @@ int main(int argc, char **argp)
 		if (!ctx.devname)
 			exit_bad_args();
 	}
+	if (ctx.json && !args[k].json)
+		exit_bad_args();
 	ctx.argc = argc;
 	ctx.argp = argp;
 	netlink_run_handler(&ctx, args[k].nlchk, args[k].nlfunc, !args[k].func);
 
+	if (ctx.json) /* no IOCTL command supports JSON output */
+		exit_bad_args();
+
 	ret = ioctl_init(&ctx, args[k].no_dev);
 	if (ret)
 		return ret;
-- 
2.31.1

