Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3559BC15
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiHVIyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiHVIys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:54:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2743F2AC7D
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B796161028
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDD1C433D7;
        Mon, 22 Aug 2022 08:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661158487;
        bh=eU6DgyEtQsnlUC9NX+1WKYDyAYVwZETWnA+ltZjUl7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C4saUNUalpq8MpBXV5Zt+L7vJIO/sS+GEuk9giNUrAzJbPD62pZ77mPcvU0tHF7K2
         Oz9UiuFuc6VC22U79gF/MThyyjCQzvisSEdjcjUkI1oWKNM+54+PlL3/RkvJnfp7ww
         km7/eudMz7PdOchrEBUZ6sqazPWng3CYJGt7J/4SzqMq6Xf1JgfZT4bu8AU36GESYS
         p+2XSpehLtSWGHeG4Qc540H2sFzgkbsXF/3kMho/mRWUjBh3pobJtBrk3ZP5FdgczV
         gBjrT7uHUHVqLNKPJ6yr0rJI0QXgw4H342T5usHtRq9WD2pgIDZkBh16+GgLI4/4/E
         SWrnxOitppbbA==
Date:   Mon, 22 Aug 2022 11:54:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <YwNEUguW7aTXC2Vs@unreal>
References: <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822084105.GI2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
> On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:
> > On Fri, 19 Aug 2022 13:01:22 -0300 Jason Gunthorpe wrote:
> > > Regardless, RDMA doesn't really intersect with this netdev work for
> > > XFRM beyond the usual ways that RDMA IP traffic can be captured by or
> > > run parallel to netdev.
> > > 
> > > A significant use case here is for switchdev modes where the switch
> > > will subject traffic from a switch port to ESP, not unlike it already
> > > does with vlan, vxlan, etc and other already fully offloaded switching
> > > transforms.
> > 
> > Yup, that's what I thought you'd say. Can't argue with that use case 
> > if Steffen is satisfied with the technical aspects.
> 
> Yes, everything that can help to overcome the performance problems
> can help and I'm interested in this type of offload. But we need to
> make sure the API is usable by the whole community, so I don't
> want an API for some special case one of the NIC vendors is
> interested in.

BTW, we have a performance data, I planned to send it as part of cover
letter for v3, but it is worth to share it now.

 ================================================================================
 Performance results:

 TCP multi-stream, using iperf3 instance per-CPU.
 +----------------------+--------+--------+--------+--------+---------+---------+
 |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
 |                      +--------+--------+--------+--------+---------+---------+
 |                      |                   BW (Gbps)                           |
 +----------------------+--------+--------+-------+---------+---------+---------+
 | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
 +----------------------+--------+--------+-------+---------+---------+---------+
 | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
 +----------------------+--------+--------+-------+---------+---------+---------+
 | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
 +----------------------+--------+--------+-------+---------+---------+---------+
 | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
 +----------------------+--------+--------+-------+---------+---------+---------+

 IPsec full offload mode behaves as baseline and reaches linerate with same amount
 of CPUs.

 Setups details (similar for both sides):
 * NIC: ConnectX6-DX dual port, 100 Gbps each.
   Single port used in the tests.
 * CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz

Thanks
