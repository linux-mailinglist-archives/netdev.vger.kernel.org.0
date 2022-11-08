Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F7D621DA8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKHU2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKHU2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:28:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB523147;
        Tue,  8 Nov 2022 12:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2128B615C0;
        Tue,  8 Nov 2022 20:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D9AC433D6;
        Tue,  8 Nov 2022 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667939288;
        bh=6fKsKVWWT08+n1qS1MdajT7uQBUlHR5HguN035AigaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GkqEvhVKafI2DW9vJx1vPux+bdhWRr4Hgis4ACKch8zteICX+cGSeWrOHap/gvzz6
         dFPXAdQD14+WzEHNYH/ElnQVCrEb7OyVsxFnJnw5D1I5kjU/bK+yvDpSNS3B25ns5X
         lOPV4BNIoMcbthJjkpEyQxCJ3ydSET61JkY4MM8EqO+6csMzZprCJGn5++OQzrNaiZ
         2eEamntTlEwKgC74AXE/4VgbC+bkzTYR5EZmQkoCX+CKAvK/X6OJ2L9SQXSeloKOrN
         w2Yur2QX0g/Luucbwtyr2AmFqbpPLdmgw3F6fpJaBO4IcUSvBBfr1z0RmidtORfvVd
         S4OiObdKI0YBw==
Date:   Tue, 8 Nov 2022 14:27:49 -0600
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
Subject: [PATCH v3 5/7] wifi: airo: Avoid clashing function prototypes
Message-ID: <820abf91d12809904696ddb8925ec5e1e0da3e4c.1667934775.git.gustavoars@kernel.org>
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

Fix a total of 32 warnings like these:

../drivers/net/wireless/cisco/airo.c:7570:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, void *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        (iw_handler) airo_config_commit,        /* SIOCSIWCOMMIT */
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The airo Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. There are no resulting binary differences
before/after changes.

These changes were made partly manually and partly with the help of
Coccinelle.

Link: https://github.com/KSPP/linux/issues/236
Link: https://reviews.llvm.org/D134831 [1]
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Update subject line: add prefix 'wifi: '.
 - Update changelog text.

Changes in v2:
 - Add RB tag from Kees.
 - Link: https://lore.kernel.org/linux-hardening/f125e61a737480c6e11005ea08684baea11e1b97.1666894751.git.gustavoars@kernel.org/

v1:
 - Link: https://lore.kernel.org/linux-hardening/ab0047382e6fd20c694e4ca14de8ca2c2a0e19d0.1666038048.git.gustavoars@kernel.org/

 drivers/net/wireless/cisco/airo.c | 204 ++++++++++++++++--------------
 1 file changed, 108 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index fb2c35bd73bb..7c4cc5f5e1eb 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -4807,7 +4807,8 @@ static int get_dec_u16(char *buffer, int *start, int limit)
 }
 
 static int airo_config_commit(struct net_device *dev,
-			      struct iw_request_info *info, void *zwrq,
+			      struct iw_request_info *info,
+			      union iwreq_data *wrqu,
 			      char *extra);
 
 static inline int sniffing_mode(struct airo_info *ai)
@@ -5814,10 +5815,10 @@ static int airo_get_quality (StatusRid *status_rid, CapabilityRid *cap_rid)
  */
 static int airo_get_name(struct net_device *dev,
 			 struct iw_request_info *info,
-			 char *cwrq,
+			 union iwreq_data *cwrq,
 			 char *extra)
 {
-	strcpy(cwrq, "IEEE 802.11-DS");
+	strcpy(cwrq->name, "IEEE 802.11-DS");
 	return 0;
 }
 
@@ -5827,9 +5828,10 @@ static int airo_get_name(struct net_device *dev,
  */
 static int airo_set_freq(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_freq *fwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_freq *fwrq = &wrqu->freq;
 	struct airo_info *local = dev->ml_priv;
 	int rc = -EINPROGRESS;		/* Call commit handler */
 
@@ -5868,9 +5870,10 @@ static int airo_set_freq(struct net_device *dev,
  */
 static int airo_get_freq(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_freq *fwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_freq *fwrq = &wrqu->freq;
 	struct airo_info *local = dev->ml_priv;
 	StatusRid status_rid;		/* Card status info */
 	int ch;
@@ -5900,9 +5903,10 @@ static int airo_get_freq(struct net_device *dev,
  */
 static int airo_set_essid(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_point *dwrq = &wrqu->essid;
 	struct airo_info *local = dev->ml_priv;
 	SsidRid SSID_rid;		/* SSIDs */
 
@@ -5945,9 +5949,10 @@ static int airo_set_essid(struct net_device *dev,
  */
 static int airo_get_essid(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_point *dwrq = &wrqu->essid;
 	struct airo_info *local = dev->ml_priv;
 	StatusRid status_rid;		/* Card status info */
 
@@ -5973,9 +5978,10 @@ static int airo_get_essid(struct net_device *dev,
  */
 static int airo_set_wap(struct net_device *dev,
 			struct iw_request_info *info,
-			struct sockaddr *awrq,
+			union iwreq_data *wrqu,
 			char *extra)
 {
+	struct sockaddr *awrq = &wrqu->ap_addr;
 	struct airo_info *local = dev->ml_priv;
 	Cmd cmd;
 	Resp rsp;
@@ -6008,9 +6014,10 @@ static int airo_set_wap(struct net_device *dev,
  */
 static int airo_get_wap(struct net_device *dev,
 			struct iw_request_info *info,
-			struct sockaddr *awrq,
+			union iwreq_data *wrqu,
 			char *extra)
 {
+	struct sockaddr *awrq = &wrqu->ap_addr;
 	struct airo_info *local = dev->ml_priv;
 	StatusRid status_rid;		/* Card status info */
 
@@ -6029,9 +6036,10 @@ static int airo_get_wap(struct net_device *dev,
  */
 static int airo_set_nick(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_point *dwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct airo_info *local = dev->ml_priv;
 
 	/* Check the size of the string */
@@ -6052,9 +6060,10 @@ static int airo_set_nick(struct net_device *dev,
  */
 static int airo_get_nick(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_point *dwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -6071,9 +6080,10 @@ static int airo_get_nick(struct net_device *dev,
  */
 static int airo_set_rate(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->bitrate;
 	struct airo_info *local = dev->ml_priv;
 	CapabilityRid cap_rid;		/* Card capability info */
 	u8	brate = 0;
@@ -6141,9 +6151,10 @@ static int airo_set_rate(struct net_device *dev,
  */
 static int airo_get_rate(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->bitrate;
 	struct airo_info *local = dev->ml_priv;
 	StatusRid status_rid;		/* Card status info */
 
@@ -6163,9 +6174,10 @@ static int airo_get_rate(struct net_device *dev,
  */
 static int airo_set_rts(struct net_device *dev,
 			struct iw_request_info *info,
-			struct iw_param *vwrq,
+			union iwreq_data *wrqu,
 			char *extra)
 {
+	struct iw_param *vwrq = &wrqu->rts;
 	struct airo_info *local = dev->ml_priv;
 	int rthr = vwrq->value;
 
@@ -6187,9 +6199,10 @@ static int airo_set_rts(struct net_device *dev,
  */
 static int airo_get_rts(struct net_device *dev,
 			struct iw_request_info *info,
-			struct iw_param *vwrq,
+			union iwreq_data *wrqu,
 			char *extra)
 {
+	struct iw_param *vwrq = &wrqu->rts;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -6206,9 +6219,9 @@ static int airo_get_rts(struct net_device *dev,
  */
 static int airo_set_frag(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
-			 char *extra)
+			 union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *vwrq = &wrqu->frag;
 	struct airo_info *local = dev->ml_priv;
 	int fthr = vwrq->value;
 
@@ -6231,9 +6244,10 @@ static int airo_set_frag(struct net_device *dev,
  */
 static int airo_get_frag(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->frag;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -6250,9 +6264,10 @@ static int airo_get_frag(struct net_device *dev,
  */
 static int airo_set_mode(struct net_device *dev,
 			 struct iw_request_info *info,
-			 __u32 *uwrq,
+			 union iwreq_data *uwrq,
 			 char *extra)
 {
+	__u32 mode = uwrq->mode;
 	struct airo_info *local = dev->ml_priv;
 	int reset = 0;
 
@@ -6260,7 +6275,7 @@ static int airo_set_mode(struct net_device *dev,
 	if (sniffing_mode(local))
 		reset = 1;
 
-	switch(*uwrq) {
+	switch (mode) {
 		case IW_MODE_ADHOC:
 			local->config.opmode &= ~MODE_CFG_MASK;
 			local->config.opmode |= MODE_STA_IBSS;
@@ -6313,7 +6328,7 @@ static int airo_set_mode(struct net_device *dev,
  */
 static int airo_get_mode(struct net_device *dev,
 			 struct iw_request_info *info,
-			 __u32 *uwrq,
+			 union iwreq_data *uwrq,
 			 char *extra)
 {
 	struct airo_info *local = dev->ml_priv;
@@ -6322,16 +6337,16 @@ static int airo_get_mode(struct net_device *dev,
 	/* If not managed, assume it's ad-hoc */
 	switch (local->config.opmode & MODE_CFG_MASK) {
 		case MODE_STA_ESS:
-			*uwrq = IW_MODE_INFRA;
+			uwrq->mode = IW_MODE_INFRA;
 			break;
 		case MODE_AP:
-			*uwrq = IW_MODE_MASTER;
+			uwrq->mode = IW_MODE_MASTER;
 			break;
 		case MODE_AP_RPTR:
-			*uwrq = IW_MODE_REPEAT;
+			uwrq->mode = IW_MODE_REPEAT;
 			break;
 		default:
-			*uwrq = IW_MODE_ADHOC;
+			uwrq->mode = IW_MODE_ADHOC;
 	}
 
 	return 0;
@@ -6348,9 +6363,10 @@ static inline int valid_index(struct airo_info *ai, int index)
  */
 static int airo_set_encode(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->encoding;
 	struct airo_info *local = dev->ml_priv;
 	int perm = (dwrq->flags & IW_ENCODE_TEMP ? 0 : 1);
 	__le16 currentAuthType = local->config.authType;
@@ -6447,9 +6463,10 @@ static int airo_set_encode(struct net_device *dev,
  */
 static int airo_get_encode(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->encoding;
 	struct airo_info *local = dev->ml_priv;
 	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 	int wep_key_len;
@@ -6794,9 +6811,10 @@ static int airo_get_auth(struct net_device *dev,
  */
 static int airo_set_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->txpower;
 	struct airo_info *local = dev->ml_priv;
 	CapabilityRid cap_rid;		/* Card capability info */
 	int i;
@@ -6831,9 +6849,10 @@ static int airo_set_txpow(struct net_device *dev,
  */
 static int airo_get_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->txpower;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -6851,9 +6870,10 @@ static int airo_get_txpow(struct net_device *dev,
  */
 static int airo_set_retry(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->retry;
 	struct airo_info *local = dev->ml_priv;
 	int rc = -EINVAL;
 
@@ -6889,9 +6909,10 @@ static int airo_set_retry(struct net_device *dev,
  */
 static int airo_get_retry(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->retry;
 	struct airo_info *local = dev->ml_priv;
 
 	vwrq->disabled = 0;      /* Can't be disabled */
@@ -6920,9 +6941,10 @@ static int airo_get_retry(struct net_device *dev,
  */
 static int airo_get_range(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_point *dwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct airo_info *local = dev->ml_priv;
 	struct iw_range *range = (struct iw_range *) extra;
 	CapabilityRid cap_rid;		/* Card capability info */
@@ -7046,9 +7068,9 @@ static int airo_get_range(struct net_device *dev,
  */
 static int airo_set_power(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
-			  char *extra)
+			  union iwreq_data *wrqu, char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -7104,9 +7126,10 @@ static int airo_set_power(struct net_device *dev,
  */
 static int airo_get_power(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  union iwreq_data *wrqu,
 			  char *extra)
 {
+	struct iw_param *vwrq = &wrqu->power;
 	struct airo_info *local = dev->ml_priv;
 	__le16 mode;
 
@@ -7135,9 +7158,10 @@ static int airo_get_power(struct net_device *dev,
  */
 static int airo_set_sens(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->sens;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -7154,9 +7178,10 @@ static int airo_set_sens(struct net_device *dev,
  */
 static int airo_get_sens(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_param *vwrq = &wrqu->sens;
 	struct airo_info *local = dev->ml_priv;
 
 	readConfigRid(local, 1);
@@ -7174,9 +7199,10 @@ static int airo_get_sens(struct net_device *dev,
  */
 static int airo_get_aplist(struct net_device *dev,
 			   struct iw_request_info *info,
-			   struct iw_point *dwrq,
+			   union iwreq_data *wrqu,
 			   char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct airo_info *local = dev->ml_priv;
 	struct sockaddr *address = (struct sockaddr *) extra;
 	struct iw_quality *qual;
@@ -7252,7 +7278,7 @@ static int airo_get_aplist(struct net_device *dev,
  */
 static int airo_set_scan(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_point *dwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
 	struct airo_info *ai = dev->ml_priv;
@@ -7483,9 +7509,10 @@ static inline char *airo_translate_scan(struct net_device *dev,
  */
 static int airo_get_scan(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_point *dwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
+	struct iw_point *dwrq = &wrqu->data;
 	struct airo_info *ai = dev->ml_priv;
 	BSSListElement *net;
 	int err = 0;
@@ -7527,7 +7554,7 @@ static int airo_get_scan(struct net_device *dev,
  */
 static int airo_config_commit(struct net_device *dev,
 			      struct iw_request_info *info,	/* NULL */
-			      void *zwrq,			/* NULL */
+			      union iwreq_data *wrqu,		/* NULL */
 			      char *extra)			/* NULL */
 {
 	struct airo_info *local = dev->ml_priv;
@@ -7577,61 +7604,46 @@ static const struct iw_priv_args airo_private_args[] = {
 
 static const iw_handler		airo_handler[] =
 {
-	(iw_handler) airo_config_commit,	/* SIOCSIWCOMMIT */
-	(iw_handler) airo_get_name,		/* SIOCGIWNAME */
-	(iw_handler) NULL,			/* SIOCSIWNWID */
-	(iw_handler) NULL,			/* SIOCGIWNWID */
-	(iw_handler) airo_set_freq,		/* SIOCSIWFREQ */
-	(iw_handler) airo_get_freq,		/* SIOCGIWFREQ */
-	(iw_handler) airo_set_mode,		/* SIOCSIWMODE */
-	(iw_handler) airo_get_mode,		/* SIOCGIWMODE */
-	(iw_handler) airo_set_sens,		/* SIOCSIWSENS */
-	(iw_handler) airo_get_sens,		/* SIOCGIWSENS */
-	(iw_handler) NULL,			/* SIOCSIWRANGE */
-	(iw_handler) airo_get_range,		/* SIOCGIWRANGE */
-	(iw_handler) NULL,			/* SIOCSIWPRIV */
-	(iw_handler) NULL,			/* SIOCGIWPRIV */
-	(iw_handler) NULL,			/* SIOCSIWSTATS */
-	(iw_handler) NULL,			/* SIOCGIWSTATS */
-	iw_handler_set_spy,			/* SIOCSIWSPY */
-	iw_handler_get_spy,			/* SIOCGIWSPY */
-	iw_handler_set_thrspy,			/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,			/* SIOCGIWTHRSPY */
-	(iw_handler) airo_set_wap,		/* SIOCSIWAP */
-	(iw_handler) airo_get_wap,		/* SIOCGIWAP */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) airo_get_aplist,		/* SIOCGIWAPLIST */
-	(iw_handler) airo_set_scan,		/* SIOCSIWSCAN */
-	(iw_handler) airo_get_scan,		/* SIOCGIWSCAN */
-	(iw_handler) airo_set_essid,		/* SIOCSIWESSID */
-	(iw_handler) airo_get_essid,		/* SIOCGIWESSID */
-	(iw_handler) airo_set_nick,		/* SIOCSIWNICKN */
-	(iw_handler) airo_get_nick,		/* SIOCGIWNICKN */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) airo_set_rate,		/* SIOCSIWRATE */
-	(iw_handler) airo_get_rate,		/* SIOCGIWRATE */
-	(iw_handler) airo_set_rts,		/* SIOCSIWRTS */
-	(iw_handler) airo_get_rts,		/* SIOCGIWRTS */
-	(iw_handler) airo_set_frag,		/* SIOCSIWFRAG */
-	(iw_handler) airo_get_frag,		/* SIOCGIWFRAG */
-	(iw_handler) airo_set_txpow,		/* SIOCSIWTXPOW */
-	(iw_handler) airo_get_txpow,		/* SIOCGIWTXPOW */
-	(iw_handler) airo_set_retry,		/* SIOCSIWRETRY */
-	(iw_handler) airo_get_retry,		/* SIOCGIWRETRY */
-	(iw_handler) airo_set_encode,		/* SIOCSIWENCODE */
-	(iw_handler) airo_get_encode,		/* SIOCGIWENCODE */
-	(iw_handler) airo_set_power,		/* SIOCSIWPOWER */
-	(iw_handler) airo_get_power,		/* SIOCGIWPOWER */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* -- hole -- */
-	(iw_handler) NULL,			/* SIOCSIWGENIE */
-	(iw_handler) NULL,			/* SIOCGIWGENIE */
-	(iw_handler) airo_set_auth,		/* SIOCSIWAUTH */
-	(iw_handler) airo_get_auth,		/* SIOCGIWAUTH */
-	(iw_handler) airo_set_encodeext,	/* SIOCSIWENCODEEXT */
-	(iw_handler) airo_get_encodeext,	/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,			/* SIOCSIWPMKSA */
+	IW_HANDLER(SIOCSIWCOMMIT,	airo_config_commit),
+	IW_HANDLER(SIOCGIWNAME,		airo_get_name),
+	IW_HANDLER(SIOCSIWFREQ,		airo_set_freq),
+	IW_HANDLER(SIOCGIWFREQ,		airo_get_freq),
+	IW_HANDLER(SIOCSIWMODE,		airo_set_mode),
+	IW_HANDLER(SIOCGIWMODE,		airo_get_mode),
+	IW_HANDLER(SIOCSIWSENS,		airo_set_sens),
+	IW_HANDLER(SIOCGIWSENS,		airo_get_sens),
+	IW_HANDLER(SIOCGIWRANGE,	airo_get_range),
+	IW_HANDLER(SIOCSIWSPY,		iw_handler_set_spy),
+	IW_HANDLER(SIOCGIWSPY,		iw_handler_get_spy),
+	IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
+	IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
+	IW_HANDLER(SIOCSIWAP,		airo_set_wap),
+	IW_HANDLER(SIOCGIWAP,		airo_get_wap),
+	IW_HANDLER(SIOCGIWAPLIST,	airo_get_aplist),
+	IW_HANDLER(SIOCSIWSCAN,		airo_set_scan),
+	IW_HANDLER(SIOCGIWSCAN,		airo_get_scan),
+	IW_HANDLER(SIOCSIWESSID,	airo_set_essid),
+	IW_HANDLER(SIOCGIWESSID,	airo_get_essid),
+	IW_HANDLER(SIOCSIWNICKN,	airo_set_nick),
+	IW_HANDLER(SIOCGIWNICKN,	airo_get_nick),
+	IW_HANDLER(SIOCSIWRATE,		airo_set_rate),
+	IW_HANDLER(SIOCGIWRATE,		airo_get_rate),
+	IW_HANDLER(SIOCSIWRTS,		airo_set_rts),
+	IW_HANDLER(SIOCGIWRTS,		airo_get_rts),
+	IW_HANDLER(SIOCSIWFRAG,		airo_set_frag),
+	IW_HANDLER(SIOCGIWFRAG,		airo_get_frag),
+	IW_HANDLER(SIOCSIWTXPOW,	airo_set_txpow),
+	IW_HANDLER(SIOCGIWTXPOW,	airo_get_txpow),
+	IW_HANDLER(SIOCSIWRETRY,	airo_set_retry),
+	IW_HANDLER(SIOCGIWRETRY,	airo_get_retry),
+	IW_HANDLER(SIOCSIWENCODE,	airo_set_encode),
+	IW_HANDLER(SIOCGIWENCODE,	airo_get_encode),
+	IW_HANDLER(SIOCSIWPOWER,	airo_set_power),
+	IW_HANDLER(SIOCGIWPOWER,	airo_get_power),
+	IW_HANDLER(SIOCSIWAUTH,		airo_set_auth),
+	IW_HANDLER(SIOCGIWAUTH,		airo_get_auth),
+	IW_HANDLER(SIOCSIWENCODEEXT,	airo_set_encodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT,	airo_get_encodeext),
 };
 
 /* Note : don't describe AIROIDIFC and AIROOLDIDIFC in here.
-- 
2.34.1

