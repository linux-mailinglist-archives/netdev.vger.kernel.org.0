Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C37599BF7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348982AbiHSMaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348970AbiHSMaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:30:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1749100F07
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=a0CC49ORKTJjI+C9DIa2g6xivXVlVlDK67xRdvHbu6Y=; b=LIUB1Zrw02N6u9uP4UWhiSy/jN
        I41UO9hJ3sP31P/kQHHPP/N7SysL40AxE3mvYWFfuqP10El/4SY89Lfu+g9x2PQegapw/0Uqu0639
        3J5vh0tI1aNoKW0u49jZnluuRvSysIwQ+MBTjsYd2LptbVyjtAOp71NYraXnTw5HiuP0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oP18O-00DuZ8-Ko; Fri, 19 Aug 2022 14:29:56 +0200
Date:   Fri, 19 Aug 2022 14:29:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next PATCH 2/3] mv88e6xxx: Implement remote management
 support (RMU)
Message-ID: <Yv+CRPCi27Ffvrbk@lunn.ch>
References: <20220818102924.287719-1-mattias.forsblad@gmail.com>
 <20220818102924.287719-3-mattias.forsblad@gmail.com>
 <Yv485js8cFGZapIQ@lunn.ch>
 <15eb1ab3-18ae-cd65-5798-bf5af3b046c7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15eb1ab3-18ae-cd65-5798-bf5af3b046c7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +int mv88e6xxx_inband_rcv(struct dsa_switch *ds, struct sk_buff *skb, int seq_no)
> >> +{
> >> +	struct mv88e6xxx_chip *chip = ds->priv;
> >> +	struct mv88e6xxx_port *port;
> >> +	__be16 *prodnum;
> >> +	__be16 *format;
> >> +	__be16 *code;
> >> +	__be32 *mib_data;
> >> +	u8 pkt_dev;
> >> +	u8 pkt_prt;
> >> +	int i;
> > 
> > Reverse christmass tree.
> > 
> 
> Will fix. Doesn't checkpatch find these?

No it does not :-(

It is only something which netdev enforces.

> >> +
> >> +	/* Extract response data */
> >> +	format = (__be16 *)&skb->data[0];
> > 
> > You have no idea of the alignment of data, so you should not cast it
> > to a pointer type and dereference it. Take a look at the unaligned
> > helpers.
> > 
> 
> Can you point me to an example please?

#include <asm/unaligned.h>

then you can use functions like get_unaligned_be16(),
get_unaligned_le32(), put_unaligned_le32().

On X86 unaligned accesses are cheap, so these macros do nothing. For
ARM they are expensive so split it into byte accesses.

> I've tested this implementation in a system with multiple switchcores
> and it works.

Cool, there are not many such boards, but RMU really helps these if
they are sharing the same MDIO bus.

     Andrew
