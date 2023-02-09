Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3469082A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBIMFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjBIMEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612FB38B70
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E139D61A25
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 11:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF05C433D2;
        Thu,  9 Feb 2023 11:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675943679;
        bh=3k4FhXiLt1HCZmy5wRL0qVcN98hZQh1aM+bOdVM2k4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XERdlSLRtBw9sEPH/xqXVj45sNxSAYeRgUcMhqrf9phC+DiT0RDPh/HPJjmWQFsB7
         79QfrAxD74Yn6IPwo/gkrCkrLYKxnQCz/fHQ6Way/TgED4w0d5l7g3IaRi2cmH340Q
         Wai8C2rTmXX5W6k/5Zpl3qwGBVxGntfffAZRiuuz52mIm4rxvFkBsJ+A2m456gIqrX
         t8bJ7yq1mZW0XC1OaHycJpiEtJR/dGPw+tqYtjOkGd1Gw1QAmYczy8LLGvIQlxRyK2
         M1/qRCc6oJa9UJyeivMFlXcNVke+Z7G9m9+oDXnoa6T4wKdQXUxxGYeLSDXC0nXaW6
         SwMupvNhdab/g==
Date:   Thu, 9 Feb 2023 13:54:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH v2 net-next v2] nfp: support IPsec offloading for NFP3800
Message-ID: <Y+Te+hAoMBlWH23j@unreal>
References: <20230208091000.4139974-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208091000.4139974-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 10:10:00AM +0100, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Add IPsec offloading support for NFP3800. Include data
> plane and control plane.
> 
> Data plane: add IPsec packet process flow in NFP3800
> datapath (NFDk).
> 
> Control plane: add an algorithm support distinction flow
> in xfrm hook function xdo_dev_state_add(), as NFP3800 has
> a different set of IPsec algorithm support.
> 
> This matches existing support for the NFP6000/NFP4000 and
> their NFD3 datapath.
> 
> In addition, fixup the md_bytes calculation for NFD3 datapath
> to make sure the two datapahts are keept in sync.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
> Changes in v2:
> * use NL_SET_ERR_MSG_MOD instead of nn_err in nfp_net_xfrm_add_state()
> * Avoid using boolean values as integers
> ---
>  drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
>  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 11 ++---
>  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 49 +++++++++++++++++--
>  .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
>  .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 +++
>  6 files changed, 83 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
