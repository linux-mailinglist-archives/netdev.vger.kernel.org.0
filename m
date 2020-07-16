Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1972C221F29
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgGPI6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:58:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:55378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGPI6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 04:58:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59B24AF21;
        Thu, 16 Jul 2020 08:58:40 +0000 (UTC)
Date:   Thu, 16 Jul 2020 10:58:35 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200716105835.32852035@ezekiel.suse.cz>
In-Reply-To: <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

first, thank you for looking into this!

On Wed, 15 Jul 2020 17:22:35 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 15.07.2020 10:28, Petr Tesarik wrote:
> > Hi all,
> > 
> > I've encountered some issues on an Asus laptop. The RTL8402 receive
> > queue behaves strangely after suspend to RAM and resume - many incoming
> > packets are truncated, but not all and not always to the same length
> > (most commonly 60 bytes, but I've also seen 150 bytes and other
> > lengths).
> > 
> > Reloading the driver can fix the problem, so I believe we must be
> > missing some initialization on resume. I've already done some
> > debugging, and the interface is not running when rtl8169_resume() is
> > called, so __rtl8169_resume() is skipped, which means that almost
> > nothing is done on resume.
> >   
> The dmesg log part in the opensuse bug report indicates that a userspace
> tool (e.g. NetworkManager) brings down the interface on suspend.
> On resume the interface is brought up again, and PHY driver is loaded.
> Therefore it's ok that rtl8169_resume() is a no-op.
> 
> The bug report mentions that the link was down before suspending.
> Does the issue also happen if the link is up when suspending?

I have tried, and it makes no difference.

> Interesting would also be a test w/o a network manager.
> Means the interface stays up during suspend/resume cycle.

I have stopped NetworkManager and configured a static IP address for
the interface. Still the same result.

I have verified that the firmware is loaded, both before suspend and
after resume:

zabulon:~ # ethtool -i eth0 
driver: r8169
version: 5.7.7-1-default
firmware-version: rtl8402-1_0.0.1 10/26/11
expansion-rom-version: 
bus-info: 0000:03:00.2
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

> Unfortunately it's not known whether it's a regression, and I have no
> test hw with this chip version.
> 
> Also you could test whether the same happens with the r8101 vendor driver.

I was not aware of this alternative driver... Anyway, I have built
r8101 from git (v1.035.03) for kernel 5.7.7. When loaded, it hangs the
machine hard. I mean like not even SysRq+B works...

Petr T

> > Some more information can be found in this openSUSE bug report:
> > 
> > https://bugzilla.opensuse.org/show_bug.cgi?id=1174098
> > 
> > The laptop is not (yet) in production, so I can do further debugging if
> > needed.
> > 
> > Petr T
> >   
> Heiner

