Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C90620836
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiKHEYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiKHEYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:24:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153BB24F14
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 20:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B612FB818BE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD87C433C1;
        Tue,  8 Nov 2022 04:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667881455;
        bh=9SlR9nOdg2+TWF3Dk7MWaLTFEIiUjIItmVc3nw/hAEY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jyHmnlh2ZaoX7u63pdiJDmaYsjOH5r3hH0xPQZPtQmKOb7ZgHqhgGcxuP/0gli4F3
         DC+JGy5mVVhfQmrCUjOc5tcOeRmpW8oiV5sYCvChAYwrTRJi3pSgcJpD1EIhuMApv0
         Ov1HW5IZx4Rf3BQXSaugRUcRfUdjoZ7yX3PAUpRmavJVFLPVrzMw1zNWBXYSWJhAFH
         0T1nRWT9UKuJRgXlhrgDlKbh5xfJr1jKKu+MdjnM1OWqRQx69FF96lHcejuyTmGAVS
         6oA9JLxbbUUXCi2Xc2v6XGjDqV+t7O8GbqhGOZrTwdFyFWVCGofhFFZ1Ktwr+hSZQP
         GPM/nwTGDHLNw==
Date:   Mon, 7 Nov 2022 20:24:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [V2 net 05/11] net/mlx5: Fix possible deadlock on
 mlx5e_tx_timeout_work
Message-ID: <20221107202413.7de06ad1@kernel.org>
In-Reply-To: <20221105071028.578594-6-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
        <20221105071028.578594-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Nov 2022 00:10:22 -0700 Saeed Mahameed wrote:
> +	/* Once deactivated, new tx_timeout_work won't be initiated. */
> +	if (current_work() != &priv->tx_timeout_work)
> +		cancel_work_sync(&priv->tx_timeout_work);

The work takes rtnl_lock, are there no callers of
mlx5e_switch_priv_channels() that are under rtnl_lock()?

This patch is definitely going onto my "expecting Fixes"
bingo card :S
