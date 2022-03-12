Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0604D6B9C
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiCLBKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiCLBKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:10:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4E1928D
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 17:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D34C615BB
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 01:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCE2C340EE;
        Sat, 12 Mar 2022 01:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647047389;
        bh=sGO8VYx62TQ+kJR9dzNDwfWWEFutATokByCzNRdF1rc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L2JKaeDRZM0ssKBICgtgxMQ4tpeF3R8uM0hhdmateP01rdlsdunpG3sZOr/ib1xsE
         0nJEk6qWlbQGsG5F7LIRZpMs9xEi1b6sjRC7sGrViRQKUC1Cz691S7RDWeHziBd841
         C8ZeS3x4yRgdWeI0dy2Xe5w9M1uNsp2zlJPHvU7CjLSbdvNPiRRgw4H7520HS2v8vH
         bBXyxVL9DdN7hiTfMe2UWblVeNoYht1xM0sBBdYEtO8S9OrZQ0/EWLvbtCqWvldYNZ
         XOleX1pWAwflO3yfAHDgNR4kmnbYAMNpnPzsHuHd1SZuP/lLkEWPF4aJ1pA9vPkxhP
         YAYtEljJP/wMA==
Date:   Fri, 11 Mar 2022 17:09:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220311170948.613fd09c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
References: <cover.1647009587.git.petrm@nvidia.com>
        <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 15:41:22 +0100 Petr Machata wrote:
> +static const struct file_operations nsim_dev_hwstats_generic_fops = {
> +	.open = simple_open,
> +	.write = nsim_dev_hwstats_do_write,
> +	.llseek = generic_file_llseek,
> +	.owner = THIS_MODULE,
> +};
> +
> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops = {
> +	.fops = nsim_dev_hwstats_generic_fops,
> +	.action = NSIM_DEV_HWSTATS_DO_DISABLE,
> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
> +};
> +
> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_enable_fops = {
> +	.fops = nsim_dev_hwstats_generic_fops,
> +	.action = NSIM_DEV_HWSTATS_DO_ENABLE,
> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
> +};
> +
> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_fail_fops = {
> +	.fops = nsim_dev_hwstats_generic_fops,
> +	.action = NSIM_DEV_HWSTATS_DO_FAIL,
> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
> +};

clang is not on board :(

drivers/net/netdevsim/hwstats.c:404:10: error: initializer element is not a compile-time constant
        .fops = nsim_dev_hwstats_generic_fops,
