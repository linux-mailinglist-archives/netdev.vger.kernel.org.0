Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F198D68871F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbjBBSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjBBSxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4422214208
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05D3AB82789
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 18:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC29C433D2;
        Thu,  2 Feb 2023 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675363981;
        bh=QZRg7czz2ne1iPQpPV77hc/f6Pshfr3jC7fzq3dyxzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GpN+Bq1oqg7xCCo6QjZOWI3A2ayoW+KFJFYjAxr5Ohy3j9EWTNeyautVAwXj0y8ZS
         oD3w13W/Fc+IxqHkeo9qsOBS0AwT80QDcSqt6pjYj3xlRTyNOyPxjujVnDxL5PZfQz
         FY+K6WBvc+Cnr95IK8fvM/Mzey+WZ2QfZaWaEFkrHG2UdQFCHT8ymwuf/Tey1XSmjh
         6py7xZOgjvt7QjCk0Lnfz7wdDgiEMCufFU9SVuvjNat4XnXVjJICd1QmXanLk0uz59
         dfLRybtTzv7cmpR0r2CjZX24tWXwffDNNqHR/aDvA3ffR1MsYB6uETtHsHhYakOj0/
         UFA6MF6rxtHlA==
Date:   Thu, 2 Feb 2023 10:53:00 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v5 0/2] mlx5: ptp fifo bugfixes
Message-ID: <Y9wGjKqh5lOzGYYZ@x130>
References: <20230202171355.548529-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230202171355.548529-1-vadfed@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 Feb 09:13, Vadim Fedorenko wrote:
>Simple FIFO implementation for PTP queue has several bugs which lead to
>use-after-free and skb leaks. This series fixes the issues and adds new
>checks for this FIFO implementation to uncover the same problems in
>future.
>

Thanks Vadim, Applied to net-mlx5.

>v4 -> v5:
>  Change check to WARN_ON_ONCE() in mlx5e_skb_fifo_pop()
>  Change the check of OOO cqe as Jakub provided corner case
>  Move OOO logic into separate function and add counter
>v3 -> v4:
>  Change pr_err to mlx5_core_err_rl per suggest
>  Removed WARN_ONCE on fifo push because has_room() should catch the
>  issue
>v2 -> v3:
>  Rearrange patches order and rephrase commit messages
>  Remove counters as Gal confirmed FW bug, use KERN_ERR message instead
>  Provide proper budget to napi_consume_skb as Jakub suggested
>v1 -> v2:
>  Update Fixes tag to proper commit.
>  Change debug line to avoid double print of function name
>
>Vadim Fedorenko (2):
>  mlx5: fix skb leak while fifo resync and push
>  mlx5: fix possible ptp queue fifo use-after-free
>
> .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 25 ++++++++++++++++---
> .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++-
> .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 +
> .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
> 4 files changed, 27 insertions(+), 4 deletions(-)
>
>-- 
>2.30.2
>
