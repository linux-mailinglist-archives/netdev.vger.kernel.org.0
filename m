Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E0B6BAFB1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCOLxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCOLxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:53:35 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D7CE1A0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678881210; x=1710417210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8YH7PxX/RUjtRTjtiRTWU75RtjOpZmEkzxt0O2HgW94=;
  b=nxfG6l02xjHDItaE64KvykuG4btlBvrAycxiEcMfax5KXrp6ZN/wTLoH
   2J1M0DxZHYMd6Xv7N8ix8ksLrgYMVFBO0+2N8kkh2b0JsieMu+tNofdfi
   9JvQfqqxRGYm+q7u0QKQy+7oYVF6u9G9oWeGVQP5lsSEwQZp64zIlUAkg
   msW3S7MhkH7XGuPgOVQVcgLy0IcCA1T0EOSEM98g6T71CMb9+XSrAdkUs
   EhsTYSclZLxEFUStuNdLNREsPf7zuiiy+M+mYDLQ30uTWsiZwnL9a6loE
   VgJebcWJFgmFHlTe/5Pu8RfMMNlQyryLw4fyG9dot7ONFt1yw+sa9ElcN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326037984"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326037984"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:53:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="629431686"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="629431686"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:53:11 -0700
Date:   Wed, 15 Mar 2023 12:53:02 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <ZBGxnjxwmY0NyVt7@localhost.localdomain>
References: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 08:10:24AM +0100, Sven Auhagen wrote:
> In PPPoE add all IPv4 header option length to the parser
> and adjust the L3 and L4 offset accordingly.
> Currently the L4 match does not work with PPPoE and
> all packets are matched as L3 IP4 OPT.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> index ed8be396428b..9af22f497a40 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
> @@ -1607,59 +1607,45 @@ static int mvpp2_prs_vlan_init(struct platform_device *pdev, struct mvpp2 *priv)
>  static int mvpp2_prs_pppoe_init(struct mvpp2 *priv)
>  {
>  	struct mvpp2_prs_entry pe;
> -	int tid;
> -
> -	/* IPv4 over PPPoE with options */
> -	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
> -					MVPP2_PE_LAST_FREE_TID);
> -	if (tid < 0)
> -		return tid;
> -
> -	memset(&pe, 0, sizeof(pe));
> -	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
> -	pe.index = tid;
> -
> -	mvpp2_prs_match_etype(&pe, 0, PPP_IP);
> -
> -	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP4);
> -	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP4_OPT,
> -				 MVPP2_PRS_RI_L3_PROTO_MASK);
> -	/* goto ipv4 dest-address (skip eth_type + IP-header-size - 4) */
> -	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN +
> -				 sizeof(struct iphdr) - 4,
> -				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
> -	/* Set L3 offset */
> -	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,
> -				  MVPP2_ETH_TYPE_LEN,
> -				  MVPP2_PRS_SRAM_OP_SEL_UDF_ADD);
> -
> -	/* Update shadow table and hw entry */
> -	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_PPPOE);
> -	mvpp2_prs_hw_write(priv, &pe);
> +	int tid, ihl;
>  
> -	/* IPv4 over PPPoE without options */
> -	tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
> -					MVPP2_PE_LAST_FREE_TID);
> -	if (tid < 0)
> -		return tid;
> +	/* IPv4 over PPPoE with header length >= 5 */
> +	for (ihl = MVPP2_PRS_IPV4_IHL_MIN; ihl <= MVPP2_PRS_IPV4_IHL_MAX; ihl++) {
> +		tid = mvpp2_prs_tcam_first_free(priv, MVPP2_PE_FIRST_FREE_TID,
> +						MVPP2_PE_LAST_FREE_TID);
pe can be defined here:
struct mvpp2_prs_entry pe = {};

and now memset can be ommited.

> +		if (tid < 0)
> +			return tid;
>  
> -	pe.index = tid;
> +		memset(&pe, 0, sizeof(pe));
> +		mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_PPPOE);
> +		pe.index = tid;
[...]
>  
> -- 
> 2.33.1
> 
