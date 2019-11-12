Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC7AF957A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKLQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:22:35 -0500
Received: from muru.com ([72.249.23.125]:41876 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLQWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 11:22:35 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id DA60480F3;
        Tue, 12 Nov 2019 16:23:09 +0000 (UTC)
Date:   Tue, 12 Nov 2019 08:22:30 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 net-next 06/13] dt-bindings: net: ti: add new cpsw
 switch driver bindings
Message-ID: <20191112162230.GK5610@atomide.com>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
 <20191109151525.18651-7-grygorii.strashko@ti.com>
 <20191111172652.GV5610@atomide.com>
 <bac9a300-cbd5-d342-a96d-d90fdcf2e4c3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bac9a300-cbd5-d342-a96d-d90fdcf2e4c3@ti.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Grygorii Strashko <grygorii.strashko@ti.com> [191112 09:54]:
> No, sorry I do not agree. The MDIO is inseparable part of CPSW and it's enabled when CPSW is enabled
> (on interconnect level), more over I want to get rid of platform device in MDIO for most of the cases
> as it only introduces boot/probing complexity.

Well the fact that mdio is enabled at the interconnect level is why
I think the cpsw child modules are independent components :)

So I did the following quick test on pocketbeagle with Linux next,
it has no Ethernet wired up, and by default we have ethernet@0
set to status = "disabled".

Manually enable the target module at 0x4a100000:
# echo on > /sys/devices/platform/ocp/4a000000.interconnect/\
4a000000.interconnect:segment@0/4a101200.target-module/power/control

Dump out mdio registers at offset 0x1000:
# rwmem 0x4a101000+0x100
0x4a101000 = 0x40070106
0x4a101004 = 0x810000ff
0x4a101008 = 0000000000
0x4a10100c = 0000000000
0x4a101010 = 0000000000
0x4a101014 = 0000000000
0x4a101018 = 0000000000
...

So yup, it seems quite independent of the other child devices
on the same interconnect target mdoule. I'm quessing it's the
same story for other modules like cppi_dma and so on, this
should be easy to check.

Hmm and isn't the some version of mdio also used stuffed into
davinci_emac and netcp too?

Anyways, up to you. But my experience is that having separate
driver modules is the way to go than trying to treat any TI
"subsystem" as a single device. This is because the child modules
tend to get updated and changed and moved around over time.

Regards,

Tony
