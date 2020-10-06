Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14285284E99
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgJFPEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgJFPEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:04:34 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC59208B8;
        Tue,  6 Oct 2020 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996673;
        bh=kOc0SU+wBfjrVQZ8eee9WVB+ukBN0CzbCnEbg/duRf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajYpA31qFjebnrVREkx9oAbjpbXeZY6GgSbQ2PXWHiLyptPpWWgWs3kaqnTu0l1Tu
         NXJ9/Bk2GJORsC+5cpBDkW+f/jsmYDDYjsoxdNEl7sltft2BcX+fvrwBWiQWWOTj29
         bAnV6CUeqaeu68eemRZSL9iopq7jxBZpaTgEbZ9g=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 6/6] pause: add support for dumping statistics
Date:   Tue,  6 Oct 2020 08:04:25 -0700
Message-Id: <20201006150425.2631432-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006150425.2631432-1-kuba@kernel.org>
References: <20201006150425.2631432-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for requesting pause frame stats from the kernel.

 # ./ethtool -I -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		on
TX:		on
Statistics:
  tx_pause_frames: 1
  rx_pause_frames: 1

 # ./ethtool -I --json -a eth0
[ {
        "ifname": "eth0",
        "autonegotiate": true,
        "rx": true,
        "tx": true,
        "statistics": {
            "tx_pause_frames": 1,
            "rx_pause_frames": 1
        }
    } ]

v2: - correct print format for u64

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/pause.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/netlink/pause.c b/netlink/pause.c
index c960c82cba5f..9bc9a301821f 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <inttypes.h>
 #include <string.h>
 #include <stdio.h>
 
@@ -105,6 +106,62 @@ static int show_pause_autoneg_status(struct nl_context *nlctx)
 	return ret;
 }
 
+static int show_pause_stats(const struct nlattr *nest)
+{
+	const struct nlattr *tb[ETHTOOL_A_PAUSE_STAT_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	static const struct {
+		unsigned int attr;
+		char *name;
+	} stats[] = {
+		{ ETHTOOL_A_PAUSE_STAT_TX_FRAMES, "tx_pause_frames" },
+		{ ETHTOOL_A_PAUSE_STAT_RX_FRAMES, "rx_pause_frames" },
+	};
+	bool header = false;
+	unsigned int i;
+	size_t n;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	open_json_object("statistics");
+	for (i = 0; i < ARRAY_SIZE(stats); i++) {
+		char fmt[32];
+
+		if (!tb[stats[i].attr])
+			continue;
+
+		if (!header && !is_json_context()) {
+			printf("Statistics:\n");
+			header = true;
+		}
+
+		if (mnl_attr_validate(tb[stats[i].attr], MNL_TYPE_U64)) {
+			fprintf(stderr, "malformed netlink message (statistic)\n");
+			goto err_close_stats;
+		}
+
+		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRIu64 "\n",
+			     stats[i].name);
+		if (n >= sizeof(fmt)) {
+			fprintf(stderr, "internal error - malformed label\n");
+			goto err_close_stats;
+		}
+
+		print_u64(PRINT_ANY, stats[i].name, fmt,
+			  mnl_attr_get_u64(tb[stats[i].attr]));
+	}
+	close_json_object();
+
+	return 0;
+
+err_close_stats:
+	close_json_object();
+	return -1;
+}
+
 int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 {
 	const struct nlattr *tb[ETHTOOL_A_PAUSE_MAX + 1] = {};
@@ -142,6 +199,11 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		if (ret < 0)
 			goto err_close_dev;
 	}
+	if (tb[ETHTOOL_A_PAUSE_STATS]) {
+		ret = show_pause_stats(tb[ETHTOOL_A_PAUSE_STATS]);
+		if (ret < 0)
+			goto err_close_dev;
+	}
 	if (!silent)
 		print_nl();
 
@@ -158,6 +220,7 @@ int nl_gpause(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
 	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
 	int ret;
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
@@ -168,8 +231,10 @@ int nl_gpause(struct cmd_context *ctx)
 		return 1;
 	}
 
+	flags = get_stats_flag(nlctx, ETHTOOL_MSG_PAUSE_GET,
+			       ETHTOOL_A_PAUSE_HEADER);
 	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PAUSE_GET,
-				      ETHTOOL_A_PAUSE_HEADER, 0);
+				      ETHTOOL_A_PAUSE_HEADER, flags);
 	if (ret < 0)
 		return ret;
 
-- 
2.26.2

