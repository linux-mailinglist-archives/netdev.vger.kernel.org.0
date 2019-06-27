Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BF583D3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfF0Ntf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:49:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfF0Ntf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 09:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yuOl03aGHh0EdDYQObAZGcVwA/nGHpP2h6G9KrXLRMk=; b=2MUQih1hZRjIUEsY6pTCaibWCO
        furAZNnFwLUwbrB5PnSr6CuSlIg/vUcUr748YXvpVnK8udGVlcIDQQcZo+FNwdIH7/yPNHkrzn4BR
        OOYBy1MrJbqnJOaGGXUSx63AXQzQBwszaKVQGawYm4tk8HcTdj5woz1+7tft9iwBL0Yg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgUmH-0008WS-Pw; Thu, 27 Jun 2019 15:49:29 +0200
Date:   Thu, 27 Jun 2019 15:49:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53
 configuration
Message-ID: <20190627134929.GE31189@lunn.ch>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
 <20190627101506.19727-1-b.spranger@linutronix.de>
 <20190627101506.19727-2-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627101506.19727-2-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 12:15:06PM +0200, Benedikt Spranger wrote:

Hi Benedikt

> +Configuration with tagging support
> +----------------------------------
> +
> +The tagging based configuration is desired.
> +
> +To use the b53 DSA driver some configuration need to be performed. As
> +example configuration the following scenarios are used:
> +
> +*single port*
> +  Every switch port acts as a different configurable ethernet port
> +
> +*bridge*
> +  Every switch port is part of one configurable ethernet bridge
> +
> +*gateway*
> +  Every switch port except one upstream port is part of a configurable
> +  ethernet bridge.
> +  The upstream port acts as different configurable ethernet port.
> +
> +All configurations are performed with tools from iproute2, wich is available at
> +https://www.kernel.org/pub/linux/utils/net/iproute2/
> +
> +In this documentation the following ethernet ports are used:
> +
> +*eth0*
> +  CPU port

In DSA terminology, this is the master interface. The switch port
which the master is connected to is called the CPU port. So you are
causing confusion with DSA terms here.

> +
> +*LAN1*
> +  a switch port
> +
> +*LAN2*
> +  another switch port
> +
> +*WAN*
> +  A switch port dedicated as upstream port

These are all slave interfaces, when using DSA terms.

> +Further ethernet ports can be configured similar.
> +The configured IPs and networks are:
> +
> +*single port*
> +  *  wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
> +  * lan1: 192.0.2.5/30 (192.0.2.4 - 192.0.2.7)
> +  * lan2: 192.0.2.9/30 (192.0.2.8 - 192.0.2.11)
> +
> +*bridge*
> +  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
> +
> +*gateway*
> +  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
> +  * wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
> +
> +single port
> +~~~~~~~~~~~
> +
> +.. code-block:: sh
> +
> +  # configure each interface
> +  ip addr add 192.0.2.1/30 dev wan
> +  ip addr add 192.0.2.5/30 dev lan1
> +  ip addr add 192.0.2.9/30 dev lan2
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +bridge
> +~~~~~~
> +
> +.. code-block:: sh
> +
> +  # create bridge
> +  ip link add name br0 type bridge
> +
> +  # add ports to bridge
> +  ip link set dev wan master br0
> +  ip link set dev lan1 master br0
> +  ip link set dev lan2 master br0
> +
> +  # configure the bridge
> +  ip addr add 192.0.2.129/25 dev br0
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up

I would probably do this in a different order. Bring the master up
first, then the slaves. Then enslave the slaves to bridge, and lastly
configure the bridge.

> +
> +  # bring up the bridge
> +  ip link set dev br0 up
> +
> +gateway
> +~~~~~~~
> +
> +.. code-block:: sh
> +
> +  # create bridge
> +  ip link add name br0 type bridge
> +
> +  # add ports to bridge
> +  ip link set dev lan1 master br0
> +  ip link set dev lan2 master br0
> +
> +  # configure the bridge
> +  ip addr add 192.0.2.129/25 dev br0
> +
> +  # configure the upstream port
> +  ip addr add 192.0.2.1/30 dev wan
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +  # bring up the bridge
> +  ip link set dev br0 up

It would be good to add a note that there is nothing specific to the
B53 here. This same process will work for all DSA drivers which
support tagging, which is actually the majority.

I also tell people that once you configure the master interface up,
they should just use the slave interfaces a normal linux
interfaces. The fact they are on a switch does not matter, and should
not matter. Just use them as normal.

	Andrew
