Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA0E6BAC10
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjCOJYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjCOJYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:24:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC54AD33B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678872245; x=1710408245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ENKfuRVJWSBByBKtH52Xxv/7J4pd+prjouVW0Q7vuvI=;
  b=FLXqcd09ULrShQZNO773HlYF6WWCd+1cyG1g7X0G4q22j5Jpv8ws928U
   qU2PqD4TsrjRqdtMmOUMa4yUHwy7mJXahMp1QyzDYZCmeiHJK8fcCtVGE
   gF98EjXJ2GyxLBhYxOPukddi4AclmDB0uEKiNbZaYpMqNpj6QUy6E/30q
   a643n5VsVaMHb/ZPRKIsjXxwnioIKv1cmKaUzoO0zHiYm+02BmNAUDhXI
   CKxlXx++tugrsVwMhbPCQYf4mFxuL4pZoxLV2A+BTkL6DhJGAvw9ymcmW
   qP0DJgnXBgztAGEV2xpQeGpbMSVPvjCvdLkSD+KIbxlS6mSKBvm2ONReo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335140063"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335140063"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:24:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008766605"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008766605"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:24:03 -0700
Date:   Wed, 15 Mar 2023 10:23:54 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 3/5] sfc: add functions to insert encap matches
 into the MAE
Message-ID: <ZBGOquhra46CArGq@localhost.localdomain>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <cae6e259972a00e4785a6d92f71d43bece0858a8.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cae6e259972a00e4785a6d92f71d43bece0858a8.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:35:23PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> An encap match corresponds to an entry in the exact-match Outer Rule
>  table; the lookup response includes the encap type (protocol) allowing
>  the hardware to continue parsing into the inner headers.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/mae.c | 105 +++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mae.h |   5 ++
>  drivers/net/ethernet/sfc/tc.h  |   1 +
>  3 files changed, 111 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 1a285facda34..754391eb575f 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -564,6 +564,20 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  	return 0;
>  }
>  
> +static int efx_mae_encap_type_to_mae_type(enum efx_encap_type type)
> +{
> +	switch (type & EFX_ENCAP_TYPES_MASK) {
> +	case EFX_ENCAP_TYPE_NONE:
> +		return MAE_MCDI_ENCAP_TYPE_NONE;
> +	case EFX_ENCAP_TYPE_VXLAN:
> +		return MAE_MCDI_ENCAP_TYPE_VXLAN;
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		return MAE_MCDI_ENCAP_TYPE_GENEVE;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
> @@ -921,6 +935,97 @@ int efx_mae_free_action_set_list(struct efx_nic *efx,
>  	return 0;
>  }
>  
> +int efx_mae_register_encap_match(struct efx_nic *efx,
> +				 struct efx_tc_encap_match *encap)
> +{
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_INSERT_IN_LEN(MAE_ENC_FIELD_PAIRS_LEN));
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_INSERT_OUT_LEN);
> +	MCDI_DECLARE_STRUCT_PTR(match_crit);
> +	size_t outlen;
> +	int rc;
> +
> +	rc = efx_mae_encap_type_to_mae_type(encap->tun_type);
> +	if (rc < 0)
> +		return rc;
> +	match_crit = _MCDI_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_FIELD_MATCH_CRITERIA);
> +	/* The struct contains IP src and dst, and udp dport.
> +	 * So we actually need to filter on IP src and dst, L4 dport, and
> +	 * ipproto == udp.
> +	 */
> +	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_INSERT_IN_ENCAP_TYPE, rc);
> +#ifdef CONFIG_IPV6
> +	if (encap->src_ip | encap->dst_ip) {
> +#endif
Looks strange, in case CONFIG_IPV6 isn't defined You can also check if
theres is no zero ip.

> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE,
> +					 encap->src_ip);
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE_MASK,
> +					 ~(__be32)0);
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE,
> +					 encap->dst_ip);
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE_MASK,
> +					 ~(__be32)0);
> +		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
> +					htons(ETH_P_IP));
> +#ifdef CONFIG_IPV6
> +	} else {
> +		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE),
> +		       &encap->src_ip6, sizeof(encap->src_ip6));
> +		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE_MASK),
> +		       0xff, sizeof(encap->src_ip6));
> +		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE),
> +		       &encap->dst_ip6, sizeof(encap->dst_ip6));
> +		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE_MASK),
> +		       0xff, sizeof(encap->dst_ip6));
> +		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
> +					htons(ETH_P_IPV6));
> +	}
> +#endif
> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE_MASK,
> +				~(__be16)0);
> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE,
> +				encap->udp_dport);
> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
> +				~(__be16)0);
Question, from tc we can set masks for matching fields. You are setting
default one, because hardware doesn't support different masks?

> +	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO, IPPROTO_UDP);
> +	MCDI_STRUCT_SET_BYTE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_IP_PROTO_MASK, ~0);
> +	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_INSERT, inbuf,
> +			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
> +	if (rc)
> +		return rc;
> +	if (outlen < sizeof(outbuf))
> +		return -EIO;
> +	encap->fw_id = MCDI_DWORD(outbuf, MAE_OUTER_RULE_INSERT_OUT_OR_ID);
> +	return 0;
> +}
> +
> +int efx_mae_unregister_encap_match(struct efx_nic *efx,
> +				   struct efx_tc_encap_match *encap)
> +{
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_OUT_LEN(1));
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_REMOVE_IN_LEN(1));
> +	size_t outlen;
> +	int rc;
> +
> +	MCDI_SET_DWORD(inbuf, MAE_OUTER_RULE_REMOVE_IN_OR_ID, encap->fw_id);
> +	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_OUTER_RULE_REMOVE, inbuf,
> +			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
> +	if (rc)
> +		return rc;
> +	if (outlen < sizeof(outbuf))
> +		return -EIO;
> +	/* FW freed a different ID than we asked for, should also never happen.
> +	 * Warn because it means we've now got a different idea to the FW of
> +	 * what encap_mds exist, which could cause mayhem later.
> +	 */
> +	if (WARN_ON(MCDI_DWORD(outbuf, MAE_OUTER_RULE_REMOVE_OUT_REMOVED_OR_ID) != encap->fw_id))
> +		return -EIO;
> +	/* We're probably about to free @encap, but let's just make sure its
> +	 * fw_id is blatted so that it won't look valid if it leaks out.
> +	 */
> +	encap->fw_id = MC_CMD_MAE_OUTER_RULE_INSERT_OUT_OUTER_RULE_ID_NULL;
> +	return 0;
> +}
> +
>  static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
>  					   const struct efx_tc_match *match)
>  {
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index a45d1791517f..5b45138aaaf4 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -94,6 +94,11 @@ int efx_mae_alloc_action_set_list(struct efx_nic *efx,
>  int efx_mae_free_action_set_list(struct efx_nic *efx,
>  				 struct efx_tc_action_set_list *acts);
>  
> +int efx_mae_register_encap_match(struct efx_nic *efx,
> +				 struct efx_tc_encap_match *encap);
> +int efx_mae_unregister_encap_match(struct efx_nic *efx,
> +				   struct efx_tc_encap_match *encap);
> +
>  int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
>  			u32 prio, u32 acts_id, u32 *id);
>  int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> index c1485679507c..19782c9a4354 100644
> --- a/drivers/net/ethernet/sfc/tc.h
> +++ b/drivers/net/ethernet/sfc/tc.h
> @@ -70,6 +70,7 @@ struct efx_tc_encap_match {
>  	__be32 src_ip, dst_ip;
>  	struct in6_addr src_ip6, dst_ip6;
>  	__be16 udp_dport;
> +	u16 tun_type; /* enum efx_encap_type */
>  	u32 fw_id; /* index of this entry in firmware encap match table */
>  };
>  
