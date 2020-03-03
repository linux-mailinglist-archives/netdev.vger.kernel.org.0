Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79232176961
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCCAkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:40:00 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:39001 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCCAj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:39:59 -0500
X-Originating-IP: 50.39.173.182
Received: from localhost (50-39-173-182.bvtn.or.frontiernet.net [50.39.173.182])
        (Authenticated sender: josh@joshtriplett.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 773441BF206;
        Tue,  3 Mar 2020 00:39:55 +0000 (UTC)
Date:   Mon, 2 Mar 2020 16:39:52 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     "Machulsky, Zorik" <zorik@amazon.com>
Cc:     "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Message-ID: <20200303003952.GA264245@localhost>
References: <20200229002813.GA177044@localhost>
 <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8B4A52CD-FC5A-4256-B7DE-A659B50654CE@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 11:16:32PM +0000, Machulsky, Zorik wrote:
> 
> ﻿On 2/28/20, 4:29 PM, "Josh Triplett" <josh@joshtriplett.org> wrote:
> 
>     Before initializing completion queue interrupts, the ena driver uses
>     polling to wait for responses on the admin command queue. The ena driver
>     waits 5ms between polls, but the hardware has generally finished long
>     before that. Reduce the poll time to 10us.
>     
>     On a c5.12xlarge, this improves ena initialization time from 173.6ms to
>     1.920ms, an improvement of more than 90x. This improves server boot time
>     and time to network bringup.
>  
> Thanks Josh,
> We agree that polling rate should be increased, but prefer not to do it aggressively and blindly.
> For example linear backoff approach might be a better choice. Please let us re-work a little this 
> patch and bring it to review. Thanks!

That's fine, as long as it has the same net improvement on boot time.

I'd appreciate the opportunity to test any alternate approach you might
have.

(Also, as long as you're working on this, you might wish to make a
similar change to the EFA driver, and to the FreeBSD drivers.)

>     Before:
>     [    0.531722] calling  ena_init+0x0/0x63 @ 1
>     [    0.531722] ena: Elastic Network Adapter (ENA) v2.1.0K
>     [    0.531751] ena 0000:00:05.0: Elastic Network Adapter (ENA) v2.1.0K
>     [    0.531946] PCI Interrupt Link [LNKD] enabled at IRQ 11
>     [    0.547425] ena: ena device version: 0.10
>     [    0.547427] ena: ena controller version: 0.0.1 implementation version 1
>     [    0.709497] ena 0000:00:05.0: Elastic Network Adapter (ENA) found at mem febf4000, mac addr 06:c4:22:0e:dc:da, Placement policy: Low Latency
>     [    0.709508] initcall ena_init+0x0/0x63 returned 0 after 173616 usecs
>     
>     After:
>     [    0.526965] calling  ena_init+0x0/0x63 @ 1
>     [    0.526966] ena: Elastic Network Adapter (ENA) v2.1.0K
>     [    0.527056] ena 0000:00:05.0: Elastic Network Adapter (ENA) v2.1.0K
>     [    0.527196] PCI Interrupt Link [LNKD] enabled at IRQ 11
>     [    0.527211] ena: ena device version: 0.10
>     [    0.527212] ena: ena controller version: 0.0.1 implementation version 1
>     [    0.528925] ena 0000:00:05.0: Elastic Network Adapter (ENA) found at mem febf4000, mac addr 06:c4:22:0e:dc:da, Placement policy: Low Latency
>     [    0.528934] initcall ena_init+0x0/0x63 returned 0 after 1920 usecs
