Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24026682637
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjAaIQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAaIQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:16:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2503A863;
        Tue, 31 Jan 2023 00:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CF161444;
        Tue, 31 Jan 2023 08:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC07EC433D2;
        Tue, 31 Jan 2023 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675152980;
        bh=AkPDOVd/gg1SKXobAIz+HtMcU0f+kTBaQHdMYOgRlDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSJXjbqzB7zccvj+KzQsVicAgC4Urr2c8mQYJJ+oZgOMBlqnFHSeib3pNFtHtrU/W
         +EmEe8sPubiBUCiPmHfxPf8lF4DqYL/b2cfkcS7wNNnr9MIkJLyqekaC6W8Y8iuWny
         4QN2D/LrTb0mNWk6QMhxWTZQWmCKkQB7NhrXsJQzs29wEKlIy2en1ggi4HH5iaFr58
         dyNux7OG5lYjH1YkAY953u7as6sxNCt5rye2jkav4wJq35VtkDnZMg46W5C3d9S/Ij
         295I59HPrFkmu0QdU4mcMKrJDiYJeGLuy1QbtH9mOuAFHXKXyxvy6976x5YZxu1dFF
         ObaJKuCLsp+YA==
Date:   Tue, 31 Jan 2023 10:16:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Florian Fainelli <florian.fainelli@broadcom.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        maxime@cerno.tech, Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: bcmgenet: Add a check for oversized packets
Message-ID: <Y9jOT/SDYIkoryWb@unreal>
References: <20230127000819.3934-1-f.fainelli@gmail.com>
 <Y9Y/jMZZbS4HNpCC@unreal>
 <7cbbb800-9999-302a-5ea9-b93020a1e9e8@gmail.com>
 <Y9eXb+ZYanvxfq2E@unreal>
 <162b91f4-9334-4941-6d71-8bb9f47a0c12@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162b91f4-9334-4941-6d71-8bb9f47a0c12@broadcom.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 10:19:07AM -0800, Florian Fainelli wrote:
> On 1/30/23 02:09, Leon Romanovsky wrote:
> > On Sun, Jan 29, 2023 at 01:17:43PM -0800, Florian Fainelli wrote:
> > > 
> > > 
> > > On 1/29/2023 1:42 AM, Leon Romanovsky wrote:
> > > > On Thu, Jan 26, 2023 at 04:08:19PM -0800, Florian Fainelli wrote:
> > > > > Occasionnaly we may get oversized packets from the hardware which
> > > > > exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
> > > > > check which drops the packet to avoid invoking skb_over_panic() and move
> > > > > on to processing the next packet.
> > > > > 
> > > > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > > > ---
> > > > >    drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
> > > > >    1 file changed, 8 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > > > index 21973046b12b..d937daa8ee88 100644
> > > > > --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > > > +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > > > > @@ -2316,6 +2316,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
> > > > >    			  __func__, p_index, ring->c_index,
> > > > >    			  ring->read_ptr, dma_length_status);
> > > > > +		if (unlikely(len > RX_BUF_LENGTH)) {
> > > > > +			netif_err(priv, rx_status, dev, "oversized packet\n");
> > > > 
> > > > I don't think that it is wise move to print to dmesg something that can
> > > > be triggered by user over network.
> > > 
> > > A frame larger than RX_BUF_LENGTH intentionally received would be segmented
> > > by the MAC, we have seen this happen however while playing with unsafe clock
> > > ratios for instance or when there are insufficient credits given to the
> > > Ethernet MAC to write frames into DRAM. The print is consistent with other
> > > errors that are captured and is only enabled if the appropriate ethtool
> > > message level bitmask is set.
> > 
> > I saw other prints in that function, but you add new one.
> > Won't netif_err() be printed by default in almost all distro?
> 
> Do distributions alter the drive default message level:
> 
>   #define GENET_MSG_DEFAULT       (NETIF_MSG_DRV | NETIF_MSG_PROBE | \
>                                   NETIF_MSG_LINK)
> ?

Ohh, I didn't know about per-driver defaults.

Thanks for the explanation.

> -- 
> Florian
> 


