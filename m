Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41307598428
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbiHRN0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245112AbiHRN0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:26:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088CCA0250
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C12615FB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663EFC433D7;
        Thu, 18 Aug 2022 13:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660829203;
        bh=sB64OgHY3IusrVjnISn0E2kr2OO3s65gCHLibWJTafw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RwdI9hSM62Y760qWIKzfXo+6HgHHZMMW5VImbOa9EMWHPYGdfacF6JtVSbJLutkSx
         LIwYfjHxTmMnr72qe1bGWssZmk5vLWqTM5S00xTT7c7E/fMqaHvb1WrKfNoKwUkHhz
         PPQjURsK5MSqIooODdUC6FDV1QxaHxdkaEbn9ZbAE2R66dUVMBk3Ck77WJugol6nrk
         jcK0h9+9FVeJhDd4ERcuHpYnXIr6fKJu7sjrLM4EIvfH1Hd8ChNgl251My7PvQn+bJ
         ESv4y8AIVtb2aswcvZTODtcXE8gzEk1cKfqErogNVsTHYIJ8JXP1ccoaGZ7WGNu6wA
         bfPBjROeSk2mg==
Date:   Thu, 18 Aug 2022 16:26:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yv4+D+2d3HPQKymx@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220818100930.GA622211@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818100930.GA622211@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:09:30PM +0200, Steffen Klassert wrote:
> Hi Leon,
> 
> On Tue, Aug 16, 2022 at 11:59:21AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v2:
> >  * Rebased to latest 6.0-rc1
> >  * Add an extra check in TX datapath patch to validate packets before
> >    forwarding to HW.
> >  * Added policy cleanup logic in case of netdev down event 
> > v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com 
> >  * Moved comment to be before if (...) in third patch.
> > v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> > -----------------------------------------------------------------------
> > 
> > The following series extends XFRM core code to handle new type of IPsec
> > offload - full offload.
> > 
> > In this mode, the HW is going to be responsible for whole data path, so
> > both policy and state should be offloaded.
> 
> some general comments about the pachset:
> 
> As implemented, the software does not hold any state.
> I.e. there is no sync between hardware and software
> regarding stats, liftetime, lifebyte, packet counts
> and replay window. IKE rekeying and auditing is based
> on these, how should this be done?

This is only rough idea as we only started to implement needed
support in libreswan, but our plan is to configure IKE with
highest possible priority 

> 
> I have not seen anything that catches configurations
> that stack multiple tunnels with the outer offloaded.
> 
> Where do we make sure that policy offloading device
> is the same as the state offloading device?

It is configuration error and we don't check it. Should we?

Thanks
