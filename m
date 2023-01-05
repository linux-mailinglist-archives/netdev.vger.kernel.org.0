Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB27565E663
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjAEICE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjAEIB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:01:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8804C17597;
        Thu,  5 Jan 2023 00:01:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB3C6190B;
        Thu,  5 Jan 2023 08:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB89C433EF;
        Thu,  5 Jan 2023 08:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672905716;
        bh=w5W3eLaqipVDvJWkR5utJmks9c/6Wu40ITZJrOR/Vtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ASD4yqvYISTgGKoiCrSfdnp5vYULBiuzLPyd6t5jCwXTnQ0VKRF8Kil9MYFTHwOpw
         tC0tWgHHo+jinhek8L5B8BpBfaPOoDKQUBsR7T1J5FcI0rtgsiOWE7vYZiY6wQXIWB
         K86khD8z7k0I7MtDJw+55IvgELxPUYPNizyY8Y5ktddjXO8YSY006TSzq8v5Z8KuAU
         bO2jmIcp4ZG4Pj/JZeonkcjHS+gs6suQ4drs8NtlKHWVBL5U0MukZJEYzyITrhHLlQ
         W5qroik6iikA54zX0C4WsIIbMdFiPzC0Yd/MALlee4SG0fWJ6P26U7UigVLCDEIBSq
         GEX54KZB9ZUvA==
Date:   Thu, 5 Jan 2023 10:01:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ezchip: Switch to some devm_ function to
 simplify code
Message-ID: <Y7aD8F5OuAwaEKjU@unreal>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
 <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
 <20230104205438.61a7dc20@kernel.org>
 <94876618-bc7c-dd42-6d41-eda80deb6f1d@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94876618-bc7c-dd42-6d41-eda80deb6f1d@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 07:27:00AM +0100, Christophe JAILLET wrote:
> Le 05/01/2023 à 05:54, Jakub Kicinski a écrit :
> > On Wed,  4 Jan 2023 22:05:33 +0100 Christophe JAILLET wrote:
> > > devm_alloc_etherdev() and devm_register_netdev() can be used to simplify
> > > code.
> > > 
> > > Now the error handling path of the probe and the remove function are
> > > useless and can be removed completely.
> > 
> > Right, but this is very likely a dead driver. Why invest in refactoring?
> > 
> 
> Hi Jakub,
> 
> this driver was just randomly picked as an example.
> 
> My main point is in the cover letter. I look for feed-back to know if
> patches like that are welcomed. Only the first, Only the second, Both or
> None.
> 
> 
> I put it here, slightly rephrased:
> 
> 
> These patches (at least 1 and 2) can be seen as an RFC for net MAINTAINERS,
> to see if there is any interest in:
>   - axing useless netif_napi_del() calls, when free_netdev() is called just
> after. (patch 1)
>   - simplifying code with axing the error handling path of the probe and the
> remove function in favor of using devm_ functions (patch 2)

I would say no. In many occasions, the devm_* calls were marked as harmful.
Latest talk about devm_kzalloc(): https://lpc.events/event/16/contributions/1227/

Thanks

> 
>   or
> 
> if it doesn't worth it and would only waste MAINTAINERS' time to review what
> is in fact only code clean-ups.
> 
> 
> The rational for patch 1 is based on Jakub's comment [1].
> free_netdev() already cleans up NAPIs (see [2]).
> 
> CJ
> 
> [1]: https://lore.kernel.org/all/20221221174043.1191996a@kernel.org/
> [2]: https://elixir.bootlin.com/linux/v6.2-rc1/source/net/core/dev.c#L10710
