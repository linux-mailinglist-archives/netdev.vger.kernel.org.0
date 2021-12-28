Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A070048059E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 03:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhL1CCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 21:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbhL1CCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 21:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4BAC06173E;
        Mon, 27 Dec 2021 18:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B8F661176;
        Tue, 28 Dec 2021 02:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931CEC36AE7;
        Tue, 28 Dec 2021 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640656940;
        bh=Kz3Bxt5Z3+1YHPo4DjVUyv4u1DjPp6OvGAbKjOAqk70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aHhqsxSeT5n7aPjArul/O1Hrlq980tL44vQrtc2jJb3/ENVxHVDirZEtxFkJcRr2W
         +APYRmVnSaGaWi0t3XN/Q5ighoGGUGcxafwRXPwzVyLC3Ng9BFo/BA4mdw9Sn6zo/3
         VD/LxDHcCBBdKPByPXzICLJvUdRQIpcomUCh+u3t0f6u+B7hamIglX/tde7LA9d2lU
         oMPTlQ9Kv22563UftoxOQ56FfHw7blP1xgK6H8h83X4Ktwa6uzcmtFU3+W3aYS4gF1
         L5vJiZ+1zs78R/HXmssofn8RNV9jrNKnPKcLJYbSMPnSnq71It3lmMuSZsWIO6hqLJ
         VYvNriaLw+dYA==
Date:   Mon, 27 Dec 2021 18:02:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: remove judgement based on gfp_flags
Message-ID: <20211227180219.4fdaaeca@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAGWkznEOsLweqA3omJ+xMs4bWvyphSvKBQmqPs+rer_e5fqKHg@mail.gmail.com>
References: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com>
        <20211223091100.4a86188f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAGWkznHcjrM2kth8uWtuu+H-LOdPGXAN70nBYJax7aqcuHkECg@mail.gmail.com>
        <CAGWkznEOsLweqA3omJ+xMs4bWvyphSvKBQmqPs+rer_e5fqKHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Dec 2021 15:38:31 +0800 Zhaoyang Huang wrote:
> On Mon, Dec 27, 2021 at 2:14 PM Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:
> > On Fri, Dec 24, 2021 at 1:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > This is checking if we can sleep AFAICT. What are you trying to fix?
> > Yes and NO. gfp means *get free pages* which indicate if the embedded
> > memory allocation among the process can sleep or not, but without any
> > other meanings. The driver which invokes this function could have to
> > use GFP_KERNEL for allocating memory as the critical resources but
> > don't want to sleep on the netlink's congestion.

Let's focus on explaining the problem you're trying to solve.
What's the driver you're talking about? Why does it have to
pay attention to the innards of netlink? Details, please.

> Since unique block flags(msg_flags & MSG_DONTWAIT) work as parameters
> for unicast, could we introduce it to broadcast, instead of abusing
> gfp_flag.
> 
>  static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  {
> ...
>          if (dst_group) {
>                  refcount_inc(&skb->users);
>                  netlink_broadcast(sk, skb, dst_portid, dst_group, GFP_KERNEL);
>          }
>          err = netlink_unicast(sk, skb, dst_portid, msg->msg_flags & MSG_DONTWAIT);
