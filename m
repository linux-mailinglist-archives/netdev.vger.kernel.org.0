Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06115DC5D9
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410249AbfJRNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:15:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56898 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbfJRNPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 09:15:37 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iLS6O-0007ay-VM; Fri, 18 Oct 2019 15:15:33 +0200
Date:   Fri, 18 Oct 2019 15:15:32 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
References: <20191018082817.111480-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191018082817.111480-1-dwagner@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-18 10:28:17 [+0200], Daniel Wagner wrote:
> handle_simple_irq() expect interrupts to be disabled. The USB
> framework is using threaded interrupts, which implies that interrupts
> are re-enabled as soon as it has run.

Without threading interrupts, this is invoked in pure softirq context
since commit ed194d1367698 ("usb: core: remove local_irq_save() around
->complete() handler") where the local_irq_disable() has been removed.

This is probably not a problem because the lock is never observed with
in IRQ context.

Wouldn't handle_nested_irq() work here instead of the simple thingy?

Sebastian
