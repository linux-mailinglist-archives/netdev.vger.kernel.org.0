Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7A56A85C4
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCBQDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 11:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjCBQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 11:03:33 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2101231ED
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 08:03:30 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z63-20020a254c42000000b0087f69905709so4530182yba.10
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 08:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677773010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w6TV6qbj19Dh9PF1pUdhjuWma2mC8eJ9x5dw31gF7bU=;
        b=NRzgn+/c4lhOaNH6wxDCRn2fYRhmn0cInVe6SE40v1Q8IaqDkCQwjflWhMUV6ljLy+
         RkFZNLb4i/FY+HSGbnnBJt4vvnP+i1Mimv74S+/SfPR7GM0RjtFLpmkxgqkyzHHnmZJ0
         PF8j/X4aBeMgi1nb+yRPLBCQ86gw3E5wKcHbJuNEdv6vRe4HUVdMpPuaM+NwxSHDZdqN
         dxYi2TmsCnYl4qur9F7V4KC1jT++b0gPJToOQ19q4FaCmE26Ci6FMse94WHlvEAV7Kyw
         rI5SO0hMlxPt0yhOEJ7dpipqVhWnZnsfR19w6IULYzeiRQWU+ipdew0yT8y8eS+qrZmI
         oshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677773010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6TV6qbj19Dh9PF1pUdhjuWma2mC8eJ9x5dw31gF7bU=;
        b=KXggXelkRBPo1XcNTn8Aq0a9g+0i+ZWrWZlk5gIaIiFw8wwmfanhIgkxQ7lq3AjlG5
         djOjUL70ZjNI0B+wI+uv0R5noiJnVd2g2RCIWI7gsWAIWbeqt19aC65JTNYovdX697zq
         LvKmpkkm6lncAEdqr/xrxFDdtsWeCU6JdkbX6fzLLyx2Tdw/vIHmqSSgwYVc6vDhVhka
         SkHQh2e4uzpt+kWGVSM/us4dW6K8Gn405AlzNBv9I/Nb23BFhkPCZ48MsFrIqApHv2oz
         ZyOmvxAMA8mOdC5WFEF9NZvrjZz6ip6Aao9Ok3gUirzYN+61a4itHVVohuycmuW3avUh
         E1Fw==
X-Gm-Message-State: AO0yUKWV6QclRAkUi1+BsOPXxMcslUkb6i7rJcU0Pl0VJRfGLgR6A8bJ
        bg3A5GToT4vWm429cx1o6fdF1kaVpA0=
X-Google-Smtp-Source: AK7set/tW947DpdWPrxzVOolHTbfoMmP2EALIiTLcJumjpAgwAG44j0bLAejo8yAywN/6PfevNxBEqtlHfo=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:101:b0:a4e:4575:f3ec with SMTP id
 o1-20020a056902010100b00a4e4575f3ecmr4841455ybh.0.1677773009959; Thu, 02 Mar
 2023 08:03:29 -0800 (PST)
Date:   Thu,  2 Mar 2023 16:03:08 +0000
In-Reply-To: <20230302160310.923349-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230302160310.923349-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302160310.923349-4-jaewan@google.com>
Subject: [PATCH v8 3/5] mac80211_hwsim: add PMSR request support via virtio
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
V7->V8: Export nl80211_send_chandef directly and instead of creating
        wrapper.
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   6 +
 2 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 79476d55c1ca..691b83140d57 100644
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
2.39.2.722.g9855ee24e9-goog

