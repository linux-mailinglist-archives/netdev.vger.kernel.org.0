Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC1868D1CB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 09:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjBGIyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 03:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjBGIyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 03:54:16 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2FC32527
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 00:54:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so14134189ybj.23
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 00:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMWhR30+iROsoA7SVAksShecAQ37fWzUWHbmR7siJWc=;
        b=PFSD+hu6zdHBR6NDlP4/oNWjuA6v+s4yTnqOz3mzgTCim/ay91h+1BYv0EyBU7/QLD
         gcKULPEs0FdsqISkPHLdPb0bvJDxNIrFl7wRV584URqAT/3qeby78GFWRxZ0///F9L/P
         czNNjIcWPVQCzNZXculG6w16AqFtM4mYuu0Oa5ApVrZhMUewY5FfgSF/bTwTSUa0s3dB
         UCqw/PgSexURJb05+m1DpWp7MptPfi0vgUB5S9LFeD+zkR9C7EUBWe/oHTc8OX8MUpqg
         z0/B7XARP/5eGBe/98yH6U9Xv0c0yJlY3aw660DXphsIPh19RHE5Frbg66OOXZpypooB
         UTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMWhR30+iROsoA7SVAksShecAQ37fWzUWHbmR7siJWc=;
        b=Uymfn7Cxdv2XqcMIerne8AqFYfWJpXiz8d6MwywAbyyE7hibQibZUZPCzKtlMCQYx3
         E9OCW8Cp7iXjcs18w3uo7yZWcOVSGrHsf16scYFoIpnfetIBQlpF4M8JX9T7f+U96uYn
         Sn7zFxkTxPn0KssgiVFFW42eBSt5Iji8UtWTc4YK0+1xQWvxFjhERrSN5ZdaDrLsNJWW
         We7TsbHHpVKyiTqmuWbqEW9ll7szjE0qQ10KFCJLS+fLbGXUKtxq+0ag9zchMBwTJVK3
         PelF6AMjt4hfdPw6WAIoHFfA6hfZr74hPOvvT93Lnn6nXge0sOmT/+JDIiBe9wLEhKHA
         5Xtg==
X-Gm-Message-State: AO0yUKXDDXOxzRD1IgM0pKn2rI0nkAG4m5q47TETqOrMvevMPgYPSuEx
        awad6/fP/Lc6wSWEDY2X26s8NN+xZQs=
X-Google-Smtp-Source: AK7set9Uq05/TBb32dh1+DtJS5nxQQHFgtY18VBzBi878TnnSn/ScEq8Bez98joX9HMOmvZ8U8v+vP9d87g=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:343:b0:873:b2b9:3b27 with SMTP id
 e3-20020a056902034300b00873b2b93b27mr299774ybs.403.1675760053616; Tue, 07 Feb
 2023 00:54:13 -0800 (PST)
Date:   Tue,  7 Feb 2023 08:53:57 +0000
In-Reply-To: <20230207085400.2232544-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230207085400.2232544-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207085400.2232544-2-jaewan@google.com>
Subject: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
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

This change allows mac80211_hwsim to be configured with PMSR capability.
The capability is mandatory to accept incoming PMSR request because
nl80211_pmsr_start() ignores incoming the request without the PMSR
capability.

This change adds HWSIM_ATTR_PMSR_SUPPORT, which is used to set PMSR
capability when creating a new radio. To send extra details,
HWSIM_ATTR_PMSR_SUPPORT can have nested PMSR capability attributes defined
in the nl80211.h. Data format is the same as cfg80211_pmsr_capabilities.

If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V6 -> V7: Added terms definitions. Removed pr_*() uses.
V5 -> V6: Added per change patch history.
V4 -> V5: Fixed style for commit messages.
V3 -> V4: Added change details for new attribute, and fixed memory leak.
V1 -> V3: Initial commit (includes resends).
---
 drivers/net/wireless/mac80211_hwsim.c | 130 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   2 +
 include/net/cfg80211.h                |  10 ++
 net/wireless/nl80211.c                |  12 ++-
 4 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c57c8903b7c0..eca559e63d27 100644
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
 
@@ -760,6 +763,34 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
 
 /* MAC80211_HWSIM netlink policy */
 
+static const struct nla_policy
+hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
+	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] = NLA_POLICY_MAX(NLA_U8, 15),
+	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] = NLA_POLICY_MAX(NLA_U8, 31),
+	[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
+};
+
+static const struct nla_policy
+hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
+};
+
+static const struct nla_policy
+hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
+	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_U32 },
+	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
+	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
+	[NL80211_PMSR_ATTR_TYPE_CAPA] = NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
+	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
+};
+
 static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_ADDR_RECEIVER] = NLA_POLICY_ETH_ADDR_COMPAT,
 	[HWSIM_ATTR_ADDR_TRANSMITTER] = NLA_POLICY_ETH_ADDR_COMPAT,
@@ -788,6 +819,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
 	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
 	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
+	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
 };
 
 #if IS_REACHABLE(CONFIG_VIRTIO)
@@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
 	u32 *ciphers;
 	u8 n_ciphers;
 	bool mlo;
+	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -3260,7 +3293,10 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 			return ret;
 	}
 
-	return 0;
+	if (param->pmsr_capa)
+		ret = cfg80211_send_pmsr_capa(param->pmsr_capa, skb);
+
+	return ret;
 }
 
 static void hwsim_mcast_new_radio(int id, struct genl_info *info,
@@ -4445,6 +4481,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
+
 
 	hw->wiphy->interface_modes = param->iftypes;
 
@@ -4606,6 +4644,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
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
@@ -4715,6 +4758,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	param.regd = data->regd;
 	param.channels = data->channels;
 	param.hwname = wiphy_name(data->hw->wiphy);
+	param.pmsr_capa = &data->pmsr_capa;
 
 	res = append_radio_msg(skb, data->idx, &param);
 	if (res < 0)
@@ -5053,6 +5097,74 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
 	return true;
 }
 
+static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211_pmsr_capabilities *out,
+			  struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
+	int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
+				   ftm_capa, hwsim_ftm_capa_policy, NULL);
+	if (ret) {
+		NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malformed FTM capability");
+		return -EINVAL;
+	}
+
+	out->ftm.supported = 1;
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
+		out->ftm.preambles = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
+		out->ftm.bandwidths = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
+		out->ftm.max_bursts_exponent =
+			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT]);
+	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
+		out->ftm.max_ftms_per_burst =
+			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST]);
+	out->ftm.asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
+	out->ftm.non_asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
+	out->ftm.request_lci = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI];
+	out->ftm.request_civicloc = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC];
+	out->ftm.trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED];
+	out->ftm.non_trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED];
+
+	return 0;
+}
+
+static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg80211_pmsr_capabilities *out,
+			   struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
+	struct nlattr *nla;
+	int size;
+	int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
+				   hwsim_pmsr_capa_policy, NULL);
+	if (ret) {
+		NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed PMSR capability");
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
+		out->max_peers = nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
+	out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
+	out->randomize_mac_addr = !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
+
+	if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_TYPE_CAPA],
+				    "malformed PMSR type");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
+		switch (nla_type(nla)) {
+		case NL80211_PMSR_TYPE_FTM:
+			parse_ftm_capa(nla, out, info);
+			break;
+		default:
+			WARN_ON(1);
+		}
+	}
+	return 0;
+}
+
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
@@ -5173,8 +5285,24 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.hwname = hwname;
 	}
 
+	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
+		struct cfg80211_pmsr_capabilities *pmsr_capa =
+			kmalloc(sizeof(struct cfg80211_pmsr_capabilities), GFP_KERNEL);
+		if (!pmsr_capa) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT], pmsr_capa, info);
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
index 33a82ecab9d5..ae1924210663 100644
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
-- 
2.39.1.519.gcb327c4b5f-goog

