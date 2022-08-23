Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9632159D03B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 06:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiHWEsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 00:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbiHWEsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 00:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E21EC58
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 21:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B92B81ADA
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10D9C433C1;
        Tue, 23 Aug 2022 04:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661230121;
        bh=mcput06ZgQsa/x6Xx9d0KOQZPta4Q0pTfqmRH6F0PY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9EHMk09nbXY8Gc5JwbtMlmlfZooPxZkOav368m8MYPMOhVRCXboljFIOO1luMZ0P
         MijTwOhyuAvdV382OhaGoz2File05WTtWixaMh4qngYPaCZ0B2XIhnkjxfDCikLOZF
         4QTF0cWf2kuMstewnykhw8MsQmhtVauCl31HsQKt4G2Kn4rI/T9Ah3vrF2GJajJf4y
         zYI+cFAcu4KOh2Olc7+TBXyE018av2UTiOMtX8/oSi4A1XsLnIcmX81o0n2XtQmrL0
         qbXlWgTlFDcemgM60lVmFT/j4FxiGMWum473QBKYAwSB0B7t8MVWfKQ710FFn/W8Fm
         yn/X8e4d5UrEw==
Date:   Tue, 23 Aug 2022 07:48:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <YwRcJaythk/kM5Kf@unreal>
References: <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
 <20220822212716.yji3ugbppse7snfy@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822212716.yji3ugbppse7snfy@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 02:27:16PM -0700, Saeed Mahameed wrote:
> On 22 Aug 09:33, Jakub Kicinski wrote:
> > On Mon, 22 Aug 2022 11:54:42 +0300 Leon Romanovsky wrote:
> > > On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
> > > > On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:
> > > > > Yup, that's what I thought you'd say. Can't argue with that use case
> > > > > if Steffen is satisfied with the technical aspects.
> > > >
> > > > Yes, everything that can help to overcome the performance problems
> > > > can help and I'm interested in this type of offload. But we need to
> > > > make sure the API is usable by the whole community, so I don't
> > > > want an API for some special case one of the NIC vendors is
> > > > interested in.
> > > 
> > > BTW, we have a performance data, I planned to send it as part of cover
> > > letter for v3, but it is worth to share it now.
> > > 
> > >  ================================================================================
> > >  Performance results:
> > > 
> > >  TCP multi-stream, using iperf3 instance per-CPU.
> > >  +----------------------+--------+--------+--------+--------+---------+---------+
> > >  |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
> > >  |                      +--------+--------+--------+--------+---------+---------+
> > >  |                      |                   BW (Gbps)                           |
> > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > >  | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
> > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > >  | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
> > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > >  | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
> > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > >  | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
> > >  +----------------------+--------+--------+-------+---------+---------+---------+
> > > 
> > >  IPsec full offload mode behaves as baseline and reaches linerate with same amount
> > >  of CPUs.
> > > 
> 
> Just making sure: Baseline == "Clear text TCP" ?

Yes, baseline is plain TCP without any encryption.

We can get higher numbers with Tariq's improvements, but it was not
important to achieve maximum as we are interested to see differences
between various modes.

Thanks
