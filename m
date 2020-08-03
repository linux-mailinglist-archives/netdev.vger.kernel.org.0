Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA39B23B08D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgHCW6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCW6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:58:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1928FC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:58:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 61A6312779168;
        Mon,  3 Aug 2020 15:41:50 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:58:35 -0700 (PDT)
Message-Id: <20200803.155835.1186341109955245993.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, dsahern@gmail.com
Subject: Re: [PATCH net v2] net: bridge: clear skb private space on bridge
 dev xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802125039.648571-1-nikolay@cumulusnetworks.com>
References: <39736ed8-8565-ab64-5163-da6f2acba68a@cumulusnetworks.com>
        <20200802125039.648571-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:41:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Sun,  2 Aug 2020 15:50:39 +0300

> We need to clear all of the bridge private skb variables as they can be
> stale due to the packet having skb->cb initialized earlier and then
> transmitted through the bridge device. Similar memset is already done on
> bridge's input. We've seen cases where proxyarp_replied was 1 on routed
> multicast packets transmitted through the bridge to ports with neigh
> suppress and were getting dropped. Same thing can in theory happen with the
> port isolation bit as well. We clear only the struct part after the bridge
> pointer (currently 8 bytes) since the pointer is always set later.
> We can now remove the redundant zeroing of frag_max_size.
> Also add a BUILD_BUG_ON to make sure we catch any movement of the bridge
> dev pointer.
> 
> Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Nikolay, I applied v1 already as I'm not at all against the full clear.
