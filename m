Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57067167A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjARIr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjARIqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:46:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA0917EC;
        Wed, 18 Jan 2023 00:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62AAF616E0;
        Wed, 18 Jan 2023 08:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B344C433EF;
        Wed, 18 Jan 2023 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674028810;
        bh=MwEEXqoGk56u8LPTYHXLSnpeUnjs6RdCBwU7mIZeA4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NasmP917JjdtrIualtLpqp4kX3x0RUg9A75XwdwVZEQL4WpHjPzuJ5sOsig1KOf5+
         bsqffv8GUhra3EXe8qKxIcpllmpV8/H08f5wsVYr2n6GxbMKiP15W1iRj1IW1WuCBj
         IXX3PEC1asZ/mS0U6dbV6n5UT8HhLm49hDnmr144=
Date:   Wed, 18 Jan 2023 09:00:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [RESEND v3 1/2] mac80211_hwsim: add PMSR capability support
Message-ID: <Y8enCG2zk5b9TCiN@kroah.com>
References: <20230112070947.1168555-1-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112070947.1168555-1-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 04:09:46PM +0900, Jaewan Kim wrote:
> Add HWSIM_ATTR_PMSR_SUPPORT to configure PMSR support.

What does this mean?  This is a new feature with almost no information
about what it is, how it can be used, or what it is for.

Would you accept a patch that was sent to you like this with no
documentation at all?


> 

> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 159 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |   2 +
>  include/net/cfg80211.h                |  10 ++
>  net/wireless/nl80211.c                |  17 ++-
>  4 files changed, 182 insertions(+), 6 deletions(-)
> 
> diff --git drivers/net/wireless/mac80211_hwsim.c drivers/net/wireless/mac80211_hwsim.c
> index c57c8903b7c0..0d5b7b5d3121 100644
> --- drivers/net/wireless/mac80211_hwsim.c
> +++ drivers/net/wireless/mac80211_hwsim.c
> @@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
>  	/* RSSI in rx status of the receiver */
>  	int rx_rssi;
>  
> +	/* only used when pmsr capability is supplied */
> +	struct cfg80211_pmsr_capabilities pmsr_capa;
> +
>  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
>  };
>  
> @@ -760,6 +763,37 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
>  
>  /* MAC80211_HWSIM netlink policy */
>  
> +static const struct nla_policy
> +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] =
> +		NLA_POLICY_MAX(NLA_U8, 15),
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] =
> +		NLA_POLICY_MAX(NLA_U8, 31),
> +	[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_ATTR_TYPE_CAPA] =
> +		NLA_POLICY_NESTED(hwsim_pmsr_type_policy),
> +	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
> +};
> +
>  static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_ADDR_RECEIVER] = NLA_POLICY_ETH_ADDR_COMPAT,
>  	[HWSIM_ATTR_ADDR_TRANSMITTER] = NLA_POLICY_ETH_ADDR_COMPAT,
> @@ -788,6 +822,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
>  	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
>  	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
> +	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
>  };
>  
>  #if IS_REACHABLE(CONFIG_VIRTIO)
> @@ -3107,6 +3142,18 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> +static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +				     struct cfg80211_pmsr_request *request)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +				      struct cfg80211_pmsr_request *request)
> +{
> +	// Do nothing for now.
> +}
> +
>  #define HWSIM_COMMON_OPS					\
>  	.tx = mac80211_hwsim_tx,				\
>  	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
> @@ -3129,7 +3176,9 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	.flush = mac80211_hwsim_flush,				\
>  	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
>  	.get_et_stats = mac80211_hwsim_get_et_stats,		\
> -	.get_et_strings = mac80211_hwsim_get_et_strings,
> +	.get_et_strings = mac80211_hwsim_get_et_strings,	\
> +	.start_pmsr = mac80211_hwsim_start_pmsr,		\
> +	.abort_pmsr = mac80211_hwsim_abort_pmsr,
>  
>  #define HWSIM_NON_MLO_OPS					\
>  	.sta_add = mac80211_hwsim_sta_add,			\
> @@ -3186,6 +3235,7 @@ struct hwsim_new_radio_params {
>  	u32 *ciphers;
>  	u8 n_ciphers;
>  	bool mlo;
> +	const struct cfg80211_pmsr_capabilities *pmsr_capa;
>  };
>  
>  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> @@ -3260,6 +3310,13 @@ static int append_radio_msg(struct sk_buff *skb, int id,
>  			return ret;
>  	}
>  
> +	if (param->pmsr_capa) {
> +		ret = cfg80211_send_pmsr_capa(param->pmsr_capa, skb);
> +
> +		if (ret < 0)
> +			return ret;

No need for this, just "return ret" below.

> +	}
> +
>  	return 0;

	return ret;


>  }
>  
> @@ -4606,6 +4663,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  				    data->debugfs,
>  				    data, &hwsim_simulate_radar);
>  
> +	if (param->pmsr_capa) {
> +		data->pmsr_capa = *param->pmsr_capa;
> +		hw->wiphy->pmsr_capa = &data->pmsr_capa;
> +	}
> +
>  	spin_lock_bh(&hwsim_radio_lock);
>  	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
>  				     hwsim_rht_params);
> @@ -4715,6 +4777,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
>  	param.regd = data->regd;
>  	param.channels = data->channels;
>  	param.hwname = wiphy_name(data->hw->wiphy);
> +	param.pmsr_capa = &data->pmsr_capa;
>  
>  	res = append_radio_msg(skb, data->idx, &param);
>  	if (res < 0)
> @@ -5053,6 +5116,83 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
>  	return true;
>  }
>  
> +static int parse_ftm_capa(const struct nlattr *ftm_capa,
> +			  struct cfg80211_pmsr_capabilities *out)
> +{
> +	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> +	int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> +				   ftm_capa, hwsim_ftm_capa_policy, NULL);
> +	if (ret) {
> +		pr_err("mac80211_hwsim: malformed FTM capability");
> +		return -EINVAL;
> +	}
> +
> +	out->ftm.supported = 1;
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
> +		out->ftm.preambles =
> +			nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
> +		out->ftm.bandwidths =
> +			nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
> +		out->ftm.max_bursts_exponent =
> +			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
> +		out->ftm.max_ftms_per_burst =
> +			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST]);
> +	out->ftm.asap =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
> +	out->ftm.non_asap =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
> +	out->ftm.request_lci =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI];
> +	out->ftm.request_civicloc =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC];
> +	out->ftm.trigger_based =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED];
> +	out->ftm.non_trigger_based =
> +		!!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED];
> +
> +	return 0;
> +}
> +
> +static int parse_pmsr_capa(const struct nlattr *pmsr_capa,
> +			   struct cfg80211_pmsr_capabilities *out)
> +{
> +	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> +	struct nlattr *nla;
> +	int size;
> +	int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
> +				   hwsim_pmsr_capa_policy, NULL);
> +	if (ret) {
> +		pr_err("mac80211_hwsim: malformed PMSR capability");
> +		return -EINVAL;
> +	}
> +
> +	if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> +		out->max_peers =
> +			nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
> +	out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> +	out->randomize_mac_addr =
> +		!!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
> +
> +	if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> +		pr_err("mac80211_hwsim: malformed PMSR type");
> +		return -EINVAL;
> +	}
> +
> +	nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
> +		switch (nla_type(nla)) {
> +		case NL80211_PMSR_TYPE_FTM:
> +			parse_ftm_capa(nla, out);
> +			break;
> +		default:
> +			pr_warn("mac80211_hwsim: Unknown PMSR type\n");
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  {
>  	struct hwsim_new_radio_params param = { 0 };
> @@ -5173,8 +5313,24 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  		param.hwname = hwname;
>  	}
>  
> +	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> +		struct cfg80211_pmsr_capabilities *pmsr_capa =
> +			kmalloc(sizeof(struct cfg80211_pmsr_capabilities),
> +				GFP_KERNEL);
> +		if (!pmsr_capa)
> +			return -ENOMEM;

Did you just leak memory?  What frees hwname now?

> +		ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT],
> +				      pmsr_capa);
> +		if (ret)
> +			goto out_free;
> +		param.pmsr_capa = pmsr_capa;
> +	}
> +
>  	ret = mac80211_hwsim_new_radio(info, &param);
> +
> +out_free:
>  	kfree(hwname);
> +	kfree(param.pmsr_capa);

You just leaked memory (hint, check your error path logic above...)

How did you test this?

greg k-h
