Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251A7676BAF
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 09:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjAVIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 03:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 03:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B248B1E1CF
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 00:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A888B80959
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 08:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E5BC433EF;
        Sun, 22 Jan 2023 08:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674377428;
        bh=j5+fVhx6MXbs66ilvtGW66Ks+rT8faZVTjTuF20YXH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=efBxH8xgEWlfYcWTl5WXObYwAW4FwEnAAAq9yEuzoa5W/e+t2pndpr6c9iycWe7Q6
         PbalnNCKfE7pE7CQukkbNvFusL5FF7LGxJ3g3mgryjPifrT1aX/TCM//r/aOyEtObP
         tzshbAkWZ/EkHuDVPdN+6rm8d5jMmK/Bwm7+/03s2SdV+ZfK4L6cRi6zwvQqtJog+2
         OUGHv5ypuxa8GXfDZ28555lOJof4arZuSXt7Z89vtJmJRyK/KxfYKg9/utI2EE7G//
         psgyi3akK63o9AJsn+ARf0cOLmFyV3mDHpqPNDvXTL7MhV36mCDROpeq55vuu+agyD
         phsES3qnSnixg==
Date:   Sun, 22 Jan 2023 10:50:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: support IPsec offloading for NFP3800
Message-ID: <Y8z40Dt0ZiETMurg@unreal>
References: <20230119113842.146884-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113842.146884-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 12:38:42PM +0100, Simon Horman wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Add IPsec offloading support for NFP3800.
> Including data plane and control plane.
> 
> Data plane: add IPsec packet process flow in NFP3800 datapath (NFDK).
> 
> Control plane: add a algorithm support distinction of flow
> in xfrm hook function xdo_dev_state_add as NFP3800
> supports a different set of IPsec algorithms.
> 
> This matches existing support for the NFP6000/NFP4000 and
> their NFD3 datapath.
> 
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
>  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 +-
>  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 47 +++++++++++++++++--
>  .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
>  .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 ++++
>  6 files changed, 79 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c

<...>

>  	md_bytes = sizeof(meta_id) +
>  		   !!md_dst * NFP_NET_META_PORTID_SIZE +
> -		   vlan_insert * NFP_NET_META_VLAN_SIZE;
> +		   vlan_insert * NFP_NET_META_VLAN_SIZE +
> +		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;

*ipsec is boolean variable, so you are assuming that true is always 1.
I'm not sure that it is always correct.

Thanks
