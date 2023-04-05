Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7813A6D83ED
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDEQmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDEQmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3535A8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA9063D9B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC19C433D2;
        Wed,  5 Apr 2023 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680712931;
        bh=2Ng5ypAwsBqnyckBlMRcSwfbs4jJasWlFGakjOvWjVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C9e0eFN+OrrVqy8p6h6dzcHoRlk9nD21ASh5oG2kpbkuJBvGFva4gYwaddcpHukaA
         QHIF7qBzvfEv9NjZYPsBerMrBUBMJP2qdA6GXurZY35QvGhO9CaAADqihiw+XFvfeh
         6CY7kEYbi1omfygu99aKO6GmBEoeQ/sd8ZUPlaukT0FLd7aoDw1Q435K92BrPYPOzd
         fBET1r/r17ynYkhd5MAnQkmPITViLft/XyMdLsejyPcfWN/zt/PQTKizta3ato6P/H
         DsGXf8P9dGE+UWBvorKQZuR4GJ1RuG0Y0Vkdm3D9ADfZBpgRzxncnCJlX/FtEydtIk
         Yu3faa+VTS7uA==
Date:   Wed, 5 Apr 2023 09:42:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan
 code path
Message-ID: <20230405094210.32c013a7@kernel.org>
In-Reply-To: <20230405063323.36270-1-glipus@gmail.com>
References: <20230405063323.36270-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Apr 2023 00:33:23 -0600 Maxim Georgiev wrote:
> +static int vlan_dev_hwtstamp(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct kernel_hwtstamp_config kernel_config = {};
> +	struct hwtstamp_config config;
> +	int err;
> +
> +	if (!netif_device_present(dev))
> +		return -ENODEV;
> +
> +	if ((cmd == SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set) ||
> +	    (cmd == SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get)) {
> +		if (ops->ndo_eth_ioctl) {
> +			return ops->ndo_eth_ioctl(real_dev, &ifr, cmd);
> +		else
> +			return -EOPNOTSUPP;
> +	}
> +
> +	kernel_config.ifr = ifr;
> +	if (cmd == SIOCSHWTSTAMP) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			return -EFAULT;
> +
> +		hwtstamp_config_to_kernel(&kernel_config, &config);
> +		err = ops->ndo_hwtstamp_set(dev, &kernel_config, NULL);
> +	} else if (cmd == SIOCGHWTSTAMP) {
> +		err = ops->ndo_hwtstamp_get(dev, &kernel_config, NULL);
> +	}
> +
> +	if (err)
> +		return err;
> +
> +	hwtstamp_kernel_to_config(&config, &kernel_config);
> +	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
> +		return -EFAULT;
> +	return 0;
> +}

This needs to live in the core. I think the real_dev is a lower of the
vlan device? All the vlan driver should do is attach the generic helper:

	.ndo_hwtstamp_get = generic_hwtstamp_get_lower,

and the same for set. No?
