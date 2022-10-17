Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF2601A71
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiJQUi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiJQUia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:38:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5C77FFA9;
        Mon, 17 Oct 2022 13:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B766B81A76;
        Mon, 17 Oct 2022 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2E4C433D6;
        Mon, 17 Oct 2022 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038942;
        bh=F36n4nCpfw2nmlWWxjmA4XyYrHFbK5qHOgNzg7nmRj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NdRLJQlxY7HyEZv03xCk0qHwOIL+TyaiFtS0JB3ORyGrvVkUfPL8Fv751Pbpq68sU
         Hc73vcn6u8WSImmHsOHM63HAUiGvB/wvyLNsvg0cTrvUwwFqO7lSRGEid80qiTctZv
         yuIdJJu+9lKy+BEW6gYoGoa7VoTuf42HM5vKuT7h4Niv/u3S7zjww/8DCMq8s60N4w
         qAnuzpZ4K62dj+Ms+qclwpKHwd5i+ClOKmsiPzhcmrwaXmmjVPx759jYY3AkOEsRb4
         DPfb7iW9hciXs0bLgFKibky7vQLARCEqK/DeyTXfIONjZ+8kW99wCpiDS5fI+9V1y1
         QQkdlyJ96FhNQ==
Date:   Mon, 17 Oct 2022 15:35:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 4/6][next] hostap: Avoid clashing function prototypes
Message-ID: <099d191c65efdf2f5f7b40a87a7eb3aabcae3e04.1666038048.git.gustavoars@kernel.org>
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

Fix a total of 42 warnings like these:

../drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3868:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, char *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        (iw_handler) prism2_get_name,                   /* SIOCGIWNAME */
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

The hostap Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. No significant binary differences were seen
before/after changes.

Link: https://github.com/KSPP/linux/issues/235
Link: https://reviews.llvm.org/D134831 [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 .../wireless/intersil/hostap/hostap_ioctl.c   | 245 ++++++++++--------
 1 file changed, 133 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
index 4e0a0c881697..25dcc3f32b67 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -91,7 +91,7 @@ static int prism2_get_datarates(struct net_device *dev, u8 *rates)
 
 static int prism2_get_name(struct net_device *dev,
 			   struct iw_request_info *info,
-			   char *name, char *extra)
+			   union iwreq_data *wrqu, char *extra)
 {
 	u8 rates[10];
 	int len, i, over2 = 0;
@@ -105,7 +105,7 @@ static int prism2_get_name(struct net_device *dev,
 		}
 	}
 
-	strcpy(name, over2 ? "IEEE 802.11b" : "IEEE 802.11-DS");
+	strcpy(wrqu->name, over2 ? "IEEE 802.11b" : "IEEE 802.11-DS");
 
 	return 0;
 }
@@ -113,8 +113,9 @@ static int prism2_get_name(struct net_device *dev,
 
 static int prism2_ioctl_siwencode(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *erq, char *keybuf)
+				  union iwreq_data *wrqu, char *keybuf)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int i;
@@ -215,8 +216,9 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 
 static int prism2_ioctl_giwencode(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *erq, char *key)
+				  union iwreq_data *wrqu, char *key)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int i, len;
@@ -321,8 +323,9 @@ static int hostap_set_rate(struct net_device *dev)
 
 static int prism2_ioctl_siwrate(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *rrq, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -381,8 +384,9 @@ static int prism2_ioctl_siwrate(struct net_device *dev,
 
 static int prism2_ioctl_giwrate(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *rrq, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->bitrate;
 	u16 val;
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -440,8 +444,9 @@ static int prism2_ioctl_giwrate(struct net_device *dev,
 
 static int prism2_ioctl_siwsens(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *sens, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *sens = &wrqu->sens;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -461,8 +466,9 @@ static int prism2_ioctl_siwsens(struct net_device *dev,
 
 static int prism2_ioctl_giwsens(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *sens, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *sens = &wrqu->sens;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 val;
@@ -485,8 +491,9 @@ static int prism2_ioctl_giwsens(struct net_device *dev,
 /* Deprecated in new wireless extension API */
 static int prism2_ioctl_giwaplist(struct net_device *dev,
 				  struct iw_request_info *info,
-				  struct iw_point *data, char *extra)
+				  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	struct sockaddr *addr;
@@ -526,8 +533,9 @@ static int prism2_ioctl_giwaplist(struct net_device *dev,
 
 static int prism2_ioctl_siwrts(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct iw_param *rts, char *extra)
+			       union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 val;
@@ -553,8 +561,9 @@ static int prism2_ioctl_siwrts(struct net_device *dev,
 
 static int prism2_ioctl_giwrts(struct net_device *dev,
 			       struct iw_request_info *info,
-			       struct iw_param *rts, char *extra)
+			       union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 val;
@@ -576,8 +585,9 @@ static int prism2_ioctl_giwrts(struct net_device *dev,
 
 static int prism2_ioctl_siwfrag(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *rts, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 val;
@@ -603,8 +613,9 @@ static int prism2_ioctl_siwfrag(struct net_device *dev,
 
 static int prism2_ioctl_giwfrag(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *rts, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rts = &wrqu->rts;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 val;
@@ -669,8 +680,9 @@ static int hostap_join_ap(struct net_device *dev)
 
 static int prism2_ioctl_siwap(struct net_device *dev,
 			      struct iw_request_info *info,
-			      struct sockaddr *ap_addr, char *extra)
+			      union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 #ifdef PRISM2_NO_STATION_MODES
 	return -EOPNOTSUPP;
 #else /* PRISM2_NO_STATION_MODES */
@@ -709,8 +721,9 @@ static int prism2_ioctl_siwap(struct net_device *dev,
 
 static int prism2_ioctl_giwap(struct net_device *dev,
 			      struct iw_request_info *info,
-			      struct sockaddr *ap_addr, char *extra)
+			      union iwreq_data *wrqu, char *extra)
 {
+	struct sockaddr *ap_addr = &wrqu->ap_addr;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -745,8 +758,9 @@ static int prism2_ioctl_giwap(struct net_device *dev,
 
 static int prism2_ioctl_siwnickn(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *nickname)
+				 union iwreq_data *wrqu, char *nickname)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -766,8 +780,9 @@ static int prism2_ioctl_siwnickn(struct net_device *dev,
 
 static int prism2_ioctl_giwnickn(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *nickname)
+				 union iwreq_data *wrqu, char *nickname)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int len;
@@ -793,8 +808,9 @@ static int prism2_ioctl_giwnickn(struct net_device *dev,
 
 static int prism2_ioctl_siwfreq(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_freq *freq, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *freq = &wrqu->freq;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -830,8 +846,9 @@ static int prism2_ioctl_siwfreq(struct net_device *dev,
 
 static int prism2_ioctl_giwfreq(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_freq *freq, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_freq *freq = &wrqu->freq;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	u16 val;
@@ -874,8 +891,9 @@ static void hostap_monitor_set_type(local_info_t *local)
 
 static int prism2_ioctl_siwessid(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *ssid)
+				 union iwreq_data *wrqu, char *ssid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -910,8 +928,9 @@ static int prism2_ioctl_siwessid(struct net_device *dev,
 
 static int prism2_ioctl_giwessid(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *essid)
+				 union iwreq_data *wrqu, char *essid)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	u16 val;
@@ -946,8 +965,9 @@ static int prism2_ioctl_giwessid(struct net_device *dev,
 
 static int prism2_ioctl_giwrange(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	struct iw_range *range = (struct iw_range *) extra;
@@ -1121,8 +1141,9 @@ static int hostap_monitor_mode_disable(local_info_t *local)
 
 static int prism2_ioctl_siwmode(struct net_device *dev,
 				struct iw_request_info *info,
-				__u32 *mode, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int double_reset = 0;
@@ -1197,8 +1218,9 @@ static int prism2_ioctl_siwmode(struct net_device *dev,
 
 static int prism2_ioctl_giwmode(struct net_device *dev,
 				struct iw_request_info *info,
-				__u32 *mode, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	__u32 *mode = &wrqu->mode;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -1222,8 +1244,9 @@ static int prism2_ioctl_giwmode(struct net_device *dev,
 
 static int prism2_ioctl_siwpower(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *wrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *wrq = &wrqu->power;
 #ifdef PRISM2_NO_STATION_MODES
 	return -EOPNOTSUPP;
 #else /* PRISM2_NO_STATION_MODES */
@@ -1281,8 +1304,9 @@ static int prism2_ioctl_siwpower(struct net_device *dev,
 
 static int prism2_ioctl_giwpower(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->power;
 #ifdef PRISM2_NO_STATION_MODES
 	return -EOPNOTSUPP;
 #else /* PRISM2_NO_STATION_MODES */
@@ -1339,8 +1363,9 @@ static int prism2_ioctl_giwpower(struct net_device *dev,
 
 static int prism2_ioctl_siwretry(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->retry;
 	struct hostap_interface *iface;
 	local_info_t *local;
 
@@ -1400,8 +1425,9 @@ static int prism2_ioctl_siwretry(struct net_device *dev,
 
 static int prism2_ioctl_giwretry(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->retry;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	__le16 shortretry, longretry, lifetime, altretry;
@@ -1494,8 +1520,9 @@ static u16 prism2_txpower_dBm_to_hfa386x(int val)
 
 static int prism2_ioctl_siwtxpow(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *rrq = &wrqu->txpower;
 	struct hostap_interface *iface;
 	local_info_t *local;
 #ifdef RAW_TXPOWER_SETTING
@@ -1575,9 +1602,10 @@ static int prism2_ioctl_siwtxpow(struct net_device *dev,
 
 static int prism2_ioctl_giwtxpow(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *rrq, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
 #ifdef RAW_TXPOWER_SETTING
+	struct iw_param *rrq = &wrqu->txpower;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	u16 resp0;
@@ -1710,8 +1738,9 @@ static inline int prism2_request_scan(struct net_device *dev)
 
 static int prism2_ioctl_siwscan(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_point *data, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int ret;
@@ -2057,8 +2086,9 @@ static inline int prism2_ioctl_giwscan_sta(struct net_device *dev,
 
 static int prism2_ioctl_giwscan(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_point *data, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int res;
@@ -2303,7 +2333,7 @@ static int prism2_ioctl_priv_inquire(struct net_device *dev, int *i)
 
 static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 					  struct iw_request_info *info,
-					  void *wrqu, char *extra)
+					  union iwreq_data *uwrq, char *extra)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -2654,7 +2684,7 @@ static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 
 static int prism2_ioctl_priv_get_prism2_param(struct net_device *dev,
 					      struct iw_request_info *info,
-					      void *wrqu, char *extra)
+					      union iwreq_data *wrqu, char *extra)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -2841,7 +2871,7 @@ static int prism2_ioctl_priv_get_prism2_param(struct net_device *dev,
 
 static int prism2_ioctl_priv_readmif(struct net_device *dev,
 				     struct iw_request_info *info,
-				     void *wrqu, char *extra)
+				     union iwreq_data *wrqu, char *extra)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -2862,7 +2892,7 @@ static int prism2_ioctl_priv_readmif(struct net_device *dev,
 
 static int prism2_ioctl_priv_writemif(struct net_device *dev,
 				      struct iw_request_info *info,
-				      void *wrqu, char *extra)
+				      union iwreq_data *wrqu, char *extra)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -2885,7 +2915,7 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int ret = 0;
-	u32 mode;
+	union iwreq_data wrqu;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -2899,8 +2929,8 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
 	if (*i == 0) {
 		/* Disable monitor mode - old mode was not saved, so go to
 		 * Master mode */
-		mode = IW_MODE_MASTER;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
+		wrqu.mode = IW_MODE_MASTER;
+		ret = prism2_ioctl_siwmode(dev, NULL, &wrqu, NULL);
 	} else if (*i == 1) {
 		/* netlink socket mode is not supported anymore since it did
 		 * not separate different devices from each other and was not
@@ -2916,8 +2946,8 @@ static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
 			local->monitor_type = PRISM2_MONITOR_PRISM;
 			break;
 		}
-		mode = IW_MODE_MONITOR;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
+		wrqu.mode = IW_MODE_MONITOR;
+		ret = prism2_ioctl_siwmode(dev, NULL, &wrqu, NULL);
 		hostap_monitor_mode_enable(local);
 	} else
 		ret = -EINVAL;
@@ -3079,8 +3109,9 @@ static int prism2_set_genericelement(struct net_device *dev, u8 *elem,
 
 static int prism2_ioctl_siwauth(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *data, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *data = &wrqu->param;
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 
@@ -3145,8 +3176,9 @@ static int prism2_ioctl_siwauth(struct net_device *dev,
 
 static int prism2_ioctl_giwauth(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_param *data, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *data = &wrqu->param;
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 
@@ -3184,8 +3216,9 @@ static int prism2_ioctl_giwauth(struct net_device *dev,
 
 static int prism2_ioctl_siwencodeext(struct net_device *dev,
 				     struct iw_request_info *info,
-				     struct iw_point *erq, char *extra)
+				     union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
@@ -3358,8 +3391,9 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 
 static int prism2_ioctl_giwencodeext(struct net_device *dev,
 				     struct iw_request_info *info,
-				     struct iw_point *erq, char *extra)
+				     union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *erq = &wrqu->encoding;
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	struct lib80211_crypt_data **crypt;
@@ -3666,16 +3700,18 @@ static int prism2_ioctl_set_assoc_ap_addr(local_info_t *local,
 
 static int prism2_ioctl_siwgenie(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	return prism2_set_genericelement(dev, extra, data->length);
 }
 
 
 static int prism2_ioctl_giwgenie(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_point *data, char *extra)
+				 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_point *data = &wrqu->data;
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
 	int len = local->generic_elem_len - 2;
@@ -3713,7 +3749,7 @@ static int prism2_ioctl_set_generic_element(local_info_t *local,
 
 static int prism2_ioctl_siwmlme(struct net_device *dev,
 				struct iw_request_info *info,
-				struct iw_point *data, char *extra)
+				union iwreq_data *wrqu, char *extra)
 {
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
@@ -3864,70 +3900,55 @@ const struct ethtool_ops prism2_ethtool_ops = {
 
 static const iw_handler prism2_handler[] =
 {
-	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
-	(iw_handler) prism2_get_name,			/* SIOCGIWNAME */
-	(iw_handler) NULL,				/* SIOCSIWNWID */
-	(iw_handler) NULL,				/* SIOCGIWNWID */
-	(iw_handler) prism2_ioctl_siwfreq,		/* SIOCSIWFREQ */
-	(iw_handler) prism2_ioctl_giwfreq,		/* SIOCGIWFREQ */
-	(iw_handler) prism2_ioctl_siwmode,		/* SIOCSIWMODE */
-	(iw_handler) prism2_ioctl_giwmode,		/* SIOCGIWMODE */
-	(iw_handler) prism2_ioctl_siwsens,		/* SIOCSIWSENS */
-	(iw_handler) prism2_ioctl_giwsens,		/* SIOCGIWSENS */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
-	(iw_handler) prism2_ioctl_giwrange,		/* SIOCGIWRANGE */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWPRIV */
-	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
-	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
-	iw_handler_set_spy,				/* SIOCSIWSPY */
-	iw_handler_get_spy,				/* SIOCGIWSPY */
-	iw_handler_set_thrspy,				/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,				/* SIOCGIWTHRSPY */
-	(iw_handler) prism2_ioctl_siwap,		/* SIOCSIWAP */
-	(iw_handler) prism2_ioctl_giwap,		/* SIOCGIWAP */
-	(iw_handler) prism2_ioctl_siwmlme,		/* SIOCSIWMLME */
-	(iw_handler) prism2_ioctl_giwaplist,		/* SIOCGIWAPLIST */
-	(iw_handler) prism2_ioctl_siwscan,		/* SIOCSIWSCAN */
-	(iw_handler) prism2_ioctl_giwscan,		/* SIOCGIWSCAN */
-	(iw_handler) prism2_ioctl_siwessid,		/* SIOCSIWESSID */
-	(iw_handler) prism2_ioctl_giwessid,		/* SIOCGIWESSID */
-	(iw_handler) prism2_ioctl_siwnickn,		/* SIOCSIWNICKN */
-	(iw_handler) prism2_ioctl_giwnickn,		/* SIOCGIWNICKN */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) prism2_ioctl_siwrate,		/* SIOCSIWRATE */
-	(iw_handler) prism2_ioctl_giwrate,		/* SIOCGIWRATE */
-	(iw_handler) prism2_ioctl_siwrts,		/* SIOCSIWRTS */
-	(iw_handler) prism2_ioctl_giwrts,		/* SIOCGIWRTS */
-	(iw_handler) prism2_ioctl_siwfrag,		/* SIOCSIWFRAG */
-	(iw_handler) prism2_ioctl_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) prism2_ioctl_siwtxpow,		/* SIOCSIWTXPOW */
-	(iw_handler) prism2_ioctl_giwtxpow,		/* SIOCGIWTXPOW */
-	(iw_handler) prism2_ioctl_siwretry,		/* SIOCSIWRETRY */
-	(iw_handler) prism2_ioctl_giwretry,		/* SIOCGIWRETRY */
-	(iw_handler) prism2_ioctl_siwencode,		/* SIOCSIWENCODE */
-	(iw_handler) prism2_ioctl_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) prism2_ioctl_siwpower,		/* SIOCSIWPOWER */
-	(iw_handler) prism2_ioctl_giwpower,		/* SIOCGIWPOWER */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) prism2_ioctl_siwgenie,		/* SIOCSIWGENIE */
-	(iw_handler) prism2_ioctl_giwgenie,		/* SIOCGIWGENIE */
-	(iw_handler) prism2_ioctl_siwauth,		/* SIOCSIWAUTH */
-	(iw_handler) prism2_ioctl_giwauth,		/* SIOCGIWAUTH */
-	(iw_handler) prism2_ioctl_siwencodeext,		/* SIOCSIWENCODEEXT */
-	(iw_handler) prism2_ioctl_giwencodeext,		/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,				/* SIOCSIWPMKSA */
-	(iw_handler) NULL,				/* -- hole -- */
+	IW_HANDLER(SIOCGIWNAME,		prism2_get_name),
+	IW_HANDLER(SIOCSIWFREQ,		prism2_ioctl_siwfreq),
+	IW_HANDLER(SIOCGIWFREQ,		prism2_ioctl_giwfreq),
+	IW_HANDLER(SIOCSIWMODE,		prism2_ioctl_siwmode),
+	IW_HANDLER(SIOCGIWMODE,		prism2_ioctl_giwmode),
+	IW_HANDLER(SIOCSIWSENS,		prism2_ioctl_siwsens),
+	IW_HANDLER(SIOCGIWSENS,		prism2_ioctl_giwsens),
+	IW_HANDLER(SIOCGIWRANGE,	prism2_ioctl_giwrange),
+	IW_HANDLER(SIOCSIWSPY,		iw_handler_set_spy),
+	IW_HANDLER(SIOCGIWSPY,		iw_handler_get_spy),
+	IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
+	IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
+	IW_HANDLER(SIOCSIWAP,		prism2_ioctl_siwap),
+	IW_HANDLER(SIOCGIWAP,		prism2_ioctl_giwap),
+	IW_HANDLER(SIOCSIWMLME,		prism2_ioctl_siwmlme),
+	IW_HANDLER(SIOCGIWAPLIST,       prism2_ioctl_giwaplist),
+	IW_HANDLER(SIOCSIWSCAN,		prism2_ioctl_siwscan),
+	IW_HANDLER(SIOCGIWSCAN,		prism2_ioctl_giwscan),
+	IW_HANDLER(SIOCSIWESSID,        prism2_ioctl_siwessid),
+	IW_HANDLER(SIOCGIWESSID,        prism2_ioctl_giwessid),
+	IW_HANDLER(SIOCSIWNICKN,        prism2_ioctl_siwnickn),
+	IW_HANDLER(SIOCGIWNICKN,        prism2_ioctl_giwnickn),
+	IW_HANDLER(SIOCSIWRATE,		prism2_ioctl_siwrate),
+	IW_HANDLER(SIOCGIWRATE,		prism2_ioctl_giwrate),
+	IW_HANDLER(SIOCSIWRTS,		prism2_ioctl_siwrts),
+	IW_HANDLER(SIOCGIWRTS,		prism2_ioctl_giwrts),
+	IW_HANDLER(SIOCSIWFRAG,		prism2_ioctl_siwfrag),
+	IW_HANDLER(SIOCGIWFRAG,		prism2_ioctl_giwfrag),
+	IW_HANDLER(SIOCSIWTXPOW,        prism2_ioctl_siwtxpow),
+	IW_HANDLER(SIOCGIWTXPOW,        prism2_ioctl_giwtxpow),
+	IW_HANDLER(SIOCSIWRETRY,        prism2_ioctl_siwretry),
+	IW_HANDLER(SIOCGIWRETRY,        prism2_ioctl_giwretry),
+	IW_HANDLER(SIOCSIWENCODE,       prism2_ioctl_siwencode),
+	IW_HANDLER(SIOCGIWENCODE,       prism2_ioctl_giwencode),
+	IW_HANDLER(SIOCSIWPOWER,        prism2_ioctl_siwpower),
+	IW_HANDLER(SIOCGIWPOWER,        prism2_ioctl_giwpower),
+	IW_HANDLER(SIOCSIWGENIE,        prism2_ioctl_siwgenie),
+	IW_HANDLER(SIOCGIWGENIE,        prism2_ioctl_giwgenie),
+	IW_HANDLER(SIOCSIWAUTH,		prism2_ioctl_siwauth),
+	IW_HANDLER(SIOCGIWAUTH,		prism2_ioctl_giwauth),
+	IW_HANDLER(SIOCSIWENCODEEXT,    prism2_ioctl_siwencodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT,    prism2_ioctl_giwencodeext),
 };
 
-static const iw_handler prism2_private_handler[] =
-{							/* SIOCIWFIRSTPRIV + */
-	(iw_handler) prism2_ioctl_priv_prism2_param,	/* 0 */
-	(iw_handler) prism2_ioctl_priv_get_prism2_param, /* 1 */
-	(iw_handler) prism2_ioctl_priv_writemif,	/* 2 */
-	(iw_handler) prism2_ioctl_priv_readmif,		/* 3 */
+static const iw_handler prism2_private_handler[] = {
+	IW_HANDLER(SIOCIWFIRSTPRIV + 0, prism2_ioctl_priv_prism2_param),
+	IW_HANDLER(SIOCIWFIRSTPRIV + 1, prism2_ioctl_priv_get_prism2_param),
+	IW_HANDLER(SIOCIWFIRSTPRIV + 2, prism2_ioctl_priv_writemif),
+	IW_HANDLER(SIOCIWFIRSTPRIV + 3, prism2_ioctl_priv_readmif),
 };
 
 const struct iw_handler_def hostap_iw_handler_def =
@@ -3935,8 +3956,8 @@ const struct iw_handler_def hostap_iw_handler_def =
 	.num_standard	= ARRAY_SIZE(prism2_handler),
 	.num_private	= ARRAY_SIZE(prism2_private_handler),
 	.num_private_args = ARRAY_SIZE(prism2_priv),
-	.standard	= (iw_handler *) prism2_handler,
-	.private	= (iw_handler *) prism2_private_handler,
+	.standard	= prism2_handler,
+	.private	= prism2_private_handler,
 	.private_args	= (struct iw_priv_args *) prism2_priv,
 	.get_wireless_stats = hostap_get_wireless_stats,
 };
-- 
2.34.1

