Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAAEFF5AB
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfKPVBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:01:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:01:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1578151A15F1;
        Sat, 16 Nov 2019 13:01:01 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:01:01 -0800 (PST)
Message-Id: <20191116.130101.268806870571558138.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: allow fast GRO for skbs with
 Ethernet header in head
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115091135.13487-1-alobakin@dlink.ru>
References: <20191115091135.13487-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:01:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Fri, 15 Nov 2019 12:11:35 +0300

> Commit 78d3fd0b7de8 ("gro: Only use skb_gro_header for completely
> non-linear packets") back in May'09 (v2.6.31-rc1) has changed the
> original condition '!skb_headlen(skb)' to
> 'skb->mac_header == skb->tail' in gro_reset_offset() saying: "Since
> the drivers that need this optimisation all provide completely
> non-linear packets" (note that this condition has become the current
> 'skb_mac_header(skb) == skb_tail_pointer(skb)' later with commmit
> ced14f6804a9 ("net: Correct comparisons and calculations using
> skb->tail and skb-transport_header") without any functional changes).
> 
> For now, we have the following rough statistics for v5.4-rc7:
> 1) napi_gro_frags: 14
> 2) napi_gro_receive with skb->head containing (most of) payload: 83
> 3) napi_gro_receive with skb->head containing all the headers: 20
> 4) napi_gro_receive with skb->head containing only Ethernet header: 2
> 
> With the current condition, fast GRO with the usage of
> NAPI_GRO_CB(skb)->frag0 is available only in the [1] case.
> Packets pushed by [2] and [3] go through the 'slow' path, but
> it's not a problem for them as they already contain all the needed
> headers in skb->head, so pskb_may_pull() only moves skb->data.
> 
> The layout of skbs in the fourth [4] case at the moment of
> dev_gro_receive() is identical to skbs that have come through [1],
> as napi_frags_skb() pulls Ethernet header to skb->head. The only
> difference is that the mentioned condition is always false for them,
> because skb_put() and friends irreversibly alter the tail pointer.
> They also go through the 'slow' path, but now every single
> pskb_may_pull() in every single .gro_receive() will call the *really*
> slow __pskb_pull_tail() to pull headers to head. This significantly
> decreases the overall performance for no visible reasons.
 ...
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Applied to net-next, thanks.
