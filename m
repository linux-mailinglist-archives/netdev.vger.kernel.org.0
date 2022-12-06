Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CBE644474
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiLFNVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiLFNVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AB32189A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FE98B81A26
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 13:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE68C433D7;
        Tue,  6 Dec 2022 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670332859;
        bh=IYp1LzEzsOI//zrcCuqY3pHIC5R7LlPT/ckeCN/KPHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpwNfIRIaUXjZIuYQYMeJ/ulDQD2EA5wK69IMo/Gc1y1gosmp0LvIHcvt9ceAtq87
         zmzi2RL2xtSGld0nRn2yUP/aIzCXjbtRXbusWDl65GfCnQGZMtmGXGJxFgUSsuaLd2
         0togSIW7dkV0qAswTCpvxC/7HtutB8yBBvVADbmOg+2P4/lv/WeQFWGamu3/tqQu1H
         esUjdx2xd/DjT3Ite1953ncuxxJfuy1/PT/hHJM6AisrNNoDgPodSoulwymWq4EP0x
         OFXB4v61GS/CGPn/gp2KxQUgoconbWeN9ZzE57TQj9GOYfQDJDT+Kw3tNr/gq+CXXb
         yXFTqRnhs2uTA==
Date:   Tue, 6 Dec 2022 15:20:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v10 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y49Bt6hbfvA7rKem@unreal>
References: <cover.1670005543.git.leonro@nvidia.com>
 <20221206124745.GH704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124745.GH704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 01:47:45PM +0100, Steffen Klassert wrote:
> On Fri, Dec 02, 2022 at 08:41:26PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> ...
> > 
> > Leon Romanovsky (8):
> >   xfrm: add new packet offload flag
> >   xfrm: allow state packet offload mode
> >   xfrm: add an interface to offload policy
> >   xfrm: add TX datapath support for IPsec packet offload mode
> >   xfrm: add RX datapath protection for IPsec packet offload mode
> >   xfrm: speed-up lookup of HW policies
> >   xfrm: add support to HW update soft and hard limits
> >   xfrm: document IPsec packet offload mode
> > 
> >  Documentation/networking/xfrm_device.rst      |  62 +++++-
> >  .../inline_crypto/ch_ipsec/chcr_ipsec.c       |   4 +
> >  .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   5 +
> >  drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   5 +
> >  .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +
> >  .../net/ethernet/netronome/nfp/crypto/ipsec.c |   5 +
> >  drivers/net/netdevsim/ipsec.c                 |   5 +
> >  include/linux/netdevice.h                     |   4 +
> >  include/net/xfrm.h                            | 124 +++++++++---
> >  include/uapi/linux/xfrm.h                     |   6 +
> >  net/xfrm/xfrm_device.c                        | 109 +++++++++-
> >  net/xfrm/xfrm_output.c                        |  12 +-
> >  net/xfrm/xfrm_policy.c                        |  85 +++++++-
> >  net/xfrm/xfrm_state.c                         | 191 ++++++++++++++++--
> >  net/xfrm/xfrm_user.c                          |  20 ++
> >  15 files changed, 577 insertions(+), 64 deletions(-)
> 
> Series applied, thanks a lot Leon!

Thanks a lot for your help.
