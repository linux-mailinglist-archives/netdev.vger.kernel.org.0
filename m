Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD6328C8C1
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 08:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbgJMGqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 02:46:05 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:33834 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389638AbgJMGqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 02:46:05 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 529FE3A7C76
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 06:36:18 +0000 (UTC)
X-Originating-IP: 81.255.150.195
Received: from windsurf.home (unknown [81.255.150.195])
        (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 51ED6C0004;
        Tue, 13 Oct 2020 06:35:55 +0000 (UTC)
Date:   Tue, 13 Oct 2020 08:35:54 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Ezra Buehler <ezra@easyb.ch>
Cc:     netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        linux-arm-kernel@lists.infradead.org, u-boot@lists.denx.de
Subject: Re: Linux mvneta driver unable to read MAC address from HW
Message-ID: <20201013083554.0ab5c099@windsurf.home>
In-Reply-To: <4E00AED7-28FD-4583-B319-FFF5C96CCE73@easyb.ch>
References: <4E00AED7-28FD-4583-B319-FFF5C96CCE73@easyb.ch>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ezra,

On Sat, 10 Oct 2020 18:41:24 +0200
Ezra Buehler <ezra@easyb.ch> wrote:

> I am running Debian buster (Linux 4.19.146) on a Synology DS214+ NAS
> (Marvell ARMADA XP). Unfortunately, I end up with random MAC addresses
> for the two Ethernet interfaces after boot. (Also with Debian sid, Linux
> 5.4.0.)
> 
> Since commit 8cc3e439ab92 ("net: mvneta: read MAC address from hardware
> when available") the mvneta Linux driver reads the MVNETA_MAC_ADDR_*
> registers when no MAC address is provided by the DT. In my case, only
> zeros are read, causing the driver to fall back to a random address. I
> was able to verify that the registers are correctly written by the
> bootloader by reading out the registers in the U-Boot prompt.
> 
> As a workaround, I now specify the MAC addresses in the DT. However, I
> would prefer not to do that. Also, it would be nice to get to the bottom
> of this.
> 
> Could it be, that for some reason, the clock of the MAC is removed
> either by U-Boot or Linux during boot?

I suspect you have the mvneta driver as a module ? If this is the case,
then indeed, the MAC address is lost because Linux turns of all unused
clocks at the end of the boot. When the driver is built-in, there is a
driver adding a reference to the clock before all unused clocks are
disabled. When the driver is compiled as a module, this does not
happen. So indeed, the correct solution here is to have U-Boot pass the
MAC address in the Device Tree.

Best regards,

Thomas Petazzoni
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
