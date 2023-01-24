Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08573679BB3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbjAXOZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbjAXOZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:25:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1FF45BEA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:25:03 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso16403360ybx.19
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EBn9cs51T8sWpYfOxR1Yon3LxmrnOdi3v3+UZdTFS5s=;
        b=ZgN9KEXEUjfk5p2ogVVK2TrkZD1vwAm84qkXpt4HDDPhZj24lmwpcDcPK2ke9IylmH
         kqAJer3IU2eetCCUDz+7TYGkFYZ0NaqHGMPhxkirZPdASKd3scPQ8f6QKUqa3I+mVprm
         0gIeS5cmA6okYin9p3TIEPr/uRRqamyo/X0FzWMb6ljram0ZpgJhot5hAWGvriPmnzzC
         Oju5BcVQIFxq+idGLVxIv4jNG4tIGkUXWuVabcv9IY0RKqeFulgK6XyPksCA29wuodoT
         T0kcpRw1YNaW8woanCjZVVFCIASag4QMsxcVmgEbtdctVsPtR6amNlgLf6akq8z6NYer
         odcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBn9cs51T8sWpYfOxR1Yon3LxmrnOdi3v3+UZdTFS5s=;
        b=QG/KmKx8f1DECSUMn2AAyMxVcjkjXrkI9JxEMmvW0BePBnckPiScC/XX1PXuDn4UpQ
         MiNwfoM7hsRXUyEu5RGZVYYkQ8KYQPP4UqCFP92dIi7xGzLfpHla0jmkTARwy2yghfKW
         2lm9DDd3xTtxZTVlrmha3SgNCFW1ReFTzQN/M27SJFCjzy9Tv117osI9BBkopdm39lMg
         bNsOQXCsXabI9gUEZq2TS7r0h+EbGJz7cox23cPDc9Rek+MNHnlixBs3z/eDJSXmhPFO
         5vwsRq1oQubhqTxxV+MRCPQXu1Z91s265Ya87KCOdCuroJl39ffDX5CFWC84iFrhGhjp
         xxmw==
X-Gm-Message-State: AO0yUKW66+dUVB4hEFYKVnZwWcm1aN0SfMUaVL8EfDQN6uAhfVorIbiJ
        /OL3Z9hjNAAq45vOIzvcdWPgYgrHQz4=
X-Google-Smtp-Source: AK7set8Ss7iuS3zZcZzXUtKRgCUpS9msQXlRGTJlrOGXo73/9ddi+dVKLLnGGfWmqbIhn4cbeaXhf7IFsJk=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a81:13c3:0:b0:506:402d:7b44 with SMTP id
 186-20020a8113c3000000b00506402d7b44mr318296ywt.245.1674570302829; Tue, 24
 Jan 2023 06:25:02 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:24:31 +0000
In-Reply-To: <20230124142431.357990-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230124142431.357990-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230124142431.357990-3-jaewan@google.com>
Subject: [PATCH v5 2/2] mac80211_hwsim: handle FTM requests with virtio
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

This CL allows mac80211_hwsim to receive FTM request and send FTM response.
It passthrough request to wmediumd and gets response with virtio
to get the FTM information with another STA.

This CL adds following commands
 - HWSIM_CMD_START_PMSR: To send request to wmediumd
 - HWSIM_CMD_ABORT_PMSR: To send abort to wmediumd
 - HWSIM_CMD_REPORT_PMSR: To receive response from wmediumd

Request and response are formatted the same way as pmsr.c.
One exception is for sending rate_info -- hwsim_rate_info_attributes is
added to send rate_info as is.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 679 +++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  54 +-
 include/net/cfg80211.h                |  10 +
 net/wireless/nl80211.c                |  11 +-
 4 files changed, 737 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 84c9db9178c3..4191037f73b6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
 
 	/* only used when pmsr capability is supplied */
 	struct cfg80211_pmsr_capabilities pmsr_capa;
+	struct cfg80211_pmsr_request *pmsr_request;
+	struct wireless_dev *pmsr_request_wdev;
 
 	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
 };
@@ -750,6 +752,13 @@ struct hwsim_radiotap_ack_hdr {
 	__le16 rt_chbitmask;
 } __packed;
 
+static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
+{
+	return rhashtable_lookup_fast(&hwsim_radios_rht,
+				      addr,
+				      hwsim_rht_params);
+}
+
 /* MAC80211_HWSIM netlink family */
 static struct genl_family hwsim_genl_family;
 
@@ -763,6 +772,81 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
 
 /* MAC80211_HWSIM netlink policy */
 
+static const struct nla_policy
+hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] = {
+	[HWSIM_RATE_INFO_ATTR_FLAGS] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_MCS] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_LEGACY] = { .type = NLA_U16 },
+	[HWSIM_RATE_INFO_ATTR_NSS] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_BW] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_HE_GI] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_HE_DCM] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_EHT_GI] = { .type = NLA_U8 },
+	[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] = { .type = NLA_U8 },
+};
+
+static const struct nla_policy
+hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] = {
+	[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] = { .type = NLA_U16 },
+	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] = { .type = NLA_U8 },
+	[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] = { .type = NLA_U8 },
+	[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] = { .type = NLA_U8 },
+	[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] = { .type = NLA_U8 },
+	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] =
+		NLA_POLICY_NESTED(hwsim_rate_info_policy),
+	[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] =
+		NLA_POLICY_NESTED(hwsim_rate_info_policy),
+	[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] = { .type = NLA_U64 },
+	[NL80211_PMSR_FTM_RESP_ATTR_LCI] = { .type = NLA_STRING },
+	[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] = { .type = NLA_STRING },
+};
+
+static const struct nla_policy
+hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_result_policy),
+};
+
+static const struct nla_policy
+hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] = {
+	[NL80211_PMSR_RESP_ATTR_STATUS] = { .type = NLA_U32 },
+	[NL80211_PMSR_RESP_ATTR_HOST_TIME] = { .type = NLA_U64 },
+	[NL80211_PMSR_RESP_ATTR_AP_TSF] = { .type = NLA_U64 },
+	[NL80211_PMSR_RESP_ATTR_FINAL] = { .type = NLA_FLAG },
+	[NL80211_PMSR_RESP_ATTR_DATA] =
+		NLA_POLICY_NESTED(hwsim_pmsr_resp_type_policy),
+};
+
+static const struct nla_policy
+hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
+	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR_COMPAT,
+	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_REJECT },
+	[NL80211_PMSR_PEER_ATTR_REQ] = { .type = NLA_REJECT },
+	[NL80211_PMSR_PEER_ATTR_RESP] =
+		NLA_POLICY_NESTED(hwsim_pmsr_resp_policy),
+};
+
+static const struct nla_policy
+hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] = {
+	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_PEERS] =
+		NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_peer_result_policy),
+};
+
 static const struct nla_policy
 hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
@@ -780,7 +864,7 @@ hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
 };
 
 static const struct nla_policy
-hwsim_pmsr_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
 	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
 };
 
@@ -790,7 +874,7 @@ hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
 	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
 	[NL80211_PMSR_ATTR_TYPE_CAPA] =
-		NLA_POLICY_NESTED(hwsim_pmsr_type_policy),
+		NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
 	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
 };
 
@@ -823,6 +907,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
 	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
+	[HWSIM_ATTR_PMSR_RESULT] = NLA_POLICY_NESTED(hwsim_pmsr_peers_result_policy),
 };
 
 #if IS_REACHABLE(CONFIG_VIRTIO)
@@ -3142,16 +3227,578 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
+						     struct cfg80211_pmsr_ftm_request_peer *request)
+{
+	void *ftm;
+
+	if (!request || !request->requested)
+		return -EINVAL;
+
+	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
+	if (!ftm)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
+			request->preamble))
+		return -ENOBUFS;
+
+	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
+			request->burst_period))
+		return -ENOBUFS;
+
+	if (request->asap &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_ASAP))
+		return -ENOBUFS;
+
+	if (request->request_lci &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI))
+		return -ENOBUFS;
+
+	if (request->request_civicloc &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC))
+		return -ENOBUFS;
+
+	if (request->trigger_based &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED))
+		return -ENOBUFS;
+
+	if (request->non_trigger_based &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED))
+		return -ENOBUFS;
+
+	if (request->lmr_feedback &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP,
+		       request->num_bursts_exp))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
+		       request->burst_duration))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST,
+		       request->ftms_per_burst))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES,
+		       request->ftmr_retries))
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR,
+		       request->bss_color))
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
+	void *peer, *chandef, *req, *data;
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
+	if (request->report_ap_tsf &&
+	    nla_put_flag(msg, NL80211_PMSR_REQ_ATTR_GET_AP_TSF))
+		return -ENOBUFS;
+
+	data = nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
+	if (!data)
+		return -ENOBUFS;
+
+	mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->ftm);
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
+	void *pmsr;
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
+		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN,
+			    request->mac_addr_mask))
+			return -ENOBUFS;
+	}
+
+	for (int i = 0; i < request->n_peers; i++) {
+		err = mac80211_hwsim_send_pmsr_request_peer(msg,
+							    &request->peers[i]);
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
 				     struct cfg80211_pmsr_request *request)
 {
-	return -EOPNOTSUPP;
+	struct mac80211_hwsim_data *data = hw->priv;
+	u32 _portid = READ_ONCE(data->wmediumd);
+	int err = 0;
+	struct sk_buff *skb = NULL;
+	void *msg_head;
+	void *pmsr;
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
 }
 
-static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
 				      struct cfg80211_pmsr_request *request)
 {
-	// Do nothing for now.
+	struct mac80211_hwsim_data *data = hw->priv;
+	u32 _portid = READ_ONCE(data->wmediumd);
+	struct sk_buff *skb = NULL;
+	int err = 0;
+	void *msg_head;
+	void *pmsr;
+
+	if (!_portid && !hwsim_virtio_enabled)
+		return;
+
+	mutex_lock(&data->mutex);
+
+	if (data->pmsr_request != request) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	if (err)
+		goto out_err;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			       HWSIM_CMD_ABORT_PMSR);
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		    ETH_ALEN, data->addresses[1].addr)) {
+		err = -EINVAL;
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
+	err = nla_nest_end(skb, pmsr);
+	if (err)
+		goto out_err;
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
+	mutex_unlock(&data->mutex);
+}
+
+static int mac80211_hwsim_parse_rate_info(struct nlattr *rateattr,
+					  struct rate_info *rate_info,
+					  struct genl_info *info)
+{
+	struct nlattr *tb[HWSIM_RATE_INFO_ATTR_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, HWSIM_RATE_INFO_ATTR_MAX,
+			       rateattr, hwsim_rate_info_policy, info->extack);
+	if (ret)
+		return ret;
+
+	if (tb[HWSIM_RATE_INFO_ATTR_FLAGS])
+		rate_info->flags = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_FLAGS]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_MCS])
+		rate_info->mcs = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_MCS]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_LEGACY])
+		rate_info->legacy = nla_get_u16(tb[HWSIM_RATE_INFO_ATTR_LEGACY]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_NSS])
+		rate_info->nss = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_NSS]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_BW])
+		rate_info->bw = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_BW]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_HE_GI])
+		rate_info->he_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_GI]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_HE_DCM])
+		rate_info->he_dcm = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_DCM]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC])
+		rate_info->he_ru_alloc =
+			nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH])
+		rate_info->n_bonded_ch =
+			nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_EHT_GI])
+		rate_info->eht_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_GI]);
+
+	if (tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC])
+		rate_info->eht_ru_alloc =
+			nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC]);
+
+	return 0;
+}
+
+static int mac80211_hwsim_parse_ftm_result(struct nlattr *ftm,
+					   struct cfg80211_pmsr_ftm_result *result,
+					   struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, NL80211_PMSR_FTM_RESP_ATTR_MAX,
+			       ftm, hwsim_ftm_result_policy, info->extack);
+	if (ret)
+		return ret;
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON])
+		result->failure_reason =
+			nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX])
+		result->burst_index =
+			nla_get_u16(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]) {
+		result->num_ftmr_attempts_valid = 1;
+		result->num_ftmr_attempts =
+			nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]);
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]) {
+		result->num_ftmr_successes_valid = 1;
+		result->num_ftmr_successes =
+			nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]);
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME])
+		result->busy_retry_time =
+			nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP])
+		result->num_bursts_exp =
+			nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION])
+		result->burst_duration =
+			nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST])
+		result->ftms_per_burst =
+			nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST]);
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]) {
+		result->rssi_avg_valid = 1;
+		result->rssi_avg =
+			nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]) {
+		result->rssi_spread_valid = 1;
+		result->rssi_spread =
+			nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]);
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE]) {
+		result->tx_rate_valid = 1;
+		ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE],
+						     &result->tx_rate, info);
+		if (ret)
+			return ret;
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE]) {
+		result->rx_rate_valid = 1;
+		ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE],
+						     &result->rx_rate, info);
+		if (ret)
+			return ret;
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]) {
+		result->rtt_avg_valid = 1;
+		result->rtt_avg =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]) {
+		result->rtt_variance_valid = 1;
+		result->rtt_variance =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]) {
+		result->rtt_spread_valid = 1;
+		result->rtt_spread =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]) {
+		result->dist_avg_valid = 1;
+		result->dist_avg =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]) {
+		result->dist_variance_valid = 1;
+		result->dist_variance =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]);
+	}
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]) {
+		result->dist_spread_valid = 1;
+		result->dist_spread =
+			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]);
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]) {
+		result->lci = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
+		result->lci_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
+	}
+
+	if (tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]) {
+		result->civicloc = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
+		result->civicloc_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
+	}
+
+	return 0;
+}
+
+static int mac80211_hwsim_parse_pmsr_resp(struct nlattr *resp,
+					  struct cfg80211_pmsr_result *result,
+					  struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_RESP_ATTR_MAX + 1];
+	struct nlattr *pmsr;
+	int rem;
+	int ret;
+
+	ret = nla_parse_nested(tb, NL80211_PMSR_RESP_ATTR_MAX, resp,
+			       hwsim_pmsr_resp_policy, info->extack);
+
+	if (tb[NL80211_PMSR_RESP_ATTR_STATUS])
+		result->status = nla_get_u32(tb[NL80211_PMSR_RESP_ATTR_STATUS]);
+
+	if (tb[NL80211_PMSR_RESP_ATTR_HOST_TIME])
+		result->host_time = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_HOST_TIME]);
+
+	if (tb[NL80211_PMSR_RESP_ATTR_AP_TSF]) {
+		result->ap_tsf_valid = 1;
+		result->ap_tsf = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_AP_TSF]);
+	}
+
+	result->final = !!tb[NL80211_PMSR_RESP_ATTR_FINAL];
+
+	if (tb[NL80211_PMSR_RESP_ATTR_DATA]) {
+		nla_for_each_nested(pmsr, tb[NL80211_PMSR_RESP_ATTR_DATA], rem) {
+			switch (nla_type(pmsr)) {
+			case NL80211_PMSR_TYPE_FTM:
+				result->type = NL80211_PMSR_TYPE_FTM;
+				ret = mac80211_hwsim_parse_ftm_result(pmsr, &result->ftm, info);
+				if (ret)
+					return ret;
+				break;
+			default:
+				NL_SET_ERR_MSG_ATTR(info->extack,
+						    pmsr, "Unknown pmsr resp type");
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int mac80211_hwsim_parse_pmsr_result(struct nlattr *peer,
+					    struct cfg80211_pmsr_result *result,
+					    struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
+	int ret;
+
+	if (!peer)
+		return -EINVAL;
+
+	ret = nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer,
+			       hwsim_pmsr_peer_result_policy, info->extack);
+	if (ret)
+		return ret;
+
+	if (tb[NL80211_PMSR_PEER_ATTR_ADDR])
+		memcpy(result->addr, nla_data(tb[NL80211_PMSR_PEER_ATTR_ADDR]),
+		       ETH_ALEN);
+
+	if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
+		ret = mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMSR_PEER_ATTR_RESP], result, info);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+};
+
+static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
+{
+	struct nlattr *reqattr;
+	const u8 *src;
+	int err = 0;
+	int rem;
+	struct nlattr *peers, *peer;
+	struct mac80211_hwsim_data *data;
+
+	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+	data = get_hwsim_data_ref_from_addr(src);
+	if (!data)
+		return -EINVAL;
+
+	mutex_lock(&data->mutex);
+	if (!data->pmsr_request) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	reqattr = info->attrs[HWSIM_ATTR_PMSR_RESULT];
+	if (!reqattr) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	peers = nla_find_nested(reqattr, NL80211_PMSR_ATTR_PEERS);
+	if (!peers) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	nla_for_each_nested(peer, peers, rem) {
+		struct cfg80211_pmsr_result result;
+
+		err = mac80211_hwsim_parse_pmsr_result(peer, &result, info);
+		if (err)
+			goto out_err;
+
+		cfg80211_pmsr_report(data->pmsr_request_wdev,
+				     data->pmsr_request, &result, GFP_KERNEL);
+	}
+
+	cfg80211_pmsr_complete(data->pmsr_request_wdev, data->pmsr_request,
+			       GFP_KERNEL);
+
+out_err:
+	data->pmsr_request = NULL;
+	data->pmsr_request_wdev = NULL;
+
+	mutex_unlock(&data->mutex);
+	return err;
 }
 
 #define HWSIM_COMMON_OPS					\
@@ -4825,13 +5472,6 @@ static void hwsim_mon_setup(struct net_device *dev)
 	eth_hw_addr_set(dev, addr);
 }
 
-static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
-{
-	return rhashtable_lookup_fast(&hwsim_radios_rht,
-				      addr,
-				      hwsim_rht_params);
-}
-
 static void hwsim_register_wmediumd(struct net *net, u32 portid)
 {
 	struct mac80211_hwsim_data *data;
@@ -5507,6 +6147,11 @@ static const struct genl_small_ops hwsim_ops[] = {
 		.doit = hwsim_get_radio_nl,
 		.dumpit = hwsim_dump_radio_nl,
 	},
+	{
+		.cmd = HWSIM_CMD_REPORT_PMSR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = hwsim_pmsr_report_nl,
+	}
 };
 
 static struct genl_family hwsim_genl_family __ro_after_init = {
@@ -5518,7 +6163,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = hwsim_ops,
 	.n_small_ops = ARRAY_SIZE(hwsim_ops),
-	.resv_start_op = HWSIM_CMD_DEL_MAC_ADDR + 1,
+	.resv_start_op = __HWSIM_CMD_MAX,
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
@@ -5662,6 +6307,7 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 	struct genlmsghdr *gnlh;
 	struct nlattr *tb[HWSIM_ATTR_MAX + 1];
 	struct genl_info info = {};
+	struct netlink_ext_ack extack;
 	int err;
 
 	nlh = nlmsg_hdr(skb);
@@ -5678,6 +6324,7 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 	}
 
 	info.attrs = tb;
+	info.extack = &extack;
 
 	switch (gnlh->cmd) {
 	case HWSIM_CMD_FRAME:
@@ -5686,10 +6333,14 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 	case HWSIM_CMD_TX_INFO_FRAME:
 		hwsim_tx_info_frame_received_nl(skb, &info);
 		break;
+	case HWSIM_CMD_REPORT_PMSR:
+		hwsim_pmsr_report_nl(skb, &info);
+		break;
 	default:
 		pr_err_ratelimited("hwsim: invalid cmd: %d\n", gnlh->cmd);
 		return -EPROTO;
 	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 81cd02d2555c..1d54fe4c402f 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -81,6 +81,9 @@ enum hwsim_tx_control_flags {
  *	to this receiver address for a given station.
  * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
  *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
+ * @HWSIM_CMD_START_PMSR: start PMSR
+ * @HWSIM_CMD_ABORT_PMSR: abort PMSR
+ * @HWSIM_CMD_REPORT_PMSR: report PMSR results
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -93,6 +96,9 @@ enum {
 	HWSIM_CMD_GET_RADIO,
 	HWSIM_CMD_ADD_MAC_ADDR,
 	HWSIM_CMD_DEL_MAC_ADDR,
+	HWSIM_CMD_START_PMSR,
+	HWSIM_CMD_ABORT_PMSR,
+	HWSIM_CMD_REPORT_PMSR,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
@@ -143,10 +149,11 @@ enum {
  * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
  *	the new radio
  * @HWSIM_ATTR_PMSR_SUPPORT: claim peer measurement support
+ * @HWSIM_ATTR_PMSR_REQUEST: peer measurement request
+ * @HWSIM_ATTR_PMSR_RESULT: peer measurement result
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
-
 enum {
 	HWSIM_ATTR_UNSPEC,
 	HWSIM_ATTR_ADDR_RECEIVER,
@@ -175,6 +182,8 @@ enum {
 	HWSIM_ATTR_CIPHER_SUPPORT,
 	HWSIM_ATTR_MLO_SUPPORT,
 	HWSIM_ATTR_PMSR_SUPPORT,
+	HWSIM_ATTR_PMSR_REQUEST,
+	HWSIM_ATTR_PMSR_RESULT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
@@ -279,4 +288,47 @@ enum {
 	HWSIM_VQ_RX,
 	HWSIM_NUM_VQS,
 };
+
+/**
+ * enum hwsim_rate_info -- bitrate information.
+ *
+ * Information about a receiving or transmitting bitrate
+ * that can be mapped to struct rate_info
+ *
+ * @HWSIM_RATE_INFO_ATTR_FLAGS: bitflag of flags from &enum rate_info_flags
+ * @HWSIM_RATE_INFO_ATTR_MCS: mcs index if struct describes an HT/VHT/HE rate
+ * @HWSIM_RATE_INFO_ATTR_LEGACY: bitrate in 100kbit/s for 802.11abg
+ * @HWSIM_RATE_INFO_ATTR_NSS: number of streams (VHT & HE only)
+ * @HWSIM_RATE_INFO_ATTR_BW: bandwidth (from &enum rate_info_bw)
+ * @HWSIM_RATE_INFO_ATTR_HE_GI: HE guard interval (from &enum nl80211_he_gi)
+ * @HWSIM_RATE_INFO_ATTR_HE_DCM: HE DCM value
+ * @HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC:  HE RU allocation (from &enum nl80211_he_ru_alloc,
+ *	only valid if bw is %RATE_INFO_BW_HE_RU)
+ * @HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH: In case of EDMG the number of bonded channels (1-4)
+ * @HWSIM_RATE_INFO_ATTR_EHT_GI: EHT guard interval (from &enum nl80211_eht_gi)
+ * @HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC: EHT RU allocation (from &enum nl80211_eht_ru_alloc,
+ *	only valid if bw is %RATE_INFO_BW_EHT_RU)
+ * @NUM_HWSIM_RATE_INFO_ATTRS: internal
+ * @HWSIM_RATE_INFO_ATTR_MAX: highest attribute number
+ */
+enum hwsim_rate_info_attributes {
+	__HWSIM_RATE_INFO_ATTR_INVALID,
+
+	HWSIM_RATE_INFO_ATTR_FLAGS,
+	HWSIM_RATE_INFO_ATTR_MCS,
+	HWSIM_RATE_INFO_ATTR_LEGACY,
+	HWSIM_RATE_INFO_ATTR_NSS,
+	HWSIM_RATE_INFO_ATTR_BW,
+	HWSIM_RATE_INFO_ATTR_HE_GI,
+	HWSIM_RATE_INFO_ATTR_HE_DCM,
+	HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC,
+	HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH,
+	HWSIM_RATE_INFO_ATTR_EHT_GI,
+	HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC,
+
+	/* keep last */
+	NUM_HWSIM_RATE_INFO_ATTRS,
+	HWSIM_RATE_INFO_ATTR_MAX = NUM_HWSIM_RATE_INFO_ATTRS - 1
+};
+
 #endif /* __MAC80211_HWSIM_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 33f775b0f0b0..4223e81e0d26 100644
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
+int cfg80211_send_chandef(struct sk_buff *msg,
+			  const struct cfg80211_chan_def *chandef);
+
 /**
  * ieee80211_chanwidth_rate_flags - return rate flags for channel width
  * @width: the channel width of the channel
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b972a2135654..f9dda1801f50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3742,8 +3742,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
-static int nl80211_send_chandef(struct sk_buff *msg,
-				const struct cfg80211_chan_def *chandef)
+int cfg80211_send_chandef(struct sk_buff *msg,
+			  const struct cfg80211_chan_def *chandef)
 {
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return -EINVAL;
@@ -3774,6 +3774,13 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	return 0;
 }
+EXPORT_SYMBOL(cfg80211_send_chandef);
+
+static int nl80211_send_chandef(struct sk_buff *msg,
+				const struct cfg80211_chan_def *chandef)
+{
+	return cfg80211_send_chandef(msg, chandef);
+}
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-- 
2.39.0.246.g2a6d74b583-goog

