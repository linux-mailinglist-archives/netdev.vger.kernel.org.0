Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D80A26B5E1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgIOXxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgIOXxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 366BC21D24;
        Tue, 15 Sep 2020 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213981;
        bh=XhGWjT6nRhPQqolWFAg+Saen05pdEeNWpwZQvjsqhgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06yjZuSyHG49OAjB3AmVu9ZcBSReo+/43MiZtvStADC3Xh/3/vz7Oyxc8GuJR3pxO
         Ian/BVXe8OXE8Dn5aQUZP1zZLHBQoOrv8bXlxI6D7BnXyyp2Xw8qODdVwjflccR036
         ULdEJifelvNtNY0fzHooLvR/Xg1BmY+8Mp+Y/lCM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 2/5] pause: add --json support
Date:   Tue, 15 Sep 2020 16:52:56 -0700
Message-Id: <20200915235259.457050-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915235259.457050-1-kuba@kernel.org>
References: <20200915235259.457050-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No change in normal text output:

 # ./ethtool  -a eth0
Pause parameters for eth0:
Autonegotiate:	on
RX:		on
TX:		on
RX negotiated: on
TX negotiated: on

JSON:

 # ./ethtool --json -a eth0
[ {
        "ifname": "eth0",
        "autonegotiate": true,
        "rx": true,
        "tx": true,
        "negotiated": {
            "rx": true,
            "tx": true
        }
    } ]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/netlink.h | 12 ++++++++++--
 netlink/pause.c   | 45 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/netlink/netlink.h b/netlink/netlink.h
index dd4a02bcc916..4916d25ed5c0 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -106,9 +106,17 @@ static inline const char *u8_to_bool(const struct nlattr *attr)
 		return "n/a";
 }
 
-static inline void show_bool(const struct nlattr *attr, const char *label)
+static inline void show_bool(const char *key, const char *fmt,
+			     const struct nlattr *attr)
 {
-	printf("%s%s\n", label, u8_to_bool(attr));
+	if (is_json_context()) {
+		if (attr) {
+			print_bool(PRINT_JSON, key, NULL,
+				   mnl_attr_get_u8(attr));
+		}
+	} else {
+		print_string(PRINT_FP, NULL, fmt, u8_to_bool(attr));
+	}
 }
 
 /* misc */
diff --git a/netlink/pause.c b/netlink/pause.c
index 7b6b3a1d2c10..30ecdccb15eb 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -72,8 +72,16 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
 		else if (peer.pause)
 			tx_status = true;
 	}
-	printf("RX negotiated: %s\nTX negotiated: %s\n",
-	       rx_status ? "on" : "off", tx_status ? "on" : "off");
+
+	if (is_json_context()) {
+		open_json_object("negotiated");
+		print_bool(PRINT_JSON, "rx", NULL, rx_status);
+		print_bool(PRINT_JSON, "tx", NULL, tx_status);
+		close_json_object();
+	} else {
+		printf("RX negotiated: %s\nTX negotiated: %s\n",
+		       rx_status ? "on" : "off", tx_status ? "on" : "off");
+	}
 
 	return MNL_CB_OK;
 }
@@ -121,21 +129,34 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		return err_ret;
 
 	if (silent)
-		putchar('\n');
-	printf("Pause parameters for %s:\n", nlctx->devname);
-	show_bool(tb[ETHTOOL_A_PAUSE_AUTONEG], "Autonegotiate:\t");
-	show_bool(tb[ETHTOOL_A_PAUSE_RX], "RX:\t\t");
-	show_bool(tb[ETHTOOL_A_PAUSE_TX], "TX:\t\t");
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "Pause parameters for %s:\n",
+		     nlctx->devname);
+
+	show_bool("autonegotiate", "Autonegotiate:\t%s\n",
+		  tb[ETHTOOL_A_PAUSE_AUTONEG]);
+	show_bool("rx", "RX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_RX]);
+	show_bool("tx", "TX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_TX]);
+
 	if (!nlctx->is_monitor && tb[ETHTOOL_A_PAUSE_AUTONEG] &&
 	    mnl_attr_get_u8(tb[ETHTOOL_A_PAUSE_AUTONEG])) {
 		ret = show_pause_autoneg_status(nlctx);
 		if (ret < 0)
-			return err_ret;
+			goto err_close_dev;
 	}
 	if (!silent)
-		putchar('\n');
+		print_nl();
+
+	close_json_object();
 
 	return MNL_CB_OK;
+
+err_close_dev:
+	close_json_object();
+	return err_ret;
 }
 
 int nl_gpause(struct cmd_context *ctx)
@@ -156,7 +177,11 @@ int nl_gpause(struct cmd_context *ctx)
 				      ETHTOOL_A_PAUSE_HEADER, 0);
 	if (ret < 0)
 		return ret;
-	return nlsock_send_get_request(nlsk, pause_reply_cb);
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, pause_reply_cb);
+	delete_json_obj();
+	return ret;
 }
 
 /* PAUSE_SET */
-- 
2.26.2

