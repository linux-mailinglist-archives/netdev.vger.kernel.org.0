Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E55E28AF
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392867AbfJXDNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:13:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390576AbfJXDNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:13:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E965614B7A0A3;
        Wed, 23 Oct 2019 20:13:51 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:13:49 -0700 (PDT)
Message-Id: <20191023.201349.2219793662782169980.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jonathann1@walla.com, aksecurity@gmail.com, benny@pinkas.net,
        tom@herbertland.com
Subject: Re: [PATCH net] net/flow_dissector: switch to siphash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022145746.4966-1-edumazet@google.com>
References: <20191022145746.4966-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 20:13:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Oct 2019 07:57:46 -0700

> UDP IPv6 packets auto flowlabels are using a 32bit secret
> (static u32 hashrnd in net/core/flow_dissector.c) and
> apply jhash() over fields known by the receivers.
> 
> Attackers can easily infer the 32bit secret and use this information
> to identify a device and/or user, since this 32bit secret is only
> set at boot time.
> 
> Really, using jhash() to generate cookies sent on the wire
> is a serious security concern.
> 
> Trying to change the rol32(hash, 16) in ip6_make_flowlabel() would be
> a dead end. Trying to periodically change the secret (like in sch_sfq.c)
> could change paths taken in the network for long lived flows.
> 
> Let's switch to siphash, as we did in commit df453700e8d8
> ("inet: switch IP ID generator to siphash")
> 
> Using a cryptographically strong pseudo random function will solve this
> privacy issue and more generally remove other weak points in the stack.
> 
> Packet schedulers using skb_get_hash_perturb() benefit from this change.
> 
> Fixes: b56774163f99 ("ipv6: Enable auto flow labels by default")
> Fixes: 42240901f7c4 ("ipv6: Implement different admin modes for automatic flow labels")
> Fixes: 67800f9b1f4e ("ipv6: Call skb_get_hash_flowi6 to get skb->hash in ip6_make_flowlabel")
> Fixes: cb1ce2ef387b ("ipv6: Implement automatic flow label generation on transmit")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Berger <jonathann1@walla.com>
> Reported-by: Amit Klein <aksecurity@gmail.com>
> Reported-by: Benny Pinkas <benny@pinkas.net>

Applied and queued up for -stable, thanks Eric.
