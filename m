Return-Path: <netdev+bounces-8779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB31725B4A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA29728116D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1815735B2C;
	Wed,  7 Jun 2023 10:08:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078857488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:08:34 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391541BC2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686132511; x=1717668511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w65BvFiUtoqQss5SqT1UczIylH+nHzs3arNxG/9TfSM=;
  b=UeJ812oDu8UePJHZS/zc67Jy20tv3LsiU4aqZ1re7UQCviLOKR7aNttg
   rEpE9RMq+7pK1X7+Pt31fAEPQ2IYAKrBg56Y9yj8TQHvqK4t0Dm7nCMFT
   piEcquNuectZs24fDMk4RFsVqqhKbYhapbWx0eg7zk9o7oqlsnACQuwN8
   sRNYUwJW8of+bbe+dJO3evfR4Y21u3//Fmt5ydjGjBWPPEFbsFDXyr6pR
   MSVDpcAQr/UwdhDsiHv4zIcfusVIjcq0YDKNYfTyLMlM2fnaraAg9+SY7
   mxnNvNKaDxdPWMXdqF83nd1nf/wfvCpWMzmh+RmI2Ol7TuFBN4YQabyxn
   w==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="216623569"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 03:08:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 03:08:27 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 03:08:26 -0700
Date: Wed, 7 Jun 2023 10:08:25 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 10/10] ice: update reset path for SRIOV LAG support
Message-ID: <20230607100825.igma5yifszm327nk@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-11-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-11-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Add code to rebuild the LAG resources when rebuilding the state of the
> interface after a reset.
> 
> Also added in a function for building per-queue information into the buffer
> used to configure VF queues for LAG fail-over.  This improves code reuse.
> 
> Due to differences in timing per interface for recovering from a reset, add
> in the ability to retry on non-local dependencies where needed.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lag.c  | 287 +++++++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_lag.h  |   3 +
>  drivers/net/ethernet/intel/ice/ice_main.c |  14 +-
>  3 files changed, 300 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
> index ffad9f3a5576..4c07d1b9e338 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
> @@ -997,6 +997,7 @@ static void ice_lag_link_unlink(struct ice_lag *lag, void *ptr)
>   * @link: Is this a linking activity
>   *
>   * If link is false, then primary_swid should be expected to not be valid
> + * This function should never be called in interrupt context.
>   */
>  static void
>  ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
> @@ -1006,7 +1007,7 @@ ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
>         struct ice_aqc_set_port_params *cmd;
>         struct ice_aq_desc desc;
>         u16 buf_len, swid;
> -       int status;
> +       int status, i;
> 
>         buf_len = struct_size(buf, elem, 1);
>         buf = kzalloc(buf_len, GFP_KERNEL);
> @@ -1057,7 +1058,20 @@ ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
>         ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_port_params);
> 
>         cmd->swid = cpu_to_le16(ICE_AQC_PORT_SWID_VALID | swid);
> -       status = ice_aq_send_cmd(&local_lag->pf->hw, &desc, NULL, 0, NULL);
> +       /* If this is happening in reset context, it is possible that the
> +        * primary interface has not finished setting its SWID to SHARED
> +        * yet.  Allow retries to account for this timing issue between
> +        * interfaces.
> +        */
> +       for (i = 0; i < ICE_LAG_RESET_RETRIES; i++) {
> +               status = ice_aq_send_cmd(&local_lag->pf->hw, &desc, NULL, 0,
> +                                        NULL);
> +               if (!status)
> +                       break;
> +
> +               usleep_range(1000, 2000);
> +       }
> +
>         if (status)
>                 dev_err(ice_pf_to_dev(local_lag->pf), "Error setting SWID in port params %d\n",
>                         status);
> @@ -1065,7 +1079,7 @@ ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
> 
>  /**
>   * ice_lag_primary_swid - set/clear the SHARED attrib of primary's SWID
> - * @lag: primary interfaces lag struct
> + * @lag: primary interface's lag struct
>   * @link: is this a linking activity
>   *
>   * Implement setting primary SWID as shared using 0x020B
> @@ -1788,6 +1802,191 @@ static u16 ice_create_lag_recipe(struct ice_hw *hw, const u8 *base_recipe,
>         return rid;
>  }
> 
> +/**
> + * ice_lag_move_vf_nodes_tc_sync - move a VF's nodes for a tc during reset
> + * @lag: primary interfaces lag struct
> + * @dest_hw: HW struct for destination's interface
> + * @vsi_num: VSI index in PF space
> + * @tc: traffic class to move
> + */
> +static void
> +ice_lag_move_vf_nodes_tc_sync(struct ice_lag *lag, struct ice_hw *dest_hw,
> +                             u16 vsi_num, u8 tc)
> +{
> +       u16 num_nodes[ICE_AQC_TOPO_MAX_LEVEL_NUM] = { 0 };
> +       struct ice_sched_node *n_prt, *tc_node, *aggnode;
> +       u16 numq, valq, buf_size, num_moved, qbuf_size;
> +       struct device *dev = ice_pf_to_dev(lag->pf);
> +       struct ice_aqc_cfg_txqs_buf *qbuf;
> +       struct ice_aqc_move_elem *buf;
> +       struct ice_port_info *pi;
> +       __le32 teid, parent_teid;
> +       struct ice_vsi_ctx *ctx;
> +       struct ice_hw *hw;
> +       u8 aggl, vsil;
> +       u32 tmp_teid;
> +       int n;
> +
> +       hw = &lag->pf->hw;
> +       ctx = ice_get_vsi_ctx(hw, vsi_num);
> +       if (!ctx) {
> +               dev_warn(dev, "LAG rebuild failed after reset due to VSI Context failure\n");
> +               return;
> +       }
> +
> +       if (!ctx->sched.vsi_node[tc])
> +               return;
> +
> +       numq = ctx->num_lan_q_entries[tc];
> +       teid = ctx->sched.vsi_node[tc]->info.node_teid;
> +       tmp_teid = le32_to_cpu(teid);
> +       parent_teid = ctx->sched.vsi_node[tc]->info.parent_teid;
> +
> +       if (!tmp_teid || !numq)
> +               return;
> +
> +       if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, true))
> +               dev_dbg(dev, "Problem suspending traffic during reset rebuild\n");
> +
> +       /* reconfig queues for new port */
> +       qbuf_size = struct_size(qbuf, queue_info, numq);
> +       qbuf = kzalloc(qbuf_size, GFP_KERNEL);
> +       if (!qbuf) {
> +               dev_warn(dev, "Failure allocating VF queue recfg buffer for reset rebuild\n");
> +               goto resume_sync;
> +       }
> +
> +       /* add the per queue info for the reconfigure command buffer */
> +       valq = ice_lag_qbuf_recfg(hw, qbuf, vsi_num, numq, tc);
> +       if (!valq) {
> +               dev_warn(dev, "Failure to reconfig queues for LAG reset rebuild\n");
> +               goto sync_none;
> +       }
> +
> +       if (ice_aq_cfg_lan_txq(hw, qbuf, qbuf_size, numq, hw->port_info->lport,
> +                              dest_hw->port_info->lport, NULL)) {
> +               dev_warn(dev, "Failure to configure queues for LAG reset rebuild\n");
> +               goto sync_qerr;
> +       }
> +
> +sync_none:
> +       kfree(qbuf);
> +
> +       /* find parent in destination tree */
> +       pi = dest_hw->port_info;
> +       tc_node = ice_sched_get_tc_node(pi, tc);
> +       if (!tc_node) {
> +               dev_warn(dev, "Failure to find TC node in secondary tree for reset rebuild\n");
> +               goto resume_sync;
> +       }
> +
> +       aggnode = ice_sched_get_agg_node(pi, tc_node, ICE_DFLT_AGG_ID);
> +       if (!aggnode) {
> +               dev_warn(dev, "Failure to find agg node in secondary tree for reset rebuild\n");
> +               goto resume_sync;
> +       }
> +
> +       aggl = ice_sched_get_agg_layer(dest_hw);
> +       vsil = ice_sched_get_vsi_layer(dest_hw);
> +
> +       for (n = aggl + 1; n < vsil; n++)
> +               num_nodes[n] = 1;
> +
> +       for (n = 0; n < aggnode->num_children; n++) {
> +               n_prt = ice_sched_get_free_vsi_parent(dest_hw,
> +                                                     aggnode->children[n],
> +                                                     num_nodes);
> +               if (n_prt)
> +                       break;
> +       }
> +
> +       /* if no free parent found - add one */
> +       if (!n_prt) {
> +               u16 num_nodes_added;
> +               u32 first_teid;
> +               int status;
> +
> +               n_prt = aggnode;
> +               for (n = aggl + 1; n < vsil; n++) {
> +                       status = ice_sched_add_nodes_to_layer(pi, tc_node,
> +                                                             n_prt, n,
> +                                                             num_nodes[n],
> +                                                             &first_teid,
> +                                                             &num_nodes_added);
> +                       if (status || num_nodes[n] != num_nodes_added)
> +                               goto resume_sync;
> +
> +                       if (num_nodes_added)
> +                               n_prt = ice_sched_find_node_by_teid(tc_node,
> +                                                                   first_teid);
> +                       else
> +                               n_prt = n_prt->children[0];
> +
> +                       if (!n_prt) {
> +                               dev_warn(dev, "Failure to add new parent for LAG reset rebuild\n");
> +                               goto resume_sync;
> +                       }
> +               }
> +       }
> +
> +       /* Move node to new parent */
> +       buf_size = struct_size(buf, teid, 1);
> +       buf = kzalloc(buf_size, GFP_KERNEL);
> +       if (!buf) {
> +               dev_warn(dev, "Failure to alloc for VF node move in reset rebuild\n");
> +               goto resume_sync;
> +       }
> +
> +       buf->hdr.src_parent_teid = parent_teid;
> +       buf->hdr.dest_parent_teid = n_prt->info.node_teid;
> +       buf->hdr.num_elems = cpu_to_le16(1);
> +       buf->hdr.mode = ICE_AQC_MOVE_ELEM_MODE_KEEP_OWN;
> +       buf->teid[0] = teid;
> +
> +       if (ice_aq_move_sched_elems(&lag->pf->hw, 1, buf, buf_size, &num_moved,
> +                                   NULL))
> +               dev_warn(dev, "Failure to move VF nodes for LAG reset rebuild\n");
> +       else
> +               ice_sched_update_parent(n_prt, ctx->sched.vsi_node[tc]);
> +
> +       kfree(buf);
> +       goto resume_sync;
> +
> +sync_qerr:
> +       kfree(qbuf);
> +
> +resume_sync:
> +       if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, false))
> +               dev_warn(dev, "Problem restarting traffic for LAG node reset rebuild\n");
> +}

This function looks suspiciously similar to ice_lag_move_vf_node_tc() in
patch #6 :-). Maybe theres room for moving some common code into
separate functions.

> +
> +/**
> + * ice_lag_move_vf_nodes_sync - move vf nodes to active interface
> + * @lag: primary interfaces lag struct
> + * @dest_hw: lport value for currently active port
> + *
> + * This function is used in a reset context, outside of event handling,
> + * to move the VF nodes to the secondary interface when that interface
> + * is the active interface during a reset rebuild
> + */
> +static void
> +ice_lag_move_vf_nodes_sync(struct ice_lag *lag, struct ice_hw *dest_hw)
> +{
> +       struct ice_pf *pf;
> +       int i, tc;
> +
> +       if (!lag->primary || !dest_hw)
> +               return;
> +
> +       pf = lag->pf;
> +       ice_for_each_vsi(pf, i)
> +               if (pf->vsi[i] && (pf->vsi[i]->type == ICE_VSI_VF ||
> +                                  pf->vsi[i]->type == ICE_VSI_SWITCHDEV_CTRL))
> +                       ice_for_each_traffic_class(tc)
> +                               ice_lag_move_vf_nodes_tc_sync(lag, dest_hw, i,
> +                                                             tc);
> +}
> +
>  /**
>   * ice_init_lag - initialize support for LAG
>   * @pf: PF struct
> @@ -1890,3 +2089,85 @@ void ice_deinit_lag(struct ice_pf *pf)
> 
>         pf->lag = NULL;
>  }
> +
> +/**
> + * ice_lag_rebuild - rebuild lag resources after reset
> + * @pf: pointer to local pf struct
> + *
> + * PF resets are promoted to CORER resets when interface in an aggregate.  This
> + * means that we need to rebuild the PF resources for the interface.  Since
> + * this will happen outside the normal event processing, need to acquire the lag
> + * lock.
> + *
> + * This function will also evaluate the VF resources if this is the primary
> + * interface.
> + */
> +void ice_lag_rebuild(struct ice_pf *pf)
> +{
> +       struct ice_lag_netdev_list ndlist;
> +       struct ice_lag *lag, *prim_lag;
> +       struct list_head *tmp, *n;
> +       u8 act_port, loc_port;
> +
> +       if (!pf->lag || !pf->lag->bonded)
> +               return;
> +
> +       mutex_lock(&pf->lag_mutex);
> +
> +       lag = pf->lag;
> +       if (lag->primary) {
> +               prim_lag = lag;
> +       } else {
> +               struct ice_lag_netdev_list *nl;
> +               struct net_device *tmp_nd;
> +
> +               INIT_LIST_HEAD(&ndlist.node);
> +               rcu_read_lock();
> +               for_each_netdev_in_bond_rcu(lag->upper_netdev, tmp_nd) {
> +                       nl = kzalloc(sizeof(*nl), GFP_KERNEL);
> +                       if (!nl)
> +                               break;
> +
> +                       nl->netdev = tmp_nd;
> +                       list_add(&nl->node, &ndlist.node);
> +               }
> +               rcu_read_unlock();
> +               lag->netdev_head = &ndlist.node;
> +               prim_lag = ice_lag_find_primary(lag);
> +       }
> +
> +       if (!prim_lag) {
> +               dev_dbg(ice_pf_to_dev(pf), "No primary interface in aggregate, can't rebuild\n");
> +               goto lag_rebuild_out;
> +       }
> +
> +       act_port = prim_lag->active_port;
> +       loc_port = lag->pf->hw.port_info->lport;
> +
> +       /* configure SWID for this port */
> +       if (lag->primary) {
> +               ice_lag_primary_swid(lag, true);
> +       } else {
> +               ice_lag_set_swid(prim_lag->pf->hw.port_info->sw_id, lag, true);
> +               ice_lag_add_prune_list(prim_lag, pf);
> +               if (act_port == loc_port)
> +                       ice_lag_move_vf_nodes_sync(prim_lag, &pf->hw);
> +       }
> +
> +       ice_lag_cfg_cp_fltr(lag, true);
> +
> +       if (lag->pf_rule_id)
> +               if (ice_lag_cfg_dflt_fltr(lag, true))
> +                       dev_err(ice_pf_to_dev(pf), "Error adding default VSI rule in rebuild\n");
> +
> +       ice_clear_rdma_cap(pf);
> +lag_rebuild_out:
> +       list_for_each_safe(tmp, n, &ndlist.node) {
> +               struct ice_lag_netdev_list *entry;
> +
> +               entry = list_entry(tmp, struct ice_lag_netdev_list, node);
> +               list_del(&entry->node);
> +               kfree(entry);
> +       }
> +       mutex_unlock(&pf->lag_mutex);
> +}
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.h b/drivers/net/ethernet/intel/ice/ice_lag.h
> index df4af5184a75..18075b82485a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.h
> @@ -16,6 +16,8 @@ enum ice_lag_role {
> 
>  #define ICE_LAG_INVALID_PORT 0xFF
> 
> +#define ICE_LAG_RESET_RETRIES          5
> +
>  struct ice_pf;
>  struct ice_vf;
> 
> @@ -59,4 +61,5 @@ struct ice_lag_work {
>  void ice_lag_move_new_vf_nodes(struct ice_vf *vf);
>  int ice_init_lag(struct ice_pf *pf);
>  void ice_deinit_lag(struct ice_pf *pf);
> +void ice_lag_rebuild(struct ice_pf *pf);
>  #endif /* _ICE_LAG_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 7030b2e54d2b..a27381ec37cd 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -636,6 +636,11 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
> 
>         dev_dbg(dev, "reset_type 0x%x requested\n", reset_type);
> 
> +       if (pf->lag && pf->lag->bonded && reset_type == ICE_RESET_PFR) {
> +               dev_dbg(dev, "PFR on a bonded interface, promoting to CORER\n");
> +               reset_type = ICE_RESET_CORER;
> +       }
> +
>         ice_prepare_for_reset(pf, reset_type);
> 
>         /* trigger the reset */
> @@ -719,8 +724,13 @@ static void ice_reset_subtask(struct ice_pf *pf)
>         }
> 
>         /* No pending resets to finish processing. Check for new resets */
> -       if (test_bit(ICE_PFR_REQ, pf->state))
> +       if (test_bit(ICE_PFR_REQ, pf->state)) {
>                 reset_type = ICE_RESET_PFR;
> +               if (pf->lag && pf->lag->bonded) {
> +                       dev_dbg(ice_pf_to_dev(pf), "PFR on a bonded interface, promoting to CORER\n");
> +                       reset_type = ICE_RESET_CORER;
> +               }
> +       }
>         if (test_bit(ICE_CORER_REQ, pf->state))
>                 reset_type = ICE_RESET_CORER;
>         if (test_bit(ICE_GLOBR_REQ, pf->state))
> @@ -7421,6 +7431,8 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
>         clear_bit(ICE_RESET_FAILED, pf->state);
> 
>         ice_plug_aux_dev(pf);
> +       if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
> +               ice_lag_rebuild(pf);
>         return;
> 
>  err_vsi_rebuild:
> --
> 2.40.1
> 
> 

