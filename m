Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4EE601A78
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiJQUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiJQUj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:39:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC9F7437F;
        Mon, 17 Oct 2022 13:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A6E061280;
        Mon, 17 Oct 2022 20:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6873CC433C1;
        Mon, 17 Oct 2022 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038989;
        bh=8750zFEwFVNAjzVEB/qQuvRZAcia7DBMMJZC9I72k5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBDjXlRt9lKmF7p3KvZ1zR8MFGWbZcgJTW19bhyQHAMUg/IA466A9F3PSHJdhkzTt
         v5K7cxcdQziZerLEnb8M9AWvHeESdpp15Fh0H0+DeYQdUZ8waxh9bSdrlKmxnv2k1K
         wpe42i075BIULjmIAcrMZR1V8UoDuNIPVZfghxB1q3SpuTppTtRsIhhP0UYRZqdUv+
         uKI1gzDfzjOee+6invQQHC48hqSAcocX/ovBeNgleMI4TA4eWGz5elOcWW/cyUy3FD
         hKewJsrGH5I7cQSq7ytyGOiIrMrODhQJLKOshZneEWgjv35Z0bPdoIOoN9C78DD8rw
         Gr3M3cyCQORKA==
Date:   Mon, 17 Oct 2022 15:36:20 -0500
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
Subject: [PATCH 6/6][next] airo: Avoid clashing function prototypes
Message-ID: <ab0047382e6fd20c694e4ca14de8ca2c2a0e19d0.1666038048.git.gustavoars@kernel.org>
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

Fix a total of 32 warnings like these:

../drivers/net/wireless/cisco/airo.c:7570:2: warning: cast from 'int (*)(struct net_device *, struct iw_request_info *, void *, char *)' to 'iw_handler' (aka 'int (*)(struct net_device *, struct iw_request_info *, union iwreq_data *, char *)') converts to incompatible function type [-Wcast-function-type-strict]
        (iw_handler) airo_config_commit,        /* SIOCSIWCOMMIT */
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The airo Wireless Extension handler callbacks (iw_handler) use a
union for the data argument. Actually use the union and perform explicit
member selection in the function body instead of having a function
prototype mismatch. No significant binary differences were seen
before/after changes.

Link: https://github.com/KSPP/linux/issues/236
Link: https://reviews.llvm.org/D134831 [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 203 ++++++++++++++++--------------
 1 file changed, 107 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 10daef81c355..b04c586943f3 100644
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
@@ -5804,10 +5805,10 @@ static int airo_get_quality (StatusRid *status_rid, CapabilityRid *cap_rid)
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
 
@@ -5817,9 +5818,10 @@ static int airo_get_name(struct net_device *dev,
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
 
@@ -5858,9 +5860,10 @@ static int airo_set_freq(struct net_device *dev,
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
@@ -5890,9 +5893,10 @@ static int airo_get_freq(struct net_device *dev,
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
 
@@ -5935,9 +5939,10 @@ static int airo_set_essid(struct net_device *dev,
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
 
@@ -5963,9 +5968,10 @@ static int airo_get_essid(struct net_device *dev,
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
@@ -5998,9 +6004,10 @@ static int airo_set_wap(struct net_device *dev,
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
 
@@ -6019,9 +6026,10 @@ static int airo_get_wap(struct net_device *dev,
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
@@ -6042,9 +6050,10 @@ static int airo_set_nick(struct net_device *dev,
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
@@ -6061,9 +6070,10 @@ static int airo_get_nick(struct net_device *dev,
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
@@ -6131,9 +6141,10 @@ static int airo_set_rate(struct net_device *dev,
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
 
@@ -6153,9 +6164,10 @@ static int airo_get_rate(struct net_device *dev,
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
 
@@ -6177,9 +6189,10 @@ static int airo_set_rts(struct net_device *dev,
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
@@ -6196,9 +6209,9 @@ static int airo_get_rts(struct net_device *dev,
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
 
@@ -6221,9 +6234,10 @@ static int airo_set_frag(struct net_device *dev,
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
@@ -6240,7 +6254,7 @@ static int airo_get_frag(struct net_device *dev,
  */
 static int airo_set_mode(struct net_device *dev,
 			 struct iw_request_info *info,
-			 __u32 *uwrq,
+			 union iwreq_data *uwrq,
 			 char *extra)
 {
 	struct airo_info *local = dev->ml_priv;
@@ -6250,7 +6264,7 @@ static int airo_set_mode(struct net_device *dev,
 	if (sniffing_mode(local))
 		reset = 1;
 
-	switch(*uwrq) {
+	switch(uwrq->mode) {
 		case IW_MODE_ADHOC:
 			local->config.opmode &= ~MODE_CFG_MASK;
 			local->config.opmode |= MODE_STA_IBSS;
@@ -6303,7 +6317,7 @@ static int airo_set_mode(struct net_device *dev,
  */
 static int airo_get_mode(struct net_device *dev,
 			 struct iw_request_info *info,
-			 __u32 *uwrq,
+			 union iwreq_data *uwrq,
 			 char *extra)
 {
 	struct airo_info *local = dev->ml_priv;
@@ -6312,16 +6326,16 @@ static int airo_get_mode(struct net_device *dev,
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
@@ -6338,9 +6352,10 @@ static inline int valid_index(struct airo_info *ai, int index)
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
@@ -6437,9 +6452,10 @@ static int airo_set_encode(struct net_device *dev,
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
@@ -6784,9 +6800,10 @@ static int airo_get_auth(struct net_device *dev,
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
@@ -6821,9 +6838,10 @@ static int airo_set_txpow(struct net_device *dev,
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
@@ -6841,9 +6859,10 @@ static int airo_get_txpow(struct net_device *dev,
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
 
@@ -6879,9 +6898,10 @@ static int airo_set_retry(struct net_device *dev,
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
@@ -6910,9 +6930,10 @@ static int airo_get_retry(struct net_device *dev,
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
@@ -7036,9 +7057,9 @@ static int airo_get_range(struct net_device *dev,
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
@@ -7094,9 +7115,10 @@ static int airo_set_power(struct net_device *dev,
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
 
@@ -7125,9 +7147,10 @@ static int airo_get_power(struct net_device *dev,
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
@@ -7144,9 +7167,10 @@ static int airo_set_sens(struct net_device *dev,
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
@@ -7164,9 +7188,10 @@ static int airo_get_sens(struct net_device *dev,
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
@@ -7242,7 +7267,7 @@ static int airo_get_aplist(struct net_device *dev,
  */
 static int airo_set_scan(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_point *dwrq,
+			 union iwreq_data *wrqu,
 			 char *extra)
 {
 	struct airo_info *ai = dev->ml_priv;
@@ -7473,9 +7498,10 @@ static inline char *airo_translate_scan(struct net_device *dev,
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
@@ -7517,7 +7543,7 @@ static int airo_get_scan(struct net_device *dev,
  */
 static int airo_config_commit(struct net_device *dev,
 			      struct iw_request_info *info,	/* NULL */
-			      void *zwrq,			/* NULL */
+			      union iwreq_data *wrqu,		/* NULL */
 			      char *extra)			/* NULL */
 {
 	struct airo_info *local = dev->ml_priv;
@@ -7567,61 +7593,46 @@ static const struct iw_priv_args airo_private_args[] = {
 
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

