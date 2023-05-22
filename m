Return-Path: <netdev+bounces-4197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0EC70B997
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EA4A280ED7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25492AD51;
	Mon, 22 May 2023 10:06:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B78A949
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:06:26 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B6B9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 03:06:24 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id BE47E61DFA908;
	Mon, 22 May 2023 12:05:43 +0200 (CEST)
Message-ID: <2b4f07b4-607f-126c-1eaa-5bdac701d831@molgen.mpg.de>
Date: Mon, 22 May 2023 12:05:43 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v3 01/10] ice: Minor switchdev
 fixes
Content-Language: en-US
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-2-wojciech.drewek@intel.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230522090542.45679-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Wojciech,


Thank you for your patches.

Am 22.05.23 um 11:05 schrieb Wojciech Drewek:
> Introduce a few fixes that are needed for bridge offload
> to work properly.
> 
> - Skip adv rule removal in ice_eswitch_disable_switchdev.
>    Advanced rules for ctrl VSI will be removed anyway when the
>    VSI will cleaned up, no need to do it explicitly.
> 
> - Don't allow to change promisc mode in switchdev mode.
>    When switchdev is configured, PF netdev is set to be a
>    default VSI. This is needed for the slow-path to work correctly.
>    All the unmatched packets will be directed to PF netdev.
> 
>    It is possible that this setting might be overwritten by
>    ndo_set_rx_mode. Prevent this by checking if switchdev is
>    enabled in ice_set_rx_mode.
> 
> - Disable vlan pruning for uplink VSI. In switchdev mode, uplink VSI
>    is configured to be default VSI which means it will receive all
>    unmatched packets. In order to receive vlan packets we need to
>    disable vlan pruning as well. This is done by dis_rx_filtering
>    vlan op.
> 
> - There is possibility that ice_eswitch_port_start_xmit might be
>    called while some resources are still not allocated which might
>    cause NULL pointer dereference. Fix this by checking if switchdev
>    configuration was finished.

If you enumerate/list changes in a commit message, it’s a good indicator 
to make one patch/commit for each item. ;-) Doing this also makes it 
easier to use a statement as the commit message summary, that means 
using a verb (in imperative mood) – Fix minor switchdev things – and 
making `git log --oneline`) more useful. Smaller commits are also easier 
to revert or to backport.

> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: enclose bitops into separate set of braces, move
>      ice_is_switchdev_running check to ice_set_rx_mode
>      from ice_vsi_sync_fltr
> ---
>   drivers/net/ethernet/intel/ice/ice_eswitch.c | 14 +++++++++++++-
>   drivers/net/ethernet/intel/ice/ice_main.c    |  4 ++--
>   2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> index ad0a007b7398..bfd003135fc8 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
> @@ -103,6 +103,10 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
>   		rule_added = true;
>   	}
>   
> +	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
> +	if (vlan_ops->dis_rx_filtering(uplink_vsi))
> +		goto err_dis_rx;
> +
>   	if (ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_set_allow_override))
>   		goto err_override_uplink;
>   
> @@ -114,6 +118,8 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
>   err_override_control:
>   	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
>   err_override_uplink:
> +	vlan_ops->ena_rx_filtering(uplink_vsi);
> +err_dis_rx:
>   	if (rule_added)
>   		ice_clear_dflt_vsi(uplink_vsi);
>   err_def_rx:
> @@ -331,6 +337,9 @@ ice_eswitch_port_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>   	np = netdev_priv(netdev);
>   	vsi = np->vsi;
>   
> +	if (!vsi || !ice_is_switchdev_running(vsi->back))
> +		return NETDEV_TX_BUSY;
> +
>   	if (ice_is_reset_in_progress(vsi->back->state) ||
>   	    test_bit(ICE_VF_DIS, vsi->back->state))
>   		return NETDEV_TX_BUSY;
> @@ -378,9 +387,13 @@ static void ice_eswitch_release_env(struct ice_pf *pf)
>   {
>   	struct ice_vsi *uplink_vsi = pf->switchdev.uplink_vsi;
>   	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
> +	struct ice_vsi_vlan_ops *vlan_ops;
> +
> +	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
>   
>   	ice_vsi_update_security(ctrl_vsi, ice_vsi_ctx_clear_allow_override);
>   	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
> +	vlan_ops->ena_rx_filtering(uplink_vsi);
>   	ice_clear_dflt_vsi(uplink_vsi);
>   	ice_fltr_add_mac_and_broadcast(uplink_vsi,
>   				       uplink_vsi->port_info->mac.perm_addr,
> @@ -503,7 +516,6 @@ static void ice_eswitch_disable_switchdev(struct ice_pf *pf)
>   
>   	ice_eswitch_napi_disable(pf);
>   	ice_eswitch_release_env(pf);
> -	ice_rem_adv_rule_for_vsi(&pf->hw, ctrl_vsi->idx);
>   	ice_eswitch_release_reprs(pf, ctrl_vsi);
>   	ice_vsi_release(ctrl_vsi);
>   	ice_repr_rem_from_all_vfs(pf);
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index b0d1e6116eb9..80b2b4d39278 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -385,7 +385,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
>   	}
>   	err = 0;
>   	/* check for changes in promiscuous modes */
> -	if (changed_flags & IFF_ALLMULTI) {
> +	if ((changed_flags & IFF_ALLMULTI)) {
>   		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
>   			err = ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
>   			if (err) {
> @@ -5767,7 +5767,7 @@ static void ice_set_rx_mode(struct net_device *netdev)
>   	struct ice_netdev_priv *np = netdev_priv(netdev);
>   	struct ice_vsi *vsi = np->vsi;
>   
> -	if (!vsi)
> +	if (!vsi || ice_is_switchdev_running(vsi->back))
>   		return;
>   
>   	/* Set the flags to synchronize filters

The diff itself looks good.

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul

