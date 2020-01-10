Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1061377F5
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgAJUds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 15:33:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgAJUds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 15:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u3jxCHUDd5Pm/Y2q0b/qKxrWWseDBaS/hK6okC7Pk38=; b=YHFcu8ccMp5yFy9YS4lh6wzLz/
        8fCAAtavMf+JJh9EqEP0ZkXV6mLtbmco+6Jx7JSgW3DgH0KSS+gmK9gMPsupNwqNRy56wsbsSNszi
        uYcm8f/wSwIdznLSiE+eT8ROc96UUbliZxKnHfakYQO2WZo+4U4euwJOt0NPElAigykE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iq0yT-0004fK-5C; Fri, 10 Jan 2020 21:33:41 +0100
Date:   Fri, 10 Jan 2020 21:33:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anirudh.venkataramanan@intel.com, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200110203341.GU19739@lunn.ch>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
 <20200110160456.enzomhfsce7bptu3@soft-dev3.microsemi.net>
 <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
 <20200110172536.42rdfwdc6eiwsw7m@soft-dev3.microsemi.net>
 <20200110175608.GK19739@lunn.ch>
 <20200110201248.tletol7glyr4soqz@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110201248.tletol7glyr4soqz@soft-dev3.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 09:12:48PM +0100, Horatiu Vultur wrote:
> The 01/10/2020 18:56, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > > > Horatiu, could you also give some references to the frames that need
> > > > to be sent. I've no idea what information they need to contain, if the
> > > > contents is dynamic, or static, etc.
> > > It is dynamic - but trivial...
> > 
> > If it is trivial, i don't see why you are so worried about abstracting
> > it?
> Maybe we misunderstood each other. When you asked if it is dynamic or
> static, I thought you meant if it is the same frame being send repeated
> or if it needs to be changed. It needs to be changed but the changes are
> trivial, but it means that a non-MRP aware frame generator can't
> properly offload this.

The only frame generator i've ever seen are for generating test
packets. They generally have random content, random length, maybe the
option to send invalid CRC etc. These are never going to work for MRP.
So we should limit our thinking to hardware specifically designed for
MRP offload.

What we need to think about is an abstract model for MRP offload. What
must such a bit of hardware do? What parameters do we need to pass to
it? When should it interrupt us because some event has happened?

Once we have an abstract model, we can define netlink messages, or
devlink messages. And you can implement driver code which takes this
abstract model and implements it for your real hardware. And if you
have the abstract model correct, other vendors should also be able to
implement drivers as well.

Since this is a closed standard, there is not much the rest of us can
do. You need to define this abstract model. We can then review it.

    Andrew
