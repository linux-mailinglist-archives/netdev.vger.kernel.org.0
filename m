Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F087C6B7082
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjCMHzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCMHzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:55:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CFF252B6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 204-20020a2514d5000000b00a3637aea9e1so12834179ybu.17
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678694026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+Dw9k6vY3PTkqStBfeYh6PHZicKW+NdFB3qNoYdHcw=;
        b=CnWPP3Rp0HdHqc2LfgC3qPsajKUnlJ83eKdUtgXPEkfkO//R3baIwXd8pSS4XzkG5z
         g1udXiMu4FYXqbXAfe7K4X9vEQ1yTGdOJNdnIYRPFZDqcVD6grDsXj3fpOEWf1r2P7GB
         iJRgbfh5RNnRKzjgkpJP6z/rwwsH4v30VbbVfgqXtxYGnAfAjGmnBH9jQp8pYPbSXO/J
         mhcdB/SbX8bFlx0zWPYR7YLsA511iP9n5FHALSk0mtNOLnFR3tvS6QyVbyF1iFWXIIDV
         85M2DOzGNLRqYixE1ZnkQhAlFXmh/u3+vhYKWra5yxAdYMKKzArYABwCy6Kio4A+Nx+n
         sAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678694026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x+Dw9k6vY3PTkqStBfeYh6PHZicKW+NdFB3qNoYdHcw=;
        b=XLrqGkTQx9e27lhtj2p/4Fzcm6ctCDlOpEYB6VQZVzUKt8vPnNCtPLLu8dGi7v2erV
         tDq8OMrC2yaI4dV8F4FMcg5UxhrctSOjAUgQzVDVe+5EsbsCfK05dL1u+ijbDVMBqrzp
         OSOAiS3ME/xDBOTP60nxLyGh0dB7O6VR1yB5ytCgypYHaD/QTk2nxGRlpLcjR+nDwoaE
         WJ1EjSIqlS/CKBwkbE+uPQ8P+9W3SM6TVZgo1zNHPilE3tL3ZFWNbFw7j+NFTPLAY82r
         txCVPBvzKsR6QXEs+FMcpKY6yR4WWkBS0yut85D0pN1MhTBEsw78DmNuLejl2B+K8pLI
         MGiw==
X-Gm-Message-State: AO0yUKW9Mao87PvKOKEr3Kfo7RTw0KKFT2qN+mk+Jdhnm/qhJgzC8JoN
        tvWw8hwiur6l+emHysO82tUWTwpobCc=
X-Google-Smtp-Source: AK7set9znKs+Tq855WMC5XCfM+6QYnzTDGvb9Q4YlAAE21JfLU04o2ae47FCtdkuEz6xEMWW9r5TpZJ82EY=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:10e:b0:98e:6280:74ca with SMTP id
 o14-20020a056902010e00b0098e628074camr18407166ybh.1.1678694025852; Mon, 13
 Mar 2023 00:53:45 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:53:24 +0000
In-Reply-To: <20230313075326.3594869-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313075326.3594869-4-jaewan@google.com>
Subject: [PATCH v9 3/5] mac80211_hwsim: add PMSR request support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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

Add necessary functionalities for mac80211_hwsim to start PMSR request by
passthrough the request to wmediumd via virtio. mac80211_hwsim can't
measure RTT for real because mac80211_hwsim the software simulator and
packets are sent almost immediately for real. This change expect wmediumd
to have all the location information of devices, so passthrough requests
to wmediumd.

In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
mac80211_hwsim receives the PMSR start request via
ieee80211_ops.start_pmsr, the received cfg80211_pmsr_request is resent to
the wmediumd with command HWSIM_CMD_START_PMSR and attribute
HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
nl80211_pmsr_start() expects.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V7 -> V8: Exported nl80211_send_chandef directly instead of creating
          wrapper.
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   6 +
 2 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 65868f28a00f..a692d9c95566 100644
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
+	err = nl80211_send_chandef(msg, &request->chandef);
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
index d10fa7f4853b..98e586a56582 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -81,6 +81,8 @@ enum hwsim_tx_control_flags {
  *	to this receiver address for a given station.
  * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
  *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
+ * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
+ *	%HWSIM_ATTR_PMSR_REQUEST.
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -93,6 +95,7 @@ enum {
 	HWSIM_CMD_GET_RADIO,
 	HWSIM_CMD_ADD_MAC_ADDR,
 	HWSIM_CMD_DEL_MAC_ADDR,
+	HWSIM_CMD_START_PMSR,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
@@ -144,6 +147,8 @@ enum {
  *	the new radio
  * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CREATE_RADIO
  *	to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
+ * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_START_PMSR
+ *	to provide details about peer measurement request (nl80211_peer_measurement_attrs)
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -176,6 +181,7 @@ enum {
 	HWSIM_ATTR_CIPHER_SUPPORT,
 	HWSIM_ATTR_MLO_SUPPORT,
 	HWSIM_ATTR_PMSR_SUPPORT,
+	HWSIM_ATTR_PMSR_REQUEST,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.40.0.rc1.284.g88254d51c5-goog

