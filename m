Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E84B68D1CE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 09:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjBGIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjBGIyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 03:54:21 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641D934027
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 00:54:18 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4bdeb1bbeafso138104097b3.4
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 00:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMQ0V26Pdhq4IjOzIKOprgL35Wrx/StaZBfs2k39axA=;
        b=ioJ7v/lMBjx8IKw59aTXlNGTYRs9prU0xur/ifWlM9yE7f8go8ZDZJorMRxqP2XrkE
         kM8XjAOplb06R0ROm/08E0AbtKZaZTOAtckx5xYEEzFGNBxSVc9zZNLI5EldIyHTp076
         WGHsCNYiQlac9qAxae2LlLy+cEgQJYXXPcKAqYrhF19/a4JnAgoEHyxbgOvnE/eOZX8R
         vppFLjfrGkBbcxpzrlN0wk417/9R7y7PPMEQBwUKqv0gj5/2khRbmzTIT0Qg4tGFaolQ
         /h/+DnIdZ9WmnTEJ2OTmlEuSbghdBhXPJMR3TJ+fbqfRQZHfl18XDi3OwHeGKeSeL1ej
         /uNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMQ0V26Pdhq4IjOzIKOprgL35Wrx/StaZBfs2k39axA=;
        b=rz9jPMBUTk7B+ITsGBXy/B+QvmbI39L9XgTnxX6nwk7JXbmRnALDptwa+U+qTV2vlx
         5um/EXl8Hb4Bm2ysp9B7p/eaGMka60e7DZz+Xubf72mZ0tBJ+8FmlkvxUMKcbe2LqcN3
         SWhPxaQY7qoJRc+mOyuPF9RhjKDDqNXvJFvhvNm9o6IU85fXzjvkkR8eTsvou7903HyS
         IInxK88oFaAeDvh8TfqJUrdPx7NynZ2ngHcb0YeQ1+7pVRTLr7uLjkoYqoLCiXdrdDgq
         HQcLxM9CkCuJMEwNeuKB96P2vHzl7xyRZwDUoNLLRgNrjbMQMccO+QzmlR4hU3RgidbY
         g9yQ==
X-Gm-Message-State: AO0yUKWPQYW/6o9BG4KqsOL8TF6BxalBG0dLUULy0oBUiVXfcXybFJqT
        QcN09bjZzvHPpNkikOxIrA1Fvt6ZkjI=
X-Google-Smtp-Source: AK7set+95AQDLT6Ke8pHcV194B8FyUsfv6v4Gpf6JhNCk5OHltysaN7gjTcO8GoQITu6Q8Q1v0/i8Qeuh1g=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a25:ac98:0:b0:880:c5ab:8a9a with SMTP id
 x24-20020a25ac98000000b00880c5ab8a9amr372420ybi.214.1675760057702; Tue, 07
 Feb 2023 00:54:17 -0800 (PST)
Date:   Tue,  7 Feb 2023 08:53:58 +0000
In-Reply-To: <20230207085400.2232544-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230207085400.2232544-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207085400.2232544-3-jaewan@google.com>
Subject: [PATCH v7 2/4] mac80211_hwsim: add PMSR request support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PMSR (a.k.a. peer measurement) is generalized measurement between two
Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
time measurement) is the one and only measurement. FTM is measured by
RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.

This change allows mac80211_hwsim to start PMSR request by passthrough
the request to wmediumd via virtio. mac80211_hwsim can't measure RTT for
real because mac80211_hwsim the software simulator and packets are sent
almost immediately for real. This change expect wmediumd to have all the
location information of devices, so passthrough requests to wmediumd.

This change adds HWSIM_CMD_ABORT_PMSR. When mac80211_hwsim receives the
PMSR start request via ieee80211_ops.start_pmsr, the received
cfg80211_pmsr_request is resent to the wmediumd with command
HWSIM_CMD_START_PMSR and attribute HWSIM_ATTR_PMSR_REQUEST. The
attribute is formatted as the same way as nl80211_pmsr_start() expects.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V1: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   4 +
 include/net/cfg80211.h                |  10 ++
 net/wireless/nl80211.c                |  10 +-
 4 files changed, 228 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index eca559e63d27..331772ff5d45 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
 
 	/* only used when pmsr capability is supplied */
 	struct cfg80211_pmsr_capabilities pmsr_capa;
+	struct cfg80211_pmsr_request *pmsr_request;
+	struct wireless_dev *pmsr_request_wdev;
 
 	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
 };
@@ -3139,6 +3141,208 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
+						     struct cfg80211_pmsr_ftm_request_peer *request)
+{
+	struct nlattr *ftm;
+
+	if (!request->requested)
+		return -EINVAL;
+
+	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
+	if (!ftm)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->preamble))
+		return -ENOBUFS;
+
+	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD, request->burst_period))
+		return -ENOBUFS;
+
+	if (request->asap && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_ASAP))
+		return -ENOBUFS;
+
+	if (request->request_lci && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI))
+		return -ENOBUFS;
+
+	if (request->request_civicloc &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC))
+		return -ENOBUFS;
+
+	if (request->trigger_based && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED))
+		return -ENOBUFS;
+
+	if (request->non_trigger_based &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED))
+		return -ENOBUFS;
+
+	if (request->lmr_feedback && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP, request->num_bursts_exp))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, request->burst_duration))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST, request->ftms_per_burst))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES, request->ftmr_retries))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, request->burst_duration))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR, request->bss_color))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, ftm);
+
+	return 0;
+}
+
+static int mac80211_hwsim_send_pmsr_request_peer(struct sk_buff *msg,
+						 struct cfg80211_pmsr_request_peer *request)
+{
+	struct nlattr *peer, *chandef, *req, *data;
+	int err;
+
+	peer = nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
+	if (!peer)
+		return -ENOBUFS;
+
+	if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN,
+		    request->addr))
+		return -ENOBUFS;
+
+	chandef = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
+	if (!chandef)
+		return -ENOBUFS;
+
+	err = cfg80211_send_chandef(msg, &request->chandef);
+	if (err)
+		return err;
+
+	nla_nest_end(msg, chandef);
+
+	req = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_REQ);
+	if (request->report_ap_tsf && nla_put_flag(msg, NL80211_PMSR_REQ_ATTR_GET_AP_TSF))
+		return -ENOBUFS;
+
+	data = nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
+	if (!data)
+		return -ENOBUFS;
+
+	err = mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->ftm);
+	if (err)
+		return err;
+
+	nla_nest_end(msg, data);
+	nla_nest_end(msg, req);
+	nla_nest_end(msg, peer);
+
+	return 0;
+}
+
+static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
+					    struct cfg80211_pmsr_request *request)
+{
+	int err;
+	struct nlattr *pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
+
+	if (!pmsr)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
+		return -ENOBUFS;
+
+	if (!is_zero_ether_addr(request->mac_addr)) {
+		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac_addr))
+			return -ENOBUFS;
+		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN, request->mac_addr_mask))
+			return -ENOBUFS;
+	}
+
+	for (int i = 0; i < request->n_peers; i++) {
+		err = mac80211_hwsim_send_pmsr_request_peer(msg, &request->peers[i]);
+		if (err)
+			return err;
+	}
+
+	nla_nest_end(msg, pmsr);
+
+	return 0;
+}
+
+static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct cfg80211_pmsr_request *request)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u32 _portid = READ_ONCE(data->wmediumd);
+	int err = 0;
+	struct sk_buff *skb = NULL;
+	void *msg_head;
+	struct nlattr *pmsr;
+
+	if (!_portid && !hwsim_virtio_enabled)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&data->mutex);
+
+	if (data->pmsr_request) {
+		err = -EBUSY;
+		goto out_err;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+
+	if (!skb) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			       HWSIM_CMD_START_PMSR);
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		    ETH_ALEN, data->addresses[1].addr)) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
+	if (!pmsr) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	err = mac80211_hwsim_send_pmsr_request(skb, request);
+	if (err)
+		goto out_err;
+
+	nla_nest_end(skb, pmsr);
+
+	genlmsg_end(skb, msg_head);
+	if (hwsim_virtio_enabled)
+		hwsim_tx_virtio(data, skb);
+	else
+		hwsim_unicast_netgroup(data, skb, _portid);
+
+out_err:
+	if (err && skb)
+		nlmsg_free(skb);
+
+	if (!err) {
+		data->pmsr_request = request;
+		data->pmsr_request_wdev = ieee80211_vif_to_wdev(vif);
+	}
+
+	mutex_unlock(&data->mutex);
+	return err;
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
@@ -3161,7 +3365,8 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	.flush = mac80211_hwsim_flush,				\
 	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
 	.get_et_stats = mac80211_hwsim_get_et_stats,		\
-	.get_et_strings = mac80211_hwsim_get_et_strings,
+	.get_et_strings = mac80211_hwsim_get_et_strings,	\
+	.start_pmsr = mac80211_hwsim_start_pmsr,		\
 
 #define HWSIM_NON_MLO_OPS					\
 	.sta_add = mac80211_hwsim_sta_add,			\
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 81cd02d2555c..4af237cef904 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -81,6 +81,7 @@ enum hwsim_tx_control_flags {
  *	to this receiver address for a given station.
  * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
  *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
+ * @HWSIM_CMD_START_PMSR: start PMSR
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -93,6 +94,7 @@ enum {
 	HWSIM_CMD_GET_RADIO,
 	HWSIM_CMD_ADD_MAC_ADDR,
 	HWSIM_CMD_DEL_MAC_ADDR,
+	HWSIM_CMD_START_PMSR,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
@@ -143,6 +145,7 @@ enum {
  * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
  *	the new radio
  * @HWSIM_ATTR_PMSR_SUPPORT: claim peer measurement support
+ * @HWSIM_ATTR_PMSR_REQUEST: peer measurement request
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -175,6 +178,7 @@ enum {
 	HWSIM_ATTR_CIPHER_SUPPORT,
 	HWSIM_ATTR_MLO_SUPPORT,
 	HWSIM_ATTR_PMSR_SUPPORT,
+	HWSIM_ATTR_PMSR_REQUEST,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 33f775b0f0b0..78a7a257b631 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -938,6 +938,16 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 				  const struct cfg80211_chan_def *chandef,
 				  enum nl80211_iftype iftype);
 
+/**
+ * cfg80211_send_chandef - sends the channel definition.
+ * @msg: the msg to send channel definition
+ * @chandef: the channel definition to check
+ *
+ * Returns: 0 if sent the channel definition to msg, < 0 on error
+ **/
+int cfg80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef);
+
+
 /**
  * ieee80211_chanwidth_rate_flags - return rate flags for channel width
  * @width: the channel width of the channel
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ae1924210663..c44611170caf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3739,8 +3739,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
-static int nl80211_send_chandef(struct sk_buff *msg,
-				const struct cfg80211_chan_def *chandef)
+int cfg80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef)
 {
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return -EINVAL;
@@ -3771,6 +3770,13 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	return 0;
 }
+EXPORT_SYMBOL(cfg80211_send_chandef);
+
+static int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef)
+{
+	return cfg80211_send_chandef(msg, chandef);
+}
+
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-- 
2.39.1.519.gcb327c4b5f-goog

