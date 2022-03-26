Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6A04E7DD3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiCZAKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCZAKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:10:38 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDBFFD1A;
        Fri, 25 Mar 2022 17:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648253342; x=1679789342;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/4/hLSPErMshZS/R4PQkE0KQWm7CKRIwCZX9uyxfrRo=;
  b=K54t00u53qqfYGv9dRcqVZUmUjRIeMpE7KHFZ4ztbDHM+cLqst8MqI4R
   kQnwEef9zddqGydMVqs+6316NdCDHaGo9tRDJwOojcj6VXW/aFPwGq9Zs
   J2EDs+AUPMB253143oJYHWTK4XSHJCZlGkPDSmJVLqmks+ILUOBlUaQdo
   Q=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 25 Mar 2022 17:09:02 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 17:09:01 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 25 Mar 2022 17:09:01 -0700
Received: from [10.110.27.134] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 25 Mar
 2022 17:09:00 -0700
Message-ID: <7ae9915d-98fc-efd4-4a1e-872c446aacca@quicinc.com>
Date:   Fri, 25 Mar 2022 17:09:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220323214533.1951791-1-egagnon@squareup.com>
 <20220325224212.159690-1-egagnon@squareup.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220325224212.159690-1-egagnon@squareup.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/2022 3:42 PM, Edmond Gagnon wrote:
> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
> rate:
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>          SSID: SQ-DEVICETEST
>          freq: 5200
>          RX: 4141 bytes (32 packets)
>          TX: 2082 bytes (15 packets)
>          signal: -77 dBm
>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>          tx bitrate: 6.0 MBit/s
> 
>          bss flags:      short-slot-time
>          dtim period:    1
>          beacon int:     100
> 
> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
> firmware message and reports it via ieee80211_ops::sta_statistics.
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>          SSID: SQ-DEVICETEST
>          freq: 5700
>          RX: 26788094 bytes (19859 packets)
>          TX: 1101376 bytes (12119 packets)
>          signal: -75 dBm
>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>          tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
> 
>          bss flags:      short-slot-time
>          dtim period:    1
>          beacon int:     100
> 
> Tested on MSM8939 with WCN3680B running firmware CNSS-PR-2-0-1-2-c1-00083,
> and verified by sniffing frames over the air with Wireshark to ensure the
> MCS indices match.
> 
> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
> Reviewed-by: Benjamin Li <benl@squareup.com>
> ---
> 
> Changes in v4:
>   - Shortened very long line in smd.c
>   - Fixed every checkpatch issue I could find:
> 	scripts/checkpatch.pl --strict
> 		0001-wcn36xx-Implement-tx_rate-reporting.patch
> 	total: 0 errors, 0 warnings, 0 checks, 156 lines checked
> Changes in v3:
>   - Refactored to report tx_rate via ieee80211_ops::sta_statistics
>   - Dropped get_sta_index patch
>   - Addressed style comments
> Changes in v2:
>   - Refactored to use existing wcn36xx_hal_get_stats_{req,rsp}_msg structs.
>   - Added more notes about testing.
>   - Reduced reporting interval to 3000msec.
>   - Assorted type and memory safety fixes.
>   - Make wcn36xx_smd_get_stats friendlier to future message implementors.
> 
>   drivers/net/wireless/ath/wcn36xx/hal.h  |  7 ++-
>   drivers/net/wireless/ath/wcn36xx/main.c | 16 +++++++
>   drivers/net/wireless/ath/wcn36xx/smd.c  | 57 +++++++++++++++++++++++++
>   drivers/net/wireless/ath/wcn36xx/smd.h  |  2 +
>   drivers/net/wireless/ath/wcn36xx/txrx.c | 29 +++++++++++++
>   drivers/net/wireless/ath/wcn36xx/txrx.h |  1 +
>   6 files changed, 111 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 2a1db9756fd5..46a49f0a51b3 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -2626,7 +2626,12 @@ enum tx_rate_info {
>   	HAL_TX_RATE_SGI = 0x8,
>   
>   	/* Rate with Long guard interval */
> -	HAL_TX_RATE_LGI = 0x10
> +	HAL_TX_RATE_LGI = 0x10,
> +
> +	/* VHT rates */
> +	HAL_TX_RATE_VHT20  = 0x20,
> +	HAL_TX_RATE_VHT40  = 0x40,
> +	HAL_TX_RATE_VHT80  = 0x80,
>   };
>   
>   struct ani_global_class_a_stats_info {
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index b545d4b2b8c4..fc76b090c39f 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1400,6 +1400,21 @@ static int wcn36xx_get_survey(struct ieee80211_hw *hw, int idx,
>   	return 0;
>   }
>   
> +static void wcn36xx_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +				   struct ieee80211_sta *sta, struct station_info *sinfo)
> +{
> +	struct wcn36xx *wcn;
> +	u8 sta_index;
> +	int status = 0;

remove initializer that is always overwritten

> +
> +	wcn = hw->priv;
> +	sta_index = get_sta_index(vif, wcn36xx_sta_to_priv(sta));
> +	status = wcn36xx_smd_get_stats(wcn, sta_index, HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);
> +
> +	if (status)
> +		wcn36xx_err("wcn36xx_smd_get_stats failed\n");
> +}
> +
>   static const struct ieee80211_ops wcn36xx_ops = {
>   	.start			= wcn36xx_start,
>   	.stop			= wcn36xx_stop,
> @@ -1423,6 +1438,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
>   	.set_rts_threshold	= wcn36xx_set_rts_threshold,
>   	.sta_add		= wcn36xx_sta_add,
>   	.sta_remove		= wcn36xx_sta_remove,
> +	.sta_statistics		= wcn36xx_sta_statistics,
>   	.ampdu_action		= wcn36xx_ampdu_action,
>   #if IS_ENABLED(CONFIG_IPV6)
>   	.ipv6_addr_change	= wcn36xx_ipv6_addr_change,
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index caeb68901326..a2188b41e308 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2627,6 +2627,62 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index)
>   	return ret;
>   }
>   
> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 stats_mask,
> +			  struct station_info *sinfo)
> +{
> +	struct wcn36xx_hal_stats_req_msg msg_body;
> +	struct wcn36xx_hal_stats_rsp_msg *rsp;
> +	void *rsp_body;
> +	int ret = 0;

remove initializer that is always overwritten before use

> +
> +	if (stats_mask & ~HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		wcn36xx_err("stats_mask 0x%x contains unimplemented types\n",
> +			    stats_mask);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&wcn->hal_mutex);
> +	INIT_HAL_MSG(msg_body, WCN36XX_HAL_GET_STATS_REQ);
> +
> +	msg_body.sta_id = sta_index;
> +	msg_body.stats_mask = stats_mask;
> +
> +	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +	if (ret) {
> +		wcn36xx_err("sending hal_get_stats failed\n");
> +		goto out;
> +	}
> +
> +	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +	if (ret) {
> +		wcn36xx_err("hal_get_stats response failed err=%d\n", ret);
> +		goto out;
> +	}
> +
> +	rsp = (struct wcn36xx_hal_stats_rsp_msg *)wcn->hal_buf;
> +	rsp_body = (wcn->hal_buf + sizeof(struct wcn36xx_hal_stats_rsp_msg));
> +
> +	if (rsp->stats_mask != stats_mask) {
> +		wcn36xx_err("stats_mask 0x%x differs from requested 0x%x\n",
> +			    rsp->stats_mask, stats_mask);
> +		goto out;
> +	}
> +
> +	if (rsp->stats_mask & HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		struct ani_global_class_a_stats_info *stats_info = rsp_body;
> +
> +		wcn36xx_process_tx_rate(stats_info, &sinfo->txrate);
> +		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
> +		rsp_body += sizeof(struct ani_global_class_a_stats_info);
> +	}
> +out:
> +	mutex_unlock(&wcn->hal_mutex);
> +
> +	return ret;
> +}
> +
>   static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len, struct add_ba_info *ba_info)
>   {
>   	struct wcn36xx_hal_trigger_ba_rsp_candidate *candidate;
> @@ -3316,6 +3372,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
>   	case WCN36XX_HAL_ADD_BA_SESSION_RSP:
>   	case WCN36XX_HAL_ADD_BA_RSP:
>   	case WCN36XX_HAL_DEL_BA_RSP:
> +	case WCN36XX_HAL_GET_STATS_RSP:
>   	case WCN36XX_HAL_TRIGGER_BA_RSP:
>   	case WCN36XX_HAL_UPDATE_CFG_RSP:
>   	case WCN36XX_HAL_JOIN_RSP:
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
> index 957cfa87fbde..3fd598ac2a27 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.h
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.h
> @@ -138,6 +138,8 @@ int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
>   int wcn36xx_smd_add_ba(struct wcn36xx *wcn, u8 session_id);
>   int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index);
>   int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index, u16 tid, u16 *ssn);
> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 stats_mask,
> +			  struct station_info *sinfo);
>   
>   int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value);
>   
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
> index df749b114568..8da3955995b6 100644
> --- a/drivers/net/wireless/ath/wcn36xx/txrx.c
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
> @@ -699,3 +699,32 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
>   
>   	return ret;
>   }
> +
> +void wcn36xx_process_tx_rate(struct ani_global_class_a_stats_info *stats, struct rate_info *info)
> +{
> +	/* tx_rate is in units of 500kbps; mac80211 wants them in 100kbps */
> +	if (stats->tx_rate_flags & HAL_TX_RATE_LEGACY)
> +		info->legacy = stats->tx_rate * 5;
> +
> +	info->flags = 0;
> +	info->mcs = stats->mcs_index;
> +	info->nss = 1;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_HT40))
> +		info->flags |= RATE_INFO_FLAGS_MCS;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_VHT20 | HAL_TX_RATE_VHT40 | HAL_TX_RATE_VHT80))
> +		info->flags |= RATE_INFO_FLAGS_VHT_MCS;
> +
> +	if (stats->tx_rate_flags & HAL_TX_RATE_SGI)
> +		info->flags |= RATE_INFO_FLAGS_SHORT_GI;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_VHT20))
> +		info->bw = RATE_INFO_BW_20;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT40 | HAL_TX_RATE_VHT40))
> +		info->bw = RATE_INFO_BW_40;
> +
> +	if (stats->tx_rate_flags & HAL_TX_RATE_VHT80)
> +		info->bw = RATE_INFO_BW_80;
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
> index b54311ffde9c..fb0d6cabd52b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/txrx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
> @@ -164,5 +164,6 @@ int  wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb);
>   int wcn36xx_start_tx(struct wcn36xx *wcn,
>   		     struct wcn36xx_sta *sta_priv,
>   		     struct sk_buff *skb);
> +void wcn36xx_process_tx_rate(struct ani_global_class_a_stats_info *stats, struct rate_info *info);
>   
>   #endif	/* _TXRX_H_ */

