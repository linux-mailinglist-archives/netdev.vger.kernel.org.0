Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0267D64FF49
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 16:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLRP2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 10:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLRP2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 10:28:38 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348945595
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 07:28:36 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3bd1ff8fadfso85168847b3.18
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 07:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTnrmznZU6bbCAJ+JruCQjNWW9+3Lyh9CJTRKYVqmOY=;
        b=Qnhqok0lq/p8nga2UGXNG895M9dJdFXAYsHphs7LuunCH9xGa31rRSPc74Er4pjS69
         o1pT3kaTgzBaowyUFRJFp80tumvE/AXxfMQhQ73amrWcpPyE0w5Don/x3RnBVhkwXG/N
         lGEoHZ7Ezg1VxlJ+wuUHFM8/37JyrJR/FMrtJfcqnR2mroTAq7eiaShsP2kjYKVyO81G
         nPGd9RzLAvSIr7D6HEMUMq6qOpQnX5KdE/tAVsso3KoztV4d9DhEBoN2+rHdr1kGMByW
         UCgGvxMl2e/BZoaFVKjqU6cadGbIcSzcf/AJlyeN9iw8zGgEzAtAAPzk3tzjOEG0uiBg
         1ihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTnrmznZU6bbCAJ+JruCQjNWW9+3Lyh9CJTRKYVqmOY=;
        b=d8gkp8AeU47BSTaBxxW83DFwDFsJsHKB0GaadDNcsxuhir4vZwkCAKd59aKr/o4kqz
         cfWgJa/AnKUX8wJfFVuif8fuYPpkW1IjxmqZ86X4Vz3/oHs5JfNdB8wI2gtNVEpqSxhV
         Cni1KOAIuGaJJyjtDT0PqwXE6EGQWRKIZzFqA0eqwo+GQW59LxEahNcAfDP9uxD3An93
         sDbyrAuo0NcDF4RoyfuvD98i3LBUYzjRKWZquj9B15BQbRTn8W7CSQJDDnMHlp3hEfvT
         iM4iwa3kAAPorQS7JJ0J9QoBnVnVkAiX8SUnY5ASVXHkwuwnBCm1abm7xSAR9UIjSwUW
         XQzA==
X-Gm-Message-State: ANoB5pmXH9gWR5wToU0MxVbaMwV553N3I5ysTtPAZLo4OCa2SaZnGD3D
        gsBcRX9n0quz30lOQReuX9UqyqHVvLE=
X-Google-Smtp-Source: AA0mqf4ZHgAnk+FPhOAYsgAO83Kxw5QrM0co9M5PM9DN9he7PRkTFTurIIjKBE3SKpeXVdH3mipiiMWG+54=
X-Received: from jaewan.seo.corp.google.com ([2401:fa00:d:11:a2d7:efaa:4e49:d20f])
 (user=jaewan job=sendgmr) by 2002:a25:8191:0:b0:700:ecb9:d811 with SMTP id
 p17-20020a258191000000b00700ecb9d811mr21929570ybk.470.1671377315482; Sun, 18
 Dec 2022 07:28:35 -0800 (PST)
Date:   Mon, 19 Dec 2022 00:28:19 +0900
In-Reply-To: <20221218152819.4018520-1-jaewan@google.com>
Mime-Version: 1.0
References: <20221205171851.2811239-2-jaewan@google.com> <20221218152819.4018520-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221218152819.4018520-2-jaewan@google.com>
Subject: [PATCH v2 2/2] mac80211_hwsim: handle RTT requests with virtio
From:   Jaewan Kim <jaewan@google.com>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
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

This CL adds PMSR (peer measurement) support,
which is generic measurement between peers.
And also adds its one and only mearsurement type - RTT (Round Trip Time).

Signed-off-by: Jaewan Kim <jaewan@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 683 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  54 +-
 include/net/cfg80211.h                |  10 +
 net/wireless/nl80211.c                |  11 +-
 4 files changed, 741 insertions(+), 17 deletions(-)

diff --git drivers/net/wireless/mac80211_hwsim.c drivers/net/wireless/mac80211_hwsim.c
index c7e314935023..5f7d9e4203af 100644
--- drivers/net/wireless/mac80211_hwsim.c
+++ drivers/net/wireless/mac80211_hwsim.c
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
@@ -3142,16 +3227,582 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
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
+	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
+		       request->burst_duration))
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
@@ -4828,13 +5479,6 @@ static void hwsim_mon_setup(struct net_device *dev)
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
@@ -5508,6 +6152,11 @@ static const struct genl_small_ops hwsim_ops[] = {
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
@@ -5519,7 +6168,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 	.small_ops = hwsim_ops,
 	.n_small_ops = ARRAY_SIZE(hwsim_ops),
-	.resv_start_op = HWSIM_CMD_DEL_MAC_ADDR + 1,
+	.resv_start_op = __HWSIM_CMD_MAX,
 	.mcgrps = hwsim_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
 };
@@ -5663,6 +6312,7 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 	struct genlmsghdr *gnlh;
 	struct nlattr *tb[HWSIM_ATTR_MAX + 1];
 	struct genl_info info = {};
+	struct netlink_ext_ack extack;
 	int err;
 
 	nlh = nlmsg_hdr(skb);
@@ -5679,6 +6329,7 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 	}
 
 	info.attrs = tb;
+	info.extack = &extack;
 
 	switch (gnlh->cmd) {
 	case HWSIM_CMD_FRAME:
@@ -5687,10 +6338,14 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
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
 
diff --git drivers/net/wireless/mac80211_hwsim.h drivers/net/wireless/mac80211_hwsim.h
index 81cd02d2555c..1d54fe4c402f 100644
--- drivers/net/wireless/mac80211_hwsim.h
+++ drivers/net/wireless/mac80211_hwsim.h
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
diff --git include/net/cfg80211.h include/net/cfg80211.h
index 1d3368e409d6..57b1c812fb29 100644
--- include/net/cfg80211.h
+++ include/net/cfg80211.h
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
diff --git net/wireless/nl80211.c net/wireless/nl80211.c
index 922586138025..e6491a5c910b 100644
--- net/wireless/nl80211.c
+++ net/wireless/nl80211.c
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
2.39.0.314.g84b9a713c41-goog

