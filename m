Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0AA1A8B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfH2MzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2MzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 08:55:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF5BF7EB88;
        Thu, 29 Aug 2019 12:55:22 +0000 (UTC)
Received: from ceranb (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88B171001B14;
        Thu, 29 Aug 2019 12:55:19 +0000 (UTC)
Date:   Thu, 29 Aug 2019 14:55:18 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <allan.nielsen@microchip.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
Message-ID: <20190829145518.393fb99d@ceranb>
In-Reply-To: <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
        <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
        <20190829095100.GH2312@nanopsycho>
        <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
        <20190829121811.GI2312@nanopsycho>
        <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 29 Aug 2019 12:55:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 14:44:14 +0200
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> When a port is added to a bridge, then the port gets in promisc mode.
> But in our case the HW has bridge capabilities so it is not required
> to set the port in promisc mode.
> But if someone else requires the port to be in promisc mode (tcpdump
> or any other application) then I would like to set the port in promisc
> mode.
> In previous emails Andrew came with the suggestion to look at
> dev->promiscuity and check if the port is a bridge port. Using this
> information I could see when to add the port in promisc mode. He also
> suggested to add a new switchdev call(maybe I missunderstood him, or I
> have done it at the wrong place) in case there are no callbacks in the
> driver to get this information.

I would use the 1st suggestion.

for/in your driver:
if (dev->promiscuity > 0) {
	if (dev->promiscuity == 1 && netif_is_bridge_port(dev)) {
		/* no need to set promisc mode because promiscuity
		 * was requested by bridge
		 */
		...
	} else {
		/* need to set promisc mode as someone else requested
		 * promiscuity
		 */
	}
}

Thanks,
Ivan
