Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC45BD5C3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 22:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiISUjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiISUjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 16:39:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913D745F64;
        Mon, 19 Sep 2022 13:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9a5eFcihQUq7qy0i7HSgljUqDP86sFxHsEy34RhOaEc=; b=RgDwR82rK1dtGtdMvjGJDG0xb1
        jVNfbiEFzydQWYnJMbomUOd+PhU3g5fFQmPSoCDbh5zNig7MlRovJA8YLtgqzMhgPGOgo2W7f1/p7
        PmKNhLohVvohRGTrMCzlu/+CjDAzAIDS8F99YXE5RqJpjTbmYcEeUcSG5wllP0AHKNnI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaNXn-00HAtX-RS; Mon, 19 Sep 2022 22:39:07 +0200
Date:   Mon, 19 Sep 2022 22:39:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Nick Bowler <nbowler@draconx.ca>
Subject: Re: [PATCH] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
Message-ID: <YyjTa1qtt7kPqEaZ@lunn.ch>
References: <20220918215534.1529108-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220918215534.1529108-1-seanga2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 05:55:34PM -0400, Sean Anderson wrote:
> There is a separate receive path for small packets (under 256 bytes).
> Instead of allocating a new dma-capable skb to be used for the next packet,
> this path allocates a skb and copies the data into it (reusing the existing
> sbk for the next packet). There are two bytes of junk data at the beginning
> of every packet. I believe these are inserted in order to allow aligned
> DMA and IP headers. We skip over them using skb_reserve. Before copying
> over the data, we must use a barrier to ensure we see the whole packet. The
> current code only synchronizes len bytes, starting from the beginning of
> the packet, including the junk bytes. However, this leaves off the final
> two bytes in the packet. Synchronize the whole packet.
> 
> To reproduce this problem, ping a HME with a payload size between 17 and 214
> 
> 	$ ping -s 17 <hme_address>
> 
> which will complain rather loudly about the data mismatch. Small packets
> (below 60 bytes on the wire) do not have this issue. I suspect this is
> related to the padding added to increase the minimum packet size.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Hi Sean

> Patch-prefix: net

This should be in the Subject of the email. Various tools look for the
netdev tree there. Please try to remember that for future patches.

Please could you add a Fixes: tag indicating when the problem was
introduced. Its O.K. if that was when the driver was added. It just
helps getting the patch back ported to older stable kernels.

I think patchwork allows you to just reply to your post, and it will
automagically append the Fixes: tag when the Maintainer actually
applies the patch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
