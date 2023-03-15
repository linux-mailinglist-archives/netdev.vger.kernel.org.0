Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706E96BAB0D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCOItI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjCOItG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:49:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C8298D7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6CFDB81D94
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96C5C433EF;
        Wed, 15 Mar 2023 08:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870141;
        bh=dkxYCd2aw2VdtUa2nWirscWAvvGcVKt2akM7gGDokVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F30e62Ac4zjE8Lk3RiupSV1Wxhrdvka4225DUqtVhmQA4z668oFZagrRkjMPxZtR+
         EMCEgEyCO4Rld7nFLTrXOxzrfsFhOnqgYUQTmXk+Ozi6yiqfdnGGskbR5Ux9C/ivb1
         Ynu5Fe4RgcCz3zeHKwo/K1eaFS8w8izBilsV8ProiAMi2Aw4DyFgYx7C70YsQCLZnG
         rdmLul6qIXq7L8mHNB17o6XBvwsdCNlH8/27Al0CqrmHjLherRdmNLsei5Q6SGjDMy
         C2iVkLW3uoncyZw4w78pgmdVuDQa8DWk6/80misSgGBi/iXh06QDavnPOYtQeRLmOn
         CPsv7r9w2SiWw==
Date:   Wed, 15 Mar 2023 10:48:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 3/3] iavf: do not track VLAN 0 filters
Message-ID: <20230315084856.GN36557@unreal>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
 <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:44:23AM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> When an interface with the maximum number of VLAN filters is brought up,
> a spurious error is logged:
> 
>     [257.483082] 8021q: adding VLAN 0 to HW filter on device enp0s3
>     [257.483094] iavf 0000:00:03.0 enp0s3: Max allowed VLAN filters 8. Remove existing VLANs or disable filtering via Ethtool if supported.
> 
> The VF driver complains that it cannot add the VLAN 0 filter.
> 
> On the other hand, the PF driver always adds VLAN 0 filter on VF
> initialization. The VF does not need to ask the PF for that filter at
> all.
> 
> Fix the error by not tracking VLAN 0 filters altogether. With that, the
> check added by commit 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0
> filters") in iavf_virtchnl.c is useless and might be confusing if left as
> it suggests that we track VLAN 0.
> 
> Fixes: 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0 filters")
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c     | 4 ++++
>  drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3273aeb8fa67..eb8f944276ff 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -893,6 +893,10 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
>  {
>  	struct iavf_adapter *adapter = netdev_priv(netdev);
>  
> +	/* Do not track VLAN 0 filter, always added by the PF on VF init */
> +	if (!vid)
> +		return 0;

I would expect similar check in iavf_vlan_rx_kill_vid(),

Thanks

> +
>  	if (!VLAN_FILTERING_ALLOWED(adapter))
>  		return -EIO;
>  
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> index 6d23338604bb..4e17d006c52d 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
> @@ -2446,8 +2446,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
>  		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
>  			if (f->is_new_vlan) {
>  				f->is_new_vlan = false;
> -				if (!f->vlan.vid)
> -					continue;
>  				if (f->vlan.tpid == ETH_P_8021Q)
>  					set_bit(f->vlan.vid,
>  						adapter->vsi.active_cvlans);
> -- 
> 2.38.1
> 
