Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CDF6E75D7
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjDSI7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjDSI7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCEC1026E
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A718A630AF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90718C4339B;
        Wed, 19 Apr 2023 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681894749;
        bh=bPUspiHGV/cQHYqjuDQgmKqH62SgWxZuQwh73JM2jjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ntrcwJwe36MwGpjRUBHS824gYAEuQTlevH6WIBGMs6AIikoaH42bfMZvm1w+AwEfg
         JNGSNTSt5HVxWunytraXUte7XSaP9qSaY7a7V14M92+gtpSsZJxZaJu04HS66n/Eij
         ep2LxyABXlx/wNKaEusTNb3z25fV2ojZn/+WUAToLAJAHF28TRI8fGZWkTWhgtJKMc
         mFqHK5RSCQbxg4hASHoqPFDM46I5mAxv7+Zs9szsx7DyfNk0/adxWyDWnaduznxsBJ
         QY7hWUoa5hszSrCPCBJPLBM9t0PJYAewkWLSKaKQCAzJJpORWzjm67YujUB9AShnn9
         laFdug2h+lQXA==
Date:   Wed, 19 Apr 2023 11:59:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        Wangyang Guo <wangyang.guo@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: [linux-next:master] [net] d288a162dd: canonical_address#:#[##]
Message-ID: <20230419085905.GE44666@unreal>
References: <202304162125.18b7bcdd-oliver.sang@intel.com>
 <20230418164133.GA44666@unreal>
 <509b08bd-d2bf-eaa8-6c49-c0860d1adbe0@kernel.org>
 <20230419055916.GB44666@unreal>
 <CANn89iLbHDjBZZT1ZOms3Ak0D0V4JTnyeEWZ26Eoc3v9PsGs6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLbHDjBZZT1ZOms3Ak0D0V4JTnyeEWZ26Eoc3v9PsGs6g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 10:41:00AM +0200, Eric Dumazet wrote:
> On Wed, Apr 19, 2023 at 7:59 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Apr 18, 2023 at 02:43:02PM -0600, David Ahern wrote:
> > > On 4/18/23 10:41 AM, Leon Romanovsky wrote:
> > > > Hi,
> > > >
> > > > I came to the following diff which eliminates the kernel panics,
> > > > unfortunately I can explain only second hunk, but first is required
> > > > too.
> > > >
> > > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > > index 3247e84045ca..750c8edfe29a 100644
> > > > --- a/net/core/dst.c
> > > > +++ b/net/core/dst.c
> > > > @@ -72,6 +72,8 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
> > > >         dst->flags = flags;
> > > >         if (!(flags & DST_NOCOUNT))
> > > >                 dst_entries_add(ops, 1);
> > > > +
> > > > +       INIT_LIST_HEAD(&dst->rt_uncached);
> > >
> > > d288a162dd1c73507da582966f17dd226e34a0c0 moved rt_uncached from rt6_info
> > > and rtable to dst_entry. Only ipv4 and ipv6 usages initialize it. Since
> > > it is now in dst_entry, dst_init is the better place so it can be
> > > removed from rt_dst_alloc and rt6_info_init.
> >
> > This is why I placed it there, but the rt_uncached list is initialized
> > in xfrm6 right before first call to rt6_uncached_list_add().
> >
> >    70 static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
> >    71                           const struct flowi *fl)
> >    72 {
> > ...
> >    92         INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
> >    93         rt6_uncached_list_add(&xdst->u.rt6);
> >
> > My silly explanation is that xfrm6_dst_destroy() can be called before xfrm6_fill_dst().
> >
> > Thanks
> >
> > >
> 
> Please take a look at the fix that was sent yesterday :
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20230418165426.1869051-1-mbizon@freebox.fr/

Thanks, I replied there with my comments.

> 
> Thanks.
