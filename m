Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D55292C70
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgJSRP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbgJSRP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:15:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556CE208B3;
        Mon, 19 Oct 2020 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603127757;
        bh=1r7FJNOlQi+D2PYDhxnkwdmwaf5e4OghjY06cClKrwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e6ziEi8ZEGxWbn6seamf/3dtKuMyD1XmIjSIbHJT+UaL2/FBpnDWXhSHoPuw1NCFC
         eYxrITejYbUrzLqbovvVuYYVLCdX6x7phOrSbswvT58dkrkTRtotEfjT/Ccby+GGDi
         tRlR2tKHG3eNInAfx4BgnvXPykLwFRXbaWH0hW7A=
Date:   Mon, 19 Oct 2020 10:15:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "zhudi (J)" <zhudi21@huawei.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Message-ID: <20201019101555.64b9f723@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0DCA8173C37AD8458D6BA40EB0C660918CA689@DGGEMI532-MBX.china.huawei.com>
References: <0DCA8173C37AD8458D6BA40EB0C660918CA689@DGGEMI532-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 01:59:19 +0000 zhudi (J) wrote:
> > zhudi, why not use size_t? Seems like the most natural fit for counting size.  
> 
> Thanks for your replying.
> min_dump_alloc original type used is u16 and it's eventually assigned to 
> struct netlink_callback{}. min_dump_alloc which data type is u32. So I just simply
> promote to u32.
> Should be used size_t instead of u32?

I had a closer look, and I agree that u32 should be fine in struct
netlink_dump_control, rtnetlink_rcv_msg(), and as a return value from
rtnl_calcit().

But please use size_t for the local variable in rtnl_calcit().
This way you can convert the max_t() to a max().

When you send v2 please move the declaration of min_ifinfo_dump_size
after struct net *net = sock_net(skb->sk); (to get closer to longest 
to shortest declaration order).
