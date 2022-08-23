Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4DF59D095
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiHWFeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiHWFeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C315D109
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F8B561446
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C108C433C1;
        Tue, 23 Aug 2022 05:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661232850;
        bh=r0Zv3ihyhI/uG26g+fz5xpQU/0RkyYns+8CNH/FjqYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=htgOCb3af3zFMSfMP9sVQxi+/dBo7aFB3wYe8HvLe9E8t8IQmkTnvFasJxBLjqLMP
         XTa9ItJqEpixbDbSKiEm/TT8nohJ7AUf2FozK1Dkaq9XcHUl+sJnvo+XAePVRsW24w
         Rmr520q6lzXeVhfAwkx5nuVrgXU8NYiReeZEU4FIq3RRYdKkgRzsW1AHu7h4vtac2G
         UhJviqGKfZYE08WRZRCnOKBiNoxpKGK+Wsuc1zc3G0YFbZCRgQzTialD/uNlLdSsq4
         wypPckcjM/M+vivwYO4YsDw4yL1F8VTCZLFuISZfcfcesh0uRUBmjXX4xioSpu8+X/
         IGEzAkV2HbRVA==
Date:   Tue, 23 Aug 2022 08:34:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <YwRmzozIY4iqKTs2@unreal>
References: <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822093304.7ddc5d35@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:33:04AM -0700, Jakub Kicinski wrote:
> On Mon, 22 Aug 2022 11:54:42 +0300 Leon Romanovsky wrote:
> > On Mon, Aug 22, 2022 at 10:41:05AM +0200, Steffen Klassert wrote:
> > > On Fri, Aug 19, 2022 at 10:53:56AM -0700, Jakub Kicinski wrote:  
> > > > Yup, that's what I thought you'd say. Can't argue with that use case 
> > > > if Steffen is satisfied with the technical aspects.  
> > > 
> > > Yes, everything that can help to overcome the performance problems
> > > can help and I'm interested in this type of offload. But we need to
> > > make sure the API is usable by the whole community, so I don't
> > > want an API for some special case one of the NIC vendors is
> > > interested in.  
> > 
> > BTW, we have a performance data, I planned to send it as part of cover
> > letter for v3, but it is worth to share it now.
> > 
> >  ================================================================================
> >  Performance results:
> > 
> >  TCP multi-stream, using iperf3 instance per-CPU.
> >  +----------------------+--------+--------+--------+--------+---------+---------+
> >  |                      | 1 CPU  | 2 CPUs | 4 CPUs | 8 CPUs | 16 CPUs | 32 CPUs |
> >  |                      +--------+--------+--------+--------+---------+---------+
> >  |                      |                   BW (Gbps)                           |
> >  +----------------------+--------+--------+-------+---------+---------+---------+
> >  | Baseline             | 27.9   | 59     | 93.1  | 92.8    | 93.7    | 94.4    |
> >  +----------------------+--------+--------+-------+---------+---------+---------+
> >  | Software IPsec       | 6      | 11.9   | 23.3  | 45.9    | 83.8    | 91.8    |
> >  +----------------------+--------+--------+-------+---------+---------+---------+
> >  | IPsec crypto offload | 15     | 29.7   | 58.5  | 89.6    | 90.4    | 90.8    |
> >  +----------------------+--------+--------+-------+---------+---------+---------+
> >  | IPsec full offload   | 28     | 57     | 90.7  | 91      | 91.3    | 91.9    |
> >  +----------------------+--------+--------+-------+---------+---------+---------+
> > 
> >  IPsec full offload mode behaves as baseline and reaches linerate with same amount
> >  of CPUs.
> > 
> >  Setups details (similar for both sides):
> >  * NIC: ConnectX6-DX dual port, 100 Gbps each.
> >    Single port used in the tests.
> >  * CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz
> 
> My questions about performance were more about where does 
> the performance loss originate. Is it because of loss of GRO?
> Maybe sharing perf traces could answer some of those questions?

Crypto mode doesn't scale good in terms of CPUs.

CPU load data:
 * Remind that this is 160 CPUs machine with 2 threads per-core

Baseline:
PROCESSES  TOTAL_BW  HOST_LOCAL_CPU  HOST_REMOTE_CPU
1	   27.95     0.6	     1.1
2	   58.99     1	             2
4	   93.05     1.3	     3.2
8	   92.75     2	             3.4
16	   93.74     2.2	     4
32	   94.37     2.6	     4.5

IPsec crypto:
PROCESSES  TOTAL_BW  HOST_LOCAL_CPU  HOST_REMOTE_CPU
1	   15.04	  0.7		  1.2
2	   29.68	  1.2		  2.1
4	   58.52	  2		  3.9
8	   89.58	  2.8		  5.1
16	   90.42	  3.1		  7.1
32	   90.81	  3.16		  6.9
