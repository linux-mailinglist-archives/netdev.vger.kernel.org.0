Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B91149DEB
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA0AM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgA0AM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 19:12:57 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F942070A;
        Mon, 27 Jan 2020 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580083977;
        bh=pc/bxIFiX81iihIf7T3NYUuS7TQlNysg3BNjzaHanlo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DlD4PeRCec2QrC3Gm7bW/TVUvA5r3OtwaA3j9+/BTF3rip2py7ssEcHsmLwCNTuNs
         2QsudmBKSNGJwFY5RqBJB/7FlKlPFfmrCq9oC8SQC+eRUzJdZEAqNf8Lt6cnqidAkB
         BWVrVe/jTRby3ykjgaBHPsmBqZnOrHzMjvnESaO8=
Date:   Sun, 26 Jan 2020 16:12:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH net-next 01/16] bnxt_en: Support ingress rate limiting
 with TC-offload.
Message-ID: <20200126161256.6cf37aad@cakuba>
In-Reply-To: <1580029390-32760-2-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
        <1580029390-32760-2-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 04:02:55 -0500, Michael Chan wrote:
> From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> 
> This patch enables offloading of ingress rate limiting TC-action
> on a VF. The driver processes "cls_matchall" filter callbacks to
> add and remove ingress rate limiting actions. The driver parses
> police action parameter and sends the command to FW to configure
> rate limiting for the VF.
> 
> For example, to configure rate limiting offload on a VF using OVS,
> use the below command on the corresponding VF-rep port. The example
> below configures min and max tx rates of 200 and 600 Mbps.
> 
> 	# ovs-vsctl set interface bnxt0_pf0vf0 \
> 		ingress_policing_rate=600000 ingress_policing_burst=200000
> 
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Does the device drop or back-pressure when VF goes over the rate?

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index f143354..534bc9e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1069,6 +1069,7 @@ struct bnxt_vf_info {
>  	u32	max_tx_rate;
>  	void	*hwrm_cmd_req_addr;
>  	dma_addr_t	hwrm_cmd_req_dma_addr;
> +	unsigned long police_id;
>  };
>  #endif
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 0cc6ec5..2dfb650 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -10,6 +10,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/inetdevice.h>
>  #include <linux/if_vlan.h>
> +#include <linux/pci.h>
>  #include <net/flow_dissector.h>
>  #include <net/pkt_cls.h>
>  #include <net/tc_act/tc_gact.h>
> @@ -1983,6 +1984,95 @@ static int bnxt_tc_indr_block_event(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> +static inline int bnxt_tc_find_vf_by_fid(struct bnxt *bp, u16 fid)

No static inlines in C files

> +{
> +	int num_vfs = pci_num_vf(bp->pdev);
> +	int i;
> +
> +	for (i = 0; i < num_vfs; i++) {
> +		if (bp->pf.vf[i].fw_fid == fid)

return i;

> +			break;
> +	}

return -EINVAL;

> +	if (i >= num_vfs)
> +		return -EINVAL;
> +	return i;
> +}

> +static int bnxt_tc_add_matchall(struct bnxt *bp, u16 src_fid,
> +				struct tc_cls_matchall_offload *matchall_cmd)
> +{
> +	struct flow_action_entry *action;
> +	int vf_idx;
> +	s64 burst;
> +	u64 rate;
> +	int rc;
> +
> +	vf_idx = bnxt_tc_find_vf_by_fid(bp, src_fid);
> +	if (vf_idx < 0)
> +		return vf_idx;

You need to check this is the only action, check priority, check
shared, etc. Just look as one of the drivers which do this right :/

> +	action = &matchall_cmd->rule->action.entries[0];
> +	if (action->id != FLOW_ACTION_POLICE) {
> +		netdev_err(bp->dev, "%s: Unsupported matchall action: %d",
> +			   __func__, action->id);
> +		return -EOPNOTSUPP;
> +	}
> +	if (bp->pf.vf[vf_idx].police_id && bp->pf.vf[vf_idx].police_id !=
> +	    matchall_cmd->cookie) {
> +		netdev_err(bp->dev,
> +			   "%s: Policer is already configured for VF: %d",
> +			   __func__, vf_idx);
> +		return -EEXIST;
> +	}
> +
> +	rate = (u32)div_u64(action->police.rate_bytes_ps, 1024 * 1000) * 8;
> +	burst = (u32)div_u64(action->police.rate_bytes_ps *
> +			     PSCHED_NS2TICKS(action->police.burst),
> +			     PSCHED_TICKS_PER_SEC);
> +	burst = (u32)PSCHED_TICKS2NS(burst) / (1 << 20);
> +
> +	rc = bnxt_set_vf_bw(bp->dev, vf_idx, burst, rate);
> +	if (rc) {
> +		netdev_err(bp->dev,
> +			   "Error: %s: VF: %d rate: %llu burst: %llu rc: %d",
> +			   __func__, vf_idx, rate, burst, rc);
> +		return rc;
> +	}
> +
> +	bp->pf.vf[vf_idx].police_id = matchall_cmd->cookie;
> +	return 0;
> +}
> +
> +int bnxt_tc_setup_matchall(struct bnxt *bp, u16 src_fid,
> +			   struct tc_cls_matchall_offload *cls_matchall)
> +{
> +	switch (cls_matchall->command) {
> +	case TC_CLSMATCHALL_REPLACE:
> +		return bnxt_tc_add_matchall(bp, src_fid, cls_matchall);
> +	case TC_CLSMATCHALL_DESTROY:
> +		return bnxt_tc_del_matchall(bp, src_fid, cls_matchall);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static const struct rhashtable_params bnxt_tc_flow_ht_params = {
>  	.head_offset = offsetof(struct bnxt_tc_flow_node, node),
>  	.key_offset = offsetof(struct bnxt_tc_flow_node, cookie),
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
> index 10c62b0..963788e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
> @@ -220,6 +220,9 @@ int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
>  int bnxt_init_tc(struct bnxt *bp);
>  void bnxt_shutdown_tc(struct bnxt *bp);
>  void bnxt_tc_flow_stats_work(struct bnxt *bp);
> +int bnxt_tc_setup_matchall(struct bnxt *bp, u16 src_fid,
> +			   struct tc_cls_matchall_offload *cls_matchall);
> +
>  

Spurious new line

>  static inline bool bnxt_tc_flower_enabled(struct bnxt *bp)
>  {
