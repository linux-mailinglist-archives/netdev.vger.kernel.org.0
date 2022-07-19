Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE5657A5D6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiGSRyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbiGSRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:54:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C379C59243;
        Tue, 19 Jul 2022 10:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45D6B616F1;
        Tue, 19 Jul 2022 17:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1813BC341C6;
        Tue, 19 Jul 2022 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658253247;
        bh=72amZZifeAc6jNQz+mSOhvFQlpyrtV6NttaUR1XcNwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kn6e8m3+/Me/Wk5kXkNG/Euep4WBWfIrV8yg/YwlzEgmqoDRHZTxnOmTrzJcIONaj
         f8fPWG2kjGPYPCo8CvdKisXHPiDKvxDmjdsSUzNe6ONgF3ybY+MzWUUahyzg2SIYBs
         5fvXyeOGuRNnoIZbdSOnb/EaS2Zqi0cC1AS/CaeQdjBLzqWWTbIHMXM+fugRy6wbyY
         YePmgzmMt6JY3Myd1jNBzSZIrVY4JwKugNQgWaMX+A0Vfpe75oTH6lMWT22trb5z9a
         jHlmJHw8lVmLOjVeL38FCzU2WBIPSb+YJOmIjhiuCIgKrCkiqYlUoH7IKQq9iCBYC8
         2EdgaB/AfcJyw==
Date:   Tue, 19 Jul 2022 20:54:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/5] mlx5-next updates 2022-07-03
Message-ID: <Ytbvu3gjGCezyZHD@unreal>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 01:54:02PM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Mark Bloch Says:
> ================
> Expose steering anchor
> 
> Expose a steering anchor per priority to allow users to re-inject
> packets back into default NIC pipeline for additional processing.
> 
> MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
> a user can use to re-inject packets at a specific priority.
> 
> A FTE (flow table entry) can be created and the flow table ID
> used as a destination.
> 
> When a packet is taken into a RDMA-controlled steering domain (like
> software steering) there may be a need to insert the packet back into
> the default NIC pipeline. This exposes a flow table ID to the user that can
> be used as a destination in a flow table entry.
> 
> With this new method priorities that are exposed to users via
> MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.
> 
> As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
> thus it's impossible to point to a NIC core flow table (core driver flow tables
> are created with UID value of zero) from userspace.
> Create flow tables that are exposed to users with the shared UID, this
> allows users to point to default NIC flow tables.
> 
> Steering loops are prevented at FW level as FW enforces that no flow
> table at level X can point to a table at level lower than X. 
> 
> ===============
> 
> Mark Bloch (5):
>   net/mlx5: Expose the ability to point to any UID from shared UID
>   net/mlx5: fs, expose flow table ID to users
>   net/mlx5: fs, allow flow table creation with a UID
>   RDMA/mlx5: Refactor get flow table function
>   RDMA/mlx5: Expose steering anchor to userspace
> 

Thanks, applied.
