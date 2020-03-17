Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753B9187767
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733149AbgCQBXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:23:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732939AbgCQBXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:23:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75A63157A57EB;
        Mon, 16 Mar 2020 18:23:01 -0700 (PDT)
Date:   Mon, 16 Mar 2020 18:22:58 -0700 (PDT)
Message-Id: <20200316.182258.413140208556936738.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        cmclachlan@solarflare.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, sameehj@amazon.com
Subject: Re: [PATCH net-next] sfc: fix XDP-redirect in this driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158410589474.499645.16292046086222118891.stgit@firesoul>
References: <158410589474.499645.16292046086222118891.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 18:23:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 13 Mar 2020 14:25:19 +0100

> XDP-redirect is broken in this driver sfc. XDP_REDIRECT requires
> tailroom for skb_shared_info when creating an SKB based on the
> redirected xdp_frame (both in cpumap and veth).
> 
> The fix requires some initial explaining. The driver uses RX page-split
> when possible. It reserves the top 64 bytes in the RX-page for storing
> dma_addr (struct efx_rx_page_state). It also have the XDP recommended
> headroom of XDP_PACKET_HEADROOM (256 bytes). As it doesn't reserve any
> tailroom, it can still fit two standard MTU (1500) frames into one page.
> 
> The sizeof struct skb_shared_info in 320 bytes. Thus drivers like ixgbe
> and i40e, reduce their XDP headroom to 192 bytes, which allows them to
> fit two frames with max 1536 bytes into a 4K page (192+1536+320=2048).
> 
> The fix is to reduce this drivers headroom to 128 bytes and add the 320
> bytes tailroom. This account for reserved top 64 bytes in the page, and
> still fit two frame in a page for normal MTUs.
> 
> We must never go below 128 bytes of headroom for XDP, as one cacheline
> is for xdp_frame area and next cacheline is reserved for metadata area.
> 
> Fixes: eb9a36be7f3e ("sfc: perform XDP processing on received packets")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> Targetted net-next as this is part of a patchset for adding XDP frame
> size and reserving tailroom for multi-buffer XDP

Applied, thanks Jesper.
