Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9C4F3FD8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240476AbiDET7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572944AbiDERWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716BA14012;
        Tue,  5 Apr 2022 10:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060AE618AC;
        Tue,  5 Apr 2022 17:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A8EC385A0;
        Tue,  5 Apr 2022 17:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649179250;
        bh=YZsDubBk95nu3x04zmH9B6wkAN+uWc38CMrzjI/URwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KLe5zgl1jn3/c4ZIruCMaO136A64eBcLm5MtWPZC5gKsaFML8XL5Qi/qHPHGunbPu
         Cn8MAg+bYIIerAENAO5CthwJdbxgxY+JcPPv4dVyDz+8Gg7Lq8nJ8U2qhQJckYp5/I
         8LVvPIeKrguyAUUzrF2cs0KvpoJRHxAnHmVLSP+dK4TTgnuRG+2y8vms+tDW2akJeY
         MyB0qBwaj662d6Ir3juQcKyHhkbEKASlApUUa2Qp5cQfBpFjfZIBOpwotaaMeLoacP
         F1Zyd4PQllzcMItH1uB2cRecYBbnUYYrNrqW9PY+Dw2KKmenqYfIQIBME36MLFZ1aq
         5xVovTJYeXidQ==
Date:   Tue, 5 Apr 2022 10:20:49 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Remove tls vs. ktls separation
 as it is the same
Message-ID: <20220405172049.slomqla4pmnyczbj@sx1>
References: <cover.1649073691.git.leonro@nvidia.com>
 <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
 <20220405003322.afko7uo527w5j3zu@sx1>
 <YkvW9SNJeb5VPmeg@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkvW9SNJeb5VPmeg@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Apr 08:43, Leon Romanovsky wrote:
>On Mon, Apr 04, 2022 at 05:33:22PM -0700, Saeed Mahameed wrote:
>> On 04 Apr 15:08, Leon Romanovsky wrote:
>> > From: Leon Romanovsky <leonro@nvidia.com>
>> >
>> > After removal FPGA TLS, we can remove tls->ktls indirection too,
>> > as it is the same thing.

[...]

> > rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (76%)
>>
>> Why not ktls_*.c => tls_*.c ?
>
>Mostly because other drivers use _ktls_ name for this type of functionality.
>Plus internally, Tariq suggested to squash everything into ktls.
>
>>
>> Since we now have one TLS implementation, it would've been easier to maybe
>> repurpose TLS to be KTLS only and avoid renaming every TLS to KTLS in all
>> functions and files.
>>
>> So just keep tls.c and all mlx5_tls_xyz functions and implement ktls
>> directly in them, the renaming will be done only on the ktls implementation
>> part of the code rather than in every caller.
>
>Should I do it or keep this patch as is?
>

Keep it, i don't have any strong feeling about this,
I just wanted to reduce the patch size.

