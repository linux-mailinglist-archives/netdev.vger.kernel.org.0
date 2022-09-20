Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E665BEA80
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiITPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiITPsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:48:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A343A61B1A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BW/FA3xUmnpcGhaoFqh+xoHbwReHfS/W0lyRCof2ouU=; b=OjltrXkyhzAnec18ChDAhv+5xj
        emKo4kGuTpcgsMlk7iR0i40x6Y6wGtD/3JhmxHWI5XfPw/HmBjm5PusKi9VnsWz9d/dptWZPeykSL
        Av8L0fLKIZ3bTGiEfgJWKYQ4VmM6kthxadP9tRdohmECb/ClDRVqj5Yy8uS7wMlG8YWw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oafU4-00HHp1-KI; Tue, 20 Sep 2022 17:48:28 +0200
Date:   Tue, 20 Sep 2022 17:48:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     mattias.forsblad@gmail.com, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH rfc v0 9/9] net: dsa: qca8k: Move inband mutex into DSA
 core
Message-ID: <YyngzF8KyRAjoIn6@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-10-andrew@lunn.ch>
 <6329c228.df0a0220.fd08a.30e3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6329c228.df0a0220.fd08a.30e3@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 05:19:07AM +0200, Christian Marangi wrote:
> On Tue, Sep 20, 2022 at 12:18:53AM +0200, Andrew Lunn wrote:
> > The mutex serves two purposes:
> > 
> > It serialises operations on the switch, so that only one
> > request/response can be happening at once.
> > 
> > It protects priv->mgmt_master, which itself has two purposes.  If the
> > hardware is wrongly wires, the wrong switch port is connected to the
> > cpu, inband cannot be used. In this case it has the value
> > NULL. Additionally, if the master is down, it is set to
> > NULL. Otherwise it points to the netdev used to send frames to the
> > switch.
> > 
> > The protection of priv->mgmt_master is not required. It is a single
> > pointer, which will be updated atomically. It is not expected that the
> > interface disappears, it only goes down. Hence mgmt_master will always
> > be valid, or NULL.
> > 
> > Move the check for the master device being NULL into the core.  Also,
> > move the mutex for serialisation into the core.
> > 
> > The MIB operations don't follow request/response semantics, so its
> > mutex is left untouched.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> BTW this patch makes the router crash with a kernel panic. Rest of the
> patchset works correctly and seems to be no regression. (I had to fix
> the clear_skb return value)

Thanks for testing.

As Vladimir pointed out, there is a mutex used in the wrong context. I
will fix that and the other issues pointed out, and see if i can spot
what i did wrong here. If not, we will have to decode the opps.

     Andrew
