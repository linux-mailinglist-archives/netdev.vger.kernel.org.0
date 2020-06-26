Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D408A20AA78
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 04:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgFZCjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 22:39:08 -0400
Received: from smtprelay0172.hostedemail.com ([216.40.44.172]:45164 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728099AbgFZCjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 22:39:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id E083318029210;
        Fri, 26 Jun 2020 02:39:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1963:2393:2559:2562:2828:2898:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3872:4250:4321:4605:5007:6119:6742:7576:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12679:12740:12760:12895:13161:13229:13439:13972:14181:14659:14721:21080:21433:21627:21740:21987:21990:30054:30055:30064:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: duck56_1f0ce8a26e51
X-Filterd-Recvd-Size: 4537
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 02:39:04 +0000 (UTC)
Message-ID: <fbe69fcb9714123f36b6ed6d03873b0e47f23500.camel@perches.com>
Subject: Re: [net-next v3 05/15] iecm: Add basic netdevice functionality
From:   Joe Perches <joe@perches.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Thu, 25 Jun 2020 19:39:03 -0700
In-Reply-To: <20200626020737.775377-6-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-6-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
> 
> This implements probe, interface up/down, and netdev_ops.

trivial notes:

> diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
[]
> @@ -194,7 +298,24 @@ static int iecm_vport_rel(struct iecm_vport *vport)
>   */
>  static void iecm_vport_rel_all(struct iecm_adapter *adapter)
>  {
> -	/* stub */
> +	int err, i;
> +
> +	if (!adapter->vports)
> +		return;
> +
> +	for (i = 0; i < adapter->num_alloc_vport; i++) {
> +		if (!adapter->vports[i])
> +			continue;
> +
> +		err = iecm_vport_rel(adapter->vports[i]);
> +		if (err)
> +			dev_dbg(&adapter->pdev->dev,
> +				"Failed to release adapter->vport[%d], err %d,\n",

odd comma

> +				i, err);
> +		else
> +			adapter->vports[i] = NULL;
> +	}
> +	adapter->num_alloc_vport = 0;

If one of these fails to release, why always set num_alloc_vport to 0?

> @@ -273,7 +483,40 @@ static void iecm_init_task(struct work_struct *work)
>   */
>  static int iecm_api_init(struct iecm_adapter *adapter)
>  {
> -	/* stub */
> +	struct iecm_reg_ops *reg_ops = &adapter->dev_ops.reg_ops;
> +	struct pci_dev *pdev = adapter->pdev;
> +
> +	if (!adapter->dev_ops.reg_ops_init) {
> +		dev_err(&pdev->dev, "Invalid device, register API init not defined.\n");

inconsistent uses of periods after logging messages.

> +		return -EINVAL;
> +	}
> +	adapter->dev_ops.reg_ops_init(adapter);
> +	if (!(reg_ops->ctlq_reg_init && reg_ops->vportq_reg_init &&
> +	      reg_ops->intr_reg_init && reg_ops->mb_intr_reg_init &&
> +	      reg_ops->reset_reg_init && reg_ops->trigger_reset)) {
> +		dev_err(&pdev->dev, "Invalid device, missing one or more register functions\n");

Most are without period.

> +		return -EINVAL;
> +	}
> +
> +	if (adapter->dev_ops.vc_ops_init) {
> +		struct iecm_virtchnl_ops *vc_ops;
> +
> +		adapter->dev_ops.vc_ops_init(adapter);
> +		vc_ops = &adapter->dev_ops.vc_ops;
> +		if (!(vc_ops->core_init && vc_ops->vport_init &&
> +		      vc_ops->vport_queue_ids_init && vc_ops->get_caps &&
> +		      vc_ops->config_queues && vc_ops->enable_queues &&
> +		      vc_ops->disable_queues && vc_ops->irq_map_unmap &&
> +		      vc_ops->get_set_rss_lut && vc_ops->get_set_rss_hash &&
> +		      vc_ops->adjust_qs && vc_ops->get_ptype)) {

style trivia:

Sometimes it's clearer for human readers if all
the tests are separated on individual lines.

> diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
[]
> @@ -594,6 +642,25 @@ static bool iecm_is_capability_ena(struct iecm_adapter *adapter, u64 flag)
>   */
>  void iecm_vc_ops_init(struct iecm_adapter *adapter)
>  {
> -	/* stub */

Maybe add a temporary for adapter->dev_ops.vc_ops
to reduce visual clutter?

> +	adapter->dev_ops.vc_ops.core_init = iecm_vc_core_init;
> +	adapter->dev_ops.vc_ops.vport_init = iecm_vport_init;
> +	adapter->dev_ops.vc_ops.vport_queue_ids_init =
> +		iecm_vport_queue_ids_init;
> +	adapter->dev_ops.vc_ops.get_caps = iecm_send_get_caps_msg;
> +	adapter->dev_ops.vc_ops.is_cap_ena = iecm_is_capability_ena;

