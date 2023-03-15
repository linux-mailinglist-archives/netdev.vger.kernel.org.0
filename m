Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1357B6BAC5E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjCOJn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCOJnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:43:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9760C40F1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678873401; x=1710409401;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8fvIOmFSyq6F26VVAn4rkoSE5f+IjN5DiC4HyVdOKnQ=;
  b=OwKddexo2/J0M51HxlOm1eZIX7+K9mXryjq7KhAuoXSaXnY3TzTSTjZf
   G6nkCw1WM7LYcrWjlAdQbQxULHMEprLglFiDF9Wpq0HRROy1yZekQnPk7
   6XOKf0Y+KKFxSkpmdqlpY6RrnTZzm7pq5jGKPlFwgxFW1fQjsAhu5bCEe
   mAzRcbwgIlz886t7pLkl2AZONMvVIeem0YMZvucrmv3hohIcayCGcOMZC
   EOeNhDhXM8tOg9DYbq7JMwmQ+N2INoEglV3Blb9Kp7h+MuQIrkcE64tMy
   VMlh6XC2ReEZRqFzj5UwiSp7H9bD7wossvK7die6MYnDnk+2kkC8Vo5ri
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="337678047"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="337678047"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:43:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925271151"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925271151"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:43:19 -0700
Date:   Wed, 15 Mar 2023 10:43:11 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 4/5] sfc: add code to register and unregister
 encap matches
Message-ID: <ZBGTL9i9/rC6xSdQ@localhost.localdomain>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <27d54534188ab35e875d8c79daf1f59ecf66f2c5.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27d54534188ab35e875d8c79daf1f59ecf66f2c5.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:35:24PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Add a hashtable to detect duplicate and conflicting matches.  If match
>  is not a duplicate, call MAE functions to add/remove it from OR table.
> Calling code not added yet, so mark the new functions as unused.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/tc.c | 176 ++++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/tc.h |  11 +++
>  2 files changed, 187 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index d683665a8d87..dc092403af12 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -57,6 +57,12 @@ static s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv
>  	return mport;
>  }
>  
> +static const struct rhashtable_params efx_tc_encap_match_ht_params = {
> +	.key_len	= offsetof(struct efx_tc_encap_match, linkage),
> +	.key_offset	= 0,
> +	.head_offset	= offsetof(struct efx_tc_encap_match, linkage),
> +};
> +
>  static const struct rhashtable_params efx_tc_match_action_ht_params = {
>  	.key_len	= sizeof(unsigned long),
>  	.key_offset	= offsetof(struct efx_tc_flow_rule, cookie),
> @@ -344,6 +350,157 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
>  	return 0;
>  }
>  
> +__always_unused
> +static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
> +					    struct efx_tc_match *match,
> +					    enum efx_encap_type type,
> +					    struct netlink_ext_ack *extack)
> +{
> +	struct efx_tc_encap_match *encap, *old;
> +	unsigned char ipv;
int? or even boolean is_ipv4

> +	int rc;
> +
> +	/* We require that the socket-defining fields (IP addrs and UDP dest
> +	 * port) are present and exact-match.  Other fields are currently not
> +	 * allowed.  This meets what OVS will ask for, and means that we don't
> +	 * need to handle difficult checks for overlapping matches as could
> +	 * come up if we allowed masks or varying sets of match fields.
> +	 */
> +	if (match->mask.enc_dst_ip | match->mask.enc_src_ip) {
> +		ipv = 4;
> +		if (!IS_ALL_ONES(match->mask.enc_dst_ip)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match is not exact on dst IP address");
> +			return -EOPNOTSUPP;
> +		}
> +		if (!IS_ALL_ONES(match->mask.enc_src_ip)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match is not exact on src IP address");
Do You mean that only exact match is supported?

> +			return -EOPNOTSUPP;
> +		}
> +#ifdef CONFIG_IPV6
> +		if (!ipv6_addr_any(&match->mask.enc_dst_ip6) ||
> +		    !ipv6_addr_any(&match->mask.enc_src_ip6)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match on both IPv4 and IPv6, don't understand");
> +			return -EOPNOTSUPP;
> +		}
> +	} else {
> +		ipv = 6;
> +		if (!efx_ipv6_addr_all_ones(&match->mask.enc_dst_ip6)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match is not exact on dst IP address");
> +			return -EOPNOTSUPP;
> +		}
> +		if (!efx_ipv6_addr_all_ones(&match->mask.enc_src_ip6)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match is not exact on src IP address");
> +			return -EOPNOTSUPP;
> +		}
> +#endif
> +	}
> +	if (!IS_ALL_ONES(match->mask.enc_dport)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Egress encap match is not exact on dst UDP port");
> +		return -EOPNOTSUPP;
> +	}
> +	if (match->mask.enc_sport) {
> +		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on src UDP port not supported");
> +		return -EOPNOTSUPP;
> +	}
> +	if (match->mask.enc_ip_tos) {
> +		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP ToS not supported");
> +		return -EOPNOTSUPP;
> +	}
> +	if (match->mask.enc_ip_ttl) {
> +		NL_SET_ERR_MSG_MOD(extack, "Egress encap match on IP TTL not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	rc = efx_mae_check_encap_match_caps(efx, ipv, extack);
> +	if (rc) {
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "MAE hw reports no support for IPv%d encap matches",
> +				       ipv);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	encap = kzalloc(sizeof(*encap), GFP_USER);
> +	if (!encap)
> +		return -ENOMEM;
> +	switch (ipv) {
> +	case 4:
> +		encap->src_ip = match->value.enc_src_ip;
> +		encap->dst_ip = match->value.enc_dst_ip;
> +		break;
> +#ifdef CONFIG_IPV6
> +	case 6:
> +		encap->src_ip6 = match->value.enc_src_ip6;
> +		encap->dst_ip6 = match->value.enc_dst_ip6;
> +		break;
> +#endif
> +	default: /* can't happen */
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Egress encap match on bad IP version %d",
> +				       ipv);
> +		rc = -EOPNOTSUPP;
> +		goto fail_allocated;
I will rewrite it to if. You will get rid of this unreachable code.

> +	}
> +	encap->udp_dport = match->value.enc_dport;
> +	encap->tun_type = type;
> +	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
> +						&encap->linkage,
> +						efx_tc_encap_match_ht_params);
> +	if (old) {
> +		/* don't need our new entry */
> +		kfree(encap);
> +		if (old->tun_type != type) {
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "Egress encap match with conflicting tun_type %u != %u",
> +					       old->tun_type, type);
> +			return -EEXIST;
> +		}
> +		if (!refcount_inc_not_zero(&old->ref))
> +			return -EAGAIN;
> +		/* existing entry found */
> +		encap = old;
> +	} else {
> +		rc = efx_mae_register_encap_match(efx, encap);
> +		if (rc) {
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to record egress encap match in HW");
> +			goto fail_inserted;
> +		}
> +		refcount_set(&encap->ref, 1);
> +	}
> +	match->encap = encap;
> +	return 0;
> +fail_inserted:
> +	rhashtable_remove_fast(&efx->tc->encap_match_ht, &encap->linkage,
> +			       efx_tc_encap_match_ht_params);
> +fail_allocated:
> +	kfree(encap);
> +	return rc;
> +}
> +
[...]
