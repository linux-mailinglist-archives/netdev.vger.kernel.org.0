Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7761E5F1388
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiI3UUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiI3UUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:20:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AEB3AB10;
        Fri, 30 Sep 2022 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HVFeev+r4ciAxUb+L8nvnXlf+hUS/MMkb8+sfY/tSPg=; b=WT0DH79vR5MYl3Pz2SmQjXQDMU
        243BGW/7yFek7ee8PqwJLil1W6xgSFwtSa03yP+uBB4hVWovfuQQaTO6l7oe166HLrx2HCPYaQ68I
        lfBSKzQQGhMLUjLFbtsYuVrHSqJLPJ3yBfal0iwS0OOTMDV96kc9C4wHwn8No+5zAea0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeMUa-000k1l-46; Fri, 30 Sep 2022 22:20:16 +0200
Date:   Fri, 30 Sep 2022 22:20:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX
 buffers
Message-ID: <YzdPgL1ghbyp3ypv@lunn.ch>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
 <YzdL7EbnULEA75/s@lunn.ch>
 <PAXPR04MB91850A034871650CB6C4F86D89569@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB91850A034871650CB6C4F86D89569@PAXPR04MB9185.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 08:07:55PM +0000, Shenwei Wang wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Friday, September 30, 2022 3:05 PM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> > Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev
> > Subject: [EXT] Re: [PATCH 1/1] net: fec: using page pool to manage RX buffers
> > 
> > Caution: EXT Email
> > 
> > > -static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> > > -                            struct bufdesc *bdp, u32 length, bool swap)
> > > +static bool __maybe_unused
> > > +fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> > > +                struct bufdesc *bdp, u32 length, bool swap)
> > >  {
> > 
> > Why add __maybe_unused? If its not used, remove it. We don't leave dead
> > functions in the code.
> > 
> 
> I was thinking to remove them by a separate patch once the page pool solution is accepted.

Then say that in the commit message. The commit message is how you
answer questions the Maintainers might have, without them having to
ask.

What is small packet performance like on the imx6? If you provide some
numbers as to how small the reduction in performance is, we can decide
if the reduction in complexity is worth it.

   Andrew
