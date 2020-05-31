Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75731E95B9
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgEaEwp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 31 May 2020 00:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaEwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:52:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A99C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:52:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 678A3128FE1E8;
        Sat, 30 May 2020 21:52:44 -0700 (PDT)
Date:   Sat, 30 May 2020 21:52:43 -0700 (PDT)
Message-Id: <20200530.215243.413220351888088239.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net] sch_cake: Take advantage of skb->hash where
 appropriate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529124344.355785-1-toke@redhat.com>
References: <20200529124344.355785-1-toke@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:52:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri, 29 May 2020 14:43:44 +0200

> While the other fq-based qdiscs take advantage of skb->hash and doesn't
> recompute it if it is already set, sch_cake does not.
> 
> This was a deliberate choice because sch_cake hashes various parts of the
> packet header to support its advanced flow isolation modes. However,
> foregoing the use of skb->hash entirely loses a few important benefits:
> 
> - When skb->hash is set by hardware, a few CPU cycles can be saved by not
>   hashing again in software.
> 
> - Tunnel encapsulations will generally preserve the value of skb->hash from
>   before the encapsulation, which allows flow-based qdiscs to distinguish
>   between flows even though the outer packet header no longer has flow
>   information.
> 
> It turns out that we can preserve these desirable properties in many cases,
> while still supporting the advanced flow isolation properties of sch_cake.
> This patch does so by reusing the skb->hash value as the flow_hash part of
> the hashing procedure in cake_hash() only in the following conditions:
> 
> - If the skb->hash is marked as covering the flow headers (skb->l4_hash is
>   set)
> 
> AND
> 
> - NAT header rewriting is either disabled, or did not change any values
>   used for hashing. The latter is important to match local-origin packets
>   such as those of a tunnel endpoint.
> 
> The immediate motivation for fixing this was the recent patch to WireGuard
> to preserve the skb->hash on encapsulation. As such, this is also what I
> tested against; with this patch, added latency under load for competing
> flows drops from ~8 ms to sub-1ms on an RRUL test over a WireGuard tunnel
> going through a virtual link shaped to 1Gbps using sch_cake. This matches
> the results we saw with a similar setup using sch_fq_codel when testing the
> WireGuard patch.
> 
> Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied to net-next, thanks.
