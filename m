Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9FB277589
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgIXPgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgIXPgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:36:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF193221EB;
        Thu, 24 Sep 2020 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600961790;
        bh=iD4NIVFB13kkkqAs0A2e/4+QEKNVEa7RpcZSRqRHfcQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H+FICnk8yZruy3pMT/GxYP30dA1f6f+BJ5E1kL4eahsghEG7DdHguRbiPQzccGAKc
         GPhfKI5hyEaRewkOKLe6WEegHu1R89YfW/xsunUe74nu4xvtxlspih4eFu9iSHnn4g
         ZPzC9leagIW5DPYd/4jD/zW/HlIkuBQP6+vP5xnA=
Date:   Thu, 24 Sep 2020 08:36:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 2/5] pause: add --json support
Message-ID: <20200924083627.613e5c59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3edc444e-ac89-a17b-3092-f91e8523cfa3@intel.com>
References: <20200915235259.457050-1-kuba@kernel.org>
        <20200915235259.457050-3-kuba@kernel.org>
        <3edc444e-ac89-a17b-3092-f91e8523cfa3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 17:10:30 -0700 Jacob Keller wrote:
> > -	printf("RX negotiated: %s\nTX negotiated: %s\n",
> > -	       rx_status ? "on" : "off", tx_status ? "on" : "off");
> > +
> > +	if (is_json_context()) {
> > +		open_json_object("negotiated");
> > +		print_bool(PRINT_JSON, "rx", NULL, rx_status);
> > +		print_bool(PRINT_JSON, "tx", NULL, tx_status);
> > +		close_json_object();
> > +	} else {
> > +		printf("RX negotiated: %s\nTX negotiated: %s\n",
> > +		       rx_status ? "on" : "off", tx_status ? "on" : "off");
> > +	}
> 
> Why not use print_string here like show_bool did?

Yeah.. I did not come up with a good way of reusing the show_bool code
so I gave up. Taking another swing at it - how does this look?

diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 65f75cf9a8dd..07a92d04b7a1 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -36,9 +36,9 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	if (silent)
 		putchar('\n');
 	printf("Coalesce parameters for %s:\n", nlctx->devname);
-	printf("Adaptive RX: %s  TX: %s\n",
-	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]),
-	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]));
+	show_bool("rx", "Adaptive RX: %s  ",
+		  tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]);
+	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]);
 	show_u32(tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS],
 		 "stats-block-usecs: ");
 	show_u32(tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL],
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 4916d25ed5c0..1012e8e32cd8 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -98,27 +98,30 @@ static inline void show_u32(const struct nlattr *attr, const char *label)
 		printf("%sn/a\n", label);
 }
 
-static inline const char *u8_to_bool(const struct nlattr *attr)
+static inline const char *u8_to_bool(const uint8_t *val)
 {
-	if (attr)
-		return mnl_attr_get_u8(attr) ? "on" : "off";
+	if (val)
+		return *val ? "on" : "off";
 	else
 		return "n/a";
 }
 
-static inline void show_bool(const char *key, const char *fmt,
-			     const struct nlattr *attr)
+static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
 {
 	if (is_json_context()) {
-		if (attr) {
-			print_bool(PRINT_JSON, key, NULL,
-				   mnl_attr_get_u8(attr));
-		}
+		if (val)
+			print_bool(PRINT_JSON, key, NULL, val);
 	} else {
-		print_string(PRINT_FP, NULL, fmt, u8_to_bool(attr));
+		print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
 	}
 }
 
+static inline void show_bool(const char *key, const char *fmt,
+			     const struct nlattr *attr)
+{
+	show_bool_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
+}
+
 /* misc */
 
 static inline void copy_devname(char *dst, const char *src)
diff --git a/netlink/pause.c b/netlink/pause.c
index f9dec9fe887a..5395398ba948 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -41,8 +41,8 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
 	struct pause_autoneg_status ours = {};
 	struct pause_autoneg_status peer = {};
 	struct nl_context *nlctx = data;
-	bool rx_status = false;
-	bool tx_status = false;
+	uint8_t rx_status = false;
+	uint8_t tx_status = false;
 	bool silent;
 	int err_ret;
 	int ret;
@@ -74,15 +74,10 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
 			tx_status = true;
 	}
 
-	if (is_json_context()) {
-		open_json_object("negotiated");
-		print_bool(PRINT_JSON, "rx", NULL, rx_status);
-		print_bool(PRINT_JSON, "tx", NULL, tx_status);
-		close_json_object();
-	} else {
-		printf("RX negotiated: %s\nTX negotiated: %s\n",
-		       rx_status ? "on" : "off", tx_status ? "on" : "off");
-	}
+	open_json_object("negotiated");
+	show_bool_val("rx", "RX negotiated: %s\n", &rx_status);
+	show_bool_val("tx", "TX negotiated: %s\n", &tx_status);
+	close_json_object();
 
 	return MNL_CB_OK;
 }
