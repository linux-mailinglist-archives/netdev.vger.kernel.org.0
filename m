Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA679601A67
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiJQUhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJQUh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7918917E10;
        Mon, 17 Oct 2022 13:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5209B81A74;
        Mon, 17 Oct 2022 20:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC96C433D6;
        Mon, 17 Oct 2022 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038872;
        bh=7UX6j6F5sTRryY4fCR8niC+hFX4BEghwSjN/DowAEA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQYy1qM583njaRFaF+9eHXScJMdIuCMaOoUxvBqhD3eSpdDLJj+JqI1zlh7NuBZbB
         vGF/2FDAdbL3rOBbomW98VYQxqSushZLquBjIMpb0HX8yj+fGcH3Xp4RHMnMtTvifG
         d30Ezk7ElEjDMitpzu1tl4uqqI/gLQSJf2ObuxxRfIsHk2y5KrvdHVX4/2JFf5uMBM
         dvPYY8YRit/POWWHEzrb/8pLgRjlT83j+D9AERYUPtfS0+PhZg4ih6ZPr0BYig9XS3
         Em9kqBlm2cP7g+2GELW/q39lO32QB+1sSLS1vIrQDu1g+xTfYDYIeDza/7FZBPKudf
         PR1TS8gdEU3nw==
Date:   Mon, 17 Oct 2022 15:34:22 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/6][next] cfg80211: Avoid clashing function prototypes
Message-ID: <291de76bc7cd5c21dc2f2471382ab0caaf625b22.1666038048.git.gustavoars@kernel.org>
References: <cover.1666038048.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666038048.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Fix a total of 10 warnings like these:

../drivers/net/wireless/intersil/orinoco/wext.c:1390:27: error: incompatible function pointer types initializing 'const iw_handler' (aka 'int (*const)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') with an expression of type 'int (struct net_device *, struct iw_request_info *, struct iw_param *, char *)' [-Wincompatible-function-pointer-types]
        IW_HANDLER(SIOCGIWRETRY,        cfg80211_wext_giwretry),
                                        ^~~~~~~~~~~~~~~~~~~~~~
../include/uapi/linux/wireless.h:357:23: note: expanded from macro 'IW_HANDLER'
        [IW_IOCTL_IDX(id)] = func

The cfg80211 Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. No significant binary differences were seen 
before/after changes.

Link: https://github.com/KSPP/linux/issues/234
Link: https://reviews.llvm.org/D134831 [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intersil/orinoco/wext.c |  22 +--
 include/net/cfg80211-wext.h                  |  20 +--
 net/wireless/scan.c                          |   3 +-
 net/wireless/wext-compat.c                   | 180 +++++++++----------
 net/wireless/wext-compat.h                   |   8 +-
 net/wireless/wext-sme.c                      |   5 +-
 6 files changed, 112 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/wext.c b/drivers/net/wireless/intersil/orinoco/wext.c
index b8eb5d60192f..dea1ff044342 100644
--- a/drivers/net/wireless/intersil/orinoco/wext.c
+++ b/drivers/net/wireless/intersil/orinoco/wext.c
@@ -1363,31 +1363,31 @@ static const struct iw_priv_args orinoco_privtab[] = {
 
 static const iw_handler	orinoco_handler[] = {
 	IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
-	IW_HANDLER(SIOCGIWNAME,		(iw_handler)cfg80211_wext_giwname),
+	IW_HANDLER(SIOCGIWNAME,		cfg80211_wext_giwname),
 	IW_HANDLER(SIOCSIWFREQ,		orinoco_ioctl_setfreq),
 	IW_HANDLER(SIOCGIWFREQ,		orinoco_ioctl_getfreq),
-	IW_HANDLER(SIOCSIWMODE,		(iw_handler)cfg80211_wext_siwmode),
-	IW_HANDLER(SIOCGIWMODE,		(iw_handler)cfg80211_wext_giwmode),
+	IW_HANDLER(SIOCSIWMODE,		cfg80211_wext_siwmode),
+	IW_HANDLER(SIOCGIWMODE,		cfg80211_wext_giwmode),
 	IW_HANDLER(SIOCSIWSENS,		orinoco_ioctl_setsens),
 	IW_HANDLER(SIOCGIWSENS,		orinoco_ioctl_getsens),
-	IW_HANDLER(SIOCGIWRANGE,	(iw_handler)cfg80211_wext_giwrange),
+	IW_HANDLER(SIOCGIWRANGE,	cfg80211_wext_giwrange),
 	IW_HANDLER(SIOCSIWSPY,		iw_handler_set_spy),
 	IW_HANDLER(SIOCGIWSPY,		iw_handler_get_spy),
 	IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
 	IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
 	IW_HANDLER(SIOCSIWAP,		orinoco_ioctl_setwap),
 	IW_HANDLER(SIOCGIWAP,		orinoco_ioctl_getwap),
-	IW_HANDLER(SIOCSIWSCAN,		(iw_handler)cfg80211_wext_siwscan),
-	IW_HANDLER(SIOCGIWSCAN,		(iw_handler)cfg80211_wext_giwscan),
+	IW_HANDLER(SIOCSIWSCAN,		cfg80211_wext_siwscan),
+	IW_HANDLER(SIOCGIWSCAN,		cfg80211_wext_giwscan),
 	IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
 	IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
 	IW_HANDLER(SIOCSIWRATE,		orinoco_ioctl_setrate),
 	IW_HANDLER(SIOCGIWRATE,		orinoco_ioctl_getrate),
-	IW_HANDLER(SIOCSIWRTS,		(iw_handler)cfg80211_wext_siwrts),
-	IW_HANDLER(SIOCGIWRTS,		(iw_handler)cfg80211_wext_giwrts),
-	IW_HANDLER(SIOCSIWFRAG,		(iw_handler)cfg80211_wext_siwfrag),
-	IW_HANDLER(SIOCGIWFRAG,		(iw_handler)cfg80211_wext_giwfrag),
-	IW_HANDLER(SIOCGIWRETRY,	(iw_handler)cfg80211_wext_giwretry),
+	IW_HANDLER(SIOCSIWRTS,		cfg80211_wext_siwrts),
+	IW_HANDLER(SIOCGIWRTS,		cfg80211_wext_giwrts),
+	IW_HANDLER(SIOCSIWFRAG,		cfg80211_wext_siwfrag),
+	IW_HANDLER(SIOCGIWFRAG,		cfg80211_wext_giwfrag),
+	IW_HANDLER(SIOCGIWRETRY,	cfg80211_wext_giwretry),
 	IW_HANDLER(SIOCSIWENCODE,	orinoco_ioctl_setiwencode),
 	IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
 	IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
diff --git a/include/net/cfg80211-wext.h b/include/net/cfg80211-wext.h
index ad77caf2ffde..0ee36d97e068 100644
--- a/include/net/cfg80211-wext.h
+++ b/include/net/cfg80211-wext.h
@@ -19,34 +19,34 @@
  */
 int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
-			  char *name, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwscan(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
+			   union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra);
+			 union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwrts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra);
+			 union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_siwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_giwretry(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra);
+			   union iwreq_data *wrqu, char *extra);
 
 #endif /* __NET_CFG80211_WEXT_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 806a5f1330ff..853619bc0f1a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3229,8 +3229,9 @@ static int ieee80211_scan_results(struct cfg80211_registered_device *rdev,
 
 int cfg80211_wext_giwscan(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct cfg80211_registered_device *rdev;
 	int res;
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index ddf340bfa07a..b5274859ccfd 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -25,16 +25,17 @@
 
 int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
-			  char *name, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
-	strcpy(name, "IEEE 802.11");
+	strcpy(wrqu->name, "IEEE 802.11");
 	return 0;
 }
 EXPORT_WEXT_HANDLER(cfg80211_wext_giwname);
 
 int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
 	struct vif_params vifparams;
@@ -71,8 +72,9 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 EXPORT_WEXT_HANDLER(cfg80211_wext_siwmode);
 
 int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	if (!wdev)
@@ -108,8 +110,9 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_giwmode);
 
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra)
+			   union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
 	enum nl80211_band band;
@@ -251,8 +254,9 @@ int cfg80211_wext_freq(struct iw_freq *freq)
 
 int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra)
+			 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 orts = wdev->wiphy->rts_threshold;
@@ -281,8 +285,9 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_siwrts);
 
 int cfg80211_wext_giwrts(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra)
+			 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	rts->value = wdev->wiphy->rts_threshold;
@@ -295,8 +300,9 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_giwrts);
 
 int cfg80211_wext_siwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *frag = &wrqu->frag;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 ofrag = wdev->wiphy->frag_threshold;
@@ -325,8 +331,9 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_siwfrag);
 
 int cfg80211_wext_giwfrag(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *frag = &wrqu->frag;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	frag->value = wdev->wiphy->frag_threshold;
@@ -339,8 +346,9 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_giwfrag);
 
 static int cfg80211_wext_siwretry(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_param *retry, char *extra)
+				  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *retry = &wrqu->retry;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 changed = 0;
@@ -378,8 +386,9 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 
 int cfg80211_wext_giwretry(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra)
+			   union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *retry = &wrqu->retry;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	retry->disabled = 0;
@@ -588,8 +597,9 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 
 static int cfg80211_wext_siwencode(struct net_device *dev,
 				   struct iw_request_info *info,
-				   struct iw_point *erq, char *keybuf)
+				   union iwreq_data *wrqu, char *keybuf)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int idx, err;
@@ -664,8 +674,9 @@ static int cfg80211_wext_siwencode(struct net_device *dev,
 
 static int cfg80211_wext_siwencodeext(struct net_device *dev,
 				      struct iw_request_info *info,
-				      struct iw_point *erq, char *extra)
+				      union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
@@ -767,8 +778,9 @@ static int cfg80211_wext_siwencodeext(struct net_device *dev,
 
 static int cfg80211_wext_giwencode(struct net_device *dev,
 				   struct iw_request_info *info,
-				   struct iw_point *erq, char *keybuf)
+				   union iwreq_data *wrqu, char *keybuf)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int idx;
 
@@ -804,8 +816,9 @@ static int cfg80211_wext_giwencode(struct net_device *dev,
 
 static int cfg80211_wext_siwfreq(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_freq *wextfreq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *wextfreq = &wrqu->freq;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_chan_def chandef = {
@@ -870,8 +883,9 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 
 static int cfg80211_wext_giwfreq(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_freq *freq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *freq = &wrqu->freq;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_chan_def chandef = {};
@@ -1147,8 +1161,9 @@ static int cfg80211_set_key_mgt(struct wireless_dev *wdev, u32 key_mgt)
 
 static int cfg80211_wext_siwauth(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *data, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *data = &wrqu->param;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION)
@@ -1180,7 +1195,7 @@ static int cfg80211_wext_siwauth(struct net_device *dev,
 
 static int cfg80211_wext_giwauth(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *data, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
 	/* XXX: what do we need? */
 
@@ -1189,8 +1204,9 @@ static int cfg80211_wext_giwauth(struct net_device *dev,
 
 static int cfg80211_wext_siwpower(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_param *wrq, char *extra)
+				  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *wrq = &wrqu->power;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	bool ps;
@@ -1238,8 +1254,9 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 
 static int cfg80211_wext_giwpower(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_param *wrq, char *extra)
+				  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *wrq = &wrqu->power;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	wrq->disabled = !wdev->ps;
@@ -1249,8 +1266,9 @@ static int cfg80211_wext_giwpower(struct net_device *dev,
 
 static int cfg80211_wext_siwrate(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rate, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rate = &wrqu->bitrate;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bitrate_mask mask;
@@ -1307,8 +1325,9 @@ static int cfg80211_wext_siwrate(struct net_device *dev,
 
 static int cfg80211_wext_giwrate(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rate, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rate = &wrqu->bitrate;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct station_info sinfo = {};
@@ -1430,8 +1449,9 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 
 static int cfg80211_wext_siwap(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct sockaddr *ap_addr, char *extra)
+			       union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int ret;
@@ -1455,8 +1475,9 @@ static int cfg80211_wext_siwap(struct net_device *dev,
 
 static int cfg80211_wext_giwap(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct sockaddr *ap_addr, char *extra)
+			       union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int ret;
@@ -1480,8 +1501,9 @@ static int cfg80211_wext_giwap(struct net_device *dev,
 
 static int cfg80211_wext_siwessid(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *data, char *ssid)
+				  union iwreq_data *wrqu, char *ssid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int ret;
@@ -1505,8 +1527,9 @@ static int cfg80211_wext_siwessid(struct net_device *dev,
 
 static int cfg80211_wext_giwessid(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *data, char *ssid)
+				  union iwreq_data *wrqu, char *ssid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int ret;
@@ -1533,7 +1556,7 @@ static int cfg80211_wext_giwessid(struct net_device *dev,
 
 static int cfg80211_wext_siwpmksa(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *data, char *extra)
+				  union iwreq_data *wrqu, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -1584,78 +1607,39 @@ static int cfg80211_wext_siwpmksa(struct net_device *dev,
 	return ret;
 }
 
-#define DEFINE_WEXT_COMPAT_STUB(func, type)			\
-	static int __ ## func(struct net_device *dev,		\
-			      struct iw_request_info *info,	\
-			      union iwreq_data *wrqu,		\
-			      char *extra)			\
-	{							\
-		return func(dev, info, (type *)wrqu, extra);	\
-	}
-
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwname, char)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfreq, struct iw_freq)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfreq, struct iw_freq)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmode, u32)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwmode, u32)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrange, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwap, struct sockaddr)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwap, struct sockaddr)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmlme, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwscan, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwessid, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwessid, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrate, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrate, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrts, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrts, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfrag, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfrag, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwretry, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwretry, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencode, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwencode, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwpower, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpower, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwgenie, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwauth, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwauth, struct iw_param)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencodeext, struct iw_point)
-DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpmksa, struct iw_point)
-
 static const iw_handler cfg80211_handlers[] = {
-	[IW_IOCTL_IDX(SIOCGIWNAME)]	= __cfg80211_wext_giwname,
-	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= __cfg80211_wext_siwfreq,
-	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= __cfg80211_wext_giwfreq,
-	[IW_IOCTL_IDX(SIOCSIWMODE)]	= __cfg80211_wext_siwmode,
-	[IW_IOCTL_IDX(SIOCGIWMODE)]	= __cfg80211_wext_giwmode,
-	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= __cfg80211_wext_giwrange,
-	[IW_IOCTL_IDX(SIOCSIWAP)]	= __cfg80211_wext_siwap,
-	[IW_IOCTL_IDX(SIOCGIWAP)]	= __cfg80211_wext_giwap,
-	[IW_IOCTL_IDX(SIOCSIWMLME)]	= __cfg80211_wext_siwmlme,
-	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= cfg80211_wext_siwscan,
-	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= __cfg80211_wext_giwscan,
-	[IW_IOCTL_IDX(SIOCSIWESSID)]	= __cfg80211_wext_siwessid,
-	[IW_IOCTL_IDX(SIOCGIWESSID)]	= __cfg80211_wext_giwessid,
-	[IW_IOCTL_IDX(SIOCSIWRATE)]	= __cfg80211_wext_siwrate,
-	[IW_IOCTL_IDX(SIOCGIWRATE)]	= __cfg80211_wext_giwrate,
-	[IW_IOCTL_IDX(SIOCSIWRTS)]	= __cfg80211_wext_siwrts,
-	[IW_IOCTL_IDX(SIOCGIWRTS)]	= __cfg80211_wext_giwrts,
-	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= __cfg80211_wext_siwfrag,
-	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= __cfg80211_wext_giwfrag,
-	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= cfg80211_wext_siwtxpower,
-	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= cfg80211_wext_giwtxpower,
-	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= __cfg80211_wext_siwretry,
-	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= __cfg80211_wext_giwretry,
-	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= __cfg80211_wext_siwencode,
-	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= __cfg80211_wext_giwencode,
-	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= __cfg80211_wext_siwpower,
-	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= __cfg80211_wext_giwpower,
-	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= __cfg80211_wext_siwgenie,
-	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= __cfg80211_wext_siwauth,
-	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= __cfg80211_wext_giwauth,
-	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= __cfg80211_wext_siwencodeext,
-	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= __cfg80211_wext_siwpmksa,
+	[IW_IOCTL_IDX(SIOCGIWNAME)]     = cfg80211_wext_giwname,
+	[IW_IOCTL_IDX(SIOCSIWFREQ)]     = cfg80211_wext_siwfreq,
+	[IW_IOCTL_IDX(SIOCGIWFREQ)]     = cfg80211_wext_giwfreq,
+	[IW_IOCTL_IDX(SIOCSIWMODE)]     = cfg80211_wext_siwmode,
+	[IW_IOCTL_IDX(SIOCGIWMODE)]     = cfg80211_wext_giwmode,
+	[IW_IOCTL_IDX(SIOCGIWRANGE)]    = cfg80211_wext_giwrange,
+	[IW_IOCTL_IDX(SIOCSIWAP)]       = cfg80211_wext_siwap,
+	[IW_IOCTL_IDX(SIOCGIWAP)]       = cfg80211_wext_giwap,
+	[IW_IOCTL_IDX(SIOCSIWMLME)]     = cfg80211_wext_siwmlme,
+	[IW_IOCTL_IDX(SIOCSIWSCAN)]     = cfg80211_wext_siwscan,
+	[IW_IOCTL_IDX(SIOCGIWSCAN)]     = cfg80211_wext_giwscan,
+	[IW_IOCTL_IDX(SIOCSIWESSID)]    = cfg80211_wext_siwessid,
+	[IW_IOCTL_IDX(SIOCGIWESSID)]    = cfg80211_wext_giwessid,
+	[IW_IOCTL_IDX(SIOCSIWRATE)]     = cfg80211_wext_siwrate,
+	[IW_IOCTL_IDX(SIOCGIWRATE)]     = cfg80211_wext_giwrate,
+	[IW_IOCTL_IDX(SIOCSIWRTS)]      = cfg80211_wext_siwrts,
+	[IW_IOCTL_IDX(SIOCGIWRTS)]      = cfg80211_wext_giwrts,
+	[IW_IOCTL_IDX(SIOCSIWFRAG)]     = cfg80211_wext_siwfrag,
+	[IW_IOCTL_IDX(SIOCGIWFRAG)]     = cfg80211_wext_giwfrag,
+	[IW_IOCTL_IDX(SIOCSIWTXPOW)]    = cfg80211_wext_siwtxpower,
+	[IW_IOCTL_IDX(SIOCGIWTXPOW)]    = cfg80211_wext_giwtxpower,
+	[IW_IOCTL_IDX(SIOCSIWRETRY)]    = cfg80211_wext_siwretry,
+	[IW_IOCTL_IDX(SIOCGIWRETRY)]    = cfg80211_wext_giwretry,
+	[IW_IOCTL_IDX(SIOCSIWENCODE)]   = cfg80211_wext_siwencode,
+	[IW_IOCTL_IDX(SIOCGIWENCODE)]   = cfg80211_wext_giwencode,
+	[IW_IOCTL_IDX(SIOCSIWPOWER)]    = cfg80211_wext_siwpower,
+	[IW_IOCTL_IDX(SIOCGIWPOWER)]    = cfg80211_wext_giwpower,
+	[IW_IOCTL_IDX(SIOCSIWGENIE)]    = cfg80211_wext_siwgenie,
+	[IW_IOCTL_IDX(SIOCSIWAUTH)]     = cfg80211_wext_siwauth,
+	[IW_IOCTL_IDX(SIOCGIWAUTH)]     = cfg80211_wext_giwauth,
+	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= cfg80211_wext_siwencodeext,
+	[IW_IOCTL_IDX(SIOCSIWPMKSA)]    = cfg80211_wext_siwpmksa,
 };
 
 const struct iw_handler_def cfg80211_wext_handler = {
diff --git a/net/wireless/wext-compat.h b/net/wireless/wext-compat.h
index 8d3cc1552e2f..c02eb789e676 100644
--- a/net/wireless/wext-compat.h
+++ b/net/wireless/wext-compat.h
@@ -13,7 +13,7 @@
 
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct iw_freq *freq, char *extra);
+			       struct iw_freq *wextfreq, char *extra);
 int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_freq *freq, char *extra);
@@ -32,7 +32,7 @@ int cfg80211_ibss_wext_giwessid(struct net_device *dev,
 
 int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra);
+			      struct iw_freq *wextfreq, char *extra);
 int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
 			      struct iw_request_info *info,
 			      struct iw_freq *freq, char *extra);
@@ -51,10 +51,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 
 int cfg80211_wext_siwmlme(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra);
+			  union iwreq_data *wrqu, char *extra);
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
+			   union iwreq_data *wrqu, char *extra);
 
 
 int cfg80211_wext_freq(struct iw_freq *freq);
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 68f45afc352d..191c6d98c700 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -324,8 +324,9 @@ int cfg80211_mgd_wext_giwap(struct net_device *dev,
 
 int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra)
+			   union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u8 *ie = extra;
@@ -374,7 +375,7 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 
 int cfg80211_wext_siwmlme(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-- 
2.34.1

