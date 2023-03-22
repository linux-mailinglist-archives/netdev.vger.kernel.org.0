Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA756C4B90
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjCVNTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCVNTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C65F221
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5425c04765dso185845447b3.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t6FTd9IM6YHYO3hjFYYJ9V+ozElyww/GBjLmXMmk7ks=;
        b=Rz1QUnXIsNuip278dg9jg+f96bxGRYL4BmivstWLPkNnq9etxhp7eu0m6NdNEcsK91
         b+OWPX30mMb/YhD96tlUlvn0iF9fR1kssNdFYI2/yy6DjvErX2IigK/Oehbp5d98dqpl
         yoifi+6Jh73lb2PDM3o7T4yr0pxQ9wBFM+s1stzEh5D62B5WcjzJw2+a0W3VynB8nPyc
         q7HHELY7qBedAfBhgUhBivUBRvHNtlwq11R5QUOwPla+/alls4TwJVkaeowVNXMGVPcT
         8aYO5vYjp8hbSaqAODS7qONj1m7mdQl6Np6d2Xy+srt4ksK9r6nVNKcTUu/7HE16A0DR
         e57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6FTd9IM6YHYO3hjFYYJ9V+ozElyww/GBjLmXMmk7ks=;
        b=qF6BMiX6DMegpJjBgLUj6DjL/N3WZBnEtdwzGtIflM/N2c+2nA3vn2RfQmcNNCgtUf
         d3r4+fsfvsJ9iyEbSy/MCStLMkgByT4uMfME8ztCat2mhFK7ujKeB31Kibugr0w1gVUD
         EsnY15J9iJ706u39Kn62RdM7+dpV40hLd/H/B9q37Quv8ZAgo3+3dN+7JzT8CdgiV0bK
         nFFcBRLEPSOYAoFFpkzKmHKs2pGTtzVzDS7JKeOlX2nh9SvTtRq9ER6s1eeSOV1sDQBi
         /XAYi4cW3AbkO8wmpWo2M9T2TZFpzRSWFcfb/cp5Mn1ZluytHYNmvjgZJgK/DWzLKxJe
         y+UQ==
X-Gm-Message-State: AAQBX9egiSRXnq0rsyAEApNMwhbQB03gGlVJKTyRWBOuVhZHWRb2Q8xq
        WcvTAjFBi7HzjsGW3hudRUsQEKRe0FU=
X-Google-Smtp-Source: AKy350aqYjj0lDU5Xj3edaz0INRl6nw9JC9jNsRPqdSHYPi3cqJT3hnjQJ6U7DZqFTAeO90hqr+vRDyh1Z0=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:1005:b0:a58:7139:cf85 with SMTP id
 w5-20020a056902100500b00a587139cf85mr3898901ybt.13.1679491156362; Wed, 22 Mar
 2023 06:19:16 -0700 (PDT)
Date:   Wed, 22 Mar 2023 13:16:33 +0000
In-Reply-To: <20230322131637.2633968-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230322131637.2633968-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230322131637.2633968-2-jaewan@google.com>
Subject: [PATCH v10 1/5] mac80211_hwsim: add PMSR capability support
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

Add necessary functionality to allow mac80211_hwsim to be configured with
PMSR capability. The capability is mandatory to accept incoming PMSR
request because nl80211_pmsr_start() ignores incoming the request without
the PMSR capability.

In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT.
HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creating a new
radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT can have
nested PMSR capability attributes defined in the nl80211.h. Data format is
the same as cfg80211_pmsr_capabilities.

If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V9 -> V10: Applied reverse xmas tree style (a.k.a. RCS).
V8 -> V9: Changed to consider unknown PMSR type as error.
V7 -> V8: Changed not to send pmsr_capa when adding new radio to limit
          exporting cfg80211 function to driver.
V6 -> V7: Added terms definitions. Removed pr_*() uses.
V5 -> V6: Added per change patch history.
V4 -> V5: Fixed style for commit messages.
V3 -> V4: Added change details for new attribute, and fixed memory leak.
V1 -> V3: Initial commit (includes resends).
---
 drivers/net/wireless/mac80211_hwsim.c | 130 ++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |   3 +
 2 files changed, 133 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4cc4eaf80b14..894049b15f3f 100644
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
@@ -4445,6 +4478,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			      NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
 	wiphy_ext_feature_set(hw->wiphy,
 			      NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
 
 	hw->wiphy->interface_modes = param->iftypes;
 
@@ -4606,6 +4640,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
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
@@ -4715,6 +4754,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	param.regd = data->regd;
 	param.channels = data->channels;
 	param.hwname = wiphy_name(data->hw->wiphy);
+	param.pmsr_capa = &data->pmsr_capa;
 
 	res = append_radio_msg(skb, data->idx, &param);
 	if (res < 0)
@@ -5053,6 +5093,79 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
 	return true;
 }
 
+static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211_pmsr_capabilities *out,
+			  struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX, ftm_capa, hwsim_ftm_capa_policy,
+			       NULL);
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
+	int ret;
+
+	ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa, hwsim_pmsr_capa_policy, NULL);
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
+			NL_SET_ERR_MSG_ATTR(info->extack, nla, "unsupported measurement type");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
@@ -5173,8 +5286,25 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.hwname = hwname;
 	}
 
+	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
+		struct cfg80211_pmsr_capabilities *pmsr_capa;
+
+		pmsr_capa = kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
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
index 527799b2de0f..d10fa7f4853b 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -142,6 +142,8 @@ enum {
  * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
  * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
  *	the new radio
+ * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CREATE_RADIO
+ *	to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -173,6 +175,7 @@ enum {
 	HWSIM_ATTR_IFTYPE_SUPPORT,
 	HWSIM_ATTR_CIPHER_SUPPORT,
 	HWSIM_ATTR_MLO_SUPPORT,
+	HWSIM_ATTR_PMSR_SUPPORT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.40.0.rc1.284.g88254d51c5-goog

