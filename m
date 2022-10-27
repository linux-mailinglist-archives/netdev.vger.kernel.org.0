Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414AA61045E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbiJ0V2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbiJ0V2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:28:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A0662A8A
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666906094; x=1698442094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vQYwWSgdT/bhEZe2ZNk4EVTH+kI4Cvw39PND8B4C3nU=;
  b=ORdH/KuphXwNrtXvd0lsNFYLPsNjJVIwPFWDdu6aiEL0p/4GXQAtEjEa
   F6WB6sGeZaos20H22r0oMkWAngZ9rnp34k3oI0AKGgkrHhsN2YLtPxmUN
   TIfFz9FGwKKENCLszWPEqzn3U2xLQH03Hm16m2kZQNzib5sJLTTNsHebF
   Vyj+G88iJU9Il8cVMO1ZWtqfTxdzseSjPUwBrIcRqsxWk/4teJ4VKdNox
   oqMVsNNxuzbEx+Q6kTx05PFaKMDI/JsSBNv38dgMaMbyV0xDywKY7bSKL
   PxZYYYzJ7uv4UZPzdFSzShFy9Lkqst+orR/pLRvSAW7OjeCUszOPwaq+U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="372556027"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="372556027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 14:28:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="663775305"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="663775305"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 27 Oct 2022 14:28:11 -0700
Received: from pkitszel-desk.tendawifi.com (arajji-mobl.ger.corp.intel.com [10.252.28.153])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29RLS9hI004218;
        Thu, 27 Oct 2022 22:28:10 +0100
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v7 3/9] devlink: Enable creation of the devlink-rate nodes from the driver
Date:   Thu, 27 Oct 2022 23:27:48 +0200
Message-Id: <20221027212748.7858-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20221027130049.2418531-4-michal.wilczynski@intel.com>
References: <20221027130049.2418531-4-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Michal Wilczynski <michal.wilczynski@intel.com>
Date:   Thu, 27 Oct 2022 15:00:43 +0200

> Intel 100G card internal firmware hierarchy for Hierarchicial QoS is very
> rigid and can't be easily removed. This requires an ability to export
> default hierarchy to allow user to modify it. Currently the driver is
> only able to create the 'leaf' nodes, which usually represent the vport.
> This is not enough for HQoS implemented in Intel hardware.
> 
> Introduce new function devl_rate_node_create() that allows for creation
> of the devlink-rate nodes from the driver.

I would swap the order of paragraphs above.

[...]

> @@ -1601,6 +1603,8 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
>  				   u32 controller, u16 pf, u32 sf,
>  				   bool external);
>  int devl_rate_leaf_create(struct devlink_port *port, void *priv);
> +int devl_rate_node_create(struct devlink *devlink, void *priv,  char *node_name,
> +			  char *parent_name);

One space to much before `char *node_name`

[...]
 
> +/**
> + * devl_rate_node_create - create devlink rate node
> + * @devlink: devlink instance
> + * @priv: driver private data
> + * @node_name: name of the resulting node
> + * @parent_name: name of the parent node
> + *
> + * Create devlink rate object of type node
> + */
> +int devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name, char *parent_name)
> +{
> +	struct devlink_rate *rate_node;
> +	struct devlink_rate *parent;
> +
> +	rate_node = devlink_rate_node_get_by_name(devlink, node_name);
> +	if (!IS_ERR(rate_node))
> +		return -EEXIST;
> +
> +	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
> +	if (!rate_node)
> +		return -ENOMEM;
> +
> +	if (parent_name) {
> +		parent = devlink_rate_node_get_by_name(devlink, parent_name);
> +		if (IS_ERR(parent))
> +			return -ENODEV;

`rate_node` is leaked on error path

> +		rate_node->parent = parent;
> +		refcount_inc(&rate_node->parent->refcnt);
> +	}
> +
> +	rate_node->type = DEVLINK_RATE_TYPE_NODE;
> +	rate_node->devlink = devlink;
> +	rate_node->priv = priv;
> +
> +	rate_node->name = kzalloc(DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
> +	if (!rate_node->name)
> +		return -ENOMEM;
> +
> +	strscpy(rate_node->name, node_name, DEVLINK_RATE_NAME_MAX_LEN);

Again a memleak on error path.
It looks also that we could use kstrndup() instead of kzalloc+strscpy combo.
Finally, I would centralize memory allocation failures.

> +
> +	refcount_set(&rate_node->refcnt, 1);
> +	list_add(&rate_node->list, &devlink->rate_list);
> +	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devl_rate_node_create);
> +

[...]

--PK
