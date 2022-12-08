Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113F5646A5B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLHIWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHIWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:22:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965485654F
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:22:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50145B821E9
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BA1C433C1;
        Thu,  8 Dec 2022 08:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670487734;
        bh=+BMTesfk6g8a9oDIiHsYBfgN7X/t6tRZyeH3WORCJOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tMX1P/34/QnDQxaWtLtYfK8bzw+jlj6XjTycBNUI82jbirCt/Bfx2qCxwoRZUhS1O
         lSF0iPSlj0pcy1+9hIZAa0x0O+Aj7clJqvcNpshch40ZG1HJnxG49989yyrB7LtZNs
         QzYP4HQoTpTYDS966FKzzLPiUoBumUN89z6J+Yw0ahCuUG2IY0C/Ufkjo4hSBJRV2Q
         zApdG5jEc2XLmN/QgYtmo3IYMqP6tZ+MYnYuyzlOuP2obmp6hpwROLbkdX44EA92Sc
         m2SUUafeJK7ykpBqRp1gwpqr2pg0taHX1rK66JLGvzzX6DNeZYPeAReBEmXmexpjxU
         DaZLA6vySL4Gg==
Date:   Thu, 8 Dec 2022 10:22:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <Y5GesjGvi+Gtj+Dq@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
 <Y4yPwR2vBSepDNE+@unreal>
 <20221204153850.42640ac2@kernel.org>
 <Y42hg4MsATH/07ED@unreal>
 <20221206161441.ziprba72sfydmjrk@lion.mk-sys.cz>
 <Y5BR/n7/rqQ+q8gm@unreal>
 <20221207093248.x6dwbcdxkgaqb6zh@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093248.x6dwbcdxkgaqb6zh@lion.mk-sys.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 10:32:48AM +0100, Michal Kubecek wrote:
> On Wed, Dec 07, 2022 at 10:42:38AM +0200, Leon Romanovsky wrote:
> > On Tue, Dec 06, 2022 at 05:14:41PM +0100, Michal Kubecek wrote:
> > > 
> > >   - avoiding the inherently racy get/modify/set cycle
> > 
> > How? IMHO, it is achieved in netlink by holding relevant locks, it can
> > be rtnl lock or specific to that netlink interface lock (devl). You cam
> > and should have same locking protection for legacy flow as well.
> 
> What I had in mind is changing only one (or few) of the parameters which
> are passed in a structure via ioctl interface, i.e. commands like
> 
>   ethtool -G eth0 rx 2048
> 
> To do that with ioctl interface, userspace needs to fetch the whole
> ethtool_ringparam structure with ETHTOOL_GRINGPARAM first, modify its
> rx_pending member and pass the structure back with ETHTOOL_SRINGPARAM.
> Obviously you cannot hold a kernel lock over multiple ioctl() syscall.

Kernel historically doesn't have protection from user space races,
which is what you presented here. Netlink gives you feature flags
over specific fields, which you can achieve over ioctl too.

Anyway, I see your point.

> 
> In some cases, there is a special with "no change" meaning but that is
> rather an exception. It would be possible to work around the problem
> using some "version counter" that would kernel check against its own
> (and reject the update if they do not match) but introducing that would
> also be a backward incompatible change.

Another options is to build netlink over ioctl. See as an example RDMA ioctl
interface (ib_uverbs_ioctl ...) which in nutshell is netlink over ioctl. After
long debates, we choose ioctl, because of need to have synchronous and reliable
interface to configure system. But we liked TLV structure of netlink, so used it.

Thanks

> 
> Michal
