Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A5E6E4FC0
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjDQR7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDQR7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A683590
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48AF7628C9
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992B5C433D2;
        Mon, 17 Apr 2023 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681754339;
        bh=v8pkkiVCz33Ss7SXJaHL/N9HUzvAGI3Y7Y47BDcdFWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lIQbEZGFl0mgKqPAayYZ1OW3V1KeinR7ImPd7F7h1A3GPy+K8Ii746e4cQu0WuPMa
         gqCFol0tGWkUuyAryv4NADc6M0+pG0RpVSem8TrUaNUdKckCmvgbpdgJzPG1xZQoHc
         iq+e20fKdDIRackmRTPbarH34eyyE9KL7L0uptwEaqjSJbBpQIsUW/inpmMTl/o0b6
         6iKoxAOzW0PH4iW5ZRFyjScNdigswDiFZGLQZpTnI1C5sx+qo1snYV257TGtUa/ipr
         iRWtEPjooFxg410liVDmpYRSVKp0HLHn4TO/a2qgp03735+uQp1jk8Pp0ix//i/GTi
         ykHKA4Cz0DclQ==
Date:   Mon, 17 Apr 2023 20:58:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec
 packet offload
Message-ID: <20230417175854.GF15386@unreal>
References: <cover.1681388425.git.leonro@nvidia.com>
 <20230416210519.1c91c559@kernel.org>
 <ZD1FM0g+KWo5GtlA@corigine.com>
 <ZD1LzTfcr6vIVZCW@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1LzTfcr6vIVZCW@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 03:38:21PM +0200, Simon Horman wrote:
> On Mon, Apr 17, 2023 at 03:10:33PM +0200, Simon Horman wrote:
> > On Sun, Apr 16, 2023 at 09:05:19PM -0700, Jakub Kicinski wrote:
> > > On Thu, 13 Apr 2023 15:29:18 +0300 Leon Romanovsky wrote:
> > > > Changelog:
> > > > v1:
> > > >  * Added Simon's ROB tags
> > > >  * Changed some hard coded values to be defines
> > > >  * Dropped custom MAC header struct in favor of struct ethhdr
> > > >  * Fixed missing returned error
> > > >  * Changed "void *" casting to "struct ethhdr *" casting
> > > > v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> > > > 
> > > > ---------------------------------------------------------------------
> > > > Hi,
> > > > 
> > > > This series extends mlx5 to support tunnel mode in its IPsec packet
> > > > offload implementation.
> > > 
> > > Hi Simon,
> > > 
> > > would you be able to take a look in the new few days?
> > > I think you have the rare combination of TC and ipsec
> > > expertise :)
> > 
> > Hi Jakub,
> > 
> > certainly, will do.
> 
> Hi Jakub,
> 
> sorry for the delay in getting to this patch - I was on a short break.
> I had already looked over v0 prior to my break.
> And, after reviewing v1, I am happy with this series.

Thanks a lot.
