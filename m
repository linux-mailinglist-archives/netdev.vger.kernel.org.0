Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E966C4B8E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCVNTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjCVNT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F061E27497
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a5a0b6e3so190003257b3.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lYwZZzNmh4870sMzDZtuBCjqT0kLuGbZ8ONfstGvxjU=;
        b=HfEbW1h5tWIYPmE5JfLRmTZFJHRPxf65L1f9lQCzhkG3IL1ZZE3/gspDvQr4kecqpX
         np3JvSAnDbgS2Uu/rfM2Rx6G6OX8X18rHuv5MGnN7IFgR/ZhZDjsks+XSh1eKRL1DuIr
         YVgpb71T2o5DWOc0Y4TpRFhzBvjzBU6qg8cRcN6+w9c/3WTkKUZAtbQqSUfXGWoeHtwM
         Wx9mj/CRiy8uN5sTE4pOrccQD8vinM6MIMeHYUSLXbiCwNd/yu8w5oJW9yZdeaBtIb6G
         OvGdxNi/vEQNRvXPaTTRZ7PCNqEeRD1WRd9DqqIoJVw3iCp55uuvI6V/WsmDwLAqdSr1
         etDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lYwZZzNmh4870sMzDZtuBCjqT0kLuGbZ8ONfstGvxjU=;
        b=4somNmIBsKDP8cQUsliwQp8LPOeaSBGyBfU0Qchql4CwfecsQ48nHWBzz8cJbDW/E+
         q236WTJU6d4s32hTWfSej5KVq5bve2x+LLDQIU3/Km5hREPMkvLTzWOMDllTuK9TrP6b
         bCbWWyAHyMcmao8Urg177viqSN/7YkZdWS76zjQ8wh5QkQ8xKgdguZWnF5M3nDkgiIba
         thpk/bGbyIrP0m/gePwXl/Su+Xg1ECIW2s7IHapEk5wnrp0ygCx2RzrHOvqF/wllaUKJ
         x88VoNdfm8YAz/M/9qVjA0JNFbhHQSJH66qWbZoPvWrFzJ/HD7KUokk3wJ8TT6V18frR
         XcbA==
X-Gm-Message-State: AAQBX9d7Ai0NxH2K8/bwKppyjK15lx6Ty2GQUJStghyrs083eWZrgUuB
        /UTDOBvxtxM5Iqasl4wrWEtAUyho/Bk=
X-Google-Smtp-Source: AKy350ZCnUaWodWJ7YnbBQtl5FYWM+9P71cAFq+NsVRlYJ9h51gMQ3bcK4GPw59FuxejhNNKlK/L/l2YjsA=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:1005:b0:a58:7139:cf85 with SMTP id
 w5-20020a056902100500b00a587139cf85mr3899155ybt.13.1679491163738; Wed, 22 Mar
 2023 06:19:23 -0700 (PDT)
Date:   Wed, 22 Mar 2023 13:16:35 +0000
In-Reply-To: <20230322131637.2633968-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230322131637.2633968-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230322131637.2633968-4-jaewan@google.com>
Subject: [PATCH v10 3/5] mac80211_hwsim: add PMSR request support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     michal.kubiak@intel.com, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
V8 -> V10: Applied reverse xmas tree style (a.k.a. RCS).
           Fixed to check nla_nest_start() result before use.
V7 -> V8: Exported nl80211_send_chandef directly instead of creating
          wrapper.
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 210 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   6 +
 2 files changed, 215 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 894049b15f3f..84f47b532d4b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
 
 	/* only used when pmsr capability is supplied */
 	struct cfg80211_pmsr_capabilities pmsr_capa;
+	struct cfg80211_pmsr_request *pmsr_request;
+	struct wireless_dev *pmsr_request_wdev;
 
 	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
 };
@@ -3139,6 +3141,211 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
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
+	if (!req)
+		return -ENOBUFS;
+
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
+	struct nlattr *pmsr;
+	int err;
+
+	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
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
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb = NULL;
+	struct nlattr *pmsr;
+	void *msg_head;
+	u32 _portid;
+	int err = 0;
+
+	data = hw->priv;
+	_portid = READ_ONCE(data->wmediumd);
+	if (!_portid && !hwsim_virtio_enabled)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&data->mutex);
+
+	if (data->pmsr_request) {
+		err = -EBUSY;
+		goto out_free;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+
+	if (!skb) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_CMD_START_PMSR);
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		    ETH_ALEN, data->addresses[1].addr)) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
+	if (!pmsr) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	err = mac80211_hwsim_send_pmsr_request(skb, request);
+	if (err)
+		goto out_free;
+
+	nla_nest_end(skb, pmsr);
+
+	genlmsg_end(skb, msg_head);
+	if (hwsim_virtio_enabled)
+		hwsim_tx_virtio(data, skb);
+	else
+		hwsim_unicast_netgroup(data, skb, _portid);
+
+	data->pmsr_request = request;
+	data->pmsr_request_wdev = ieee80211_vif_to_wdev(vif);
+
+out_free:
+	if (err && skb)
+		nlmsg_free(skb);
+
+	mutex_unlock(&data->mutex);
+	return err;
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
@@ -3161,7 +3368,8 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
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

