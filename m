Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA16E1748
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjDMWWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDMWV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:21:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCAC9019;
        Thu, 13 Apr 2023 15:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE1964120;
        Thu, 13 Apr 2023 22:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95D3C433D2;
        Thu, 13 Apr 2023 22:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681424512;
        bh=k2UJ1veLaHrbFX3kFBHc3EjZuApFw91PwSmwqHWX3NI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fmJr/bAz6TFS7UsjeabgEbnU6yg3P/IxSYcJYjwXok5hbrGG2MDgYiHkC4rtNx98H
         FZumOI/vYjrQd+aWLD+ecCOiBOv/KGJPtVfjjetJg2ESEh5N0reUBL2WQ/8RaG2YGR
         RkB+e5dwrRd6t5N0D8Rb5ARRJ0sAdqBn1f0IYfBFFxUvpb29Qw6rUBg71oXTG4D1qM
         rkDRfPMHGoFZalZ/RRiPFlJWrXUd1bmsnXlpzWc4cTeP6jrMMsawfhNFacNBMkZS6C
         L/k15tVvYH8/0wlRi0x/HG9OcYj+ljNX6R7qCUkOFwHYDWOz73pHPhNWOYuyjo4KB9
         +uEzo/2J0qgWA==
Date:   Thu, 13 Apr 2023 15:21:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230413152150.4b54d6f4@kernel.org>
In-Reply-To: <ZDhwUYpMFvCRf1EC@x130>
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
        <ZCS5oxM/m9LuidL/@x130>
        <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
        <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
        <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
        <20230410054605.GL182481@unreal>
        <20230413075421.044d7046@kernel.org>
        <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
        <ZDhwUYpMFvCRf1EC@x130>
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

On Thu, 13 Apr 2023 14:12:49 -0700 Saeed Mahameed wrote:
> This is a high priority and we are working on this, unfortunately for mlx5
> we don't check FW versions since we support more than 6 different devices
> already, with different FW production lines. 
> 
> So we believe that this bug is very hard to solve without breaking backward
> compatibility with the currently supported working FWs, the issue exists only
> on very old firmwares and we will recommend a firmware upgrade to resolve this
> issue.

On a closer read I don't like what this patch is doing at all.
I'm not sure we have precedent for "management connection" functions.
This requires a larger discussion. And after looking up the patch set
it went in, it seems to have been one of the hastily merged ones.
I'm sending a revert.
