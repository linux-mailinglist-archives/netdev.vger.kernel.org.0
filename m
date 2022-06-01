Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C5539F7A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350750AbiFAI3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349252AbiFAI3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25824B861;
        Wed,  1 Jun 2022 01:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 513D3B81854;
        Wed,  1 Jun 2022 08:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AB1C385A5;
        Wed,  1 Jun 2022 08:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654072155;
        bh=1iXjC+c5NDksDK4JWBcsRyUMhftWpjNZ5o01WmkxYAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HAildSU/sq7Bgxx0sWq8pyb5IW7hO4kp1mXK9VDpSGGieB/7DZd6I8AvLt0YkEDB5
         +9cFXyLVug9Vm/WIEm8VnZNUT1z4Cq5kg6vxviY5FCRX+zYt+qLBnUkiDVvOmLyK5S
         Vg07weRxFj18FDJWZQi0lB1p2bS1+QR/pMOUgNmyRTu+bsRv+D/tdfQN1BzCCN+cV2
         efEexTSPtk+K5OXjyDx9LUL8ZJ2inc1V9RNShdvvit0zVWv85IWkYtNwak3eDwNJsp
         Te868s6mOvSqgnV87dZx3TlrTHQeRWEjOuELjgaBo7/vwhXdgF+CD8Y975G7UB7sz/
         TDqCVKcQG9zjg==
Date:   Wed, 1 Jun 2022 11:29:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, mcgrof@kernel.org, tytso@mit.edu,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: RFC: Ioctl v2
Message-ID: <YpcjVs/41EzAtr9k@unreal>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <Yof6hsC1hLiYITdh@lunn.ch>
 <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
 <20220521124559.69414fec@hermes.local>
 <20220525170233.2yxb5pm75dehrjuj@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525170233.2yxb5pm75dehrjuj@moria.home.lan>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 01:02:33PM -0400, Kent Overstreet wrote:
> On Sat, May 21, 2022 at 12:45:59PM -0700, Stephen Hemminger wrote:
> > On Sat, 21 May 2022 12:45:46 -0400
> > Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > 
> > > On Fri, May 20, 2022 at 10:31:02PM +0200, Andrew Lunn wrote:
> > > > > I want to circulate this and get some comments and feedback, and if
> > > > > no one raises any serious objections - I'd love to get collaborators
> > > > > to work on this with me. Flame away!  
> > > > 
> > > > Hi Kent
> > > > 
> > > > I doubt you will get much interest from netdev. netdev already
> > > > considers ioctl as legacy, and mostly uses netlink and a message
> > > > passing structure, which is easy to extend in a backwards compatible
> > > > manor.  
> > > 
> > > The more I look at netlink the more I wonder what on earth it's targeted at or
> > > was trying to solve. It must exist for a reason, but I've written a few ioctls
> > > myself and I can't fathom a situation where I'd actually want any of the stuff
> > > netlink provides.
> > 
> > Netlink was built for networking operations, you want to set something like a route with a large
> > number of varying parameters in one transaction. And you don't want to have to invent
> > a new system call every time a new option is added.
> > 
> > Also, you want to monitor changes and see these events for a userspace control
> > application such as a routing daemon.
> 
> That makes sense - perhaps the new mount API could've been done as a netlink
> interface :)
> 
> But perhaps it makes sense to have both - netlink for the big complicated
> stateful operations, ioctl v2 for the simpler ones. I haven't looked at netlink
> usage at all, but most of the filesystem ioctls I've looked at fall into the the
> simple bucket, for me.

In RDMA, we solved this thing (standard entry points, multiple
parameters and vendor specific data) by combining netlink and ioctls.

The entry point is done with ioctls (mainly performance reason, but not
only) while data is passed in netlink attributes style.

ib_uverbs_ioctl:
https://elixir.bootlin.com/linux/v5.18/source/drivers/infiniband/core/uverbs_ioctl.c#L605

Latest example of newly added global to whole stack command:
RDMA/uverbs: Add uverbs command for dma-buf based MR registration
https://lore.kernel.org/linux-rdma/1608067636-98073-4-git-send-email-jianxin.xiong@intel.com/

Thanks
