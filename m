Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0535A5C78
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiH3HGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiH3HFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91EC2770
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0852B8159B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5077C433D6;
        Tue, 30 Aug 2022 07:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661843148;
        bh=HN0BmeUp2Pm7LokEIQJyJ1inRPcuzl3JRgnJC2eyJtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eL8fk9Hs0WztQaTvs2X381tlw5lB+0cNWx4C6S75FYzSBxfUr0jWaNizCvIaqI7qr
         Gssxor4s+m6a0rNuZUUFKxpbSAQanGo1RcuOWAAU/W4gOtEh34NMbhUrdkbls0XmSH
         s7CZd+7E8PED+6mPMYVOnyFnugHj0auYgfF/6hdiJmg4SB353dR2b6/Di2XUyuUmv9
         SIrxlNO3zgrxpXNWHgwTX1CGyxiGt/mHqSEEIi4dbxdT25AjRq8uCIwVCNakVWFETo
         ESR6BQ7Xlo5RJ3LGu9zXyWkbPnaunUncNCewf9GBPmGjaUwfOWYoTeuDZIM+SzEqZ/
         5SImvzmH7FqxQ==
Date:   Tue, 30 Aug 2022 09:48:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yw2yq7ywfyHVqTrT@unreal>
References: <cover.1661260787.git.leonro@nvidia.com>
 <20220829075403.GL566407@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829075403.GL566407@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 09:54:03AM +0200, Steffen Klassert wrote:
> On Tue, Aug 23, 2022 at 04:31:57PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v3:
> >  * I didn't hear any suggestion what term to use instead of
> >    "full offload", so left it as is. It is used in commit messages
> >    and documentation only and easy to rename.
> >  * Added performance data and background info to cover letter
> >  * Reused xfrm_output_resume() function to support multiple XFRM transformations
> >  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
> >  * Documentation is in progress, but not part of this series yet.
> > v2: https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com
> >  * Rebased to latest 6.0-rc1
> >  * Add an extra check in TX datapath patch to validate packets before
> >    forwarding to HW.
> >  * Added policy cleanup logic in case of netdev down event
> > v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com
> >  * Moved comment to be before if (...) in third patch.
> > v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> > -----------------------------------------------------------------------
> > 
> > The following series extends XFRM core code to handle a new type of IPsec
> > offload - full offload.
> > 
> > In this mode, the HW is going to be responsible for the whole data path,
> > so both policy and state should be offloaded.
> > 
> > IPsec full offload is an improved version of IPsec crypto mode,
> > In full mode, HW is responsible to trim/add headers in addition to
> > decrypt/encrypt. In this mode, the packet arrives to the stack as already
> > decrypted and vice versa for TX (exits to HW as not-encrypted).
> > 
> > Devices that implement IPsec full offload mode offload policies too.
> > In the RX path, it causes the situation that HW can't effectively
> > handle mixed SW and HW priorities unless users make sure that HW offloaded
> > policies have higher priorities.
> > 
> > To make sure that users have a coherent picture, we require that
> > HW offloaded policies have always (both RX and TX) higher priorities
> > than SW ones.
> > 
> > To not over-engineer the code, HW policies are treated as SW ones and
> > don't take into account netdev to allow reuse of the same priorities for
> > different devices.
> > 
> > There are several deliberate limitations:
> >  * No software fallback
> >  * Fragments are dropped, both in RX and TX
> >  * No sockets policies
> >  * Only IPsec transport mode is implemented
> 
> ... and you still have not answered the fundamental questions:
> 
> As implemented, the software does not hold any state.
> I.e. there is no sync between hardware and software
> regarding stats, liftetime, lifebyte, packet counts
> and replay window. IKE rekeying and auditing is based
> on these, how should this be done?
> 
> How can tunnel mode work with this offload?
> 
> I want to see the full picture before I consider to
> apply this.

Hi,

Unfortunately, due to vacation time, it takes more time to get internal answers
than I anticipated.

I will continue to collect the needed data and add everything to cover
letter/documentation when respin.

Thanks
