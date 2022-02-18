Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8074BB0D6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiBRErh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:47:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBREre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:47:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F652A267
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2CD617C5
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00A8C340E9;
        Fri, 18 Feb 2022 04:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645159636;
        bh=9Nst3q3Kc3gcSg0qxca/y0VmPc6oQCD+e1GYs/Wq27g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WdXS0mErCLxnqpJ3EeGluNkk68m4nisnq2PUIGWgCyUEdyuDEzPY81IOd+d0z4/CY
         g9LPEzVDYseWrI0v2nerSAvl+h70V+Meo/Nupl46Bxb2FkBmdmgRzJLI51c76EpEbb
         mLdN+zbWoW8uzXIv0YXwGeXLgg/ZQSOxyd7F+0VJ4IVjNFSfvoWFdLqiFRvmvpRl4t
         EFFcwXW1Helw/DWVIjvMHjfHIdX6/tEy9EVPzahnAC+BBVxqV37hS6OZKCjPBb+vIz
         zXBcymTtddwg+baP5tY3BV2HSqDrav3JNt2GQcns1weIge6pMYIYm5XYrcWN2lVuDI
         T1AotZDUEVMLw==
Date:   Thu, 17 Feb 2022 20:47:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 3/6] nfp: add hash table to store meter table
Message-ID: <20220217204714.33132c8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217105652.14451-4-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
        <20220217105652.14451-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 11:56:49 +0100 Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Add a hash table to store meter table.
> 
> This meter table will also be used by flower action.

> +static struct nfp_meter_entry *
> +nfp_flower_add_meter_entry(struct nfp_app *app, u32 meter_id)
> +{
> +	struct nfp_meter_entry *meter_entry = NULL;
> +	struct nfp_flower_priv *priv = app->priv;
> +
> +	meter_entry = rhashtable_lookup_fast(&priv->meter_table,
> +					     &meter_id,
> +					     stats_meter_table_params);
> +

unnecessary new line

> +	if (meter_entry)
> +		return meter_entry;
> +
> +	meter_entry = kzalloc(sizeof(*meter_entry), GFP_ATOMIC);

why is this ATOMIC?

> +	if (!meter_entry)
> +		goto err;
> +
> +	meter_entry->meter_id = meter_id;
> +	meter_entry->used = jiffies;
> +	if (rhashtable_insert_fast(&priv->meter_table, &meter_entry->ht_node,
> +				   stats_meter_table_params)) {
> +		goto err_free_meter_entry;
> +	}

unnecessary brackets

> +	priv->qos_rate_limiters++;
> +	if (priv->qos_rate_limiters == 1)
> +		schedule_delayed_work(&priv->qos_stats_work,
> +				      NFP_FL_QOS_UPDATE);
> +	return meter_entry;
> +
> +err_free_meter_entry:
> +	kfree(meter_entry);
> +err:

don't jump to return, just return directly instead of a goto

> +	return NULL;
> +}
> +
> +static void nfp_flower_del_meter_entry(struct nfp_app *app, u32 meter_id)
> +{
> +	struct nfp_meter_entry *meter_entry = NULL;
> +	struct nfp_flower_priv *priv = app->priv;
> +
> +	meter_entry = rhashtable_lookup_fast(&priv->meter_table, &meter_id,
> +					     stats_meter_table_params);
> +

unnecessary nl

> +	if (meter_entry) {

flip condition and return early

> +		rhashtable_remove_fast(&priv->meter_table,
> +				       &meter_entry->ht_node,
> +				       stats_meter_table_params);
> +		kfree(meter_entry);
> +		priv->qos_rate_limiters--;
> +		if (!priv->qos_rate_limiters)
> +			cancel_delayed_work_sync(&priv->qos_stats_work);
> +	}
> +}
> +
> +int nfp_flower_setup_meter_entry(struct nfp_app *app,
> +				 const struct flow_action_entry *action,
> +				 enum nfp_meter_op op,
> +				 u32 meter_id)
> +{
> +	struct nfp_flower_priv *fl_priv = app->priv;
> +	struct nfp_meter_entry *meter_entry = NULL;
> +	int err = 0;
> +
> +	mutex_lock(&fl_priv->meter_stats_lock);
> +
> +	switch (op) {
> +	case NFP_METER_DEL:
> +		nfp_flower_del_meter_entry(app, meter_id);
> +		goto ret;

try to avoid naming labels with common variable names, exit_unlock
would be most in line with the style of the driver here.

> +	case NFP_METER_ADD:
> +		meter_entry = nfp_flower_add_meter_entry(app, meter_id);
> +		break;
> +	default:

why default and not use _SET?

> +		meter_entry = nfp_flower_search_meter_entry(app, meter_id);
> +		break;
> +	}
> +
> +	if (!meter_entry) {
> +		err = -ENOMEM;
> +		goto ret;
> +	}
> +
> +	if (!action) {
> +		err = -EINVAL;
> +		goto ret;
> +	}

defensive programming is discouraged in the kernel, please drop the
action check if it can't happen in practice

> +	if (action->police.rate_bytes_ps > 0) {
> +		meter_entry->bps = true;
> +		meter_entry->rate = action->police.rate_bytes_ps;
> +		meter_entry->burst = action->police.burst;
> +	} else {
> +		meter_entry->bps = false;
> +		meter_entry->rate = action->police.rate_pkt_ps;
> +		meter_entry->burst = action->police.burst_pkt;
> +	}
> +ret:
> +	mutex_unlock(&fl_priv->meter_stats_lock);
> +	return err;
> +}
> +
> +int nfp_init_meter_table(struct nfp_app *app)
> +{
> +	struct nfp_flower_priv *priv = app->priv;
> +
> +	return rhashtable_init(&priv->meter_table, &stats_meter_table_params);
> +}

missing nl

>  static int
>  nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
>  			struct netlink_ext_ack *extack)
