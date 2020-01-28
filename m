Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFDC14CEB7
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgA2Q6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:58:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgA2Q6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 11:58:46 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0ADF14F0D033;
        Wed, 29 Jan 2020 08:58:44 -0800 (PST)
Date:   Tue, 28 Jan 2020 10:59:09 +0100 (CET)
Message-Id: <20200128.105909.2133255162840958859.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, willemb@google.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] udp: segment looped gso packets correctly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com>
References: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 08:58:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 27 Jan 2020 15:40:31 -0500

> From: Willem de Bruijn <willemb@google.com>
> 
> Multicast and broadcast packets can be looped from egress to ingress
> pre segmentation with dev_loopback_xmit. That function unconditionally
> sets ip_summed to CHECKSUM_UNNECESSARY.
> 
> udp_rcv_segment segments gso packets in the udp rx path. Segmentation
> usually executes on egress, and does not expect packets of this type.
> __udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
> the offsets are not correct for gso_make_checksum.
> 
> UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
> to the correct pseudo header checksum. Reset ip_summed to this type.
> (CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, but I have to say:

> +	if (skb->pkt_type == PACKET_LOOPBACK)
> +		skb->ip_summed = CHECKSUM_PARTIAL;
> +

There are a lot of implementation detail assumptions encoded into that
conditional statement :-)

Feel free to follow-up with a patch adding a comment containing a
condensed version of your commit log here.

Thanks.
