Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2269C524031
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348699AbiEKWYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiEKWYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:24:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8AFEAD09;
        Wed, 11 May 2022 15:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB62B82637;
        Wed, 11 May 2022 22:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F260EC340EE;
        Wed, 11 May 2022 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652307852;
        bh=BfTpXL3NjR4e6g+Q/T4BbQTGZ9tGQWTxBSuv9bZuhao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tPKgz3dxWELXVfE1icHDaigxUm7pYnEGoN+U5ma1VOmgR+msoq+Jo5QPSiQE2WTNE
         dQGfPqbHVkxhuN9wxkAJ9YDLlcA0s4Oog2L8MTHOT2ER6FEVyV5jXFNWi1+UzJNA4e
         ngKfFChQqj+xFTAnnKc4zZ6Uu/2I45rMs/jUg9+Xsxpte6+Qa8EAVg0KWpLSpJgRWa
         9mY/3MSatRe2XQ6exyOKBxtgyQ5DOD0MXM42EP+kfPSIjeCZVlp9twjWNHbbeBNrD+
         4jjUmU6vlsghD0Ry0BXtWsoGgTf/O+sSrXSCB3msHO/nuc+Jbp+30JgeF06iFY1aNh
         44ik93AUbElUg==
Date:   Wed, 11 May 2022 15:24:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, stable@vger.kernel.org,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v2 1/1] i40e: i40e_main: fix a missing check on list
 iterator
Message-ID: <20220511152410.465ea444@kernel.org>
In-Reply-To: <20220510204846.2166999-1-anthony.l.nguyen@intel.com>
References: <20220510204846.2166999-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 13:48:46 -0700 Tony Nguyen wrote:
> From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> 
> The bug is here:
> 	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);
> 
> The list iterator 'ch' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will
> lead to a invalid memory access.
> 
> To fix this bug, use a new variable 'iter' as the list iterator,
> while use the origin variable 'ch' as a dedicated pointer to
> point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1d8d80b4e4ff6 ("i40e: Add macvlan support on i40e")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
> v2: Dropped patch "iavf: Fix error when changing ring parameters on ice PF"
> as its being reworked
> 
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 27 +++++++++++----------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 6778df2177a1..98871f014994 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -7549,42 +7549,43 @@ static void i40e_free_macvlan_channels(struct i40e_vsi *vsi)
>  static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
>  			    struct i40e_fwd_adapter *fwd)
>  {
> +	struct i40e_channel *ch = NULL, *ch_tmp, *iter;
>  	int ret = 0, num_tc = 1,  i, aq_err;
> -	struct i40e_channel *ch, *ch_tmp;
>  	struct i40e_pf *pf = vsi->back;
>  	struct i40e_hw *hw = &pf->hw;
>  
> -	if (list_empty(&vsi->macvlan_list))
> -		return -EINVAL;
> -
>  	/* Go through the list and find an available channel */
> -	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
> -		if (!i40e_is_channel_macvlan(ch)) {
> -			ch->fwd = fwd;
> +	list_for_each_entry_safe(iter, ch_tmp, &vsi->macvlan_list, list) {
> +		if (!i40e_is_channel_macvlan(iter)) {
> +			iter->fwd = fwd;
>  			/* record configuration for macvlan interface in vdev */
>  			for (i = 0; i < num_tc; i++)
>  				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
>  							     i,
> -							     ch->num_queue_pairs,
> -							     ch->base_queue);
> -			for (i = 0; i < ch->num_queue_pairs; i++) {
> +							     iter->num_queue_pairs,
> +							     iter->base_queue);
> +			for (i = 0; i < iter->num_queue_pairs; i++) {
>  				struct i40e_ring *tx_ring, *rx_ring;
>  				u16 pf_q;
>  
> -				pf_q = ch->base_queue + i;
> +				pf_q = iter->base_queue + i;
>  
>  				/* Get to TX ring ptr */
>  				tx_ring = vsi->tx_rings[pf_q];
> -				tx_ring->ch = ch;
> +				tx_ring->ch = iter;
>  
>  				/* Get the RX ring ptr */
>  				rx_ring = vsi->rx_rings[pf_q];
> -				rx_ring->ch = ch;
> +				rx_ring->ch = iter;
>  			}
> +			ch = iter;
>  			break;

I guess this is some form of an intentional pattern so I won't delay
the fix. But Paolo pointed out in previous reviews of similar patches
that if the assignment to the old iterator name (ch in this case) was
done earlier in the function (right before iter->fwd = fwd;) we would
not have to modify so many lines of this function.

>  		}
>  	}
>  
> +	if (!ch)
> +		return -EINVAL;
> +
>  	/* Guarantee all rings are updated before we update the
>  	 * MAC address filter.
>  	 */

