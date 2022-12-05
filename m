Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CDB642E89
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiLERTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLERTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:19:30 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B7D21833
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:19:20 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368994f4bc0so128176537b3.14
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fVckvgVkuhHX0Nyziotc7g//jlEAyIHdRb97tUqu834=;
        b=Kk5fDxBLlOurbSsHEi6ei5TXSnyes8pxT38XQJW6wrx5jgIG9uzep8j/ROgaGV1H5E
         g7gzQkIy6FqUO4bW5UWOVJqBk4dEH/f706+Y46gFuiToNdt/DrTtvQR1ifFDu7TNHox7
         8Shr4hHG3tSDV1ga5D6mW2eMN3tC7nCcgZyfTOPlkDdRVMCaTiWFDLc8Q8eD8BwuQvUa
         L64NK8pfUNPePvpEZKtWeyxQq+IqWVctfWslmEStRZRRkCJPCoo8Rc4sRwfNFlPmRAYC
         cPDNf2ewFI+Fq3G81yFyraIOzAuAbDDLUllQrMNZqBnvsr/ihf0XdeSZYaS5xy5oFLox
         kGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fVckvgVkuhHX0Nyziotc7g//jlEAyIHdRb97tUqu834=;
        b=rG9COHXwwBip+eY8KnD2GTJdAmEZiFT7wAEM8iVBJFFnSn/m4TBfX2u8tbBxuFGamP
         VV92mThPxaEw2XHIUo8qEgGPC+xVDWlqVx9dxmPIkZQP2R8sPz19UEO2Yf5ln+TB3jZp
         VLe46LvlKP/+S7f0x5/bcFLcIQT+SkJ/nj5Bbs70KrogvqU9L9dXWdCGIyB8knXIcpuJ
         fByvq2TSQr1IfWjUGehzQ7ZhE5gWWqGjT8+nBKiZz1BypPQ4S2vz01vrdO6n1PH5xd5E
         AzPpSznKwuKEq+nsEw0rbjV4tDTO07IKPIjhwoRBof+qangsvUovw53ciF49wUfrWghi
         eAzw==
X-Gm-Message-State: ANoB5pl9XVwI5zWRsffDgxGgzcD8OW+Yc3PUXQvlIbHA1/UU7MsBobLO
        dEUAWv3iTo5pWTpoq2CDbnW88bc3T+o=
X-Google-Smtp-Source: AA0mqf7mawp3z7PMs0JAO7l5Rr/JqfNzJkcu2biKywQgWHsjIavMG3X++TjJl/Xg2TCdf2CB+EgjkN8zKDs=
X-Received: from jaewan.seo.corp.google.com ([2401:fa00:d:11:79be:314e:4538:ae86])
 (user=jaewan job=sendgmr) by 2002:a25:918a:0:b0:6f7:9c34:67a7 with SMTP id
 w10-20020a25918a000000b006f79c3467a7mr32273782ybl.16.1670260760186; Mon, 05
 Dec 2022 09:19:20 -0800 (PST)
Date:   Tue,  6 Dec 2022 02:18:50 +0900
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205171851.2811239-1-jaewan@google.com>
Subject: [PATCH 1/2] mac80211_hwsim: add PMSR capability support
From:   Jaewan Kim <jaewan@google.com>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
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

Add HWSIM_ATTR_PMSR_SUPPORT to configure PMSR support.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 159 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |   2 +
 include/net/cfg80211.h                |  10 ++
 net/wireless/nl80211.c                |  17 ++-
 4 files changed, 182 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0d81098c7b45..c7e314935023 100644
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
 	.start = mac80211_hwsim_start,				\
@@ -3128,7 +3175,9 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
 	.flush = mac80211_hwsim_flush,				\
 	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
 	.get_et_stats = mac80211_hwsim_get_et_stats,		\
-	.get_et_strings = mac80211_hwsim_get_et_strings,
+	.get_et_strings = mac80211_hwsim_get_et_strings,	\
+	.start_pmsr = mac80211_hwsim_start_pmsr,		\
+	.abort_pmsr = mac80211_hwsim_abort_pmsr,
 
 #define HWSIM_NON_MLO_OPS					\
 	.sta_add = mac80211_hwsim_sta_add,			\
@@ -3185,6 +3234,7 @@ struct hwsim_new_radio_params {
 	u32 *ciphers;
 	u8 n_ciphers;
 	bool mlo;
+	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -3259,6 +3309,13 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 			return ret;
 	}
 
+	if (param->pmsr_capa) {
+		ret = cfg80211_send_pmsr_capa(param->pmsr_capa, skb);
+
+		if (ret < 0)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -4605,6 +4662,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
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
@@ -4714,6 +4776,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 	param.regd = data->regd;
 	param.channels = data->channels;
 	param.hwname = wiphy_name(data->hw->wiphy);
+	param.pmsr_capa = &data->pmsr_capa;
 
 	res = append_radio_msg(skb, data->idx, &param);
 	if (res < 0)
@@ -5052,6 +5115,83 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
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
@@ -5172,8 +5312,24 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.hwname = hwname;
 	}
 
+	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
+		struct cfg80211_pmsr_capabilities *pmsr_capa =
+			kmalloc(sizeof(struct cfg80211_pmsr_capabilities),
+				GFP_KERNEL);
+		if (!pmsr_capa)
+			return -ENOMEM;
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
 
@@ -5418,7 +5574,6 @@ static struct notifier_block hwsim_netlink_notifier = {
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
index e09ff87146c1..1d3368e409d6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8740,6 +8740,16 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
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
index 597c52236514..922586138025 100644
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
2.39.0.rc0.267.gcb52ba06e7-goog

