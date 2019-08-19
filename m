Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974CB94BC4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfHSRcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:32:50 -0400
Received: from mail.nic.cz ([217.31.204.67]:35456 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfHSRcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:32:50 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 7599D140B70;
        Mon, 19 Aug 2019 19:32:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566235968; bh=wOYX7VTyXUel+7isJ1uJ52UrgNEboML/bErym9AZf5M=;
        h=Date:From:To;
        b=sZSzpu+ee+C5Cj3zPzsPldWDUFKZJPzmT3fxN7Kg6C7a19EiMHGcJEzeleYXXRleS
         fsIYjnoZYV6Zm3J7CFBzG1aUCP+Tub/ErCxb+8KW33gBKJEVwL66goQDDjc+gityBW
         xL90KQhZZow55UppCxVCJjkoMxK6TsppXGTG9m7g=
Date:   Mon, 19 Aug 2019 19:32:46 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next 3/6] net: dsa: enable and disable all ports
Message-ID: <20190819193246.0e40a1d4@nic.cz>
In-Reply-To: <20190818173548.19631-4-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
        <20190818173548.19631-4-vivien.didelot@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Aug 2019 13:35:45 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Call the .port_enable and .port_disable functions for all ports,
> not only the user ports, so that drivers may optimize the power
> consumption of all ports after a successful setup.
> 
> Unused ports are now disabled on setup. CPU and DSA ports are now
> enabled on setup and disabled on teardown. User ports were already
> enabled at slave creation and disabled at slave destruction.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

My original reason for enabling CPU and DSA ports is that enabling
serdes irq could not be done in .setup in mv88e6xxx, since the required
phylink structures did not yet exists for those ports.

The case after this patch would be that .port_enable is called for
CPU/DSA ports right after these required phylink structures are created
for this port. A thought came to me while reading this that some driver
in the future can expect, in their implementation of
port_enable/port_disable, that phylink structures already exist for all
ports, not just the one being currently enabled/disabled.

Wouldn't it be safer if CPU/DSA ports were enabled in setup after all
ports are registered, and disabled in teardown before ports are
unregistered?

Current:
  ->setup()
  for each port
      dsa_port_link_register_of()
      dsa_port_enable()

Proposed:
  ->setup()
  for each port
      dsa_port_link_register_of()
  for each port
      dsa_port_enable()

Marek
