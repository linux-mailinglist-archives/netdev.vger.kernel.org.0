Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE86BAB6C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCOJCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjCOJCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:02:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE00212B3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678870912; x=1710406912;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=46Fbyxsf2jpzvGJkTT2Pw1SLP742v50V79irgSWIBNo=;
  b=j+JvKZVfcWZrPtbSI5XZkzRVhfRiOxlH2bIqfB0Mc3shzccSHXI/OSmP
   tsruXJfa2Dpu80W+q0yJnuSg0yiprAEM/XJuyfSEZBoVkXDvzM8h0x7RF
   4eaH1mdGvJBV3HTOjJ+ktyPwq6A699oF0wKvrwcxGM+RQbXDODOyR3W2J
   DZPfXxA5TPP6I7szrAXT1veVdbFruzEPwDPq0ak5MdU+VBBw3NreE8sUp
   roSb0AobkNAmbjTRPl1qhP25vzxYtxkRaZK8jEkomwuhzJEzLZvJ9mhJn
   EzkJscwaNK/MUoJ0vFZIaoCq/xR13dIcE7DM7U7EYaMnE+BZCqZ0u3D8E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326010474"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326010474"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768422949"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768422949"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:01:50 -0700
Date:   Wed, 15 Mar 2023 10:01:41 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 2/5] sfc: handle enc keys in
 efx_tc_flower_parse_match()
Message-ID: <ZBGJdWyXZSlXwN96@localhost.localdomain>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <962d11de229400416804173b2ab035d73493a6b4.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962d11de229400416804173b2ab035d73493a6b4.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:35:22PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Translate the fields from flow dissector into struct efx_tc_match.
> In efx_tc_flower_replace(), reject filters that match on them, because
>  only 'foreign' filters (i.e. those for which the ingress dev is not
>  the sfc netdev or any of its representors, e.g. a tunnel netdev) can
>  use them.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/tc.c | 65 +++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index 2b07bb2fd735..d683665a8d87 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -193,6 +193,11 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
>  	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
>  	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
>  	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
> +	      BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
> +	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
> +	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
> +	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
> +	      BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL) |
>  	      BIT(FLOW_DISSECTOR_KEY_TCP) |
>  	      BIT(FLOW_DISSECTOR_KEY_IP))) {
>  		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
> @@ -280,6 +285,61 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
>  	MAP_KEY_AND_MASK(PORTS, ports, src, l4_sport);
>  	MAP_KEY_AND_MASK(PORTS, ports, dst, l4_dport);
>  	MAP_KEY_AND_MASK(TCP, tcp, flags, tcp_flags);
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
> +		struct flow_match_control fm;
> +
> +		flow_rule_match_enc_control(rule, &fm);
> +		if (fm.mask->flags) {
> +			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on enc_control.flags %#x",
> +					       fm.mask->flags);
> +			return -EOPNOTSUPP;
> +		}
> +		if (!IS_ALL_ONES(fm.mask->addr_type)) {
> +			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported enc addr_type mask %u (key %u)",
> +					       fm.mask->addr_type,
> +					       fm.key->addr_type);
> +			return -EOPNOTSUPP;
> +		}
> +		switch (fm.key->addr_type) {
> +		case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
> +			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
> +					     src, enc_src_ip);
> +			MAP_ENC_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, enc_ipv4_addrs,
> +					     dst, enc_dst_ip);
> +			break;
> +#ifdef CONFIG_IPV6
> +		case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
> +			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
> +					     src, enc_src_ip6);
> +			MAP_ENC_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, enc_ipv6_addrs,
> +					     dst, enc_dst_ip6);
> +			break;
> +#endif
> +		default:
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "Unsupported enc addr_type %u (supported are IPv4, IPv6)",
> +					       fm.key->addr_type);
> +			return -EOPNOTSUPP;
> +		}
> +#if !defined(EFX_USE_KCOMPAT) || defined(EFX_HAVE_FLOW_DISSECTOR_KEY_ENC_IP)
Are these defines already in kernel, or You want to add it to kconfig?
I can't find it in tree, aren't they some kind of OOT driver defines?

> +		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, tos, enc_ip_tos);
> +		MAP_ENC_KEY_AND_MASK(IP, ip, enc_ip, ttl, enc_ip_ttl);
> +#endif
> +		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, src, enc_sport);
> +		MAP_ENC_KEY_AND_MASK(PORTS, ports, enc_ports, dst, enc_dport);
> +		MAP_ENC_KEY_AND_MASK(KEYID, enc_keyid, enc_keyid, keyid, enc_keyid);
> +	} else if (dissector->used_keys &
> +		   (BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
> +		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) |
> +		    BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
> +#if !defined(EFX_USE_KCOMPAT) || defined(EFX_HAVE_FLOW_DISSECTOR_KEY_ENC_IP)
> +		    BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
> +#endif
> +		    BIT(FLOW_DISSECTOR_KEY_ENC_PORTS))) {
> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Flower enc keys require enc_control (keys: %#x)",
> +				       dissector->used_keys);
> +		return -EOPNOTSUPP;
> +	}
>  
>  	return 0;
>  }
> @@ -373,6 +433,11 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>  	rc = efx_tc_flower_parse_match(efx, fr, &match, extack);
>  	if (rc)
>  		return rc;
> +	if (efx_tc_match_is_encap(&match.mask)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Ingress enc_key matches not supported");
> +		rc = -EOPNOTSUPP;
> +		goto release;
> +	}
>  
>  	if (tc->common.chain_index) {
>  		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
