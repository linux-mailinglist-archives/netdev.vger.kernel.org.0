Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58086E72CF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 07:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDSF7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 01:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSF7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 01:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8143A90
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 22:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C72863A8F
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA82C433D2;
        Wed, 19 Apr 2023 05:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681883960;
        bh=uMEP/rLMSuizQenPLrelbZAZmJG14sYh9fm/by6+dFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuXRxOIj80rqK2A/dyzSWBRMytGf8o6ZQ3LNriU1TOAMu8iSwoVoiyVLBHq0nf9aJ
         dzYc0Ll6oKk06ZEQpD6A2VeR3gB8AJFi8bNjFg5UQiXxUdWdeR5vtLacIdbSdsJA/a
         QMmTfJJW+aKCidmgcd0ODd0T+ztpzcHiQrcRAXeMrSHzveyCau+vTcH/EXoYO3wpdw
         /ib+QL3+xH7GyHWXATVkUzdjG/gX7gETPzFZu6SNYcHtMvLe8AhjSlV/P1zkGrTZ90
         Ukish9v2oseVsi1U6VSpaVC1hAuKz+4JVTgJfXFFA0Nj6LQpsVOOAgE8dIQm/ZcraF
         /r0tmQ+quF9/Q==
Date:   Wed, 19 Apr 2023 08:59:16 +0300
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
Message-ID: <20230419055916.GB44666@unreal>
References: <202304162125.18b7bcdd-oliver.sang@intel.com>
 <20230418164133.GA44666@unreal>
 <509b08bd-d2bf-eaa8-6c49-c0860d1adbe0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509b08bd-d2bf-eaa8-6c49-c0860d1adbe0@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:43:02PM -0600, David Ahern wrote:
> On 4/18/23 10:41 AM, Leon Romanovsky wrote:
> > Hi,
> > 
> > I came to the following diff which eliminates the kernel panics,
> > unfortunately I can explain only second hunk, but first is required
> > too.
> > 
> > diff --git a/net/core/dst.c b/net/core/dst.c
> > index 3247e84045ca..750c8edfe29a 100644
> > --- a/net/core/dst.c
> > +++ b/net/core/dst.c
> > @@ -72,6 +72,8 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
> >         dst->flags = flags;
> >         if (!(flags & DST_NOCOUNT))
> >                 dst_entries_add(ops, 1);
> > +
> > +       INIT_LIST_HEAD(&dst->rt_uncached);
> 
> d288a162dd1c73507da582966f17dd226e34a0c0 moved rt_uncached from rt6_info
> and rtable to dst_entry. Only ipv4 and ipv6 usages initialize it. Since
> it is now in dst_entry, dst_init is the better place so it can be
> removed from rt_dst_alloc and rt6_info_init.

This is why I placed it there, but the rt_uncached list is initialized
in xfrm6 right before first call to rt6_uncached_list_add().

   70 static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
   71                           const struct flowi *fl)
   72 {
...
   92         INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
   93         rt6_uncached_list_add(&xdst->u.rt6);

My silly explanation is that xfrm6_dst_destroy() can be called before xfrm6_fill_dst().

Thanks

> 
