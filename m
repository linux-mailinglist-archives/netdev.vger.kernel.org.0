Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6082222048
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGPKHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:07:53 -0400
Received: from mail.intenta.de ([178.249.25.132]:44938 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgGPKHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=6eVThLOs/3oIyrS9tbgUaNYE8V9s3kyXcgaa0gI44kM=;
        b=Vvc0od84Xm+oymkjclOdENg5jUiPzOBu2pVyDQq/KDMtlVjRRRkqZ8I3HzPBWa0M8SBvPCZbhq7j7gOeMuTGWy/4Rpv8lQEz0mtetPQ7hnrwlzoPOnl1Jehl/ZsQDhbRg4aC7aPGla3xT7nHXu7OlNfqLSrvwjShEtaN+RwAxHSiKGhx1sn0QIv8P8Kk+HiG7BM6KPZ/Lni8RCfBsTzzTrvfD7+VnyHf1JoIsgceSWmkO14p++2ow9fNy7gr2TXzgaWu4TS5Cq1Pp5EAslqFybW1+xcJPRNkWexu06VU1EDDYHZncKKIcSB3IqeIsYNSWskGKT4EuuYmyq1J7iUb+g==;
Date:   Thu, 16 Jul 2020 12:07:43 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200716100743.GA3275@laureti-dev>
References: <20200617082235.GA1523@laureti-dev>
 <20200714120827.GA7939@laureti-dev>
 <20200714222716.GP1078057@lunn.ch>
 <20200715073112.GA25047@laureti-dev>
 <20200715130046.GB1211629@lunn.ch>
 <20200716070000.GA27587@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200716070000.GA27587@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 09:00:00AM +0200, Helmut Grohne wrote:
> I've prepared a patch based one the one-CPU-port assumption. It really
> becomes way simpler that way. I'd like to give it a little more testing
> before sending it.

I'm sorry, but it is not that simple. Testing revealed a fatal flaw.

At the time ksz_switch_register is called, dev->cpu_port is not
necessarily initialized. For ksz8795, it is initialized during detect
and that is fine. For ksz9477, it is initialized in
ksz9477_config_cpu_port, which comes much too late. The ksz9477 driver
actually handles the case where we choose a CPU port and selects it
using dsa_is_cpu_port (which derives this information from the device
tree during dsa_register_switch).

So in ksz_switch_register, I have no good way of knowing which port will
end up being the CPU port. Options include:
 * Replicating the logic from ksz9477_config_cpu_port. I expect that
   doing this would make the driver harder to maintain.
 * Move the cpu_port computation from ksz9477_config_cpu_port to
   ksz9477_switch_detect. I don't think this would work, because we
   presently call detect before dsa_register_switch, which parses the
   device tree. During detect, dsa_is_cpu_port is not usable.
 * Add a function to ksz_common.c that looks up the phy mode for a port
   from the device tree on demand. That way, ksz9477_config_cpu_port
   could call into the common code instead of reading a ksz_device
   property. It would defer parsing the device tree though and it could
   issue the warning multiple times.
 * Stick with my previous patch that stores the phy mode per-port.

Given the above, the last option seems least bad to me. Do you agree?

Helmut
