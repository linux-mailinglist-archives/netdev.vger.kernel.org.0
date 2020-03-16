Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8D186792
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgCPJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:13:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgCPJNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:13:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4139C1475D3BB;
        Mon, 16 Mar 2020 02:13:15 -0700 (PDT)
Date:   Mon, 16 Mar 2020 02:13:14 -0700 (PDT)
Message-Id: <20200316.021314.2124785837023809696.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     vincent@bernat.ch, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, kafai@fb.com
Subject: Re: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for
 non-root users
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a2d2b020-c2a7-5efa-497e-44eff651b9ce@gmail.com>
References: <20200315155910.3262015-1-vincent@bernat.ch>
        <20200315.170231.388798443331914470.davem@davemloft.net>
        <a2d2b020-c2a7-5efa-497e-44eff651b9ce@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 02:13:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Sun, 15 Mar 2020 20:36:10 -0600

> As a reminder, there are currently 3 APIs to specify a preferred device
> association which influences route lookups:
> 
> 1. SO_BINDTODEVICE - sets sk_bound_dev_if and is the strongest binding
> (ie., can not be overridden),
> 
> 2. IP_UNICAST_IF / IPV6_UNICAST_IF - sets uc_index / ucast_oif and is
> sticky for a socket, and
> 
> 3. IP_PKTINFO / IPV6_PKTINFO - which is per message.
> 
> The first, SO_BINDTODEVICE, requires root privileges. The last 2 do not
> require root privileges but only apply to raw and UDP sockets making TCP
> the outlier.
> 
> Further, a downside to the last 2 is that they work for sendmsg only;
> there is no way to definitively match a response to the sending socket.
> The key point is that UDP and raw have multiple non-root APIs to dictate
> a preferred device for sending messages.
> 
> Vincent's patch simplifies things quite a bit - allowing consistency
> across the protocols and directions - but without overriding any
> administrator settings (e.g., inherited bindings via ebpf programs).

Understood, but I still wonder if this mis-match of privilege
requirements was by design or unintentional.

Allowing arbitrary users to specify SO_BINDTODEVICE has broad and far
reaching consequences, so at a minimum if we are going to remove the
restriction we should at least discuss the implications.
