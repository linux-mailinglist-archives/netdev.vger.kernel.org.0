Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62CA57914A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiGSDZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiGSDZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:25:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F939DB7
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09C6B81815
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF1BC341C0;
        Tue, 19 Jul 2022 03:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658201105;
        bh=swd1XuGY+RHGDFgKkRn5w6he4LjwSWa+0ObOj8dJU1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KsS3r8o3KX7p2GvpnY+Bv1WzFx5WKl3uDx4/S2DKqgwSPODo9//Md0H/yb/+x5llf
         fEhHkVb3ASDa7MQEeQZ+Q5aA6aPTKEoJm9M8ADE+ZaBMrliJwaXE+5+ed6gzAM7dMZ
         DpaXT/2YC7f2tcXlvVttikXVpaN7g+HQEyRk2yjsMAYNbz5ukbkQyziq+E/Uf3poi7
         ew2xCvHEsVVPOMg3Xq2MLp5oZ4sdJvemTBYvoeGig+20VhF96HSgb7fFLU7ipBwRmu
         ClIf7CQl6D6ZyEVyGIIsKJs/ojPwh3Bg6psPf3LROuvkXOP6W6gu0ccv1to5DAz4ID
         fOBo5VpBV5FpA==
Date:   Mon, 18 Jul 2022 20:25:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Message-ID: <20220718202504.3d189f57@kernel.org>
In-Reply-To: <20220717213352.89838-4-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
        <20220717213352.89838-4-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jul 2022 14:33:41 -0700 Saeed Mahameed wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> Add the rx_oversize_pkts_buffer counter to ethtool statistics.
> This counter exposes the number of dropped received packets due to
> length which arrived to RQ and exceed software buffer size allocated by
> the device for incoming traffic. It might imply that the device MTU is
> larger than the software buffers size.

Is it counted towards any of the existing stats as well? It needs 
to end up in struct rtnl_link_stats64::rx_length_errors somehow.

On ethtool side - are you not counting this towards FrameTooLongErrors
because it's not dropped in the MAC? Can we count it as RMON's
oversize_pkts?
