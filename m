Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E34FB3D3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbiDKGkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244963AbiDKGkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:40:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D867622BE7;
        Sun, 10 Apr 2022 23:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7474EB8108F;
        Mon, 11 Apr 2022 06:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C7CC385A3;
        Mon, 11 Apr 2022 06:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649659074;
        bh=IH9HGCzUDxr6ArC4hLFPFbPwK9Zx/tl75hCAOLBSY7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nu48QePC1ycUvVxDUKg/81Q2EKwKNcfenlPm+JScXmAK7SaTV0dlGK8X3e9d7Pkir
         7F8MoV+8GcJON3PP5zY5KoX3pZLeWMOeCdH2LwlQXcmzmq8Tt8/CIFo3+ObgwhVe83
         X+TST+krtD+MNpdn5ZKFyQoOK4e/RGliG9LFlAMKtHhyCiqixygpf/qJf2bW2wUip7
         n/xOIUpnbv/gUXRT8ol2nwfqfdSI5fvj7bha0OzKYeFke7RNpjRPaEXjpJy37z0fpo
         R2JZhhIZRNo1dqob1Fc+I8B6LK7Fz0h5zC4b/KXUbZsr6aqG3Fu7O3pOlRO4Ou6zEi
         21JYMfnPSddSg==
Date:   Mon, 11 Apr 2022 09:37:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 01/17] net/mlx5: Simplify IPsec flow steering
 init/cleanup functions
Message-ID: <YlPMvuDXHFsZReLt@unreal>
References: <cover.1649578827.git.leonro@nvidia.com>
 <3f7001272e4dc51fcef031bf896a7e01a2b4b7f6.1649578827.git.leonro@nvidia.com>
 <20220410164620.2dfzhx6qt4cg6b6o@sx1>
 <YlMR/CHoS3xg5uRL@unreal>
 <20220410215813.sxqmvmm5wkeguj6y@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410215813.sxqmvmm5wkeguj6y@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 02:58:13PM -0700, Saeed Mahameed wrote:
> On 10 Apr 20:21, Leon Romanovsky wrote:
> > On Sun, Apr 10, 2022 at 09:46:20AM -0700, Saeed Mahameed wrote:
> > > On 10 Apr 11:28, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Cleanup IPsec FS initialization and cleanup functions.
> > > 
> > > Can you be more clear about what are you cleaning up ?
> > > 
> > > unfolding/joining static functions shouldn't be considered as cleanup.
> > 
> > And how would you describe extensive usage of one time called functions
> > that have no use as standalone ones?
> > 
> 
> Functional programming.

The separation between various modules and their functions is function
programming, but wrapper in .c file over basic kernel primitive (kzalloc)
is obfuscation.

> 
> > This patch makes sure that all flow steering initialized and cleaned at
> > one place and allows me to present coherent picture of what is needed
> > for IPsec FS.
> > 
> 
> This is already the case before this patch.

With two main differences: 
First, it is is less code to achieve the same and second, it is easy
to read (I read this code a lot lately).

 3 files changed, 27 insertions(+), 54 deletions(-)

> 
> > You should focus on the end result of this series rather on single patch.
> > 15 files changed, 320 insertions(+), 839 deletions(-)
> 
> Overall the series is fine, this patch in particular is unnecessary cancelation of
> others previous decisions, which i personally like and might as well have
> suggested myself, so let's avoid such clutter.

Sorry, but I disagree that removal of useless indirection that hurts
readability is clutter. It is refactoring.

Please focus on end goal of this series.

Thanks

> 
> 
