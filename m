Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799481DA10A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgESTdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:33:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESTdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 15:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CyJq9A6s7V5K1qA/LsPffhIYKmpatsLmwIJZbeI/tI8=; b=4YS4XwxeP19iVTKfzxHsZR+XYT
        MqDRDOVtzQWdT9FBIlWQS3GF1NHo46/8MzV/AvHbRTJEO801jHvFLj87iJB3uZbrs73vIRElTO+Ke
        jGcNGvNflUQyhrkIB0JulkPAgN3tNlB87QyRfTRge8wujxDuuu7T+Gh/aPYHeUWaLo/s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jb7z8-002k1l-Bi; Tue, 19 May 2020 21:33:06 +0200
Date:   Tue, 19 May 2020 21:33:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
Message-ID: <20200519193306.GB652285@lunn.ch>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
 <20200519141541.GJ624248@lunn.ch>
 <20200519185642.GA1016583@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519185642.GA1016583@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's basically the number of lanes

Then why not call it lanes? It makes it clearer how this maps to the
hardware?

> > Is it well defined that all splits of the for 2, 4, 8 have to be
> > supported?
> 
> That I don't actually know. It is true for Mellanox and I can only
> assume it holds for other vendors. So far beside mlxsw only nfp
> implemented port_split() callback. I see it has this check:
> 
> ```
>         if (eth_port.is_split || eth_port.port_lanes % count) {
>                 ret = -EINVAL;
>                 goto out;
>         }
> ```
> 
> So it seems to be consistent with mlxsw. Jakub will hopefully chime in
> and keep me honest.
> 
> > Must all 40Gbps ports with a width of 4, be splitable to 2x
> > 20Mps? It seems like some hardware might only allow 4x 10G?
> 
> Possible. There are many vendor-specific quirks in this area, as I'm
> sure you know :)

So this makes me wonder if the API is sufficient. Do we actually want
to enumerate what is possible, rather than leave the user to guess,
trial and error?

> I assume you're asking because you are trying to see if the test is not
> making some vendor-specific assumptions?

Not just the test, but also the API itself. Is the API generic enough?
Should we actually be able to indicate a 40G port cannot be used as 2x
20G? But 4x 10G is O.K?

The PDF you gave a link to actually says nothing about 2x 50G, or 2x
20G. There is a cable which does support 2x 50G. Does the firmware do
any sanity checking and return errors if you ask it to do something
which does not make sense with the cable currently inserted in the
SFP cage?

	Andrew
