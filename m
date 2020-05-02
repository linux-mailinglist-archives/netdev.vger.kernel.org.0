Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6BF1C2808
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgEBTbz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 May 2020 15:31:55 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56663 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbgEBTby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 15:31:54 -0400
X-Originating-IP: 86.210.146.109
Received: from windsurf.home (lfbn-tou-1-915-109.w86-210.abo.wanadoo.fr [86.210.146.109])
        (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 56DFDFF803;
        Sat,  2 May 2020 19:31:52 +0000 (UTC)
Date:   Sat, 2 May 2020 21:31:51 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>
Cc:     Arnaud Ebalard <arno@natisbad.org>, netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?UTF-8?B?VMOpbmFy?= =?UTF-8?B?dA==?= 
        <antoine.tenart@bootlin.com>
Subject: Re: network unreliable on ReadyNAS 104 with Debian kernel
Message-ID: <20200502213151.2507c6b0@windsurf.home>
In-Reply-To: <20200502141408.GA29911@taurus.defre.kleine-koenig.org>
References: <20200502141408.GA29911@taurus.defre.kleine-koenig.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Uwe,

+Maxime Chevallier and Antoine Ténart, who have also worked on mvneta.

On Sat, 2 May 2020 16:14:08 +0200
Uwe Kleine-König <uwe@kleine-koenig.org> wrote:

> I own a ReadyNAS 104 (CPU: Armada 370, mvneta driver) and since some
> time its network driver isn't reliable any more. I see things like:
> 
> 	$ rsync -a remotehost:dir /srv/dir
> 	ssh_dispatch_run_fatal: Connection to $remoteaddress port 22: message authentication code incorrect
> 	rsync: connection unexpectedly closed (11350078 bytes received so far) [receiver]
> 	rsync error: error in rsync protocol data stream (code 12) at io.c(235) [receiver=3.1.3]
> 	rsync: connection unexpectedly closed (13675 bytes received so far) [generator]
> 	rsync error: unexplained error (code 255) at io.c(235) [generator=3.1.3]
> 
> when ever something like this happens, I get
> 
> 	mvneta d0074000.ethernet eth1: bad rx status 0e8b0000 (overrun error), size=680

I am also running an Armada 370 ReadyNAS, though with a much older
kernel (4.4.x). It is working fine for me, but checking the kernel
logs, I in fact also have the same issue:

[4141806.620510] mvneta d0070000.ethernet eth0: bad rx status 0f830000 (overrun error), size=1344
[4141821.344100] mvneta d0070000.ethernet eth0: bad rx status 0f830000 (overrun error), size=272
[4141831.098003] mvneta d0070000.ethernet eth0: bad rx status 0f830000 (overrun error), size=896
[4141850.655858] mvneta d0070000.ethernet eth0: bad rx status 0f830000 (overrun error), size=592
[4141850.915259] mvneta d0070000.ethernet eth0: bad rx status 0d830000 (overrun error), size=16

> This happens with Debian's 5.4.0-4-armmp (Version: 5.4.19-1) kernel, but
> I also experienced it with the 4.19 series. On slow connections this
> isn't a problem so the problem might exist already longer. In fact I
> think there are two problems: The first is that the hardware doesn't get
> enough buffers in time for the receive path and the other is that in the
> error case corrupted packets are given to the upper layers.
> 
> Does this ring a bell for you? I didn't start to debug that yet.

I think I do remember seeing reports about this, but I don't remember
if it ended up being fixed (and what we're seeing is some other
problem), or if it's still the same issue. It's been a long time I
looked into mvneta, unfortunately.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
