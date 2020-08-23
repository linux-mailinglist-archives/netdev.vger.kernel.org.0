Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8C24EF83
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHWTk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgHWTkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C2E07AECB;
        Sun, 23 Aug 2020 19:40:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 27ECE6030D; Sun, 23 Aug 2020 21:40:24 +0200 (CEST)
Message-Id: <48ef048e78abee08eb6403985786659840d419e4.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 3/9] ioctl: prevent argc underflow in do_perqueue()
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nicholas Nunley <nicholas.d.nunley@intel.com>
Date:   Sun, 23 Aug 2020 21:40:24 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When first command line argument after "-Q" is "queue_mask", we parse
the queue mask and following subcommand without checking if these
arguments do actually exist. Add check if we have at least two arguments
left after "queue_mask" in the corresponding branch.

Fixes: 9ecd54248b1a ("ethtool: introduce new ioctl for per-queue settings")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 4fa7a2c1716f..6c12452be7b4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5880,6 +5880,8 @@ static int do_perqueue(struct cmd_context *ctx)
 			"The sub commands will be applied to all %d queues\n",
 			n_queues);
 	} else {
+		if (ctx->argc <= 2)
+			exit_bad_args();
 		ctx->argc--;
 		ctx->argp++;
 		if (parse_hex_u32_bitmap(*ctx->argp, MAX_NUM_QUEUE,
-- 
2.28.0

