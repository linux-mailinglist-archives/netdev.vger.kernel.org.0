Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A25596891
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiHQFWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiHQFWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:22:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35037B1F7
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 22:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5317CB81AF2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 05:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2CFC433C1;
        Wed, 17 Aug 2022 05:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660713727;
        bh=1Ok/SyHTdGGWov4S5UOjmezRGia5QlseJwFv18IZ/dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZjmmPedeuWzJKLgh7fWbkSamusHjiHE8PolpyPNdbNQMo3i0nLwG+bZXllKvztLN
         xZs7DzAdXY4ZQCozArBLSgZvYurpfXYDyk/7hD9XAlZiCEWSjfmGGf/q94UqrDtLNR
         caW/o+nHB2bORVgGmj40LZYLplmSdYknYfK3Z9NMba21ALXV2ynKo4SWIp4dvSdkI1
         OVGnZEK+yefpWpWuVh1GVL+I1Y/qpocXbX70WYm3esVa/H9kg4HRMkXWocW3jRKCSv
         B1tGZEuuq2MpeRq4Guz8UVlOPcRDVjdSUdZyceRsPIkOfDxBmrjqBsuuFywLfYjhu4
         e0+RSCb5c9Q5Q==
Date:   Wed, 17 Aug 2022 08:22:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yvx6+qLPWWfCmDVG@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816195408.56eec0ed@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 07:54:08PM -0700, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 11:59:21 +0300 Leon Romanovsky wrote:
> > The following series extends XFRM core code to handle new type of IPsec
> > offload - full offload.
> > 
> > In this mode, the HW is going to be responsible for whole data path, so
> > both policy and state should be offloaded.
> 
> This is making a precedent for full tunnel offload in netdev, right?

Not really. SW IPsec supports two modes: tunnel and transport.

However HW and SW stack supports only offload of transport mode.
This is the case for already merged IPsec crypto offload mode and
the case for this full offload.

> Could you indulge us with a more detailed description, motivation,
> performance results, where the behavior of offload may differ (if at
> all), what visibility users have, how SW and HW work together on the
> datapath? Documentation would be great.

IPsec full offload is actually improved version of IPsec crypto mode,
In full mode, HW is responsible to trim/add headers in addition to
decrypt/encrypt. In this mode, the packet arrives to the stack as already
decrypted and vice versa for TX (exits to HW as not-encrypted).

My main motivation is to perform IPsec on RoCE traffic and in our
preliminary results, we are able to do IPsec full offload in line
rate. The same goes for ETH traffic.

Regarding behavior differences - they are not expected.

We (Raed and me) tried very hard to make sure that IPsec full offload
will behave exactly as SW path.

There are some limitations to reduce complexity, but they can be removed
later if needs will arise. Right now, none of them are "real" limitations
for various *swarn forks, which we extend as well.

Some of them:
1. Request to have reqid for policy and state. I use reqid for HW
matching between policy and state.
2. Automatic separation between HW and SW priorities, because HW sees
packet first.
3. Only main template is supported.
4. No fallback to SW if IPsec HW failed to handle packet. HW should drop
such packet.

Visibility:
Users can see the mode through iproute2
https://lore.kernel.org/netdev/cover.1652179360.git.leonro@nvidia.com/
and see statistics through ethtool.

Documentation will come as well. I assume that IPsec folks are familiar
with this topic as it was discussed in IPsec coffee hour. 

Thanks
