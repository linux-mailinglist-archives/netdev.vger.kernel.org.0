Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5317679CA4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjAXOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjAXOym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:54:42 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FC54B48E
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:54:40 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id me17-20020a17090b17d100b0022901e51ab3so11253933pjb.2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDEq+hcMKeYMe2qDeryigFHsBJcRfk5HdpwyAexDCsM=;
        b=TwZZW1PtF2BaSuKN3Hu0J/wdL9cwQONaev9kAhZg11OSgGkAsIpwfe0QdfCjlN4c0w
         LqUFRhbC/+tfFRvsfOCwTMIIoO/E434xgyJAA9uXgChyC8w7L3f7zAGgSUuLaFt7ED3f
         CysTY2AP1rT74TEtEEKyrmghxxWaJ6ODmeWjZSvQaFIs4Up0ZhgV6ulg2ZPqSzHQLmfG
         fDiGUldKJnmzNhz5zXuuq5TgD6KqaD7diIqpZTbtXx5mJZeN2sU5jIpxySYVJZJVlxmU
         rH3xcLWQTe3VKfbvYFAcuYVlNAa0jIu5YVz9rHs0NC/6Fe2V/j1hWm1x7TQUeUlWg7MV
         MTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YDEq+hcMKeYMe2qDeryigFHsBJcRfk5HdpwyAexDCsM=;
        b=OEoQRhBdiOEs9VEcwNoIfG+ImQ/M+rQb2xl2T2gUwu+LZV1Ggazfr7nWMp+nV5a5Gr
         HdDdE6rH+uNJbW9kD59UwBKcK/Jl88gSDwzZCHLwPDFONaqEFb7LzojifocnNtxCxDMz
         9DH2o/IDq4CSqbhxZ9Vwuccdtr+1KADxBOTSipp1WwLocQEc0dScB15yvTxeRPkXH3J0
         PjTo3eHOFWq+Hgd7HqWRU1Zw1bayPOp/Yhh82rW1hwGwzy53YrChJYFwsnylCducwwLi
         nf8c3nvrkyN6KhRBSu6H5ilTPIvtZZGneVg5hcHEDqWcxW4ifBzhl2v+j5EV6K9eXJuw
         Ee1A==
X-Gm-Message-State: AFqh2kr+32onGbzDGCcozeo5Q6/00mEvcQEkhAYFpDncaG0YZhvsbF0T
        DQAPF55ZXg7JEPmG+i1Lzx3AmoN9n1E=
X-Google-Smtp-Source: AMrXdXuH5hFyWDvawKSi9ZCPO9GA4xIUMjcL8yYRSdhAHi542OSJmB9EyS1e4Ery2G85HatHqUoeH5/ssDI=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a63:807:0:b0:477:ceeb:cb9c with SMTP id
 7-20020a630807000000b00477ceebcb9cmr2429554pgi.17.1674572079673; Tue, 24 Jan
 2023 06:54:39 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:54:29 +0000
In-Reply-To: <20230124145430.365495-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230124145430.365495-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230124145430.365495-2-jaewan@google.com>
Subject: [PATCH v6 1/2] mac80211_hwsim: add PMSR capability support
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

This CL allows mac80211_hwsim to be configured with PMSR capability.
The capability is mandatory because nl80211_pmsr_start() ignores
incoming PMSR request if PMSR capability isn't set in the wiphy.

This CL adds HWSIM_ATTR_PMSR_SUPPORT.
It can be used to set PMSR capability when creating a new radio.
To send extra details, HWSIM_ATTR_PMSR_SUPPORT can have nested
PMSR capability attributes defined in the nl80211.h.
Data format is the same as cfg80211_pmsr_capabilities.

If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V5 -> V6: Added per change patch history.
V4 -> V5: Fixed style for commit messages.
V3 -> V4: Added change details for new attribute, and fixed memory leak.
V1 -> V3: Initial commit (includes resends).
---
 drivers/net/wireless/mac80211_hwsim.c | 159 +++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   2 +
 include/net/cfg80211.h                |  10 ++
 net/wireless/nl80211.c                |  17 ++-
 4 files changed, 181 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c57c8903b7c0..84c9db9178c3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
 	/* RSSI in rx status of the receiver */
 	int rx_rssi;
 
+	/* only used when pmsr capability is supplied */
+	struct cfg80211_pmsr_capabilities pmsr_capa;
+
 	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
 };
 
@@ -760,6 +763,37 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
 
 /* MAC80211_HWSIM netlink policy */
 
+static const struct nla_policy
+hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
+	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] =
+		NLA_POLICY_MAX(NLA_U8, 15),
+	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] =
+		NLA_POLICY_MAX(NLA_U8, 31),
+	[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
+};
+
+static const struct nla_policy
+hwsim_pmsr_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
+};
+
+static const struct nla_policy
+hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
+	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_U32 },
+	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
+	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
+	[NL80211_PMSR_ATTR_TYPE_CAPA] =
+		NLA_POLICY_NESTED(hwsim_pmsr_type_policy),
+	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
+};
+
 static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_ADDR_RECEIVER] = NLA_POLICY_ETH_ADDR_COMPAT,
 	[HWSIM_ATTR_ADDR_TRANSMITTER] = NLA_POLICY_ETH_ADDR_COMPAT,
@@ -788,6 +822,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
 	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
 	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
+	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
 };
 
 #if IS_REACHABLE(CONFIG_VIRTIO)
@@ -3107,6 +3142,18 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				     struct cfg80211_pmsr_request *request)
+{
+	return -EOPNOTSUPP;
+}
+
+static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				      struct cfg80211_pmsr_request *request)
+{
+	// Do nothing for now.
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
@@ -3129,7 +3176,9 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	.flush = mac80211_hwsim_flush,				\
 	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
 	.get_et_stats = mac80211_hwsim_get_et_stats,		\
-	.get_et_strings = mac80211_hwsim_get_et_strings,
+	.get_et_strings = mac80211_hwsim_get_et_strings,	\
+	.start_pmsr = mac80211_hwsim_start_pmsr,		\
+	.abort_pmsr = mac80211_hwsim_abort_pmsr,
 
 #define HWSIM_NON_MLO_OPS					\
 	.sta_add = mac80211_hwsim_sta_add,			\
@@ -3186,6 +3235,7 @@ struct hwsim_new_radio_params {
 	u32 *ciphers;
 	u8 n_ciphers;
 	bool mlo;
+	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -3260,7 +3310,10 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 			return ret;
 	}
 
-	return 0;
+	if (param->pmsr_capa)
+		ret = cfg80211_send_pmsr_capa(param->pmsr_capa, skb);
+
+	return ret;
 }
 
 static void hwsim_mcast_new_radio(int id, struct genl_info *info,
@@ -4606,6 +4659,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
 
+	if (param->pmsr_capa) {
+		data->pmsr_capa = *param->pmsr_capa;
+		hw->wiphy->pmsr_capa = &data->pmsr_capa;
+	}
+
 	spin_lock_bh(&hwsim_radio_lock);
 	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
 				     hwsim_rht_params);
@@ -4715,6 +4773,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	param.regd = data->regd;
 	param.channels = data->channels;
 	param.hwname = wiphy_name(data->hw->wiphy);
+	param.pmsr_capa = &data->pmsr_capa;
 
 	res = append_radio_msg(skb, data->idx, &param);
 	if (res < 0)
@@ -5053,6 +5112,83 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
 	return true;
 }
 
+static int parse_ftm_capa(const struct nlattr *ftm_capa,
+			  struct cfg80211_pmsr_capabilities *out)
+{
+	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
+	int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
+				   ftm_capa, hwsim_ftm_capa_policy, NULL);
+	if (ret) {
+		pr_err("mac80211_hwsim: malformed FTM capability");
+		return -EINVAL;
+	}
+
+	out->ftm.supported = 1;
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
+		out->ftm.preambles =
+			nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
+		out->ftm.bandwidths =
+			nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
+		out->ftm.max_bursts_exponent =
+			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
+		out->ftm.max_ftms_per_burst =
+			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST]);
+	out->ftm.asap =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
+	out->ftm.non_asap =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
+	out->ftm.request_lci =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI];
+	out->ftm.request_civicloc =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC];
+	out->ftm.trigger_based =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED];
+	out->ftm.non_trigger_based =
+		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED];
+
+	return 0;
+}
+
+static int parse_pmsr_capa(const struct nlattr *pmsr_capa,
+			   struct cfg80211_pmsr_capabilities *out)
+{
+	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
+	struct nlattr *nla;
+	int size;
+	int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
+				   hwsim_pmsr_capa_policy, NULL);
+	if (ret) {
+		pr_err("mac80211_hwsim: malformed PMSR capability");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
+		out->max_peers =
+			nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
+	out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
+	out->randomize_mac_addr =
+		!!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
+
+	if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
+		pr_err("mac80211_hwsim: malformed PMSR type");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
+		switch (nla_type(nla)) {
+		case NL80211_PMSR_TYPE_FTM:
+			parse_ftm_capa(nla, out);
+			break;
+		default:
+			pr_warn("mac80211_hwsim: Unknown PMSR type\n");
+		}
+	}
+	return 0;
+}
+
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
@@ -5173,8 +5309,26 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.hwname = hwname;
 	}
 
+	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
+		struct cfg80211_pmsr_capabilities *pmsr_capa =
+			kmalloc(sizeof(struct cfg80211_pmsr_capabilities),
+				GFP_KERNEL);
+		if (!pmsr_capa) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT],
+				      pmsr_capa);
+		if (ret)
+			goto out_free;
+		param.pmsr_capa = pmsr_capa;
+	}
+
 	ret = mac80211_hwsim_new_radio(info, &param);
+
+out_free:
 	kfree(hwname);
+	kfree(param.pmsr_capa);
 	return ret;
 }
 
@@ -5419,7 +5573,6 @@ static struct notifier_block hwsim_netlink_notifier = {
 static int __init hwsim_init_netlink(void)
 {
 	int rc;
-
 	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
 
 	rc = genl_register_family(&hwsim_genl_family);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 527799b2de0f..81cd02d2555c 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -142,6 +142,7 @@ enum {
  * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
  * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
  *	the new radio
+ * @HWSIM_ATTR_PMSR_SUPPORT: claim peer measurement support
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -173,6 +174,7 @@ enum {
 	HWSIM_ATTR_IFTYPE_SUPPORT,
 	HWSIM_ATTR_CIPHER_SUPPORT,
 	HWSIM_ATTR_MLO_SUPPORT,
+	HWSIM_ATTR_PMSR_SUPPORT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 03d4f4deadae..33f775b0f0b0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8751,6 +8751,16 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
 			    struct cfg80211_pmsr_request *req,
 			    gfp_t gfp);
 
+/**
+ * cfg80211_send_pmsr_capa - send the pmsr capabilities.
+ * @cap: peer measurement capabilities
+ * @skb: The skb to send pmsr capa
+ *
+ * Send the peer measurement capabilities to skb.
+ */
+int cfg80211_send_pmsr_capa(const struct cfg80211_pmsr_capabilities *cap,
+			    struct sk_buff *msg);
+
 /**
  * cfg80211_iftype_allowed - check whether the interface can be allowed
  * @wiphy: the wiphy
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33a82ecab9d5..b972a2135654 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2152,10 +2152,9 @@ nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
 	return 0;
 }
 
-static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
-				  struct sk_buff *msg)
+int cfg80211_send_pmsr_capa(const struct cfg80211_pmsr_capabilities *cap,
+			    struct sk_buff *msg)
 {
-	const struct cfg80211_pmsr_capabilities *cap = rdev->wiphy.pmsr_capa;
 	struct nlattr *pmsr, *caps;
 
 	if (!cap)
@@ -2193,6 +2192,13 @@ static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cfg80211_send_pmsr_capa);
+
+static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
+				  struct sk_buff *msg)
+{
+	return cfg80211_send_pmsr_capa(rdev->wiphy.pmsr_capa, msg);
+}
 
 static int
 nl80211_put_iftype_akm_suites(struct cfg80211_registered_device *rdev,
@@ -3181,8 +3187,11 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	struct nlattr **attrs = info->attrs;
 	u32 control_freq;
 
-	if (!attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		NL_SET_ERR_MSG_ATTR(extack, attrs[NL80211_ATTR_WIPHY_FREQ],
+				    "Frequency is missing");
 		return -EINVAL;
+	}
 
 	control_freq = MHZ_TO_KHZ(
 			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-- 
2.39.0.246.g2a6d74b583-goog

