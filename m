Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE8B6E739B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDSHCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjDSHCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B63B199A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB17D63B9D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7C1C433EF;
        Wed, 19 Apr 2023 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681887759;
        bh=JP+P9Uj3W/De8PEr9B2Ujl46kJqnROKOmOOECwHUMqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQYSTIsNCyBK2zZvz0V4+JRaiASojnL2wwCFRphudqfJ/k3neU1zqVvbR2t3rGnAk
         fg06OXB+88UTlBwliXxDPmOeGrzEgz9pL519m9gpMue+3M4pDZEmMXxOrfEiyvZ1u7
         lYZ0lARUFBLzDa/bJt7U6QNxSvf+/23x5+jIGs25QFHekzzK35jvJmJ1DYrhHKuDLc
         mM03/RwTvzRhQjubV2V9wit0+ZwR/+H0D2n0yEKtjfoKbEAOBrI7I6HHIBGLcFrgun
         vBpJOcJ4/+UM8/OhHE6uDcmZydMnTwI7QLCUajBeO/Yuoe3dkRw7k/AidSa816A/vl
         y34Wi5d+NYCHQ==
Date:   Wed, 19 Apr 2023 10:02:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Wangyang Guo <wangyang.guo@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: [linux-next:master] [net] d288a162dd: canonical_address#:#[##]
Message-ID: <20230419070234.GC44666@unreal>
References: <202304162125.18b7bcdd-oliver.sang@intel.com>
 <20230418164133.GA44666@unreal>
 <509b08bd-d2bf-eaa8-6c49-c0860d1adbe0@kernel.org>
 <20230419055916.GB44666@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419055916.GB44666@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 08:59:16AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 18, 2023 at 02:43:02PM -0600, David Ahern wrote:
> > On 4/18/23 10:41 AM, Leon Romanovsky wrote:
> > > Hi,
> > > 
> > > I came to the following diff which eliminates the kernel panics,
> > > unfortunately I can explain only second hunk, but first is required
> > > too.
> > > 
> > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > index 3247e84045ca..750c8edfe29a 100644
> > > --- a/net/core/dst.c
> > > +++ b/net/core/dst.c
> > > @@ -72,6 +72,8 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
> > >         dst->flags = flags;
> > >         if (!(flags & DST_NOCOUNT))
> > >                 dst_entries_add(ops, 1);
> > > +
> > > +       INIT_LIST_HEAD(&dst->rt_uncached);
> > 
> > d288a162dd1c73507da582966f17dd226e34a0c0 moved rt_uncached from rt6_info
> > and rtable to dst_entry. Only ipv4 and ipv6 usages initialize it. Since
> > it is now in dst_entry, dst_init is the better place so it can be
> > removed from rt_dst_alloc and rt6_info_init.
> 
> This is why I placed it there, but the rt_uncached list is initialized
> in xfrm6 right before first call to rt6_uncached_list_add().
> 
>    70 static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
>    71                           const struct flowi *fl)
>    72 {
> ...
>    92         INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
>    93         rt6_uncached_list_add(&xdst->u.rt6);
> 
> My silly explanation is that xfrm6_dst_destroy() can be called before xfrm6_fill_dst().

David,

I think that I found how it is possible.

  2959 static struct xfrm_dst *xfrm_create_dummy_bundle(struct net *net,
  2960                                                  struct xfrm_flo *xflo,
  2961                                                  const struct flowi *fl,
  2962                                                  int num_xfrms,
  2963                                                  u16 family)
  2964 {       
...
  2971         xdst = xfrm_alloc_dst(net, family);
  2972         if (IS_ERR(xdst))
  2973                 return xdst;
...
  2981         dst1 = &xdst->u.dst;
...
  3005         err = xfrm_fill_dst(xdst, dev, fl);
  3006         if (err)
  3007                 goto free_dst;
  3008
  3009 out:
  3010         return xdst;
  3011
  3012 free_dst:
  3013         dst_release(dst1); <-- release of dst1 which has not-initialized rt_uncached.

Thanks

> 
> Thanks
> 
> > 
