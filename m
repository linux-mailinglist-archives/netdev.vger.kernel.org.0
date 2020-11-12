Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51512B0C06
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKLR72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgKLR7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 12:59:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED55221D91;
        Thu, 12 Nov 2020 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605203964;
        bh=DrzPJU7X9mQG5qJGkraIwXGPVbKy/tkk8OIbI65fe6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=by1iYEFXNmpRlaCTCFEnUAM98NkarClMGMBJWaQUNGZ7AkqTKNfUEI278xHhYKmWU
         ADhFkUoqXvJH5XkmFpgvnZ+ndFJ2Aj7zxHw5iszq0oZ9tr0NADJfB4FBUXW51n/Jc7
         k+qPst9vT+/Aa8tVPnT8U4aPqR1F+BAaoJoY2PzY=
Date:   Thu, 12 Nov 2020 09:59:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net 0/2] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <20201112095922.5868d9a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <hjGOh0iCOYyo1FPiZh6TMXcx3YCgNs1T1eGKLrDz8@cp4-web-037.plabs.ch>
References: <hjGOh0iCOYyo1FPiZh6TMXcx3YCgNs1T1eGKLrDz8@cp4-web-037.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 20:44:08 +0000 Alexander Lobakin wrote:
> While testing UDP GSO fraglists forwarding through driver that uses
> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> iperf packets:
> 
> [ ID] Interval           Transfer     Bitrate         Jitter
> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
> 
> Simple switch to napi_gro_receive() or any other method without frag0
> shortcut completely resolved them.
> 
> I've found two incorrect header accesses in GRO receive callback(s):
>  - udp_hdr() (instead of udp_gro_udphdr()) that always points to junk
>    in "fast" mode and could probably do this in "regular".
>    This was the actual bug that caused all out-of-order delivers;
>  - udp{4,6}_lib_lookup_skb() -> ip{,v6}_hdr() (instead of
>    skb_gro_network_header()) that potentionally might return odd
>    pointers in both modes.
> 
> Each patch addresses one of these two issues.
> 
> This doesn't cover a support for nested tunnels as it's out of the
> subject and requires more invasive changes. It will be handled
> separately in net-next series.

Applied, thanks!
