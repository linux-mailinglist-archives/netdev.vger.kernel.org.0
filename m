Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C294F94E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 02:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfFWAHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 20:07:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFWAHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 20:07:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A9D91540C186;
        Sat, 22 Jun 2019 17:07:13 -0700 (PDT)
Date:   Sat, 22 Jun 2019 17:07:12 -0700 (PDT)
Message-Id: <20190622.170712.2073255657139689928.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: fix neighbour resolution with raw socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
References: <20190620123434.7219-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 17:07:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 20 Jun 2019 14:34:34 +0200

> The scenario is the following: the user uses a raw socket to send an ipv6
> packet, destinated to a not-connected network, and specify a connected nh.
> Here is the corresponding python script to reproduce this scenario:
 ...
> fd00:175::/64 is a connected route and fd00:200::fa is not a connected
> host.
> 
> With this scenario, the kernel starts by sending a NS to resolve
> fd00:175::2. When it receives the NA, it flushes its queue and try to send
> the initial packet. But instead of sending it, it sends another NS to
> resolve fd00:200::fa, which obvioulsy fails, thus the packet is dropped. If
> the user sends again the packet, it now uses the right nh (fd00:175::2).
> 
> The problem is that ip6_dst_lookup_neigh() uses the rt6i_gateway, which is
> :: because the associated route is a connected route, thus it uses the dst
> addr of the packet. Let's use rt6_nexthop() to choose the right nh.
> 
> Note that rt and in6addr_any are const in ip6_dst_lookup_neigh(), thus
> let's constify rt6_nexthop() to avoid ugly cast.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied and queued up for -stable, thanks.
