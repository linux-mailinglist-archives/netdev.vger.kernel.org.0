Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCCD677C97
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjAWNgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAWNgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:36:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826E1F4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0BE60EBA
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E64C433EF;
        Mon, 23 Jan 2023 13:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674480999;
        bh=buMVqHo4qYu2ZpUoF0r58dCqgL/SRQZbRahfxZPKYtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lG8ipc0kTjfSXBSuyFfo7HC0188tBChdCnZsy0oGACQ/S4o2SncDCDcOatMT/gCl9
         oJSG/UYfd4/uquKu0EhWJVVD8gwWDvUoV+41/Ch6BGDT859AcRsT5Cn/Ak8+nGBrxg
         JbQ+Nzsvfpjm+4WnQ5ZxwNjFBPFhRGDDXntwQh+OUy9XrlDh2xWyUVfHo4kFnfZYEo
         UnPOAONDeVFRYXQA+/hj/Q+0CfGVDRUrwXfyeleBL0NuI/jJe/Ui1VJ34CyHc/Lerz
         BV7RshPp4oFZQgj8ivk+wJjYrOTN3H1ONTxniLGqSLBd/R1GyMstVOJ+NmP4JbMwPO
         xgRyJNo0c5+Yg==
Date:   Mon, 23 Jan 2023 15:36:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next] nfp: support IPsec offloading for NFP3800
Message-ID: <Y86NY9MVcfgO1PPs@unreal>
References: <20230119113842.146884-1-simon.horman@corigine.com>
 <Y8z40Dt0ZiETMurg@unreal>
 <Y86IgKLKITyw0K9E@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y86IgKLKITyw0K9E@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:15:44PM +0100, Simon Horman wrote:
> On Sun, Jan 22, 2023 at 10:50:24AM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 19, 2023 at 12:38:42PM +0100, Simon Horman wrote:
> > > From: Huanhuan Wang <huanhuan.wang@corigine.com>
> > > 
> > > Add IPsec offloading support for NFP3800.
> > > Including data plane and control plane.
> > > 
> > > Data plane: add IPsec packet process flow in NFP3800 datapath (NFDK).
> > > 
> > > Control plane: add a algorithm support distinction of flow
> > > in xfrm hook function xdo_dev_state_add as NFP3800
> > > supports a different set of IPsec algorithms.
> > > 
> > > This matches existing support for the NFP6000/NFP4000 and
> > > their NFD3 datapath.
> > > 
> > > Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > ---
> > >  drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
> > >  .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
> > >  drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 +-
> > >  drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 47 +++++++++++++++++--
> > >  .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
> > >  .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 ++++
> > >  6 files changed, 79 insertions(+), 9 deletions(-)
> > >  create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
> > 
> > <...>
> > 
> > >  	md_bytes = sizeof(meta_id) +
> > >  		   !!md_dst * NFP_NET_META_PORTID_SIZE +
> > > -		   vlan_insert * NFP_NET_META_VLAN_SIZE;
> > > +		   vlan_insert * NFP_NET_META_VLAN_SIZE +
> > > +		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE;
> > 
> > *ipsec is boolean variable, so you are assuming that true is always 1.
> > I'm not sure that it is always correct.
> 
> Thanks, I do see what you are saying.
> 
> But I think what is there is consistent with the existing
> use if md_dst and vlan_insert.

It doesn't make it correct.

Thanks
