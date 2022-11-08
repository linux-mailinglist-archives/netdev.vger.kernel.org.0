Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30626621DA3
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKHU1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKHU1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:27:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0C32314F;
        Tue,  8 Nov 2022 12:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388E961751;
        Tue,  8 Nov 2022 20:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585A4C433C1;
        Tue,  8 Nov 2022 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667939226;
        bh=KiscCDDD8t5aCEiOHjSVORwg7P7jfSY8A1GDJNcCJ1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gz9HBHg14BzoeQuRLlMyKBHj6Ajz8h6snt/wcLGhhsINkrh7xglLFh42u0rP8mQoW
         8edFPdSNdY28vo13WxevmHT2xq4DlHzHWWikUtkp+y5aq4zuaQ7IEbqvdJsiB719Od
         UESlg7gslAtbGlcXYzTTxnNTQeh6wSh9SuJY7zuOFN4FFLHEWrs1OODXmwVDCYr10m
         akqhyXRjINt9CwHthmFo5VLWzMDvND6Y5mJvWis1fKJW/Jn4gRDQ8Ri+7eQKtl9ntj
         gtmOnXB+6o0xvvKz02eiQGyntaHHNKwCqzHErOvHLJ8wwYurr6jC7tvzSYid/b6lRe
         gtBuYCSRdPgBA==
Date:   Tue, 8 Nov 2022 14:26:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3 4/7] wifi: zd1201: Avoid clashing function prototypes
Message-ID: <5b7fbb1a22d5bfaa872263ca20297de9b431d1ec.1667934775.git.gustavoars@kernel.org>
References: <cover.1667934775.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1667934775.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When built with Control Flow Integrity, function prototypes between
caller and function declaration must match. These mismatches are visible
at compile time with the new -Wcast-function-type-strict in Clang[1].

Fix a total of 30 warnings like these:

../drivers/net/wireless/zydas/zd1201.c:1560:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, struct iw_freq *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        (iw_handler) zd1201_set_freq,           /* SIOCSIWFREQ */
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

The zd1201 Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch.There are no resulting binary differences
before/after changes.

These changes were made partly manually and partly with the help of
Coccinelle.

Link: https://github.com/KSPP/linux/issues/233
Link: https://reviews.llvm.org/D134831 [1]
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Remove iw_handler casts from zd1201_private_handler[].
 - Update subject line: add prefix 'wifi: '.
 - Add RB tag from Kees.
 - Update changelog text. 

Changes in v2:
 - Revert changes in zd1201_private_handler[].
 - Link: https://lore.kernel.org/linux-hardening/973dea1fc38ee4df0a6ff6d07b3a3966be781316.1666894751.git.gustavoars@kernel.org/

v1:
 - Link: https://lore.kernel.org/linux-hardening/b16526a7a35638224990d265db21c8b450b67545.1666038048.git.gustavoars@kernel.org/

 drivers/net/wireless/zydas/zd1201.c | 174 ++++++++++++++--------------
 1 file changed, 89 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 82bc0d44212e..a85fe7e4c6d4 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -886,7 +886,7 @@ static void zd1201_set_multicast(struct net_device *dev)
 }
 
 static int zd1201_config_commit(struct net_device *dev, 
-    struct iw_request_info *info, struct iw_point *data, char *essid)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
 	struct zd1201 *zd = netdev_priv(dev);
 
@@ -894,15 +894,16 @@ static int zd1201_config_commit(struct net_device *dev,
 }
 
 static int zd1201_get_name(struct net_device *dev,
-    struct iw_request_info *info, char *name, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
-	strcpy(name, "IEEE 802.11b");
+	strcpy(wrqu->name, "IEEE 802.11b");
 	return 0;
 }
 
 static int zd1201_set_freq(struct net_device *dev,
-    struct iw_request_info *info, struct iw_freq *freq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *freq = &wrqu->freq;
 	struct zd1201 *zd = netdev_priv(dev);
 	short channel = 0;
 	int err;
@@ -922,8 +923,9 @@ static int zd1201_set_freq(struct net_device *dev,
 }
 
 static int zd1201_get_freq(struct net_device *dev,
-    struct iw_request_info *info, struct iw_freq *freq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *freq = &wrqu->freq;
 	struct zd1201 *zd = netdev_priv(dev);
 	short channel;
 	int err;
@@ -938,8 +940,9 @@ static int zd1201_get_freq(struct net_device *dev,
 }
 
 static int zd1201_set_mode(struct net_device *dev,
-    struct iw_request_info *info, __u32 *mode, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct zd1201 *zd = netdev_priv(dev);
 	short porttype, monitor = 0;
 	unsigned char buffer[IW_ESSID_MAX_SIZE+2];
@@ -1001,8 +1004,9 @@ static int zd1201_set_mode(struct net_device *dev,
 }
 
 static int zd1201_get_mode(struct net_device *dev,
-    struct iw_request_info *info, __u32 *mode, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct zd1201 *zd = netdev_priv(dev);
 	short porttype;
 	int err;
@@ -1038,8 +1042,9 @@ static int zd1201_get_mode(struct net_device *dev,
 }
 
 static int zd1201_get_range(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *wrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *wrq = &wrqu->data;
 	struct iw_range *range = (struct iw_range *)extra;
 
 	wrq->length = sizeof(struct iw_range);
@@ -1077,8 +1082,9 @@ static int zd1201_get_range(struct net_device *dev,
  *	the stats after asking the bssid.
  */
 static int zd1201_get_wap(struct net_device *dev,
-    struct iw_request_info *info, struct sockaddr *ap_addr, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct zd1201 *zd = netdev_priv(dev);
 	unsigned char buffer[6];
 
@@ -1098,15 +1104,16 @@ static int zd1201_get_wap(struct net_device *dev,
 }
 
 static int zd1201_set_scan(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *srq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	/* We do everything in get_scan */
 	return 0;
 }
 
 static int zd1201_get_scan(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *srq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *srq = &wrqu->data;
 	struct zd1201 *zd = netdev_priv(dev);
 	int err, i, j, enabled_save;
 	struct iw_event iwe;
@@ -1197,8 +1204,9 @@ static int zd1201_get_scan(struct net_device *dev,
 }
 
 static int zd1201_set_essid(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *data, char *essid)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct zd1201 *zd = netdev_priv(dev);
 
 	if (data->length > IW_ESSID_MAX_SIZE)
@@ -1212,8 +1220,9 @@ static int zd1201_set_essid(struct net_device *dev,
 }
 
 static int zd1201_get_essid(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *data, char *essid)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *essid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct zd1201 *zd = netdev_priv(dev);
 
 	memcpy(essid, zd->essid, zd->essidlen);
@@ -1224,8 +1233,9 @@ static int zd1201_get_essid(struct net_device *dev,
 }
 
 static int zd1201_get_nick(struct net_device *dev, struct iw_request_info *info,
-    struct iw_point *data, char *nick)
+	union iwreq_data *wrqu, char *nick)
 {
+	struct iw_point *data = &wrqu->data;
 	strcpy(nick, "zd1201");
 	data->flags = 1;
 	data->length = strlen(nick);
@@ -1233,8 +1243,9 @@ static int zd1201_get_nick(struct net_device *dev, struct iw_request_info *info,
 }
 
 static int zd1201_set_rate(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	struct zd1201 *zd = netdev_priv(dev);
 	short rate;
 	int err;
@@ -1266,8 +1277,9 @@ static int zd1201_set_rate(struct net_device *dev,
 }
 
 static int zd1201_get_rate(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	struct zd1201 *zd = netdev_priv(dev);
 	short rate;
 	int err;
@@ -1299,8 +1311,9 @@ static int zd1201_get_rate(struct net_device *dev,
 }
 
 static int zd1201_set_rts(struct net_device *dev, struct iw_request_info *info,
-    struct iw_param *rts, char *extra)
+	union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct zd1201 *zd = netdev_priv(dev);
 	int err;
 	short val = rts->value;
@@ -1319,8 +1332,9 @@ static int zd1201_set_rts(struct net_device *dev, struct iw_request_info *info,
 }
 
 static int zd1201_get_rts(struct net_device *dev, struct iw_request_info *info,
-    struct iw_param *rts, char *extra)
+	union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct zd1201 *zd = netdev_priv(dev);
 	short rtst;
 	int err;
@@ -1336,8 +1350,9 @@ static int zd1201_get_rts(struct net_device *dev, struct iw_request_info *info,
 }
 
 static int zd1201_set_frag(struct net_device *dev, struct iw_request_info *info,
-    struct iw_param *frag, char *extra)
+	union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *frag = &wrqu->frag;
 	struct zd1201 *zd = netdev_priv(dev);
 	int err;
 	short val = frag->value;
@@ -1357,8 +1372,9 @@ static int zd1201_set_frag(struct net_device *dev, struct iw_request_info *info,
 }
 
 static int zd1201_get_frag(struct net_device *dev, struct iw_request_info *info,
-    struct iw_param *frag, char *extra)
+	union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *frag = &wrqu->frag;
 	struct zd1201 *zd = netdev_priv(dev);
 	short fragt;
 	int err;
@@ -1374,20 +1390,21 @@ static int zd1201_get_frag(struct net_device *dev, struct iw_request_info *info,
 }
 
 static int zd1201_set_retry(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	return 0;
 }
 
 static int zd1201_get_retry(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
 	return 0;
 }
 
 static int zd1201_set_encode(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *erq, char *key)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *key)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct zd1201 *zd = netdev_priv(dev);
 	short i;
 	int err, rid;
@@ -1443,8 +1460,9 @@ static int zd1201_set_encode(struct net_device *dev,
 }
 
 static int zd1201_get_encode(struct net_device *dev,
-    struct iw_request_info *info, struct iw_point *erq, char *key)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *key)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct zd1201 *zd = netdev_priv(dev);
 	short i;
 	int err;
@@ -1476,8 +1494,9 @@ static int zd1201_get_encode(struct net_device *dev,
 }
 
 static int zd1201_set_power(struct net_device *dev, 
-    struct iw_request_info *info, struct iw_param *vwrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct zd1201 *zd = netdev_priv(dev);
 	short enabled, duration, level;
 	int err;
@@ -1515,8 +1534,9 @@ static int zd1201_set_power(struct net_device *dev,
 }
 
 static int zd1201_get_power(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *vwrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct zd1201 *zd = netdev_priv(dev);
 	short enabled, level, duration;
 	int err;
@@ -1553,57 +1573,37 @@ static int zd1201_get_power(struct net_device *dev,
 
 static const iw_handler zd1201_iw_handler[] =
 {
-	(iw_handler) zd1201_config_commit,	/* SIOCSIWCOMMIT */
-	(iw_handler) zd1201_get_name,    	/* SIOCGIWNAME */
-	(iw_handler) NULL,			/* SIOCSIWNWID */
-	(iw_handler) NULL,			/* SIOCGIWNWID */
-	(iw_handler) zd1201_set_freq,		/* SIOCSIWFREQ */
-	(iw_handler) zd1201_get_freq,		/* SIOCGIWFREQ */
-	(iw_handler) zd1201_set_mode,		/* SIOCSIWMODE */
-	(iw_handler) zd1201_get_mode,		/* SIOCGIWMODE */
-	(iw_handler) NULL,                  	/* SIOCSIWSENS */
-	(iw_handler) NULL,           		/* SIOCGIWSENS */
-	(iw_handler) NULL,			/* SIOCSIWRANGE */
-	(iw_handler) zd1201_get_range,           /* SIOCGIWRANGE */
-	(iw_handler) NULL,			/* SIOCSIWPRIV */
-	(iw_handler) NULL,			/* SIOCGIWPRIV */
-	(iw_handler) NULL,			/* SIOCSIWSTATS */
-	(iw_handler) NULL,			/* SIOCGIWSTATS */
-	(iw_handler) NULL,			/* SIOCSIWSPY */
-	(iw_handler) NULL,			/* SIOCGIWSPY */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL/*zd1201_set_wap*/,		/* SIOCSIWAP */
-	(iw_handler) zd1201_get_wap,		/* SIOCGIWAP */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,       		/* SIOCGIWAPLIST */
-	(iw_handler) zd1201_set_scan,		/* SIOCSIWSCAN */
-	(iw_handler) zd1201_get_scan,		/* SIOCGIWSCAN */
-	(iw_handler) zd1201_set_essid,		/* SIOCSIWESSID */
-	(iw_handler) zd1201_get_essid,		/* SIOCGIWESSID */
-	(iw_handler) NULL,         		/* SIOCSIWNICKN */
-	(iw_handler) zd1201_get_nick, 		/* SIOCGIWNICKN */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) zd1201_set_rate,		/* SIOCSIWRATE */
-	(iw_handler) zd1201_get_rate,		/* SIOCGIWRATE */
-	(iw_handler) zd1201_set_rts,		/* SIOCSIWRTS */
-	(iw_handler) zd1201_get_rts,		/* SIOCGIWRTS */
-	(iw_handler) zd1201_set_frag,		/* SIOCSIWFRAG */
-	(iw_handler) zd1201_get_frag,		/* SIOCGIWFRAG */
-	(iw_handler) NULL,         		/* SIOCSIWTXPOW */
-	(iw_handler) NULL,          		/* SIOCGIWTXPOW */
-	(iw_handler) zd1201_set_retry,		/* SIOCSIWRETRY */
-	(iw_handler) zd1201_get_retry,		/* SIOCGIWRETRY */
-	(iw_handler) zd1201_set_encode,		/* SIOCSIWENCODE */
-	(iw_handler) zd1201_get_encode,		/* SIOCGIWENCODE */
-	(iw_handler) zd1201_set_power,		/* SIOCSIWPOWER */
-	(iw_handler) zd1201_get_power,		/* SIOCGIWPOWER */
+	IW_HANDLER(SIOCSIWCOMMIT,	zd1201_config_commit),
+	IW_HANDLER(SIOCGIWNAME,		zd1201_get_name),
+	IW_HANDLER(SIOCSIWFREQ,		zd1201_set_freq),
+	IW_HANDLER(SIOCGIWFREQ,		zd1201_get_freq),
+	IW_HANDLER(SIOCSIWMODE,		zd1201_set_mode),
+	IW_HANDLER(SIOCGIWMODE,		zd1201_get_mode),
+	IW_HANDLER(SIOCGIWRANGE,	zd1201_get_range),
+	IW_HANDLER(SIOCGIWAP,		zd1201_get_wap),
+	IW_HANDLER(SIOCSIWSCAN,		zd1201_set_scan),
+	IW_HANDLER(SIOCGIWSCAN,		zd1201_get_scan),
+	IW_HANDLER(SIOCSIWESSID,	zd1201_set_essid),
+	IW_HANDLER(SIOCGIWESSID,	zd1201_get_essid),
+	IW_HANDLER(SIOCGIWNICKN,	zd1201_get_nick),
+	IW_HANDLER(SIOCSIWRATE,		zd1201_set_rate),
+	IW_HANDLER(SIOCGIWRATE,		zd1201_get_rate),
+	IW_HANDLER(SIOCSIWRTS,		zd1201_set_rts),
+	IW_HANDLER(SIOCGIWRTS,		zd1201_get_rts),
+	IW_HANDLER(SIOCSIWFRAG,		zd1201_set_frag),
+	IW_HANDLER(SIOCGIWFRAG,		zd1201_get_frag),
+	IW_HANDLER(SIOCSIWRETRY,	zd1201_set_retry),
+	IW_HANDLER(SIOCGIWRETRY,	zd1201_get_retry),
+	IW_HANDLER(SIOCSIWENCODE,	zd1201_set_encode),
+	IW_HANDLER(SIOCGIWENCODE,	zd1201_get_encode),
+	IW_HANDLER(SIOCSIWPOWER,	zd1201_set_power),
+	IW_HANDLER(SIOCGIWPOWER,	zd1201_get_power),
 };
 
 static int zd1201_set_hostauth(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->param;
 	struct zd1201 *zd = netdev_priv(dev);
 
 	if (!zd->ap)
@@ -1613,8 +1613,9 @@ static int zd1201_set_hostauth(struct net_device *dev,
 }
 
 static int zd1201_get_hostauth(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->param;
 	struct zd1201 *zd = netdev_priv(dev);
 	short hostauth;
 	int err;
@@ -1632,8 +1633,9 @@ static int zd1201_get_hostauth(struct net_device *dev,
 }
 
 static int zd1201_auth_sta(struct net_device *dev,
-    struct iw_request_info *info, struct sockaddr *sta, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *sta = &wrqu->ap_addr;
 	struct zd1201 *zd = netdev_priv(dev);
 	unsigned char buffer[10];
 
@@ -1648,8 +1650,9 @@ static int zd1201_auth_sta(struct net_device *dev,
 }
 
 static int zd1201_set_maxassoc(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->param;
 	struct zd1201 *zd = netdev_priv(dev);
 
 	if (!zd->ap)
@@ -1659,8 +1662,9 @@ static int zd1201_set_maxassoc(struct net_device *dev,
 }
 
 static int zd1201_get_maxassoc(struct net_device *dev,
-    struct iw_request_info *info, struct iw_param *rrq, char *extra)
+	struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->param;
 	struct zd1201 *zd = netdev_priv(dev);
 	short maxassoc;
 	int err;
@@ -1678,12 +1682,12 @@ static int zd1201_get_maxassoc(struct net_device *dev,
 }
 
 static const iw_handler zd1201_private_handler[] = {
-	(iw_handler) zd1201_set_hostauth,	/* ZD1201SIWHOSTAUTH */
-	(iw_handler) zd1201_get_hostauth,	/* ZD1201GIWHOSTAUTH */
-	(iw_handler) zd1201_auth_sta,		/* ZD1201SIWAUTHSTA */
-	(iw_handler) NULL,			/* nothing to get */
-	(iw_handler) zd1201_set_maxassoc,	/* ZD1201SIMAXASSOC */
-	(iw_handler) zd1201_get_maxassoc,	/* ZD1201GIMAXASSOC */
+	zd1201_set_hostauth,	/* ZD1201SIWHOSTAUTH */
+	zd1201_get_hostauth,	/* ZD1201GIWHOSTAUTH */
+	zd1201_auth_sta,	/* ZD1201SIWAUTHSTA */
+	NULL,			/* nothing to get */
+	zd1201_set_maxassoc,	/* ZD1201SIMAXASSOC */
+	zd1201_get_maxassoc,	/* ZD1201GIMAXASSOC */
 };
 
 static const struct iw_priv_args zd1201_private_args[] = {
@@ -1703,8 +1707,8 @@ static const struct iw_handler_def zd1201_iw_handlers = {
 	.num_standard 		= ARRAY_SIZE(zd1201_iw_handler),
 	.num_private 		= ARRAY_SIZE(zd1201_private_handler),
 	.num_private_args 	= ARRAY_SIZE(zd1201_private_args),
-	.standard 		= (iw_handler *)zd1201_iw_handler,
-	.private 		= (iw_handler *)zd1201_private_handler,
+	.standard		= zd1201_iw_handler,
+	.private		= zd1201_private_handler,
 	.private_args 		= (struct iw_priv_args *) zd1201_private_args,
 	.get_wireless_stats	= zd1201_get_wireless_stats,
 };
-- 
2.34.1

