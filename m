Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3049DE6F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiA0Juh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiA0Jug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:50:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59A1C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 01:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B556B8220C
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B182C340E4;
        Thu, 27 Jan 2022 09:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643277033;
        bh=9Qp2wZxmtf4fmNFWQUzF7YCHq9LIF9GGUNw8EtmqXRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IyaiP9TbIo19yMWkPpXnTD1PeJjRzlDJt+u8bl9lWqabupVTN2xhSxSqAjoZmXyiT
         2bBS5B4JkRp0vPqXvylBgp0dbPsjx2PK6k4GugHf6lgqY4as1hnUNYyAR0FDifmeFj
         jqH3owOy3Xo1jZDMe4v3GdhudFzkxXmICxTeWAXPUXOFWJbDAzExKN8KVsQ/GWFddN
         Opo3xuAhBR+biOZx/1p4CGJc5RUzKHjghWbDHTpAHkzoTWb+n5zvNEzA9jFg5stNjO
         8WuvLqi704yXzYoG+3Td4JebMWi2p/u8s2UDXRTGQWAsiY1egpv+NDsQiYub1N3Rm1
         D3tBAP0522kgA==
Date:   Thu, 27 Jan 2022 11:50:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Message-ID: <YfJq5IEsW8oSj46B@unreal>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <YfJi10IcxtYQ7Ttr@unreal>
 <f49d8f3f-f9e9-574f-f41b-01d35a0a1b03@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f49d8f3f-f9e9-574f-f41b-01d35a0a1b03@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 05:40:02PM +0800, shenjian (K) wrote:
> 
> 
> 在 2022/1/27 17:16, Leon Romanovsky 写道:
> > On Wed, Sep 29, 2021 at 11:50:47PM +0800, Jian Shen wrote:
> > > For the prototype of netdev_features_t is u64, and the number
> > > of netdevice feature bits is 64 now. So there is no space to
> > > introduce new feature bit.
> > > 
> > > This patchset try to solve it by change the prototype of
> > > netdev_features_t from u64 to bitmap. With this change,
> > > it's necessary to introduce a set of bitmap operation helpers
> > > for netdev features. Meanwhile, the functions which use
> > > netdev_features_t as return value are also need to be changed,
> > > return the result as an output parameter.
> > > 
> > > With above changes, it will affect hundreds of files, and all the
> > > nic drivers. To make it easy to be reviewed, split the changes
> > > to 167 patches to 5 parts.
> > > 
> > > patch 1~22: convert the prototype which use netdev_features_t
> > > as return value
> > > patch 24: introduce fake helpers for bitmap operation
> > > patch 25~165: use netdev_feature_xxx helpers
> > > patch 166: use macro __DECLARE_NETDEV_FEATURE_MASK to replace
> > > netdev_feature_t declaration.
> > > patch 167: change the type of netdev_features_t to bitmap,
> > > and rewrite the bitmap helpers.
> > > 
> > > Sorry to send a so huge patchset, I wanna to get more suggestions
> > > to finish this work, to make it much more reviewable and feasible.
> > > 
> > > The former discussing for the changes, see [1]
> > > [1]. https://www.spinics.net/lists/netdev/msg753528.html
> > > 
> > ------------------------------------------------
> > 
> > Is anyone actively working on this task?
> > 
> > Thanks
> > .
> Hi Leon,
> 
> I have sent RFCv4  [1] three months ago, and according Andrew' suggestion，
> I'm trying to
> continue this work with semantic-patches, and waiting for more comments
> for the scheme.
> But I'm not familiar with it, and  busy with some other work recently, so it
> got delayed.
> 
> Sorry for this. I will speed up it.

Thanks

> 
> [1] https://lore.kernel.org/netdev/YYvKyruLcemj6J+i@lunn.ch/T/
> 
> Thanks
> 
> 
