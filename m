Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEF6128F7
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJ3INL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3INK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F23306
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC7CC60DEA
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C40C433D6;
        Sun, 30 Oct 2022 08:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667117588;
        bh=A4NeqB9OzJWw/EH8tV+CQMh80+AJhPHwFjTMDdthOA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gelwvb+YWf4hfUKoed/Smugut5oIrJvhMr6WBojOw4QTjZ+ll1y9OnmGHSzjJd8nd
         ituEHqeain4LMi7czb7yJq5EhrjA+ct6Zr58SDnX+LIkE1lHvXsGHcb+StA0wEhPSB
         Kq7Kq4WLuAtzDYtW8nzGzZ29kOBuQHFGyiD1GG94wHU5Ud4V6PvQzC3XEfIG6qdoz4
         UanlncqGkjFgceUhDQuoKmGZefhJOrTzk3MyYLI/DFyTN3FlxLZVrkuI/6q7d8kYPv
         mkTA82Bb9jeJ87gcmzXxmKls4pp5Lt5VlBUDcfbMpufrOWBKQqn+ZsE33TJXs+ph2I
         Jtcy1kqM8mzGw==
Date:   Sun, 30 Oct 2022 10:13:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net v2 1/5] Revert "net: macsec: report real_dev features
 when HW offloading is enabled"
Message-ID: <Y14yD7i53usq1ge8@unreal>
References: <cover.1666793468.git.sd@queasysnail.net>
 <38fa0a328351ba9283ecda2ba126d1147379416c.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38fa0a328351ba9283ecda2ba126d1147379416c.1666793468.git.sd@queasysnail.net>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:56:23PM +0200, Sabrina Dubroca wrote:
> This reverts commit c850240b6c4132574a00f2da439277ab94265b66.
> 
> That commit tried to improve the performance of macsec offload by
> taking advantage of some of the NIC's features, but in doing so, broke
> macsec offload when the lower device supports both macsec and ipsec
> offload, as the ipsec offload feature flags (mainly NETIF_F_HW_ESP)
> were copied from the real device. Since the macsec device doesn't
> provide xdo_* ops, the XFRM core rejects the registration of the new
> macsec device in xfrm_api_check.
> 
> Example perf trace when running
>   ip link add link eni1np1 type macsec port 4 offload mac
> 
>     ip   737 [003]   795.477676: probe:xfrm_dev_event__REGISTER      name="macsec0" features=0x1c000080014869
>               xfrm_dev_event+0x3a
>               notifier_call_chain+0x47
>               register_netdevice+0x846
>               macsec_newlink+0x25a
> 
>     ip   737 [003]   795.477687:   probe:xfrm_dev_event__return      ret=0x8002 (NOTIFY_BAD)
>              notifier_call_chain+0x47
>              register_netdevice+0x846
>              macsec_newlink+0x25a
> 
> dev->features includes NETIF_F_HW_ESP (0x04000000000000), so
> xfrm_api_check returns NOTIFY_BAD because we don't have
> dev->xfrmdev_ops on the macsec device.
> 
> We could probably propagate GSO and a few other features from the
> lower device, similar to macvlan. This will be done in a future patch.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/macsec.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 

It is still mystery for me why mlx5 works.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
