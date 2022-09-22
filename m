Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469F55E699E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiIVR2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiIVR2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:28:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53DE105D4E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6YRyPvcL52rF0grMTQsnDkc6Y0UmTVBj9t/xlkDCBPo=; b=LafvYu5AeNokwkn1KWfUd+Ex/j
        O2+hiC7axKfyoZcaWHcPFSr0939IFJRTN4G/TfXnqCDMnQ50qBIVxzksRIYao6EhXF6QBzcdDogqr
        UDbKdBwfDy+ascDoItMljddUKqxs+FEpcCKqhOWfKtpzRPYEuEur5RpfvhHQw1Xn9QEk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obPzP-00HYTo-AC; Thu, 22 Sep 2022 19:27:55 +0200
Date:   Thu, 22 Sep 2022 19:27:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <YyybG/MsUIUji4UH@lunn.ch>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
 <Yyoqx1+AqMlAqRMx@lunn.ch>
 <20220922114820.hexazc2do5yytsu2@skbuf>
 <YyxY7hLaX0twtThI@lunn.ch>
 <20220922130452.v2yhykduhbpdw3mi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922130452.v2yhykduhbpdw3mi@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I was thinking within mv88e6xxx_read() and mv88e6xxx_write(). Keep a
> > buffer for building requests. Each write call appends the write to the
> > buffer and returns 0. A read call gets appended to the buffer and then
> > executes the RMU. We probably also need to wrap the reg mutex, so that
> > when it is released, any buffered writes get executed. If the RMU
> > fails, we have all the information needed to do the same via MDIO.
> 
> Ah, so you want to make the mv88e6xxx_reg_unlock() become an implicit
> write barrier.

I'm still thinking this through. It probably needs real code to get
all the details sorted out. The locking could be interesting...  We
need something to flush the queue before we exit from the driver, and
that seems like the obvious synchronisation point. If not that, we
need to add another function call at all the exit points.

> That could work, but the trouble seems to be error propagation.
> mv88e6xxx_write() will always return 0, the operation will be delayed
> until the unlock, and mv88e6xxx_reg_unlock() does not return an error
> code (why would it?).

If the RMU fails and the fallback MDIO also fails, we are in big
trouble, and the switch is probably dead. At which point, do we really
care. netdev_ratelimited_err('Switch has died...') and keep going,
everything afterwards is probably going to go wrong as well.

I don't think there are any instances in the driver where we try to
recover from an MDIO write failure, other than return -ETIMEDOUT or
-EIO or whatever.

> Or the driver might have a worker which periodically sends the GetID
> message and tracks whether the switch responded. Maybe the rescheduling
> intervals of that are dynamically adjusted based on feedback from
> timeouts or successes of register reads/writes. In any case, now we're
> starting to talk about really complex logic. And it's not clear how
> effective any of these mechanisms would be against random and sporadic
> timeouts rather than persistent issues.

I don't think we can assume every switch has an equivalent of
GetID. So a solution like this would have to be per driver. Given the
potential complexity, it would probably be better to have it in the
core, everybody shares it, debugs it, and makes sure it works well.

      Andrew
