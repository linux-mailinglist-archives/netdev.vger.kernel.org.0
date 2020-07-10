Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C835B21B691
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGJNfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:35:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57178 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJNfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 09:35:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jttBi-004T7V-V5; Fri, 10 Jul 2020 15:35:38 +0200
Date:   Fri, 10 Jul 2020 15:35:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200710133538.GF1014141@lunn.ch>
References: <20200709233337.xxneb7kweayr4yis@skbuf>
 <C42U7ICFS9TP.3PIIHGICUXOC4@wkz-x280>
 <20200710094517.fiaotxw2kuvosv5s@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710094517.fiaotxw2kuvosv5s@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In principle there is nothing in this para-virtualization design that
> would preclude a quirky quad PHY from being accessed in a
> virtualization-safe mode. The main use case for PHY access in a VM is
> for detecting when the link went down. Worst case, the QEMU host-side
> driver could lie about the PHY ID, and could only expose the clause 22
> subset of registers that could make it compatible with genphy. I don't
> think this changes the overall approach about how MDIO devices would be
> virtualized with QEMU.

A more generic solution might be to fully virtualize the PHY. Let the
host kernel drive the PHY, and QEMU can use /sys/bus/mdio_bus/devices,
and uevents sent to user space. Ioana already added support for a PHY
not bound to a MAC in phylink. You would need to add a UAPI for
start/stop, and maybe a couple more operations, and probably export a
bit more information.

This would then solve the quad PHY situation, and any other odd
setups. And all the VM would require is genphy, keeping it simple.

	Andrew

