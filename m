Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB60624C8C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiKJVHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKJVH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:07:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0C857B5B;
        Thu, 10 Nov 2022 13:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B41461E60;
        Thu, 10 Nov 2022 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39865C433D6;
        Thu, 10 Nov 2022 21:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668114446;
        bh=SvL0tC1tE3nUW82Ug4o+iFeGBWUfd1ASGwxtRRbRBIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6yt9egAXwk6xG2LbJRgSeQmEklIyWZA5SD6g3i1mbm/msswMh+cNIlufSBE1fnEP
         IR8NXRPq/4lBDssPB1ryholDBQqqVPgD0B8e/AesPMnTanXCPFU8xi2brMcWnulkzp
         lw+FsY5Gmj/CisaT3DjixrbxKgA53rk3HLi+Bnb8hGVMMBA+cDeYCr332lSbl41UxO
         uytQUD8vnYD8xdCha3JHV2fftWkXYlsO4yb7fEwxnhDgaobuF3LNZ5bWVxk1UT59/h
         M5K2hQ0mwVjh2h7PIqFEdDT4TkfdhjKVcUC8VV4DgQeNqAltlxc+QodOyapY4K2qVL
         Edpf9kQpRmwqA==
Date:   Thu, 10 Nov 2022 23:07:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ivan Vecera <ivecera@redhat.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Message-ID: <Y21oCUjEHEMr9HGb@unreal>
References: <20221108102502.2147389-1-ivecera@redhat.com>
 <Y2vvbwkvAIOdtZaA@unreal>
 <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20221110155147.1a2c57f6@p1.luc.cera.cz>
 <Y20vtqd6raqg8iwy@unreal>
 <20221110122418.32414666@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110122418.32414666@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 12:24:18PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 19:07:02 +0200 Leon Romanovsky wrote:
> > > > Yes I think you're right. A ton of people check it without the
> > > > lock but I think thats not strictly safe. Is dev_close safe to
> > > > call when netif_running is false? Why not just remove the check
> > > > and always call dev_close then.
> > > 
> > > Check for a bit value (like netif_runnning()) is much cheaper than
> > > unconditionally taking global lock like RTNL.  
> > 
> > This cheap operation is racy and performed in non-performance
> > critical path.
> 
> To be clear - the rtnl_lock around the entire if is still racy 
> in the grand scheme of things, no? What's stopping someone from
> bringing the device right back up after you drop the lock?

I want to believe what there is some sort of state machine that won't
allow simple toggling of dev_close/dev_open. If it doesn't, rtnl_lock
users should audit their code for possible toggling right after that
lock is dropped.

Anyway, this discussion reminds me our devl_lock debate where we had
completely opposite views if rtnl_lock model is the right one.
https://lore.kernel.org/netdev/20211101073259.33406da3@kicinski-fedora-PC1C0HJN/

Let's not start argue again, we had enough back then. :)

Thanks
