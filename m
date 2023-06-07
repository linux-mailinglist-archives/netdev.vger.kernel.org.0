Return-Path: <netdev+bounces-8749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0DE72582A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02E192812C1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FE5748B;
	Wed,  7 Jun 2023 08:42:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28CE8BF7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:42:25 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2D919AC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686127338; x=1717663338;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qgQks9WfxD1MnpEmt0AMrKemcZwXG49waTSu2SeHhTo=;
  b=YDAnLOngwhyOpJRmgdjp4QX5xZxnSQajTZMVZLtrw50sFx+p7wcVV+NS
   IQ3xMN7nmFB4hKNAuepDWLCfV4lbgnALcVWZCzdshpyqVDIQYVjvN83+1
   D5jJz1zvpmcjNXGp1ozlps7W29ePh82X6eJQn+7uGixCFSOHzWwLbQ2JG
   pY6LBEvNKaBpjIwLfFMP5bRSHPfwOK2xRbcCqq0PhFdWKYgiCHlwNGMz1
   kQHuTqb3WSZdz5CSVJL8Ur4Z8/vJQB0OmulXaaRwuFrxZPxBcrwsLMYQW
   oq7xierUSJ3pzTuILgjV/Opw6Gd/Yr02zOFRV+HEhx9OMwlJbDRR7g7Ux
   w==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="217210128"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 01:42:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 01:42:16 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 7 Jun 2023 01:42:15 -0700
Date: Wed, 7 Jun 2023 08:42:15 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 06/10] ice: Flesh out implementation of support
 for SRIOV on bonded interface
Message-ID: <20230607084215.km4btmugwew6633t@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-7-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-7-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Mostly tiny nits here. But since you are respinning, you might as well
get that in.

> Add in the function s that will allow a VF created on the primary interface

s/function s/functions/

> of a bond to "fail-over" to another PF interface in the bond and continue
> to Tx and Rx.
> 
> Add in an ordered take-down path for the bonded interface.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lag.c | 851 ++++++++++++++++++++++-
>  1 file changed, 848 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
> index 25365d4c72f3..e46234ad836d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
> @@ -10,6 +10,11 @@
>  #define ICE_LAG_RES_SHARED     BIT(14)
>  #define ICE_LAG_RES_VALID      BIT(15)
> 
> +#define LACP_TRAIN_PKT_LEN             16
> +static const u8 lacp_train_pkt[LACP_TRAIN_PKT_LEN] = { 0, 0, 0, 0, 0, 0,
> +                                                      0, 0, 0, 0, 0, 0,
> +                                                      0x88, 0x09, 0, 0 };
> +
>  #define ICE_RECIPE_LEN                 64
>  static const u8 ice_dflt_vsi_rcp[ICE_RECIPE_LEN] = {
>         0x05, 0, 0, 0, 0x20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
> @@ -57,6 +62,39 @@ static void ice_lag_set_backup(struct ice_lag *lag)
>         lag->role = ICE_LAG_BACKUP;
>  }
> 
 
> +/**
> + * ice_lag_qbuf_recfg - generate a buffer of queues for a reconfigure command
> + * @hw: HW struct that contains the queue contexts
> + * @qbuf: pointer to buffer to populate
> + * @vsi_num: index of the VSI in PF space
> + * @numq: number of queues to search for
> + * @tc: traffic class that contains the queues
> + *
> + * function returns the numnber of valid queues in buffer

s/numnber/number/

> + */
> +static u16
> +ice_lag_qbuf_recfg(struct ice_hw *hw, struct ice_aqc_cfg_txqs_buf *qbuf,
> +                  u16 vsi_num, u16 numq, u8 tc)
> +{
> +       struct ice_q_ctx *q_ctx;
> +       u16 qid, count = 0;
> +       struct ice_pf *pf;
> +       int i;
> +
> +       pf = hw->back;
> +       for (i = 0; i < numq; i++) {
> +               q_ctx = ice_get_lan_q_ctx(hw, vsi_num, tc, i);
> +               if (!q_ctx || q_ctx->q_handle == ICE_INVAL_Q_HANDLE) {
> +                       dev_dbg(ice_hw_to_dev(hw), "%s queue %d %s\n", __func__,
> +                               i, q_ctx ? "INVAL Q HANDLE" : "NO Q CONTEXT");
> +                       continue;
> +               }
> +
> +               qid = pf->vsi[vsi_num]->txq_map[q_ctx->q_handle];
> +               qbuf->queue_info[count].q_handle = cpu_to_le16(qid);
> +               qbuf->queue_info[count].tc = tc;
> +               qbuf->queue_info[count].q_teid = cpu_to_le32(q_ctx->q_teid);
> +               count++;
> +       }
> +
> +       return count;
> +}
> +
>  /**
>   * ice_lag_move_vf_node_tc - move scheduling nodes for one VF on one TC
>   * @lag: lag info struct
> @@ -245,6 +353,167 @@ static void
>  ice_lag_move_vf_node_tc(struct ice_lag *lag, u8 oldport, u8 newport,
>                         u16 vsi_num, u8 tc)
>  {
> +       struct ice_sched_node *n_prt, *tc_node, *aggnode;
> +       u16 num_nodes[ICE_AQC_TOPO_MAX_LEVEL_NUM] = { 0 };

RXT.

> +       u16 numq, valq, buf_size, num_moved, qbuf_size;
> +       struct device *dev = ice_pf_to_dev(lag->pf);
> +       struct ice_aqc_cfg_txqs_buf *qbuf;
> +       struct ice_aqc_move_elem *buf;
> +       struct ice_hw *new_hw = NULL;
> +       struct ice_port_info *pi;
> +       __le32 teid, parent_teid;
> +       struct ice_vsi_ctx *ctx;
> +       u8 aggl, vsil;
> +       u32 tmp_teid;
> +       int n;
> +
> +       ctx = ice_get_vsi_ctx(&lag->pf->hw, vsi_num);
> +       if (!ctx) {
> +               dev_warn(dev, "Unable to locate VSI context for LAG failover\n");
> +               return;
> +       }
> +
> +       /* check to see if this VF is enabled on this TC */
> +       if (!ctx->sched.vsi_node[tc])
> +               return;
> +
> +       /* locate HW struct for destination port */
> +       new_hw = ice_lag_find_hw_by_lport(lag, newport);
> +       if (!new_hw) {
> +               dev_warn(dev, "Unable to locate HW struct for LAG node destination\n");
> +               return;
> +       }
> +
> +       pi = new_hw->port_info;
> +
> +       numq = ctx->num_lan_q_entries[tc];
> +       teid = ctx->sched.vsi_node[tc]->info.node_teid;
> +       tmp_teid = le32_to_cpu(teid);
> +       parent_teid = ctx->sched.vsi_node[tc]->info.parent_teid;
> +       /* if no teid assigned or numq == 0, then this TC is not active */
> +       if (!tmp_teid || !numq)
> +               return;
> +
> +       /* suspend VSI subtree for Traffic Class "tc" on
> +        * this VF's VSI
> +        */
> +       if (ice_sched_suspend_resume_elems(&lag->pf->hw, 1, &tmp_teid, true))
> +               dev_dbg(dev, "Problem suspending traffic for LAG node move\n");
> +
> +       /* reconfigure all VF's queues on this Traffic Class
> +        * to new port
> +        */
> +       qbuf_size = struct_size(qbuf, queue_info, numq);
> +       qbuf = kzalloc(qbuf_size, GFP_KERNEL);
> +       if (!qbuf) {
> +               dev_warn(dev, "Failure allocating memory for VF queue recfg buffer\n");
> +               goto resume_traffic;
> +       }
> +
> +       /* add the per queue info for the reconfigure command buffer */
> +       valq = ice_lag_qbuf_recfg(&lag->pf->hw, qbuf, vsi_num, numq, tc);
> +       if (!valq) {
> +               dev_dbg(dev, "No valid queues found for LAG failover\n");
> +               goto qbuf_none;
> +       }
> +
> +       if (ice_aq_cfg_lan_txq(&lag->pf->hw, qbuf, qbuf_size, valq, oldport,
> +                              newport, NULL)) {
> +               dev_warn(dev, "Failure to configure queues for LAG failover\n");
> +               goto qbuf_err;
> +       }
> +
> +qbuf_none:
> +       kfree(qbuf);
> +
> +       /* find new parent in destination port's tree for VF VSI node on this
> +        * Traffic Class
> +        */
> +       tc_node = ice_sched_get_tc_node(pi, tc);
> +       if (!tc_node) {
> +               dev_warn(dev, "Failure to find TC node in failover tree\n");
> +               goto resume_traffic;
> +       }
> +
> +       aggnode = ice_sched_get_agg_node(pi, tc_node,
> +                                        ICE_DFLT_AGG_ID);
> +       if (!aggnode) {
> +               dev_warn(dev, "Failure to find aggreagte node in failover tree\n");
> +               goto resume_traffic;
> +       }
> +
> +       aggl = ice_sched_get_agg_layer(new_hw);
> +       vsil = ice_sched_get_vsi_layer(new_hw);
> +
> +       for (n = aggl + 1; n < vsil; n++)
> +               num_nodes[n] = 1;
> +
> +       for (n = 0; n < aggnode->num_children; n++) {
> +               n_prt = ice_sched_get_free_vsi_parent(new_hw,
> +                                                     aggnode->children[n],
> +                                                     num_nodes);
> +               if (n_prt)
> +                       break;
> +       }
> +
> +       /* add parent if none were free */
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
> +                               goto resume_traffic;
> +
> +                       if (num_nodes_added)
> +                               n_prt = ice_sched_find_node_by_teid(tc_node,
> +                                                                   first_teid);
> +                       else
> +                               n_prt = n_prt->children[0];
> +                       if (!n_prt) {
> +                               dev_warn(dev, "Failure to add new parent for LAG node\n");
> +                               goto resume_traffic;
> +                       }
> +               }
> +       }
> +
> +       /* Move Vf's VSI node for this TC to newport's scheduler tree */
> +       buf_size = struct_size(buf, teid, 1);
> +       buf = kzalloc(buf_size, GFP_KERNEL);
> +       if (!buf) {
> +               dev_warn(dev, "Failure to alloc memory for VF node failover\n");
> +               goto resume_traffic;
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
> +               dev_warn(dev, "Failure to move VF nodes for failover\n");
> +       else
> +               ice_sched_update_parent(n_prt, ctx->sched.vsi_node[tc]);
> +
> +       kfree(buf);
> +       goto resume_traffic;
> +
> +qbuf_err:
> +       kfree(qbuf);
> +
> +resume_traffic:
> +       /* restart traffic for VSI node */
> +       if (ice_sched_suspend_resume_elems(&lag->pf->hw, 1, &tmp_teid, false))
> +               dev_dbg(dev, "Problem restarting traffic for LAG node move\n");
>  }

This was a really long function :-)
 
>  /**
> @@ -362,6 +735,155 @@ static void
>  ice_lag_reclaim_vf_tc(struct ice_lag *lag, struct ice_hw *src_hw, u16 vsi_num,
>                       u8 tc)
>  {
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
> +               dev_warn(dev, "Unable to locate VSI context for LAG reclaim\n");
> +               return;
> +       }
> +
> +       /* check to see if this VF is enabled on this TC */
> +       if (!ctx->sched.vsi_node[tc])
> +               return;
> +
> +       numq = ctx->num_lan_q_entries[tc];
> +       teid = ctx->sched.vsi_node[tc]->info.node_teid;
> +       tmp_teid = le32_to_cpu(teid);
> +       parent_teid = ctx->sched.vsi_node[tc]->info.parent_teid;
> +
> +       /* if !teid or !numq, then this TC is not active */
> +       if (!tmp_teid || !numq)
> +               return;
> +
> +       /* suspend traffic */
> +       if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, true))
> +               dev_dbg(dev, "Problem suspending traffic for LAG node move\n");
> +
> +       /* reconfig queues for new port */
> +       qbuf_size = struct_size(qbuf, queue_info, numq);
> +       qbuf = kzalloc(qbuf_size, GFP_KERNEL);
> +       if (!qbuf) {
> +               dev_warn(dev, "Failure allocating memory for VF queue recfg buffer\n");
> +               goto resume_reclaim;
> +       }
> +
> +       /* add the per queue info for the reconfigure command buffer */
> +       valq = ice_lag_qbuf_recfg(hw, qbuf, vsi_num, numq, tc);
> +       if (!valq) {
> +               dev_dbg(dev, "No valid queues found for LAG reclaim\n");
> +               goto reclaim_none;
> +       }
> +
> +       if (ice_aq_cfg_lan_txq(hw, qbuf, qbuf_size, numq,
> +                              src_hw->port_info->lport, hw->port_info->lport,
> +                              NULL)) {
> +               dev_warn(dev, "Failure to configure queues for LAG failover\n");
> +               goto reclaim_qerr;
> +       }
> +
> +reclaim_none:
> +       kfree(qbuf);
> +
> +       /* find parent in primary tree */
> +       pi = hw->port_info;
> +       tc_node = ice_sched_get_tc_node(pi, tc);
> +       if (!tc_node) {
> +               dev_warn(dev, "Failure to find TC node in failover tree\n");
> +               goto resume_reclaim;
> +       }
> +
> +       aggnode = ice_sched_get_agg_node(pi, tc_node, ICE_DFLT_AGG_ID);
> +       if (!aggnode) {
> +               dev_warn(dev, "Failure to find aggreagte node in failover tree\n");

s/aggreagte/aggregate/

> +               goto resume_reclaim;
> +       }
> +
> +       aggl = ice_sched_get_agg_layer(hw);
> +       vsil = ice_sched_get_vsi_layer(hw);
> +
> +       for (n = aggl + 1; n < vsil; n++)
> +               num_nodes[n] = 1;
> +
> +       for (n = 0; n < aggnode->num_children; n++) {
> +               n_prt = ice_sched_get_free_vsi_parent(hw, aggnode->children[n],
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
> +                               goto resume_reclaim;
> +
> +                       if (num_nodes_added)
> +                               n_prt = ice_sched_find_node_by_teid(tc_node,
> +                                                                   first_teid);
> +                       else
> +                               n_prt = n_prt->children[0];
> +
> +                       if (!n_prt) {
> +                               dev_warn(dev, "Failure to add new parent for LAG node\n");
> +                               goto resume_reclaim;
> +                       }
> +               }
> +       }
> +
> +       /* Move node to new parent */
> +       buf_size = struct_size(buf, teid, 1);
> +       buf = kzalloc(buf_size, GFP_KERNEL);
> +       if (!buf) {
> +               dev_warn(dev, "Failure to alloc memory for VF node failover\n");
> +               goto resume_reclaim;
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
> +               dev_warn(dev, "Failure to move VF nodes for LAG reclaim\n");
> +       else
> +               ice_sched_update_parent(n_prt, ctx->sched.vsi_node[tc]);
> +
> +       kfree(buf);
> +       goto resume_reclaim;
> +
> +reclaim_qerr:
> +       kfree(qbuf);
> +
> +resume_reclaim:
> +       /* restart traffic */
> +       if (ice_sched_suspend_resume_elems(hw, 1, &tmp_teid, false))
> +               dev_warn(dev, "Problem restarting traffic for LAG node reclaim\n");
>  }
> 
>  /**
> @@ -479,6 +1001,65 @@ static void
>  ice_lag_set_swid(u16 primary_swid, struct ice_lag *local_lag,
>                  bool link)
>  {
> +       struct ice_aqc_alloc_free_res_elem *buf;
> +       struct ice_aqc_set_port_params *cmd;
> +       struct ice_aq_desc desc;
> +       u16 buf_len, swid;
> +       int status;
> +
> +       buf_len = struct_size(buf, elem, 1);
> +       buf = kzalloc(buf_len, GFP_KERNEL);
> +       if (!buf) {
> +               dev_err(ice_pf_to_dev(local_lag->pf), "-ENONMEM error setting SWID\n");

s/ENONMEM/ENOMEM/

> +               return;
> +       }
> +
> +       buf->num_elems = cpu_to_le16(1);
> +       buf->res_type = cpu_to_le16(ICE_AQC_RES_TYPE_SWID);
> +       /* if unlinnking need to free the shared resource */
> +       if (!link && local_lag->bond_swid) {
> +               buf->elem[0].e.sw_resp = cpu_to_le16(local_lag->bond_swid);
> +               status = ice_aq_alloc_free_res(&local_lag->pf->hw, 1, buf,
> +                                              buf_len, ice_aqc_opc_free_res,
> +                                              NULL);
> +               if (status)
> +                       dev_err(ice_pf_to_dev(local_lag->pf), "Error freeing SWID duing LAG unlink\n");

s/duing/during/

> +               local_lag->bond_swid = 0;
> +       }
> +
> +       if (link) {
> +               buf->res_type |=  cpu_to_le16(ICE_LAG_RES_SHARED |
> +                                             ICE_LAG_RES_VALID);
> +               /* store the primary's SWID in case it leaves bond first */
> +               local_lag->bond_swid = primary_swid;
> +               buf->elem[0].e.sw_resp = cpu_to_le16(local_lag->bond_swid);
> +       } else {
> +               buf->elem[0].e.sw_resp =
> +                       cpu_to_le16(local_lag->pf->hw.port_info->sw_id);
> +       }
> +
> +       status = ice_aq_alloc_free_res(&local_lag->pf->hw, 1, buf, buf_len,
> +                                      ice_aqc_opc_alloc_res, NULL);
> +       if (status)
> +               dev_err(ice_pf_to_dev(local_lag->pf), "Error subscribing to SWID 0x%04X\n",
> +                       local_lag->bond_swid);
> +
> +       kfree(buf);
> +
> +       /* Configure port param SWID to correct value */
> +       if (link)
> +               swid = primary_swid;
> +       else
> +               swid = local_lag->pf->hw.port_info->sw_id;
> +
> +       cmd = &desc.params.set_port_params;
> +       ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_port_params);
> +
> +       cmd->swid = cpu_to_le16(ICE_AQC_PORT_SWID_VALID | swid);
> +       status = ice_aq_send_cmd(&local_lag->pf->hw, &desc, NULL, 0, NULL);
> +       if (status)
> +               dev_err(ice_pf_to_dev(local_lag->pf), "Error setting SWID in port params %d\n",
> +                       status);
>  }
> 
>  /**
> @@ -507,6 +1088,38 @@ static void ice_lag_primary_swid(struct ice_lag *lag, bool link)
>   */
>  static void ice_lag_add_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
>  {
> +       u16 num_vsi, rule_buf_sz, vsi_list_id, event_vsi_num, prim_vsi_idx;
> +       struct ice_sw_rule_vsi_list *s_rule = NULL;
> +       struct device *dev;
> +
> +       num_vsi = 1;
> +
> +       dev = ice_pf_to_dev(lag->pf);
> +       event_vsi_num = event_pf->vsi[0]->vsi_num;
> +       prim_vsi_idx = lag->pf->vsi[0]->idx;
> +
> +       if (!ice_find_vsi_list_entry(&lag->pf->hw, ICE_SW_LKUP_VLAN,
> +                                    prim_vsi_idx, &vsi_list_id)) {
> +               dev_warn(dev, "Could not locate prune list when setting up SRIOV LAG\n");
> +               return;
> +       }
> +
> +       rule_buf_sz = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, num_vsi);
> +       s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
> +       if (!s_rule) {
> +               dev_warn(dev, "Error allocating space for prune list when configuring SRIOV LAG\n");
> +               return;
> +       }
> +
> +       s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_PRUNE_LIST_SET);
> +       s_rule->index = cpu_to_le16(vsi_list_id);
> +       s_rule->number_vsi = cpu_to_le16(num_vsi);
> +       s_rule->vsi[0] = cpu_to_le16(event_vsi_num);
> +
> +       if (ice_aq_sw_rules(&event_pf->hw, s_rule, rule_buf_sz, 1,
> +                           ice_aqc_opc_update_sw_rules, NULL))
> +               dev_warn(dev, "Error adding VSI prune list\n");
> +       kfree(s_rule);
>  }
> 
>  /**
> @@ -516,6 +1129,39 @@ static void ice_lag_add_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
>   */
>  static void ice_lag_del_prune_list(struct ice_lag *lag, struct ice_pf *event_pf)
>  {
> +       u16 num_vsi, vsi_num, vsi_idx, rule_buf_sz, vsi_list_id;
> +       struct ice_sw_rule_vsi_list *s_rule = NULL;
> +       struct device *dev;
> +
> +       num_vsi = 1;
> +
> +       dev = ice_pf_to_dev(lag->pf);
> +       vsi_num = event_pf->vsi[0]->vsi_num;
> +       vsi_idx = lag->pf->vsi[0]->idx;
> +
> +       if (!ice_find_vsi_list_entry(&lag->pf->hw, ICE_SW_LKUP_VLAN,
> +                                    vsi_idx, &vsi_list_id)) {
> +               dev_warn(dev, "Could not locate prune list when unwinding SRIOV LAG\n");
> +               return;
> +       }
> +
> +       rule_buf_sz = (u16)ICE_SW_RULE_VSI_LIST_SIZE(s_rule, num_vsi);
> +       s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
> +       if (!s_rule) {
> +               dev_warn(dev, "Error allocating prune list when unwinding SRIOV LAG\n");
> +               return;
> +       }
> +
> +       s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_PRUNE_LIST_CLEAR);
> +       s_rule->index = cpu_to_le16(vsi_list_id);
> +       s_rule->number_vsi = cpu_to_le16(num_vsi);
> +       s_rule->vsi[0] = cpu_to_le16(vsi_num);
> +
> +       if (ice_aq_sw_rules(&event_pf->hw, (struct ice_aqc_sw_rules *)s_rule,
> +                           rule_buf_sz, 1, ice_aqc_opc_update_sw_rules, NULL))
> +               dev_warn(dev, "Error clearing VSI prune list\n");
> +
> +       kfree(s_rule);
>  }
> 
>  /**
> @@ -542,8 +1188,6 @@ static void ice_lag_check_nvm_support(struct ice_pf *pf)
>   * ice_lag_changeupper_event - handle LAG changeupper event
>   * @lag: LAG info struct
>   * @ptr: opaque pointer data
> - *
> - * ptr is to be cast into netdev_notifier_changeupper_info
>   */
>  static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
>  {
> @@ -603,6 +1247,40 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
>   */
>  static void ice_lag_monitor_link(struct ice_lag *lag, void *ptr)
>  {
> +       struct netdev_notifier_changeupper_info *info;
> +       struct ice_hw *prim_hw, *active_hw;
> +       struct net_device *event_netdev;
> +       struct ice_pf *pf;
> +       u8 prim_port;
> +
> +       if (!lag->primary)
> +               return;
> +
> +       event_netdev = netdev_notifier_info_to_dev(ptr);
> +       if (!netif_is_same_ice(lag->pf, event_netdev))
> +               return;
> +
> +       pf = lag->pf;
> +       prim_hw = &pf->hw;
> +       prim_port = prim_hw->port_info->lport;
> +
> +       info = (struct netdev_notifier_changeupper_info *)ptr;
> +       if (info->upper_dev != lag->upper_netdev)
> +               return;
> +
> +       if (!info->linking) {
> +               /* Since there are only two interfaces allowed in SRIOV+LAG, if
> +                * one port is leaving, then nodes need to be on primary
> +                * interface.
> +                */
> +               if (prim_port != lag->active_port &&
> +                   lag->active_port != ICE_LAG_INVALID_PORT) {
> +                       active_hw = ice_lag_find_hw_by_lport(lag,
> +                                                            lag->active_port);
> +                       ice_lag_reclaim_vf_nodes(lag, active_hw);
> +                       lag->active_port = ICE_LAG_INVALID_PORT;
> +               }
> +       }
>  }
> 
>  /**
> @@ -615,6 +1293,67 @@ static void ice_lag_monitor_link(struct ice_lag *lag, void *ptr)
>   */
>  static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
>  {
> +       struct net_device *event_netdev, *event_upper;
> +       struct netdev_notifier_bonding_info *info;
> +       struct netdev_bonding_info *bonding_info;
> +       struct ice_netdev_priv *event_np;
> +       struct ice_pf *pf, *event_pf;
> +       u8 prim_port, event_port;
> +
> +       if (!lag->primary)
> +               return;
> +
> +       pf = lag->pf;
> +       if (!pf)
> +               return;
> +
> +       event_netdev = netdev_notifier_info_to_dev(ptr);
> +       rcu_read_lock();
> +       event_upper = netdev_master_upper_dev_get_rcu(event_netdev);
> +       rcu_read_unlock();
> +       if (!netif_is_ice(event_netdev) || event_upper != lag->upper_netdev)
> +               return;
> +
> +       event_np = netdev_priv(event_netdev);
> +       event_pf = event_np->vsi->back;
> +       event_port = event_pf->hw.port_info->lport;
> +       prim_port = pf->hw.port_info->lport;
> +
> +       info = (struct netdev_notifier_bonding_info *)ptr;
> +       bonding_info = &info->bonding_info;
> +
> +       if (!bonding_info->slave.state) {
> +               /* if no port is currently active, then nodes and filters exist
> +                * on primary port, check if we need to move them
> +                */
> +               if (lag->active_port == ICE_LAG_INVALID_PORT) {
> +                       if (event_port != prim_port)
> +                               ice_lag_move_vf_nodes(lag, prim_port,
> +                                                     event_port);
> +                       lag->active_port = event_port;
> +                       return;
> +               }
> +
> +               /* active port is already set and is current event port */
> +               if (lag->active_port == event_port)
> +                       return;
> +               /* new active port */
> +               ice_lag_move_vf_nodes(lag, lag->active_port, event_port);
> +               lag->active_port = event_port;
> +       } else {
> +               /* port not set as currently active (e.g. new active port
> +                * has already claimed the nodes and filters
> +                */
> +               if (lag->active_port != event_port)
> +                       return;
> +               /* This is the case when neither port is active (both link down)
> +                * Link down on the bond - set active port to invalid and move
> +                * nodes and filters back to primary if not already there
> +                */
> +               if (event_port != prim_port)
> +                       ice_lag_move_vf_nodes(lag, event_port, prim_port);
> +               lag->active_port = ICE_LAG_INVALID_PORT;
> +       }
>  }
> 
>  /**
> @@ -625,6 +1364,73 @@ static void ice_lag_monitor_active(struct ice_lag *lag, void *ptr)
>  static bool
>  ice_lag_chk_comp(struct ice_lag *lag, void *ptr)
>  {
> +       struct net_device *event_netdev, *event_upper;
> +       struct netdev_notifier_bonding_info *info;
> +       struct netdev_bonding_info *bonding_info;
> +       struct list_head *tmp;
> +       int count = 0;
> +
> +       if (!lag->primary)
> +               return true;
> +
> +       event_netdev = netdev_notifier_info_to_dev(ptr);
> +       rcu_read_lock();
> +       event_upper = netdev_master_upper_dev_get_rcu(event_netdev);
> +       rcu_read_unlock();
> +       if (event_upper != lag->upper_netdev)
> +               return true;
> +
> +       info = (struct netdev_notifier_bonding_info *)ptr;
> +       bonding_info = &info->bonding_info;
> +       lag->bond_mode = bonding_info->master.bond_mode;
> +       if (lag->bond_mode != BOND_MODE_ACTIVEBACKUP) {
> +               netdev_info(lag->netdev, "Bond Mode not ACTIVE-BACKUP\n");
> +               return false;
> +       }
> +
> +       list_for_each(tmp, lag->netdev_head) {
> +#if !defined(NO_DCB_SUPPORT) || defined(ADQ_SUPPORT)
> +               struct ice_dcbx_cfg *dcb_cfg, *peer_dcb_cfg;
> +#endif /* !NO_DCB_SUPPORT || ADQ_SUPPORT */
> +               struct ice_lag_netdev_list *entry;
> +               struct ice_netdev_priv *peer_np;
> +               struct net_device *peer_netdev;
> +               struct ice_vsi *vsi, *peer_vsi;
> +
> +               entry = list_entry(tmp, struct ice_lag_netdev_list, node);
> +               peer_netdev = entry->netdev;
> +               if (!netif_is_ice(peer_netdev)) {
> +                       netdev_info(lag->netdev, "Found non-ice netdev in LAG\n");
> +                       return false;
> +               }
> +
> +               count++;
> +               if (count > 2) {
> +                       netdev_info(lag->netdev, "Found more than two netdevs in LAG\n");
> +                       return false;
> +               }
> +
> +               peer_np = netdev_priv(peer_netdev);
> +               vsi = ice_get_main_vsi(lag->pf);
> +               peer_vsi = peer_np->vsi;
> +               if (lag->pf->pdev->bus != peer_vsi->back->pdev->bus ||
> +                   lag->pf->pdev->slot != peer_vsi->back->pdev->slot) {
> +                       netdev_info(lag->netdev, "Found netdev on different device in LAG\n");
> +                       return false;
> +               }
> +
> +#if !defined(NO_DCB_SUPPORT) || defined(ADQ_SUPPORT)
> +               dcb_cfg = &vsi->port_info->qos_cfg.local_dcbx_cfg;
> +               peer_dcb_cfg = &peer_vsi->port_info->qos_cfg.local_dcbx_cfg;
> +               if (memcmp(dcb_cfg, peer_dcb_cfg,
> +                          sizeof(struct ice_dcbx_cfg))) {
> +                       netdev_info(lag->netdev, "Found netdev with different DCB config in LAG\n");
> +                       return false;
> +               }
> +
> +#endif /* !NO_DCB_SUPPORT || ADQ_SUPPORT */
> +       }
> +
>         return true;
>  }
> 
> @@ -843,8 +1649,31 @@ static void ice_unregister_lag_handler(struct ice_lag *lag)
>  static u16 ice_create_lag_recipe(struct ice_hw *hw, const u8 *base_recipe,
>                                  u8 prio)
>  {
> +       struct ice_aqc_recipe_data_elem *new_rcp;
>         u16 rid = 0;
> +       int err;
> +
> +       err = ice_alloc_recipe(hw, &rid);
> +       if (err)
> +               return 0;
> +
> +       new_rcp = kzalloc(ICE_RECIPE_LEN * ICE_MAX_NUM_RECIPES, GFP_KERNEL);
> +       if (!new_rcp)
> +               return 0;
> +
> +       memcpy(new_rcp, base_recipe, ICE_RECIPE_LEN);
> +       new_rcp->content.act_ctrl_fwd_priority = prio;
> +       new_rcp->content.rid = rid | ICE_AQ_RECIPE_ID_IS_ROOT;
> +       new_rcp->recipe_indx = rid;
> +       bitmap_zero((unsigned long *)new_rcp->recipe_bitmap,
> +                   ICE_MAX_NUM_RECIPES);
> +       set_bit(rid, (unsigned long *)new_rcp->recipe_bitmap);
> +
> +       err = ice_aq_add_recipe(hw, new_rcp, 1, NULL);
> +       if (err)
> +               rid = 0;
> 
> +       kfree(new_rcp);
>         return rid;
>  }

You return 0 on error here. In patch #5, rid is checked against zero and
-EINVAL is returned. Maybe you could make rid a function argument and
just return the actual error codes here. That way the error is passed down
the callstack. Just a suggestion - your call.
 

