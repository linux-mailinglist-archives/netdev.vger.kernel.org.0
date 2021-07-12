Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE5E3C5F35
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhGLP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235535AbhGLP0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:26:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6C161004;
        Mon, 12 Jul 2021 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626103411;
        bh=Km7m+sMQrXP7DqjWyUl0Sw4r+oGeea3llqP9YuC7F1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZbKQct6/fvCdcbAfPcsZztVg7l7wnJYtQUhX5vWWG+uK7y1vMNck8UR4giBXKiDK8
         Hg0TAZqe0uruqthQqo0pYtQLX7ld+jdNZRI677KHh9PavDcIwyVkqFAQs6VV2OPleB
         z/Vk53CzazpHABZakqNsULfOFB9liUy5QVaCku/3LFRvyk273qVZfBTPX5Z5vVg9/2
         DP46T5nVPOQHZMFGvaJfLU2gFusP3rZ2907vYGKkIfZxIO+nPGRPYu16YgMV3cEbCB
         ghMNeDEiYZyu5HheOotRUoIrgfzEzpw8orw1tnp5S6LBw4thqDloBLOWBpn3T1Bno2
         7e0RupvsLXGRA==
Date:   Mon, 12 Jul 2021 08:23:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, toke@redhat.com
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
Message-ID: <20210712082330.12c2a7c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <26432bbc3556fd23bd58f6d359395e5dfa2eaf8c.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
        <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
        <20210709125431.3597a126@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f99875f7-c8c2-7a33-781c-a131d4b35273@gmail.com>
        <26432bbc3556fd23bd58f6d359395e5dfa2eaf8c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 12:45:13 +0200 Paolo Abeni wrote:
> On Sun, 2021-07-11 at 19:44 -0600, David Ahern wrote:
> > On 7/9/21 1:54 PM, Jakub Kicinski wrote:  
> > > Ah damn, I must have missed the get_channels being added. I believe the
> > > correct interpretation of the params is rx means NAPI with just Rx
> > > queue(s), tx NAPI with just Tx queue(s) and combined has both.
> > > IOW combined != min(rx, tx).
> > > Instead real_rx = combined + rx; real_tx = combined + tx.
> > > Can we still change this?  
> > 
> > Is it not an 'either' / 'or' situation? ie., you can either control the
> > number of Rx and Tx queues or you control the combined value but not
> > both. That is what I recall from nics (e.g., ConnectX).  
> 
> Thanks for the feedback. My understanding was quite alike what David
> stated - and indeed that is what ConnectX enforces AFAICS. Anyhow the
> core ethtool code allows for what Jackub said, so I guess I need to
> deal with that.

I thought Mellanox was doing something funny to reuse the rx as the
number of AF_XDP queues. Normal rings are not reported twice, they're
only reported as combined.

ethtool man page is relatively clear, unfortunately the kernel code 
is not and few read the man page. A channel is approximately an IRQ, 
not a queue, and IRQ can't be dedicated and combined simultaneously:

 "A channel is an IRQ and the set of queues that can trigger that IRQ."

 " rx N   Changes the number of channels with only receive queues."

> @Jakub: if we are still on time about changing the veth_get_channel()
> exposed behaviour, what about just showing nr combined == 0 and
> enforcing comined_max == 0? that would both describe more closely the
> veth architecture and will make the code simpler - beyond fixing the
> current uncorrect nr channels report.

SGTM.
