Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7F91223
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfHQSDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:03:45 -0400
Received: from mail.nic.cz ([217.31.204.67]:41312 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfHQSDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 14:03:45 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 3D4D9140983;
        Sat, 17 Aug 2019 20:03:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566065023; bh=rX44tiLMCCxYVWA527MgcpaNgOsxUtpi00DFyX/A8Go=;
        h=Date:From:To;
        b=JQ/Q/tc6sIZC1ZiFleGP8lpHgRQpM//klOEo8x9TzkftnU52FGSa7HPWjoJ8B8maQ
         KA7Wi5IBGwU1jVyTqgOSkm5ob/CHuE55PZL50QY/1Zadjbsz5+EgjT6/OtrrgChU5V
         0/Umveau09RW3m6Sq/ydQbY5ecA8u2lDLpA0cToY=
Date:   Sat, 17 Aug 2019 20:03:42 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
Message-ID: <20190817200342.567c13c4@nic.cz>
In-Reply-To: <20190816190537.GB14714@t480s.localdomain>
References: <20190816150834.26939-1-marek.behun@nic.cz>
        <20190816150834.26939-4-marek.behun@nic.cz>
        <20190816122552.GC629@t480s.localdomain>
        <20190816190520.57958fde@nic.cz>
        <20190816190537.GB14714@t480s.localdomain>
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

Hi Vivien,

On Fri, 16 Aug 2019 19:05:37 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> I think the DSA switch port_setup/port_teardown operations are fine, but the
> idea would be that the drivers must no longer setup their ports directly
> in their .setup function. So for mv88e6xxx precisely, we should rename
> mv88e6xxx_setup_port to mv88e6xxx_port_setup, and move all the port-related
> code from mv88e6xxx_setup into mv88e6xxx_port_setup.

I looked into the driver, and found out that mv88e6xxx_setup calls many
other setup functions after the calls to mv88e6xxx_setup_port for each
port:
   1. setup errata
   2. cache cmode
   3. for each port setup_port
   4. irl setup
   5. mac setup
   6. phy setup
   7. vtu setup
   8. pvt setup
   9. atu setup
  10. broadcast setuo
  11. pot setup
  12. rmu setup
  13. rsvd2cpu setup
  14. trunk setup
  15. devmap setup
  16. pri setup
  17. ptp setup
  18. hwtstamp setup
  19. stats setup

The problem is that some of these steps (after step 3) may depend on
some of the work done by step 3. Some of these functions iterate again
over the port array (mv88e6xxx_hwtstamp_setup, for example).
We cannot simply move step 3 to be called from DSA after
mv88e6xxx_setup.

I now do not know exactly what to do about the error prone naming of
setup_port vs port_setup.

One way would be to rename the mv88e6xxx_setup_port function to
mv88e6xxx_setup_port_regs, or mv88e6xxx_port_pre_setup, or something
like that. Would the names mv88e6xxx_port_setup and
mv88e6xxx_setup_port_regs still be very confusing and error prone?
I think maybe yes...

Other solution would be to, instead of the .port_setup()
and .port_teardown() DSA ops, create the .after_setup()
and .before_teardown() ops I mentioned in the previous mail.

And yet another (in my opinion very improper) solution could be that
the .setup() method could call dsa_port_setup() from within itself, to
ensure that the needed structres exist.

Please let me know what you think about this.

The first solution to me currently seems as the easiest.

Marek
