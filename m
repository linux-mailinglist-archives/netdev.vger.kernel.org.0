Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3BA679DF8
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjAXPv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 10:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjAXPv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:51:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D714474D9;
        Tue, 24 Jan 2023 07:51:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C43612AF;
        Tue, 24 Jan 2023 15:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190AFC433EF;
        Tue, 24 Jan 2023 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674575483;
        bh=osN1wqK01SA8rS2IwP+Rm0F8qlTWasxwhE2RAtZvIfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdkY3bCUbjHY6q6B2mVE+bK9yH/TFYT5qmDySvTjyqce3qF1txY9K8hDaphowIPye
         qwVUQSBUUxA0MWF4+0cxOi+KIMwiqbFJ8bHY8Mbe3LDsMCiKjCdimQeEJ5TJwiABnC
         IKvAtJ1e/aqgmZR21KdNobkPcF1A8JKMMNONGzMg=
Date:   Tue, 24 Jan 2023 16:51:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v6 2/2] mac80211_hwsim: handle FTM requests with virtio
Message-ID: <Y8/+duv3y1drM5Wm@kroah.com>
References: <20230124145430.365495-1-jaewan@google.com>
 <20230124145430.365495-3-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124145430.365495-3-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 02:54:30PM +0000, Jaewan Kim wrote:
> This CL allows mac80211_hwsim to receive FTM request and send FTM response.

What is a "CL"?

What is "FTM"?

And why is this line not wrapped at 72 columns like your editor asked
you do when you committed it?  :)

> It passthrough request to wmediumd and gets response with virtio
> to get the FTM information with another STA.

What is "STA"?

> 
> This CL adds following commands

Again, what is "CL"?

>  - HWSIM_CMD_START_PMSR: To send request to wmediumd
>  - HWSIM_CMD_ABORT_PMSR: To send abort to wmediumd
>  - HWSIM_CMD_REPORT_PMSR: To receive response from wmediumd

Why isn't this 3 different patches?  One per thing you are adding?

> Request and response are formatted the same way as pmsr.c.
> One exception is for sending rate_info -- hwsim_rate_info_attributes is
> added to send rate_info as is.

I do not understand what this last sentence means, sorry.

> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V5 -> V6: Added per change patch history.
> V4 -> V5: N/A.
> V3 -> V4: Added more comments about new commands in mac80211_hwsim.
> V1 -> V3: Initial commit (includes resends).
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 679 +++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |  54 +-
>  include/net/cfg80211.h                |  10 +
>  net/wireless/nl80211.c                |  11 +-
>  4 files changed, 737 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 84c9db9178c3..4191037f73b6 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
>  
>  	/* only used when pmsr capability is supplied */
>  	struct cfg80211_pmsr_capabilities pmsr_capa;
> +	struct cfg80211_pmsr_request *pmsr_request;
> +	struct wireless_dev *pmsr_request_wdev;
>  
>  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
>  };
> @@ -750,6 +752,13 @@ struct hwsim_radiotap_ack_hdr {
>  	__le16 rt_chbitmask;
>  } __packed;
>  
> +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
> +{
> +	return rhashtable_lookup_fast(&hwsim_radios_rht,
> +				      addr,
> +				      hwsim_rht_params);

Odd line wrapping :(

> +}
> +
>  /* MAC80211_HWSIM netlink family */
>  static struct genl_family hwsim_genl_family;
>  
> @@ -763,6 +772,81 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
>  
>  /* MAC80211_HWSIM netlink policy */
>  
> +static const struct nla_policy
> +hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] = {
> +	[HWSIM_RATE_INFO_ATTR_FLAGS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_MCS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_LEGACY] = { .type = NLA_U16 },
> +	[HWSIM_RATE_INFO_ATTR_NSS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_BW] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_GI] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_DCM] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_EHT_GI] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] = { .type = NLA_U8 },
> +};
> +
> +static const struct nla_policy
> +hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] = { .type = NLA_U16 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] =
> +		NLA_POLICY_NESTED(hwsim_rate_info_policy),
> +	[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] =
> +		NLA_POLICY_NESTED(hwsim_rate_info_policy),
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_LCI] = { .type = NLA_STRING },
> +	[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] = { .type = NLA_STRING },
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_result_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_RESP_ATTR_STATUS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_RESP_ATTR_HOST_TIME] = { .type = NLA_U64 },
> +	[NL80211_PMSR_RESP_ATTR_AP_TSF] = { .type = NLA_U64 },
> +	[NL80211_PMSR_RESP_ATTR_FINAL] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_RESP_ATTR_DATA] =
> +		NLA_POLICY_NESTED(hwsim_pmsr_resp_type_policy),

Are you sure these line-wraps are needed?  We can go to 100 columns now,
right?

> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR_COMPAT,
> +	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_PEER_ATTR_REQ] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_PEER_ATTR_RESP] =
> +		NLA_POLICY_NESTED(hwsim_pmsr_resp_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_PEERS] =
> +		NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_peer_result_policy),
> +};
> +
>  static const struct nla_policy
>  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
>  	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> @@ -780,7 +864,7 @@ hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
>  };
>  
>  static const struct nla_policy
> -hwsim_pmsr_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
>  	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
>  };
>  
> @@ -790,7 +874,7 @@ hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
>  	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
>  	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
>  	[NL80211_PMSR_ATTR_TYPE_CAPA] =
> -		NLA_POLICY_NESTED(hwsim_pmsr_type_policy),
> +		NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
>  	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
>  };
>  
> @@ -823,6 +907,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
>  	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
>  	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
> +	[HWSIM_ATTR_PMSR_RESULT] = NLA_POLICY_NESTED(hwsim_pmsr_peers_result_policy),
>  };
>  
>  #if IS_REACHABLE(CONFIG_VIRTIO)
> @@ -3142,16 +3227,578 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> -static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
> +						     struct cfg80211_pmsr_ftm_request_peer *request)
> +{
> +	void *ftm;

Are you sure this is void?  Why isn't this a pointer to a real structure
that you are asking for?

> +
> +	if (!request || !request->requested)
> +		return -EINVAL;

How can these happen?

> +
> +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> +	if (!ftm)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
> +			request->preamble))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
> +			request->burst_period))
> +		return -ENOBUFS;
> +
> +	if (request->asap &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_ASAP))
> +		return -ENOBUFS;
> +
> +	if (request->request_lci &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI))
> +		return -ENOBUFS;
> +
> +	if (request->request_civicloc &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC))
> +		return -ENOBUFS;
> +
> +	if (request->trigger_based &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED))
> +		return -ENOBUFS;
> +
> +	if (request->non_trigger_based &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED))
> +		return -ENOBUFS;
> +
> +	if (request->lmr_feedback &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP,
> +		       request->num_bursts_exp))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
> +		       request->burst_duration))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST,
> +		       request->ftms_per_burst))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES,
> +		       request->ftmr_retries))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR,
> +		       request->bss_color))
> +		return -ENOBUFS;
> +
> +	nla_nest_end(msg, ftm);
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_send_pmsr_request_peer(struct sk_buff *msg,
> +						 struct cfg80211_pmsr_request_peer *request)
> +{
> +	void *peer, *chandef, *req, *data;

Same here, why void * when you konw the types being used?

> +	int err;
> +
> +	peer = nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
> +	if (!peer)
> +		return -ENOBUFS;
> +
> +	if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN,
> +		    request->addr))
> +		return -ENOBUFS;
> +
> +	chandef = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> +	if (!chandef)
> +		return -ENOBUFS;
> +
> +	err = cfg80211_send_chandef(msg, &request->chandef);
> +	if (err)
> +		return err;
> +
> +	nla_nest_end(msg, chandef);
> +
> +	req = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_REQ);
> +	if (request->report_ap_tsf &&
> +	    nla_put_flag(msg, NL80211_PMSR_REQ_ATTR_GET_AP_TSF))
> +		return -ENOBUFS;
> +
> +	data = nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
> +	if (!data)
> +		return -ENOBUFS;
> +
> +	mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->ftm);
> +	nla_nest_end(msg, data);
> +	nla_nest_end(msg, req);
> +	nla_nest_end(msg, peer);
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> +					    struct cfg80211_pmsr_request *request)
> +{
> +	int err;
> +	void *pmsr;

and here (hint larger variables go before smaller ones usually, right?)

> +
> +	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
> +	if (!pmsr)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> +		return -ENOBUFS;
> +
> +	if (!is_zero_ether_addr(request->mac_addr)) {
> +		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac_addr))
> +			return -ENOBUFS;
> +		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN,
> +			    request->mac_addr_mask))
> +			return -ENOBUFS;
> +	}
> +
> +	for (int i = 0; i < request->n_peers; i++) {
> +		err = mac80211_hwsim_send_pmsr_request_peer(msg,
> +							    &request->peers[i]);

Is this line wrap needed?

> +		if (err)
> +			return err;
> +	}
> +
> +	nla_nest_end(msg, pmsr);
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
>  				     struct cfg80211_pmsr_request *request)
>  {
> -	return -EOPNOTSUPP;
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	u32 _portid = READ_ONCE(data->wmediumd);

Why READ_ONCE()?

Shouldn't you only access this after the lock is held?

thanks,

greg k-h
