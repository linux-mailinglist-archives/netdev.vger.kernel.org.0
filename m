Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3C5598FC5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 23:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiHRVtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 17:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiHRVta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 17:49:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668C5C6EAB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 14:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1oqPqZaad5S6/d7T+JEnwmf5shSfnv+Pqq8FX+Puh5s=; b=VRqmcWVlPxGa5ETyimvTAuM9Rf
        YkF96S6m8VjoEtB9g+iJMa9RZFkr9Tu3VGNXE2MLTQTsJmJtbvfshby2n4QsRL/WQdwgcZya7tVlm
        UMzt3S9jiAa1sXTKdn1faVuMP5Y+DbGj95PZDtuItu/brhj4gWVlmbZM7dUUWtPsRQW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOnOG-00DqdN-FE; Thu, 18 Aug 2022 23:49:24 +0200
Date:   Thu, 18 Aug 2022 23:49:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH net-next 00/10] Use robust notifiers in DSA
Message-ID: <Yv6z5HTyenpJ+pex@lunn.ch>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am posting this as RFC because something still feels off, but I can't
> exactly pinpoint what, and I'm looking for some feedback. Since most DSA
> switches are behind I/O protocols that can fail or time out (SPI, I2C,
> MDIO etc), everything can fail; that's a fact. On the other hand, when
> a network device or the entire system is torn down, nobody cares that
> SPI I/O failed - the system is still shutting down; that is also a fact.
> I'm not quite sure how to reconcile the two. On one hand we're
> suppressing errors emitted by DSA drivers in the non-robust form of
> notifiers, and on the other hand there's nothing we can do about them
> either way (upper layers don't necessarily care).

I would split it into two classes of errors:

Bus transactions fail. This very likely means the hardware design is
bad, connectors are loose, etc. There is not much we can do about
this, bad things are going to happen no what.

We have consumed all of some sort of resource. Out of memory, the ATU
is full, too many LAGs, etc. We try to roll back in order to get out
of this resource problem.

So i would say -EIO, -ETIMEDOUT, we don't care about too
much. -ENOMEM, -ENOBUF, -EOPNOTSUPP or whatever, we should try to do a
robust rollback.

The original design of switchdev was two phase:

1) Allocate whatever resources are needed, can fail
2) Put those resources into use, must not fail

At some point that all got thrown away.

	Andrew
