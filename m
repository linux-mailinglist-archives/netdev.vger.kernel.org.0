Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7AC2B9FE8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgKTBnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:43:19 -0500
Received: from lists.nic.cz ([217.31.204.67]:49250 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgKTBnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:43:19 -0500
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id C0B2C140A03;
        Fri, 20 Nov 2020 02:43:16 +0100 (CET)
Date:   Fri, 20 Nov 2020 02:43:11 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavana Sharma <pavana.sharma@digi.com>, lkp@intel.com,
        ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family  of Marvell
Message-ID: <20201120024311.5021d6b7@nic.cz>
In-Reply-To: <20201120012906.GA1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
        <df58a3716ab900a0c2a4d727ddae52ef1310fcdc.1605830552.git.pavana.sharma@digi.com>
        <20201120012906.GA1804098@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 20 Nov 2020 02:29:06 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > +	if (speed >= 2500 && port > 0 && port < 9)
> > +		return -EOPNOTSUPP;  
> 
> Maybe i'm missing something, but it looks like at this point you can
> call
> 
> 	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true, duplex);

He can't. That function does not support speed 5000. You can't simply
add it, because it clashes with register value for speed 2500 on
previous switches (Peridot, Topaz).

	Amethyst reg val	Peridot + Topaz reg val
2500	SPD_1000 | ALT_BIT	SPD_10000 | ALT_BIT
5000	SPD_10000 | ALT_BIT	not supported
10000	SPD_UNFORCED		SPD_UNFORCED

When I sent my proposal for Amethyst I somehow did it, and you
commented [1]:
> This is getting more and more complex. Maybe it is time to refactor it?
And I agree :)

Marek

[1] https://www.spinics.net/lists/netdev/msg678090.html
