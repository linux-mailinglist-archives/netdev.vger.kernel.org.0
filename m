Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0375A4C80
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiH2Mxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiH2Mxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:53:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C961D98
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8aMX122KRKlsn1AeTHhkeZ8O0HoIa4hJOfBCXHbGG8Y=; b=pMwjrccx3oB0vVb1OzEEcgQYO3
        DaD529H1nXQaVKdlyC0BwVOqhkxMv1ktgHgc7WnHhQYUSPU5YFtyK7J3gBq/wDCGfSv1Q46gIla+l
        8WWhNiRw12WJJu8NIJFp0Lclz0/hmJCoYtyCfjKzt7wYygSL5bHBvwCO8OpeUiSxtcF0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSe6I-00ExkP-23; Mon, 29 Aug 2022 14:42:46 +0200
Date:   Mon, 29 Aug 2022 14:42:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Message-ID: <Ywy0RrY0Ih3lBBxx@lunn.ch>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-2-mattias.forsblad@gmail.com>
 <YwkelQ7NWgNU2+xm@lunn.ch>
 <5f550ab1-13b5-d78c-d4be-abc6fd7ac8f9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f550ab1-13b5-d78c-d4be-abc6fd7ac8f9@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Mattias
> > 
> > Vladimer pointed you towards the qca driver, in a comment for your
> > RFC. qca already has support for switch commands via Ethernet frames.
> > 
> > The point he was trying to make is that you should look at that
> > code. The concept of executing a command via an Ethernet frame, and
> > expecting a reply via an Ethernet frame is generic. The format of
> > those frames is specific to the switch. We want the generic parts to
> > look the same for all switches. If possible, we want to implement it
> > once in the dsa core, so all switch drivers share it. Less code,
> > better tested code, less bugs, easier maintenance.
> > 
> > Take a look at qca_tagger_data. Please use the same mechanism with
> 
> This I can do which makes sense.
> 
> > mv88e6xxx. But also look deeper. What else can be shared? You need a
> 
> I can also make a generic dsa_eth_tx_timeout routine which
> handles the sending and receiving of cmd frames.
> 
> > buffer to put the request in, you need to send it, you need to wait
> 
> The skb is the buffer and it's up to the driver to decode it properly?

Yes, the tagger layer passes the skb, which contains the complete
Ethernet frame, plus additional meta data. But you need to watch out
for the life cycle of that skb:

        /* Ethernet mgmt read/write packet */
        if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
                if (likely(tagger_data->rw_reg_ack_handler))
                        tagger_data->rw_reg_ack_handler(ds, skb);
                return NULL;
        }

returning NULL means the DSA core will free the skb when the call to
qca_tag_rcv() returns. So either you need to take a copy of the data,
clone the skb, or change this code somehow. See what makes most sense
for generic code.


> I've looked into the qca driver and that uses a small static buffer
> for replies, no buffer lifetime cycle.
> 
> > for the reply, you need to pass the results to the driver, you need to
> > free that buffer afterwards. That should all be common. Look at these
> > parts in the qca driver. Can you make them generic, move them into the
> > DSA core? Are there other parts which could be shared?
> 
> I cannot change the qca code as I have no way of verifying that the
> resulting code works.

You can change it. You can at least compile test your change. The QCA
developers are also quite active, and so will probably help out
testing whatever you change. And ideally, you want lots of simple,
obviously correct changes, which i can review and say look correct.

Changing code which you cannot test is very normal in Linux, do your
best, and ask for testing.

      Andrew
