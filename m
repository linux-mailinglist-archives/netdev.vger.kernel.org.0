Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7937B5E6344
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIVNKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiIVNKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:10:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEDAC88AC
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663852223; x=1695388223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Ft/I2f+sN+v7VTGj4JOvsDKHJ7+0wm2kgjaF6IMJXQ=;
  b=AHHr3m8JT7CQIpIz1m2C1Uulw2u49Ck8R9ThQCC0OBdzFwCz2Npc67JL
   QhMt/4XIZZggnYN6aeX2g3hYuQlxVTWgTiTsMM94wrRtvKBODCaDEYS2n
   DOFjpU/QHpxq4EPFFIxkfF82NYldRDKWjzC/tcrQCl2QziAzWTWoKU3QL
   JjPUt5EuYjNd2Vy8ZgpUU/Y8ZqwwfBun5pd19uP8f5FtJZEBid4vcO/NY
   25YABGX8GCjKqO7aIYPYHGXAyB1OCH8TtOsNN0s+XrO+n9tlOilGY5Ih+
   kakeVnHqCMkZJy6tw7BBZI9KRlraq5d1UU56hq+al4zrrKnRTvkll7ziy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="280659997"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="280659997"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 06:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="570955405"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2022 06:09:44 -0700
Received: from localhost.localdomain (pelor.igk.intel.com [10.123.220.13])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28MD9hvo018372;
        Thu, 22 Sep 2022 14:09:43 +0100
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        dchumak@nvidia.com, maximmi@nvidia.com, jiri@resnulli.us,
        simon.horman@corigine.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [RFC PATCH net-next v4 4/6] ice: Implement devlink-rate API
Date:   Thu, 22 Sep 2022 15:08:59 +0200
Message-Id: <20220922130859.337985-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220915134239.1935604-5-michal.wilczynski@intel.com>
References: <20220915134239.1935604-5-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Michal Wilczynski <michal.wilczynski@intel.com>
Date:   Thu, 15 Sep 2022 15:42:37 +0200

> There is a need to support modification of Tx scheduler topology, in the
> ice driver. This will allow user to control Tx settings of each node in
> the internal hierarchy of nodes. A number of parameters is supported per
> each node: tx_max, tx_share, tx_priority and tx_weight.
> 
> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 511 +++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h |   2 +
>  2 files changed, 513 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index e6ec20079ced..925283605b59 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -713,6 +713,490 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
>  	return ice_devlink_port_split(devlink, port, 1, extack);
>  }
>  
> +/**
> + * ice_traverse_tx_tree - traverse Tx scheduler tree
> + * @devlink: devlink struct
> + * @node: current node, used for recursion
> + * @tc_node: tc_node struct, that is treated as a root
> + * @pf: pf struct
> + *
> + * This function traverses Tx scheduler tree and exports
> + * entire structure to the devlink-rate.
> + */
> +static void ice_traverse_tx_tree(struct devlink *devlink, struct ice_sched_node *node,
> +				 struct ice_sched_node *tc_node, struct ice_pf *pf)
> +{
> +	struct ice_vf *vf;
> +	int i;
> +
> +	devl_lock(devlink);
> +
> +	if (node->parent == tc_node) {
> +		/* create root node */
> +		devl_rate_node_create(devlink, node, node->name, NULL);
> +	} else if (node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF &&
> +		   node->parent->name) {
> +		devl_rate_queue_create(devlink, node->parent->name, node->tx_queue_id, node);
> +	} else if (node->vsi_handle &&
> +		   pf->vsi[node->vsi_handle]->vf) {
> +		vf = pf->vsi[node->vsi_handle]->vf;
> +		snprintf(node->name, DEVLINK_RATE_NAME_MAX_LEN, "vport_%u", vf->devlink_port.index);
> +		if (!vf->devlink_port.devlink_rate)
> +			devl_rate_vport_create(&vf->devlink_port, node, node->parent->name);
> +	} else {
> +		devl_rate_node_create(devlink, node, node->name, node->parent->name);
> +	}
> +
> +	devl_unlock(devlink);

I would move devlink locking into ice_devlink_rate_init_tx_topology(),
so it would be locked only once for the whole tree walking.

> +
> +	for (i = 0; i < node->num_children; i++)
> +		ice_traverse_tx_tree(devlink, node->children[i], tc_node, pf);
> +}
> +
> +/**
> + * ice_devlink_rate_init_tx_topology - export Tx scheduler tree to devlink rate
> + * @devlink: devlink struct
> + * @vsi: main vsi struct
> + *
> + * This function finds a root node, then calls ice_traverse_tx tree, which
> + * traverses the tree and export it's contents to devlink rate.
> + */
> +int ice_devlink_rate_init_tx_topology(struct devlink *devlink, struct ice_vsi *vsi)
> +{
> +	struct ice_port_info *pi = vsi->port_info;
> +	struct ice_sched_node *tc_node;
> +	struct ice_pf *pf = vsi->back;
> +	int i;
> +
> +	tc_node = pi->root->children[0];
> +	mutex_lock(&pi->sched_lock);
> +	for (i = 0; i < tc_node->num_children; i++)
> +		ice_traverse_tx_tree(devlink, tc_node->children[i], tc_node, pf);
> +	mutex_unlock(&pi->sched_lock);
> +
> +	return 0;
> +}

// snip

>  static int
> @@ -893,6 +1399,9 @@ void ice_devlink_register(struct ice_pf *pf)
>   */
>  void ice_devlink_unregister(struct ice_pf *pf)
>  {
> +	devl_lock(priv_to_devlink(pf));
> +	devl_rate_objects_destroy(priv_to_devlink(pf));
> +	devl_unlock(priv_to_devlink(pf));
>  	devlink_unregister(priv_to_devlink(pf));
>  }
>

Maybe it's now worth a variable for priv_to_devlink(pf)?

[...]

--Przemek
