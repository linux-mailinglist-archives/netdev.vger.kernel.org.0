Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595F026B5E0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgIOXxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgIOXxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:04 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15FFB221E3;
        Tue, 15 Sep 2020 23:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213982;
        bh=yLS1vq20W6tTyAkcxNKspYRmP2DcQhY1lsr6EZbvcKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0+qlgY53MhuKmu5X3NmnsrslOJ785fzVLnTd2zR7daRnXi6W9T0lamsN66zTfqe8
         p9laMseVPAhoxmZTQrQtKAzbmnu/hcm/m8/woIwjtYEgfEobC0ktaQZEtvWUZBg9Sg
         6x4B+eTk3WiIJDoLHgnmoG7Kyu9q9HIJAwi/bd3c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 5/5] pause: add support for dumping statistics
Date:   Tue, 15 Sep 2020 16:52:59 -0700
Message-Id: <20200915235259.457050-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915235259.457050-1-kuba@kernel.org>
References: <20200915235259.457050-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/pause.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/netlink/pause.c b/netlink/pause.c
index 30ecdccb15eb..f9dec9fe887a 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <inttypes.h>
 #include <string.h>
 #include <stdio.h>
 
@@ -110,6 +111,62 @@ static int show_pause_autoneg_status(struct nl_context *nlctx)
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
+		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRId64 "\n",
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
@@ -147,6 +204,11 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
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
 
@@ -163,6 +225,7 @@ int nl_gpause(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
 	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
 	int ret;
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
@@ -173,8 +236,9 @@ int nl_gpause(struct cmd_context *ctx)
 		return 1;
 	}
 
+	flags = nlctx->ctx->show_stats ? ETHTOOL_FLAG_STATS : 0;
 	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PAUSE_GET,
-				      ETHTOOL_A_PAUSE_HEADER, 0);
+				      ETHTOOL_A_PAUSE_HEADER, flags);
 	if (ret < 0)
 		return ret;
 
-- 
2.26.2

