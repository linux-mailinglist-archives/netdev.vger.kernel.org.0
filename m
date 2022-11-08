Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD576621D8E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKHUVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKHUVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464C069DC9;
        Tue,  8 Nov 2022 12:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA023B81C1C;
        Tue,  8 Nov 2022 20:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C23CC433D6;
        Tue,  8 Nov 2022 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667938903;
        bh=7H5cOjKdvFC+65oS59R3haDUTaZKrPGn0ZayGQxAldg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7ACygnbq0Sinui6YfAqoeldYq4ZLJ4S9f1TxRCFMo7NrXA1tZX/dCkNXo21ZOLlm
         uSRpamtTT1nk+YhJ1l+eJm0njG//BEnqHe7TRaUwyEIY1UFrRkdfKsuA+9Auy5bdDE
         7725pT4mgzp9DuA70idKmnZk6urM3irp1W0YqGbZXkRyvPQFbVAjjkp/KqBd8fTOQ5
         DvlCIlAwGJv+3zFxIOm0h1g8w5jJ0dg5GPTZ+gPez3292r5WCZIkxNgRZ+o8GT6EQL
         gRf35++l7nWuDv5SI9xHBURvhRGGyIb71c6RBSuEibaHT1hU4L5o9eLqo6I8vQKp3H
         upvE6I8aXzFGw==
Date:   Tue, 8 Nov 2022 14:21:24 -0600
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
Subject: [PATCH v3 1/7] wifi: orinoco: Avoid clashing function prototypes
Message-ID: <e564003608a1f2ad86283370ef816805c92b30f6.1667934775.git.gustavoars@kernel.org>
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

Fix a total of 43 warnings like these:

drivers/net/wireless/intersil/orinoco/wext.c:1379:27: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, struct iw_param *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        IW_HANDLER(SIOCGIWPOWER,        (iw_handler)orinoco_ioctl_getpower),
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The orinoco Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. No significant binary differences were seen
before/after changes.

These changes were made partly manually and partly with the help of
Coccinelle.

Link: https://github.com/KSPP/linux/issues/234
Link: https://reviews.llvm.org/D134831 [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Split patch out of cfg80211.
 - Remove iw_handler casts from orinoco_private_handler[].
 - Update changelog text.

Changes in v2:
 - Use IW_HANDLER in cfg80211_handlers instead of open-coded
        [IW_IOCTL_IDX(SIOCGIWRETRY)]    = cfg80211_wext_giwretry, ...
 - This patch was merged into cfg80211.
 - Link: https://lore.kernel.org/linux-hardening/c8239f5813dec6e5cfb554ca92b1783a18ac5537.1666894751.git.gustavoars@kernel.org/

v1:
 - Link: https://lore.kernel.org/linux-hardening/2387e02ae7f31388f24041cae8d02d5e12151708.1666038048.git.gustavoars@kernel.org/

 drivers/net/wireless/intersil/orinoco/wext.c | 109 +++++++++++--------
 1 file changed, 62 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/wext.c b/drivers/net/wireless/intersil/orinoco/wext.c
index 4a01260027bc..b8eb5d60192f 100644
--- a/drivers/net/wireless/intersil/orinoco/wext.c
+++ b/drivers/net/wireless/intersil/orinoco/wext.c
@@ -154,9 +154,10 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 
 static int orinoco_ioctl_setwap(struct net_device *dev,
 				struct iw_request_info *info,
-				struct sockaddr *ap_addr,
+				union iwreq_data *wrqu,
 				char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
@@ -213,9 +214,10 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
 
 static int orinoco_ioctl_getwap(struct net_device *dev,
 				struct iw_request_info *info,
-				struct sockaddr *ap_addr,
+				union iwreq_data *wrqu,
 				char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct orinoco_private *priv = ndev_priv(dev);
 
 	int err = 0;
@@ -234,9 +236,10 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 
 static int orinoco_ioctl_setiwencode(struct net_device *dev,
 				     struct iw_request_info *info,
-				     struct iw_point *erq,
+				     union iwreq_data *wrqu,
 				     char *keybuf)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	int setindex = priv->tx_key;
@@ -325,9 +328,10 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 
 static int orinoco_ioctl_getiwencode(struct net_device *dev,
 				     struct iw_request_info *info,
-				     struct iw_point *erq,
+				     union iwreq_data *wrqu,
 				     char *keybuf)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	unsigned long flags;
@@ -361,9 +365,10 @@ static int orinoco_ioctl_getiwencode(struct net_device *dev,
 
 static int orinoco_ioctl_setessid(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *erq,
+				  union iwreq_data *wrqu,
 				  char *essidbuf)
 {
+	struct iw_point *erq = &wrqu->essid;
 	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 
@@ -392,9 +397,10 @@ static int orinoco_ioctl_setessid(struct net_device *dev,
 
 static int orinoco_ioctl_getessid(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *erq,
+				  union iwreq_data *wrqu,
 				  char *essidbuf)
 {
+	struct iw_point *erq = &wrqu->essid;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int active;
 	int err = 0;
@@ -420,9 +426,10 @@ static int orinoco_ioctl_getessid(struct net_device *dev,
 
 static int orinoco_ioctl_setfreq(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_freq *frq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_freq *frq = &wrqu->freq;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int chan = -1;
 	unsigned long flags;
@@ -469,9 +476,10 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 
 static int orinoco_ioctl_getfreq(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_freq *frq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_freq *frq = &wrqu->freq;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int tmp;
 
@@ -488,9 +496,10 @@ static int orinoco_ioctl_getfreq(struct net_device *dev,
 
 static int orinoco_ioctl_getsens(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *srq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_param *srq = &wrqu->sens;
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct hermes *hw = &priv->hw;
 	u16 val;
@@ -517,9 +526,10 @@ static int orinoco_ioctl_getsens(struct net_device *dev,
 
 static int orinoco_ioctl_setsens(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *srq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_param *srq = &wrqu->sens;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int val = srq->value;
 	unsigned long flags;
@@ -540,9 +550,10 @@ static int orinoco_ioctl_setsens(struct net_device *dev,
 
 static int orinoco_ioctl_setrate(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int ratemode;
 	int bitrate; /* 100s of kilobits */
@@ -574,9 +585,10 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 
 static int orinoco_ioctl_getrate(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq,
+				 union iwreq_data *wrqu,
 				 char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 	int bitrate, automatic;
@@ -610,9 +622,10 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 
 static int orinoco_ioctl_setpower(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_param *prq,
+				  union iwreq_data *wrqu,
 				  char *extra)
 {
+	struct iw_param *prq = &wrqu->power;
 	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
@@ -664,9 +677,10 @@ static int orinoco_ioctl_setpower(struct net_device *dev,
 
 static int orinoco_ioctl_getpower(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_param *prq,
+				  union iwreq_data *wrqu,
 				  char *extra)
 {
+	struct iw_param *prq = &wrqu->power;
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct hermes *hw = &priv->hw;
 	int err = 0;
@@ -1097,7 +1111,7 @@ static int orinoco_ioctl_set_mlme(struct net_device *dev,
 
 static int orinoco_ioctl_reset(struct net_device *dev,
 			       struct iw_request_info *info,
-			       void *wrqu,
+			       union iwreq_data *wrqu,
 			       char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1121,7 +1135,7 @@ static int orinoco_ioctl_reset(struct net_device *dev,
 
 static int orinoco_ioctl_setibssport(struct net_device *dev,
 				     struct iw_request_info *info,
-				     void *wrqu,
+				     union iwreq_data *wrqu,
 				     char *extra)
 
 {
@@ -1143,7 +1157,7 @@ static int orinoco_ioctl_setibssport(struct net_device *dev,
 
 static int orinoco_ioctl_getibssport(struct net_device *dev,
 				     struct iw_request_info *info,
-				     void *wrqu,
+				     union iwreq_data *wrqu,
 				     char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1155,7 +1169,7 @@ static int orinoco_ioctl_getibssport(struct net_device *dev,
 
 static int orinoco_ioctl_setport3(struct net_device *dev,
 				  struct iw_request_info *info,
-				  void *wrqu,
+				  union iwreq_data *wrqu,
 				  char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1201,7 +1215,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 
 static int orinoco_ioctl_getport3(struct net_device *dev,
 				  struct iw_request_info *info,
-				  void *wrqu,
+				  union iwreq_data *wrqu,
 				  char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1213,7 +1227,7 @@ static int orinoco_ioctl_getport3(struct net_device *dev,
 
 static int orinoco_ioctl_setpreamble(struct net_device *dev,
 				     struct iw_request_info *info,
-				     void *wrqu,
+				     union iwreq_data *wrqu,
 				     char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1245,7 +1259,7 @@ static int orinoco_ioctl_setpreamble(struct net_device *dev,
 
 static int orinoco_ioctl_getpreamble(struct net_device *dev,
 				     struct iw_request_info *info,
-				     void *wrqu,
+				     union iwreq_data *wrqu,
 				     char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1265,9 +1279,10 @@ static int orinoco_ioctl_getpreamble(struct net_device *dev,
  * For Wireless Tools 25 and 26 append "dummy" are the end. */
 static int orinoco_ioctl_getrid(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_point *data,
+				union iwreq_data *wrqu,
 				char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct orinoco_private *priv = ndev_priv(dev);
 	struct hermes *hw = &priv->hw;
 	int rid = data->flags;
@@ -1303,7 +1318,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 /* Commit handler, called after set operations */
 static int orinoco_ioctl_commit(struct net_device *dev,
 				struct iw_request_info *info,
-				void *wrqu,
+				union iwreq_data *wrqu,
 				char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1347,36 +1362,36 @@ static const struct iw_priv_args orinoco_privtab[] = {
  */
 
 static const iw_handler	orinoco_handler[] = {
-	IW_HANDLER(SIOCSIWCOMMIT,	(iw_handler)orinoco_ioctl_commit),
+	IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
 	IW_HANDLER(SIOCGIWNAME,		(iw_handler)cfg80211_wext_giwname),
-	IW_HANDLER(SIOCSIWFREQ,		(iw_handler)orinoco_ioctl_setfreq),
-	IW_HANDLER(SIOCGIWFREQ,		(iw_handler)orinoco_ioctl_getfreq),
+	IW_HANDLER(SIOCSIWFREQ,		orinoco_ioctl_setfreq),
+	IW_HANDLER(SIOCGIWFREQ,		orinoco_ioctl_getfreq),
 	IW_HANDLER(SIOCSIWMODE,		(iw_handler)cfg80211_wext_siwmode),
 	IW_HANDLER(SIOCGIWMODE,		(iw_handler)cfg80211_wext_giwmode),
-	IW_HANDLER(SIOCSIWSENS,		(iw_handler)orinoco_ioctl_setsens),
-	IW_HANDLER(SIOCGIWSENS,		(iw_handler)orinoco_ioctl_getsens),
+	IW_HANDLER(SIOCSIWSENS,		orinoco_ioctl_setsens),
+	IW_HANDLER(SIOCGIWSENS,		orinoco_ioctl_getsens),
 	IW_HANDLER(SIOCGIWRANGE,	(iw_handler)cfg80211_wext_giwrange),
 	IW_HANDLER(SIOCSIWSPY,		iw_handler_set_spy),
 	IW_HANDLER(SIOCGIWSPY,		iw_handler_get_spy),
 	IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
 	IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
-	IW_HANDLER(SIOCSIWAP,		(iw_handler)orinoco_ioctl_setwap),
-	IW_HANDLER(SIOCGIWAP,		(iw_handler)orinoco_ioctl_getwap),
+	IW_HANDLER(SIOCSIWAP,		orinoco_ioctl_setwap),
+	IW_HANDLER(SIOCGIWAP,		orinoco_ioctl_getwap),
 	IW_HANDLER(SIOCSIWSCAN,		(iw_handler)cfg80211_wext_siwscan),
 	IW_HANDLER(SIOCGIWSCAN,		(iw_handler)cfg80211_wext_giwscan),
-	IW_HANDLER(SIOCSIWESSID,	(iw_handler)orinoco_ioctl_setessid),
-	IW_HANDLER(SIOCGIWESSID,	(iw_handler)orinoco_ioctl_getessid),
-	IW_HANDLER(SIOCSIWRATE,		(iw_handler)orinoco_ioctl_setrate),
-	IW_HANDLER(SIOCGIWRATE,		(iw_handler)orinoco_ioctl_getrate),
+	IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
+	IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
+	IW_HANDLER(SIOCSIWRATE,		orinoco_ioctl_setrate),
+	IW_HANDLER(SIOCGIWRATE,		orinoco_ioctl_getrate),
 	IW_HANDLER(SIOCSIWRTS,		(iw_handler)cfg80211_wext_siwrts),
 	IW_HANDLER(SIOCGIWRTS,		(iw_handler)cfg80211_wext_giwrts),
 	IW_HANDLER(SIOCSIWFRAG,		(iw_handler)cfg80211_wext_siwfrag),
 	IW_HANDLER(SIOCGIWFRAG,		(iw_handler)cfg80211_wext_giwfrag),
 	IW_HANDLER(SIOCGIWRETRY,	(iw_handler)cfg80211_wext_giwretry),
-	IW_HANDLER(SIOCSIWENCODE,	(iw_handler)orinoco_ioctl_setiwencode),
-	IW_HANDLER(SIOCGIWENCODE,	(iw_handler)orinoco_ioctl_getiwencode),
-	IW_HANDLER(SIOCSIWPOWER,	(iw_handler)orinoco_ioctl_setpower),
-	IW_HANDLER(SIOCGIWPOWER,	(iw_handler)orinoco_ioctl_getpower),
+	IW_HANDLER(SIOCSIWENCODE,	orinoco_ioctl_setiwencode),
+	IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
+	IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
+	IW_HANDLER(SIOCGIWPOWER,	orinoco_ioctl_getpower),
 	IW_HANDLER(SIOCSIWGENIE,	orinoco_ioctl_set_genie),
 	IW_HANDLER(SIOCGIWGENIE,	orinoco_ioctl_get_genie),
 	IW_HANDLER(SIOCSIWMLME,		orinoco_ioctl_set_mlme),
@@ -1391,15 +1406,15 @@ static const iw_handler	orinoco_handler[] = {
   Added typecasting since we no longer use iwreq_data -- Moustafa
  */
 static const iw_handler	orinoco_private_handler[] = {
-	[0] = (iw_handler)orinoco_ioctl_reset,
-	[1] = (iw_handler)orinoco_ioctl_reset,
-	[2] = (iw_handler)orinoco_ioctl_setport3,
-	[3] = (iw_handler)orinoco_ioctl_getport3,
-	[4] = (iw_handler)orinoco_ioctl_setpreamble,
-	[5] = (iw_handler)orinoco_ioctl_getpreamble,
-	[6] = (iw_handler)orinoco_ioctl_setibssport,
-	[7] = (iw_handler)orinoco_ioctl_getibssport,
-	[9] = (iw_handler)orinoco_ioctl_getrid,
+	[0] = orinoco_ioctl_reset,
+	[1] = orinoco_ioctl_reset,
+	[2] = orinoco_ioctl_setport3,
+	[3] = orinoco_ioctl_getport3,
+	[4] = orinoco_ioctl_setpreamble,
+	[5] = orinoco_ioctl_getpreamble,
+	[6] = orinoco_ioctl_setibssport,
+	[7] = orinoco_ioctl_getibssport,
+	[9] = orinoco_ioctl_getrid,
 };
 
 const struct iw_handler_def orinoco_handler_def = {
-- 
2.34.1

