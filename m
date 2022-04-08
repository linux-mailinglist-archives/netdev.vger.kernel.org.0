Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE634F9D49
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiDHSxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiDHSxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:53:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106F71D306F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE4DB82D12
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D48C385A3;
        Fri,  8 Apr 2022 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649443856;
        bh=1wwQ4GbJRuoQW9mcfv+XLpZZuOm5o/ECPCLFvRqVa9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gxe8SxX//UdKtx9knENErPR0JBf/E2c20FBebys5in7T/ZWf5eT/grnCEnuTOvYp4
         Mc9tgk2DzqB0Pz33AOrKAYTY7ZH5KMBSu/KYiblRnmn5leNMIQotlIuUFcnuGBjZ1M
         BrrDH2OK87647xjtq/tixGN5tXqlkVqvSpeQYVU9wFhJmaSxqWgemrPGs9p8pGjf9U
         y4TVFZc/ou8safdbKzYtuzsa58Lif+zEffJ8mgMaZh17d0+eJjApy10RDRtXXYjTgh
         zOM8mAqA66Kop2oEyjKipcxar2Xm7ptRBXGuVp+UMOEbjkFqjtCsm9ogH8ji3bPSKd
         0XFQt4/wSiq/g==
Date:   Fri, 8 Apr 2022 11:50:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: What is the purpose of dev->gflags?
Message-ID: <20220408115054.7471233b@kernel.org>
In-Reply-To: <20220408183045.wpyx7tqcgcimfudu@skbuf>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 21:30:45 +0300 Vladimir Oltean wrote:
> Hello,
> 
> I am trying to understand why dev->gflags, which holds a mask of
> IFF_PROMISC | IFF_ALLMULTI, exists independently of dev->flags.
> 
> I do see that __dev_change_flags() (called from the ioctl/rtnetlink/sysfs
> code paths) updates the IFF_PROMISC and IFF_ALLMULTI bits of
> dev->gflags, while the direct calls to dev_set_promiscuity()/
> dev_set_allmulti() don't.
> 
> So at first I'd be tempted to say: IFF_PROMISC | IFF_ALLMULTI are
> exposed to user space when set in dev->gflags, hidden otherwise.
> This would be consistent with the implementation of dev_get_flags().
> 
> [ side note: why is that even desirable? why does it matter who made an
>   interface promiscuous as long as it's promiscuous? ]

Isn't that just a mechanism to make sure user space gets one "refcount"
on PROMISC and ALLMULTI, while in-kernel calls are tracked individually
in dev->promiscuity? User space can request promisc while say bridge
already put ifc into promisc mode, in that case we want promisc to stay
up even if ifc is unbridged. But setting promisc from user space
multiple times has no effect, since clear with remove it. Does that
help? 

> But in the process of digging deeper I stumbled upon Nicolas' commit
> 991fb3f74c14 ("dev: always advertise rx_flags changes via netlink")
> which I am still struggling to understand.
>
> There, a call to __dev_notify_flags(gchanges=IFF_PROMISC) was added to
> __dev_set_promiscuity(), called with "notify=true" from dev_set_promiscuity().
> In my understanding, "gchanges" means "changes to gflags", i.e. to what
> user space should know about. But as discussed above, direct calls to
> dev_set_promiscuity() don't update dev->gflags, yet user space is
> notified via rtmsg_ifinfo() of the promiscuity change.
> 
> Another oddity with Nicolas' commit: the other added call to
> __dev_notify_flags(), this time from __dev_set_allmulti().
> The logic is:
> 
> static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
> {
> 	unsigned int old_flags = dev->flags, old_gflags = dev->gflags;
> 
> 	dev->flags |= IFF_ALLMULTI;
> 
> 	(bla bla, stuff that doesn't modify dev->gflags)
> 
> 	if (dev->flags ^ old_flags) {
> 
> 		(bla bla, more stuff that doesn't modify dev->gflags)
> 
> 		if (notify)
> 			__dev_notify_flags(dev, old_flags,
> 					   dev->gflags ^ old_gflags);
> 					   ~~~~~~~~~~~~~~~~~~~~~~~~
> 					   oops, dev->gflags was never
> 					   modified, so this call to
> 					   __dev_notify_flags() is
> 					   effectively dead code, since
> 					   user space is not notified,
> 					   and a NETDEV_CHANGE netdev
> 					   notifier isn't emitted
> 					   either, since IFF_ALLMULTI is
> 					   excluded from that
> 	}
> 	return 0;
> }
> 
> Can someone please clarify what is at least the intention? As can be
> seen I'm highly confused.
> 
> Thanks.

