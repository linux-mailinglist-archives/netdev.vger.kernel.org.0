Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99236BA7AC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCOGTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjCOGTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:19:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F8137702
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 23:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678861153; x=1710397153;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JeUmr9oYJvT9XBliDIRDwZBLapj5rUyM7UuqqvYlZRw=;
  b=bJfDTANCLjaUdelEjDlCrpVBQle4kOk+UaHDsBPeq5u6+9Sc3q4xb6bo
   7untx9JeJe0lihwNpP49zN9LXMHwadIJ0SS+oSoKMMrkMFik+NJXZfnTy
   J81+H9g0orqpiLuOwb+SJNycNYmu9JGBfLg+gpUtUZ17M9kQMo9sV1Q3f
   l8P8xhXUNNbli5TzOX4nlMNPWMzUY31CRHER5c1tGUUBhEptizHFVx8Qz
   n8eSW6197my+LMjnR1KmCfcNTHGL8f6Vk7SGY6c50/UhSa62uLsFmawSV
   OegLYtb3RbBP+UoY4Xri5y335Hk9I2pqqZmIVm7HQ60yOs5CWPMP6/x/E
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="336311269"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="336311269"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008707255"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008707255"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:19:09 -0700
Date:   Wed, 15 Mar 2023 07:19:01 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 1/5] sfc: add notion of match on enc keys to MAE
 machinery
Message-ID: <ZBFjVV7ZfOz9u50M@localhost.localdomain>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <cc70de55f816fe885fcb73003a9822961d1c5dfd.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc70de55f816fe885fcb73003a9822961d1c5dfd.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:35:21PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Extend the MAE caps check to validate that the hardware supports used
>  outer-header matches.
> Extend efx_mae_populate_match_criteria() to fill in the outer rule ID
>  and VNI match fields.
> Nothing yet populates these match fields, nor creates outer rules.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/mae.c | 104 ++++++++++++++++++++++++++++++++-
>  drivers/net/ethernet/sfc/mae.h |   3 +
>  drivers/net/ethernet/sfc/tc.h  |  24 ++++++++
>  3 files changed, 129 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index c53d354c1fb2..1a285facda34 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -254,13 +254,23 @@ static int efx_mae_get_rule_fields(struct efx_nic *efx, u32 cmd,
>  	size_t outlen;
>  	int rc, i;
>  
> +	/* AR and OR caps MCDIs have identical layout, so we are using the
> +	 * same code for both.
> +	 */
> +	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_LEN(MAE_NUM_FIELDS) <
> +		     MC_CMD_MAE_GET_OR_CAPS_OUT_LEN(MAE_NUM_FIELDS));
>  	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_IN_LEN);
> +	BUILD_BUG_ON(MC_CMD_MAE_GET_OR_CAPS_IN_LEN);
>  
>  	rc = efx_mcdi_rpc(efx, cmd, NULL, 0, outbuf, sizeof(outbuf), &outlen);
>  	if (rc)
>  		return rc;
> +	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_COUNT_OFST !=
> +		     MC_CMD_MAE_GET_OR_CAPS_OUT_COUNT_OFST);
>  	count = MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_COUNT);
>  	memset(field_support, MAE_FIELD_UNSUPPORTED, MAE_NUM_FIELDS);
> +	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_OUT_FIELD_FLAGS_OFST !=
> +		     MC_CMD_MAE_GET_OR_CAPS_OUT_FIELD_FLAGS_OFST);
>  	caps = _MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_FIELD_FLAGS);
>  	/* We're only interested in the support status enum, not any other
>  	 * flags, so just extract that from each entry.
> @@ -278,8 +288,12 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps)
>  	rc = efx_mae_get_basic_caps(efx, caps);
>  	if (rc)
>  		return rc;
> -	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
> -				       caps->action_rule_fields);
> +	rc = efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
> +				     caps->action_rule_fields);
> +	if (rc)
> +		return rc;
> +	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_OR_CAPS,
> +				       caps->outer_rule_fields);
>  }
>  
>  /* Bit twiddling:
> @@ -432,11 +446,73 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
>  	    CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag) ||
>  	    CHECK(RECIRC_ID, recirc_id))
>  		return rc;
> +	/* Matches on outer fields are done in a separate hardware table,
> +	 * the Outer Rule table.  Thus the Action Rule merely does an
> +	 * exact match on Outer Rule ID if any outer field matches are
> +	 * present.  The exception is the VNI/VSID (enc_keyid), which is
> +	 * available to the Action Rule match iff the Outer Rule matched
if I think :)

> +	 * (and thus identified the encap protocol to use to extract it).
> +	 */
> +	if (efx_tc_match_is_encap(mask)) {
> +		rc = efx_mae_match_check_cap_typ(
> +				supported_fields[MAE_FIELD_OUTER_RULE_ID],
> +				MASK_ONES);
> +		if (rc) {
> +			NL_SET_ERR_MSG_MOD(extack, "No support for encap rule ID matches");
> +			return rc;
> +		}
> +		if (CHECK(ENC_VNET_ID, enc_keyid))
> +			return rc;
> +	} else if (mask->enc_keyid) {
> +		NL_SET_ERR_MSG_MOD(extack, "Match on enc_keyid requires other encap fields");
> +		return -EINVAL;
> +	}
>  	return 0;
>  }
>  #undef CHECK_BIT
>  #undef CHECK
>  
> +#define CHECK(_mcdi)	({						       \
> +	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
> +					 MASK_ONES);			       \
> +	if (rc)								       \
> +		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
> +				       "No support for field %s", #_mcdi);     \
> +	rc;								       \
> +})
Is there any reasone why macro is used instead of function? It is a
little hard to read becasue it is modyfing rc value.

> +/* Checks that the fields needed for encap-rule matches are supported by the
> + * MAE.  All the fields are exact-match.
> + */
> +int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
> +				   struct netlink_ext_ack *extack)
> +{
> +	u8 *supported_fields = efx->tc->caps->outer_rule_fields;
> +	int rc;
> +
> +	if (CHECK(ENC_ETHER_TYPE))
> +		return rc;
> +	switch (ipv) {
> +	case 4:
> +		if (CHECK(ENC_SRC_IP4) ||
> +		    CHECK(ENC_DST_IP4))
> +			return rc;
> +		break;
> +	case 6:
> +		if (CHECK(ENC_SRC_IP6) ||
> +		    CHECK(ENC_DST_IP6))
> +			return rc;
> +		break;
> +	default: /* shouldn't happen */
> +		EFX_WARN_ON_PARANOID(1);
> +		break;
> +	}
> +	if (CHECK(ENC_L4_DPORT) ||
> +	    CHECK(ENC_IP_PROTO))
> +		return rc;
> +	return 0;
> +}
> +#undef CHECK
> +
>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
> @@ -941,6 +1017,30 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
>  				match->value.tcp_flags);
>  	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
>  				match->mask.tcp_flags);
> +	/* enc-keys are handled indirectly, through encap_match ID */
> +	if (match->encap) {
> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
> +				      match->encap->fw_id);
> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
> +				      (u32)-1);
U32_MAX can't be used here?

> +		/* enc_keyid (VNI/VSID) is not part of the encap_match */
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
> +					 match->value.enc_keyid);
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
> +					 match->mask.enc_keyid);
> +	} else {
> +		/* No enc-keys should appear in a rule without an encap_match */
> +		if (WARN_ON_ONCE(match->mask.enc_src_ip) ||
> +		    WARN_ON_ONCE(match->mask.enc_dst_ip) ||
> +		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_src_ip6)) ||
> +		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_dst_ip6)) ||
> +		    WARN_ON_ONCE(match->mask.enc_ip_tos) ||
> +		    WARN_ON_ONCE(match->mask.enc_ip_ttl) ||
> +		    WARN_ON_ONCE(match->mask.enc_sport) ||
> +		    WARN_ON_ONCE(match->mask.enc_dport) ||
> +		    WARN_ON_ONCE(match->mask.enc_keyid))
> +			return -EOPNOTSUPP;
Can be written as else if {}

Also, You define a similar function: efx_tc_match_is_encap(), I think it
can be used here.

> +	}
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index bec293a06733..a45d1791517f 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -72,6 +72,7 @@ struct mae_caps {
>  	u32 match_field_count;
>  	u32 action_prios;
>  	u8 action_rule_fields[MAE_NUM_FIELDS];
> +	u8 outer_rule_fields[MAE_NUM_FIELDS];
>  };
>  
>  int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
> @@ -79,6 +80,8 @@ int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
>  int efx_mae_match_check_caps(struct efx_nic *efx,
>  			     const struct efx_tc_match_fields *mask,
>  			     struct netlink_ext_ack *extack);
> +int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
> +				   struct netlink_ext_ack *extack);
>  
>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
>  int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> index 542853f60c2a..c1485679507c 100644
> --- a/drivers/net/ethernet/sfc/tc.h
> +++ b/drivers/net/ethernet/sfc/tc.h
> @@ -48,11 +48,35 @@ struct efx_tc_match_fields {
>  	/* L4 */
>  	__be16 l4_sport, l4_dport; /* Ports (UDP, TCP) */
>  	__be16 tcp_flags;
> +	/* Encap.  The following are *outer* fields.  Note that there are no
> +	 * outer eth (L2) fields; this is because TC doesn't have them.
> +	 */
> +	__be32 enc_src_ip, enc_dst_ip;
> +	struct in6_addr enc_src_ip6, enc_dst_ip6;
> +	u8 enc_ip_tos, enc_ip_ttl;
> +	__be16 enc_sport, enc_dport;
> +	__be32 enc_keyid; /* e.g. VNI, VSID */
> +};
> +
> +static inline bool efx_tc_match_is_encap(const struct efx_tc_match_fields *mask)
> +{
> +	return mask->enc_src_ip || mask->enc_dst_ip ||
> +	       !ipv6_addr_any(&mask->enc_src_ip6) ||
> +	       !ipv6_addr_any(&mask->enc_dst_ip6) || mask->enc_ip_tos ||
> +	       mask->enc_ip_ttl || mask->enc_sport || mask->enc_dport;
> +}
> +
> +struct efx_tc_encap_match {
> +	__be32 src_ip, dst_ip;
> +	struct in6_addr src_ip6, dst_ip6;
> +	__be16 udp_dport;
What about source port? It isn't supported?

> +	u32 fw_id; /* index of this entry in firmware encap match table */
>  };
>  
>  struct efx_tc_match {
>  	struct efx_tc_match_fields value;
>  	struct efx_tc_match_fields mask;
> +	struct efx_tc_encap_match *encap;
>  };
>  
>  struct efx_tc_action_set_list {
