Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038CB60C02B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiJYAwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiJYAwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:52:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE531D29B0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 16:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LiDch3H/SH/MZ53KsZsXIcdFt4ELIvi0XCqIzP3CGls=; b=WX+J4QG+MjPSltO66zl7e53OMf
        Y22OUb75gAyQuKhnJh1Vy+ggKM4CkHGNSBKkNeFb2KwdYDKDUygUr4Fpcq67Ph/x7gVgAT3cdYfEq
        jcjZYgjFZHaA+a1zwOrKIoPFUJ3r3LFfJntmZ78FQhgaZDotlSz1SJjwS+2cfJleFyqo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1on00c-000OC1-Tz; Mon, 24 Oct 2022 18:09:02 +0200
Date:   Mon, 24 Oct 2022 18:09:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Message-ID: <Y1a4no+U1cbXAWLi@lunn.ch>
References: <20221019162058.289712-1-saproj@gmail.com>
 <20221019165516.sgoddwmdx6srmh5e@skbuf>
 <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
 <20221019184203.4ywx3ighj72hjbqz@skbuf>
 <CABikg9x8SGyva2C5HUgygS3r-c-_nv6H1g_CaBq-8m3rKp1o0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9x8SGyva2C5HUgygS3r-c-_nv6H1g_CaBq-8m3rKp1o0g@mail.gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 06:50:31PM +0300, Sergei Antonov wrote:
> On Wed, 19 Oct 2022 at 21:42, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Oct 19, 2022 at 09:36:21PM +0300, Sergei Antonov wrote:
> > > On Wed, 19 Oct 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> > > > > The ftmac100 controller considers some packets FTL (frame
> > > > > too long) and drops them. An example of a dropped packet:
> > > > > 6 bytes - dst MAC
> > > > > 6 bytes - src MAC
> > > > > 2 bytes - EtherType IPv4 (0800)
> > > > > 1504 bytes - IPv4 packet
> > > >
> > > > Why do you insist writing these confusing messages?
> 
> Working on a better version of the patch. And here is another question.
> Unless the flag is set, the controller drops packets bigger than 1518
> (that is 1500 payload + 14 Ethernet header + 4 FCS). So if mtu is 1500
> the driver can enable the controller's functionality (clear the
> FTMAC100_MACCR_RX_FTL flag) and save CPU time. When mtu is less or
> greater than 1500, should the driver do the following:
> if (ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN) {
>     drop the packet
> }
> I mean, is it driver's duty to drop oversized packets?

It is not well defined what should happen here. Some drivers will
deliver oversized packets to the stack, some will not.

The main purpose of the MTU is fragmentation on transmission. How do
you break a UDP or TCP PDU up into L2 frames. MTU is not really used
on reception. If the L2 frame is otherwise valid, i doubt the stack
will drop it if it is longer than expected.

     Andrew
