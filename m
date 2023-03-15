Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF56BAD30
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjCOKMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjCOKL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:11:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E9D86B2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678875082; x=1710411082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=oDtnlClw+TYKcGnei7+eXYDiMU7e18uEjcnvLI/IEmk=;
  b=BDWcOGHCVGSnm4CR6Rs9o5wFam3W6dax3j9DPU07AnKMCfG0P1mWdaTD
   nQg40GSn7hcpTkOeWOfnlAJuTXI+uhDijdTv08/B4kfOJxGmdR8/6OS1H
   j68bhJxtOItcOnknJ6XtOHGfZ2zSR7lsjvhL6W35PMyAKy25VJEUJwtYg
   6G0+tJHj6fOl3PE/Kt4TesrcdGO7lC90i67mzBpDaGGSQkPbxWbZy1ubg
   ox4LedzsX8nGGjRji5cH8K727QsSIMkepWyBNe2PYKE5QUAAahZ/d6WLb
   fcJnUw+oIjgkUf2g6ZTqbe8DaD8V71CFmxwJWTiwF+HrHuYgVMAmOVClC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="340025888"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340025888"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:11:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="748360855"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="748360855"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:11:19 -0700
Date:   Wed, 15 Mar 2023 11:11:10 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap)
 rules
Message-ID: <ZBGZvr/tDZYaUAht@localhost.localdomain>
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:35:25PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> A 'foreign' rule is one for which the net_dev is not the sfc netdevice
>  or any of its representors.  The driver registers indirect flow blocks
>  for tunnel netdevs so that it can offload decap rules.  For example:
> 
>     tc filter add dev vxlan0 parent ffff: protocol ipv4 flower \
>         enc_src_ip 10.1.0.2 enc_dst_ip 10.1.0.1 \
>         enc_key_id 1000 enc_dst_port 4789 \
>         action tunnel_key unset \
>         action mirred egress redirect dev $REPRESENTOR
> 
> When notified of a rule like this, register an encap match on the IP
>  and dport tuple (creating an Outer Rule table entry) and insert an MAE
>  action rule to perform the decapsulation and deliver to the representee.
> 
> Move efx_tc_delete_rule() below efx_tc_flower_release_encap_match() to
>  avoid the need for a forward declaration.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/mae.c |  28 ++-
>  drivers/net/ethernet/sfc/mae.h |   3 +
>  drivers/net/ethernet/sfc/tc.c  | 359 +++++++++++++++++++++++++++++++--
>  drivers/net/ethernet/sfc/tc.h  |   1 +
>  4 files changed, 374 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 754391eb575f..e8139076fcb0 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -241,6 +241,7 @@ static int efx_mae_get_basic_caps(struct efx_nic *efx, struct mae_caps *caps)
>  	if (outlen < sizeof(outbuf))
>  		return -EIO;
>  	caps->match_field_count = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_MATCH_FIELD_COUNT);
> +	caps->encap_types = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_ENCAP_TYPES_SUPPORTED);
>  	caps->action_prios = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_ACTION_PRIOS);
>  	return 0;
>  }
> @@ -513,6 +514,28 @@ int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
>  }
>  #undef CHECK
>  
> +int efx_mae_check_encap_type_supported(struct efx_nic *efx, enum efx_encap_type typ)
> +{
> +	unsigned int bit;
> +
> +	switch (typ & EFX_ENCAP_TYPES_MASK) {
In 3/5 You ommited EFX_ENCAP_TYPE_NVGRE, was it intetional?

> +	case EFX_ENCAP_TYPE_VXLAN:
> +		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_VXLAN_LBN;
> +		break;
> +	case EFX_ENCAP_TYPE_NVGRE:
> +		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_NVGRE_LBN;
> +		break;
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		bit = MC_CMD_MAE_GET_CAPS_OUT_ENCAP_TYPE_GENEVE_LBN;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +	if (efx->tc->caps->encap_types & BIT(bit))
> +		return 0;
> +	return -EOPNOTSUPP;
> +}
> +
>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
> @@ -772,9 +795,10 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
>  	size_t outlen;
>  	int rc;
>  
> -	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
> +	MCDI_POPULATE_DWORD_3(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
>  			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, act->vlan_push,
> -			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop);
> +			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, act->vlan_pop,
> +			      MAE_ACTION_SET_ALLOC_IN_DECAP, act->decap);
>  
>  	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
>  		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
> diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
> index 5b45138aaaf4..6cc96f8adfea 100644
> --- a/drivers/net/ethernet/sfc/mae.h
> +++ b/drivers/net/ethernet/sfc/mae.h
> @@ -70,6 +70,7 @@ void efx_mae_counters_grant_credits(struct work_struct *work);
>  
>  struct mae_caps {
>  	u32 match_field_count;
> +	u32 encap_types;
>  	u32 action_prios;
>  	u8 action_rule_fields[MAE_NUM_FIELDS];
>  	u8 outer_rule_fields[MAE_NUM_FIELDS];
> @@ -82,6 +83,8 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
>  			     struct netlink_ext_ack *extack);
>  int efx_mae_check_encap_match_caps(struct efx_nic *efx, unsigned char ipv,
>  				   struct netlink_ext_ack *extack);
> +int efx_mae_check_encap_type_supported(struct efx_nic *efx,
> +				       enum efx_encap_type typ);
>  
>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
>  int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index dc092403af12..8ccf25260312 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -10,12 +10,24 @@
>   */
>  
>  #include <net/pkt_cls.h>
> +#include <net/vxlan.h>
> +#include <net/geneve.h>
>  #include "tc.h"
>  #include "tc_bindings.h"
>  #include "mae.h"
>  #include "ef100_rep.h"
>  #include "efx.h"
>  
> +enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
> +{
> +	if (netif_is_vxlan(net_dev))
> +		return EFX_ENCAP_TYPE_VXLAN;
> +	if (netif_is_geneve(net_dev))
> +		return EFX_ENCAP_TYPE_GENEVE;
netif_is_gretap or NVGRE isn't supported?

> +
> +	return EFX_ENCAP_TYPE_NONE;
> +}
> +
>  #define EFX_EFV_PF	NULL
>  /* Look up the representor information (efv) for a device.
>   * May return NULL for the PF (us), or an error pointer for a device that
> @@ -43,6 +55,20 @@ static struct efx_rep *efx_tc_flower_lookup_efv(struct efx_nic *efx,
>  	return efv;
>  }
>  
> +/* Convert a driver-internal vport ID into an internal device (PF or VF) */
> +static s64 efx_tc_flower_internal_mport(struct efx_nic *efx, struct efx_rep *efv)
> +{
> +	u32 mport;
> +
> +	if (IS_ERR(efv))
> +		return PTR_ERR(efv);
> +	if (!efv) /* device is PF (us) */
> +		efx_mae_mport_uplink(efx, &mport);
> +	else /* device is repr */
> +		efx_mae_mport_mport(efx, efv->mport, &mport);
> +	return mport;
> +}
> +
>  /* Convert a driver-internal vport ID into an external device (wire or VF) */
>  static s64 efx_tc_flower_external_mport(struct efx_nic *efx, struct efx_rep *efv)
>  {
> @@ -106,15 +132,6 @@ static void efx_tc_free_action_set_list(struct efx_nic *efx,
>  	/* Don't kfree, as acts is embedded inside a struct efx_tc_flow_rule */
>  }
>  
> -static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
> -{
> -	efx_mae_delete_rule(efx, rule->fw_id);
> -
> -	/* Release entries in subsidiary tables */
> -	efx_tc_free_action_set_list(efx, &rule->acts, true);
> -	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
> -}
> -
>  static void efx_tc_flow_free(void *ptr, void *arg)
>  {
>  	struct efx_tc_flow_rule *rule = ptr;
> @@ -350,7 +367,6 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
>  	return 0;
>  }
>  
> -__always_unused
>  static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>  					    struct efx_tc_match *match,
>  					    enum efx_encap_type type,
> @@ -479,7 +495,6 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>  	return rc;
>  }
>  
> -__always_unused
>  static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
>  					      struct efx_tc_encap_match *encap)
>  {
> @@ -501,8 +516,38 @@ static void efx_tc_flower_release_encap_match(struct efx_nic *efx,
>  	kfree(encap);
>  }
>  
> +static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
> +{
> +	efx_mae_delete_rule(efx, rule->fw_id);
> +
> +	/* Release entries in subsidiary tables */
> +	efx_tc_free_action_set_list(efx, &rule->acts, true);
> +	if (rule->match.encap)
> +		efx_tc_flower_release_encap_match(efx, rule->match.encap);
> +	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
> +}
> +
> +static const char *efx_tc_encap_type_name(enum efx_encap_type typ, char *buf,
> +					  size_t n)
> +{
> +	switch (typ) {
> +	case EFX_ENCAP_TYPE_NONE:
> +		return "none";
> +	case EFX_ENCAP_TYPE_VXLAN:
> +		return "vxlan";
> +	case EFX_ENCAP_TYPE_NVGRE:
> +		return "nvgre";
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		return "geneve";
> +	default:
> +		snprintf(buf, n, "type %u\n", typ);
> +		return buf;
I will return unsupported here, instead of playing with buffer.

> +	}
> +}
> +
>  /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
Is it a device documentation? Where it can be find?

>  enum efx_tc_action_order {
> +	EFX_TC_AO_DECAP,
>  	EFX_TC_AO_VLAN_POP,
>  	EFX_TC_AO_VLAN_PUSH,
>  	EFX_TC_AO_COUNT,
> @@ -513,6 +558,10 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
>  					  enum efx_tc_action_order new)
>  {
>  	switch (new) {
> +	case EFX_TC_AO_DECAP:
> +		if (act->decap)
> +			return false;
> +		fallthrough;
>  	case EFX_TC_AO_VLAN_POP:
>  		if (act->vlan_pop >= 2)
>  			return false;
> @@ -540,6 +589,288 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
>  	}
>  }
>  
> +static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
> +					 struct net_device *net_dev,
> +					 struct flow_cls_offload *tc)
> +{
> +	struct flow_rule *fr = flow_cls_offload_flow_rule(tc);
> +	struct netlink_ext_ack *extack = tc->common.extack;
> +	struct efx_tc_flow_rule *rule = NULL, *old = NULL;
> +	struct efx_tc_action_set *act = NULL;
> +	bool found = false, uplinked = false;
> +	const struct flow_action_entry *fa;
> +	struct efx_tc_match match;
> +	struct efx_rep *to_efv;
> +	s64 rc;
> +	int i;
> +
> +	/* Parse match */
> +	memset(&match, 0, sizeof(match));
> +	rc = efx_tc_flower_parse_match(efx, fr, &match, NULL);
> +	if (rc)
> +		return rc;
> +	/* The rule as given to us doesn't specify a source netdevice.
> +	 * But, determining whether packets from a VF should match it is
> +	 * complicated, so leave those to the software slowpath: qualify
> +	 * the filter with source m-port == wire.
> +	 */
> +	rc = efx_tc_flower_external_mport(efx, EFX_EFV_PF);
Let's define extern_port as s64, a rc as int, it will be more readable I
think.

> +	if (rc < 0) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to identify ingress m-port for foreign filter");
> +		return rc;
> +	}
> +	match.value.ingress_port = rc;
> +	match.mask.ingress_port = ~0;
> +
> +	if (tc->common.chain_index) {
> +		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
> +		return -EOPNOTSUPP;
> +	}
> +	match.mask.recirc_id = 0xff;
> +
> +	flow_action_for_each(i, fa, &fr->action) {
> +		switch (fa->id) {
> +		case FLOW_ACTION_REDIRECT:
> +		case FLOW_ACTION_MIRRED: /* mirred means mirror here */
> +			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
> +			if (IS_ERR(to_efv))
> +				continue;
> +			found = true;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +	if (!found) { /* We don't care. */
> +		netif_dbg(efx, drv, efx->net_dev,
> +			  "Ignoring foreign filter that doesn't egdev us\n");
> +		rc = -EOPNOTSUPP;
> +		goto release;
> +	}
> +
> +	rc = efx_mae_match_check_caps(efx, &match.mask, NULL);
> +	if (rc)
> +		goto release;
> +
> +	if (efx_tc_match_is_encap(&match.mask)) {
> +		enum efx_encap_type type;
> +
> +		type = efx_tc_indr_netdev_type(net_dev);
> +		if (type == EFX_ENCAP_TYPE_NONE) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Egress encap match on unsupported tunnel device");
> +			rc = -EOPNOTSUPP;
> +			goto release;
> +		}
> +
> +		rc = efx_mae_check_encap_type_supported(efx, type);
> +		if (rc) {
> +			char errbuf[16];
> +
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "Firmware reports no support for %s encap match",
> +					       efx_tc_encap_type_name(type, errbuf,
> +								      sizeof(errbuf)));
> +			goto release;
> +		}
> +
> +		rc = efx_tc_flower_record_encap_match(efx, &match, type,
> +						      extack);
> +		if (rc)
> +			goto release;
> +	} else {
> +		/* This is not a tunnel decap rule, ignore it */
> +		netif_dbg(efx, drv, efx->net_dev,
> +			  "Ignoring foreign filter without encap match\n");
> +		rc = -EOPNOTSUPP;
> +		goto release;
> +	}
> +
> +	rule = kzalloc(sizeof(*rule), GFP_USER);
> +	if (!rule) {
> +		rc = -ENOMEM;
> +		goto release;
> +	}
> +	INIT_LIST_HEAD(&rule->acts.list);
> +	rule->cookie = tc->cookie;
> +	old = rhashtable_lookup_get_insert_fast(&efx->tc->match_action_ht,
> +						&rule->linkage,
> +						efx_tc_match_action_ht_params);
> +	if (old) {
> +		netif_dbg(efx, drv, efx->net_dev,
> +			  "Ignoring already-offloaded rule (cookie %lx)\n",
> +			  tc->cookie);
> +		rc = -EEXIST;
> +		goto release;
> +	}
> +
> +	/* Parse actions */
> +	act = kzalloc(sizeof(*act), GFP_USER);
> +	if (!act) {
> +		rc = -ENOMEM;
> +		goto release;
> +	}
> +
> +	/* Parse actions.  For foreign rules we only support decap & redirect */
> +	flow_action_for_each(i, fa, &fr->action) {
> +		struct efx_tc_action_set save;
> +
> +		switch (fa->id) {
> +		case FLOW_ACTION_REDIRECT:
> +		case FLOW_ACTION_MIRRED:
> +			/* See corresponding code in efx_tc_flower_replace() for
> +			 * long explanations of what's going on here.
> +			 */
> +			save = *act;
Why save is needed here? In one bloick You are changing act, in other
save.

> +			if (fa->hw_stats) {
> +				struct efx_tc_counter_index *ctr;
> +
> +				if (!(fa->hw_stats & FLOW_ACTION_HW_STATS_DELAYED)) {
> +					NL_SET_ERR_MSG_FMT_MOD(extack,
> +							       "hw_stats_type %u not supported (only 'delayed')",
> +							       fa->hw_stats);
> +					rc = -EOPNOTSUPP;
> +					goto release;
> +				}
> +				if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_COUNT)) {
> +					rc = -EOPNOTSUPP;
> +					goto release;
> +				}
> +
> +				ctr = efx_tc_flower_get_counter_index(efx,
> +								      tc->cookie,
> +								      EFX_TC_COUNTER_TYPE_AR);
> +				if (IS_ERR(ctr)) {
> +					rc = PTR_ERR(ctr);
> +					NL_SET_ERR_MSG_MOD(extack, "Failed to obtain a counter");
> +					goto release;
> +				}
> +				act->count = ctr;
> +			}
> +
> +			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DELIVER)) {
> +				/* can't happen */
> +				rc = -EOPNOTSUPP;
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Deliver action violates action order (can't happen)");
> +				goto release;
> +			}
> +			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
> +			/* PF implies egdev is us, in which case we really
> +			 * want to deliver to the uplink (because this is an
> +			 * ingress filter).  If we don't recognise the egdev
> +			 * at all, then we'd better trap so SW can handle it.
> +			 */
> +			if (IS_ERR(to_efv))
> +				to_efv = EFX_EFV_PF;
> +			if (to_efv == EFX_EFV_PF) {
> +				if (uplinked)
> +					break;
> +				uplinked = true;
> +			}
> +			rc = efx_tc_flower_internal_mport(efx, to_efv);
> +			if (rc < 0) {
> +				NL_SET_ERR_MSG_MOD(extack, "Failed to identify egress m-port");
> +				goto release;
> +			}
> +			act->dest_mport = rc;
> +			act->deliver = 1;
> +			rc = efx_mae_alloc_action_set(efx, act);
> +			if (rc) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Failed to write action set to hw (mirred)");
> +				goto release;
> +			}
> +			list_add_tail(&act->list, &rule->acts.list);
> +			act = NULL;
act was allocated, You need to free it, or maybe it is being cleared in
alloc_action_set()? However, this function is really hard to follow.
Please explain it more widely.

> +			if (fa->id == FLOW_ACTION_REDIRECT)
> +				break; /* end of the line */
> +			/* Mirror, so continue on with saved act */
> +			save.count = NULL;
> +			act = kzalloc(sizeof(*act), GFP_USER);
> +			if (!act) {
> +				rc = -ENOMEM;
> +				goto release;
> +			}
> +			*act = save;
> +			break;
> +		case FLOW_ACTION_TUNNEL_DECAP:
> +			if (!efx_tc_flower_action_order_ok(act, EFX_TC_AO_DECAP)) {
> +				rc = -EINVAL;
> +				NL_SET_ERR_MSG_MOD(extack, "Decap action violates action order");
> +				goto release;
> +			}
> +			act->decap = 1;
> +			/* If we previously delivered/trapped to uplink, now
> +			 * that we've decapped we'll want another copy if we
> +			 * try to deliver/trap to uplink again.
> +			 */
> +			uplinked = false;
> +			break;
> +		default:
> +			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
> +					       fa->id);
> +			rc = -EOPNOTSUPP;
> +			goto release;
> +		}
> +	}
> +
> +	if (act) {
> +		if (!uplinked) {
> +			/* Not shot/redirected, so deliver to default dest (which is
> +			 * the uplink, as this is an ingress filter)
> +			 */
> +			efx_mae_mport_uplink(efx, &act->dest_mport);
> +			act->deliver = 1;
> +		}
> +		rc = efx_mae_alloc_action_set(efx, act);
> +		if (rc) {
> +			NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (deliver)");
> +			goto release;
> +		}
> +		list_add_tail(&act->list, &rule->acts.list);
> +		act = NULL; /* Prevent double-free in error path */
> +	}
> +
> +	rule->match = match;
> +
> +	netif_dbg(efx, drv, efx->net_dev,
> +		  "Successfully parsed foreign filter (cookie %lx)\n",
> +		  tc->cookie);
> +
> +	rc = efx_mae_alloc_action_set_list(efx, &rule->acts);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to write action set list to hw");
> +		goto release;
> +	}
> +	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
> +				 rule->acts.fw_id, &rule->fw_id);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
> +		goto release_act;
> +	}
act is saved somewhere?

> +	return 0;
> +
> +release_act:
> +	efx_mae_free_action_set_list(efx, &rule->acts);
> +release:
> +	/* We failed to insert the rule, so free up any entries we created in
> +	 * subsidiary tables.
> +	 */
> +	if (act)
> +		efx_tc_free_action_set(efx, act, false);
> +	if (rule) {
> +		rhashtable_remove_fast(&efx->tc->match_action_ht,
> +				       &rule->linkage,
> +				       efx_tc_match_action_ht_params);
> +		efx_tc_free_action_set_list(efx, &rule->acts, false);
> +	}
> +	kfree(rule);
> +	if (match.encap)
> +		efx_tc_flower_release_encap_match(efx, match.encap);
> +	return rc;
> +}
> +
>  static int efx_tc_flower_replace(struct efx_nic *efx,
>  				 struct net_device *net_dev,
>  				 struct flow_cls_offload *tc,
> @@ -564,10 +895,8 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>  
>  	from_efv = efx_tc_flower_lookup_efv(efx, net_dev);
>  	if (IS_ERR(from_efv)) {
> -		/* Might be a tunnel decap rule from an indirect block.
> -		 * Support for those not implemented yet.
> -		 */
> -		return -EOPNOTSUPP;
> +		/* Not from our PF or representors, so probably a tunnel dev */
> +		return efx_tc_flower_replace_foreign(efx, net_dev, tc);
>  	}
>  
>  	if (efv != from_efv) {
> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> index d70c0ba86669..47b6e9e35808 100644
> --- a/drivers/net/ethernet/sfc/tc.h
> +++ b/drivers/net/ethernet/sfc/tc.h
> @@ -28,6 +28,7 @@ static inline bool efx_ipv6_addr_all_ones(struct in6_addr *addr)
>  struct efx_tc_action_set {
>  	u16 vlan_push:2;
>  	u16 vlan_pop:2;
> +	u16 decap:1;
>  	u16 deliver:1;
>  	__be16 vlan_tci[2]; /* TCIs for vlan_push */
>  	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
