Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D469BE78
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfHXPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:24:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbfHXPYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 11:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G18D+dPwxL8gEYiQX/xlXCUBOq3K36GOclJ88+8s6ls=; b=j0fnZKEeNdbGm/lbDlayNaPzwv
        CYZslIJp2OQF+Zn8n7daGNWodiCBNnzzFmYbCRYiQYmqgbakPXqb2Hz5cLUVfu9FreH9WNa4mrt+q
        b8HiryaCRRX3bphqTdrQxml8Lrw+uDDBc7//E21EmNz3NxGYgkr/o5MkTKCMvCIeYSLc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1Xtf-0002PP-3f; Sat, 24 Aug 2019 17:24:07 +0200
Date:   Sat, 24 Aug 2019 17:24:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824152407.GA8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 04:42:47AM +0200, Marek Behún wrote:
> Hi,
> this is my attempt to solve the multi-CPU port issue for DSA.
> 
> Patch 1 adds code for handling multiple CPU ports in a DSA switch tree.
> If more than one CPU port is found in a tree, the code assigns CPU ports
> to user/DSA ports in a round robin way. So for the simplest case where
> we have one switch with N ports, 2 of them of type CPU connected to eth0
> and eth1, and the other ports labels being lan1, lan2, ..., the code
> assigns them to CPU ports this way:
>   lan1 <-> eth0
>   lan2 <-> eth1
>   lan3 <-> eth0
>   lan4 <-> eth1
>   lan5 <-> eth0

Hi Marek

That is what i've always argued is a good default. So i'm happy with
this.

> Patch 2 adds a new operation to the net device operations structure.
> Currently we use the iflink property of a net device to report to which
> CPU port a given switch port si connected to. The ip link utility from
> iproute2 reports this as "lan1@eth0". We add a new net device operation,
> ndo_set_iflink, which can be used to set this property. We call this
> function from the netlink handlers.

That is a new idea. Interesting.

I would like to look around and see what else uses this "lan1@eth0"
concept. We need to ensure it is not counter intuitive in general,
when you consider all possible users.

> Patch 3 implements this new ndo_set_iflink operation for DSA slave
> device. Thus the userspace can request a change of CPU port of a given
> port.

So this is all about transmit from the host out the switch. What about
receive? How do you tell the switch which CPU interface it should use
for a port?

    Thanks
	Andrew
