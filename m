Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0E19122C
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfHQSPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:15:55 -0400
Received: from mail.nic.cz ([217.31.204.67]:41406 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfHQSPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 14:15:55 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id C48BA140B39;
        Sat, 17 Aug 2019 20:15:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566065752; bh=mWT+92UrG6kOQd2eNiW9KigiW6SU2aja+j17UOoZjgs=;
        h=Date:From:To;
        b=RIONL8fD90sc2a7m3/J0PkC3vnI52fNDMjuOORBUza8bDipZRxf+BzPdjsRGyE3Ur
         qf3I8ENLeI+UPitKMst9VNNPriYi+QIVKxA/170FNKStOP6T+yb9obvRvJP29ebs5z
         zfKfZoMU7UfNPK6Shi67twzeyZJmog5oyO9n5em8=
Date:   Sat, 17 Aug 2019 20:15:52 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
Message-ID: <20190817201552.06c39d3e@nic.cz>
In-Reply-To: <20190817200342.567c13c4@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
        <20190816150834.26939-4-marek.behun@nic.cz>
        <20190816122552.GC629@t480s.localdomain>
        <20190816190520.57958fde@nic.cz>
        <20190816190537.GB14714@t480s.localdomain>
        <20190817200342.567c13c4@nic.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Aug 2019 20:03:42 +0200
Marek Behun <marek.behun@nic.cz> wrote:

> One way would be to rename the mv88e6xxx_setup_port function to
> mv88e6xxx_setup_port_regs, or mv88e6xxx_port_pre_setup, or something
> like that. Would the names mv88e6xxx_port_setup and
> mv88e6xxx_setup_port_regs still be very confusing and error prone?
> I think maybe yes...
> 
> Other solution would be to, instead of the .port_setup()
> and .port_teardown() DSA ops, create the .after_setup()
> and .before_teardown() ops I mentioned in the previous mail.
> 
> And yet another (in my opinion very improper) solution could be that
> the .setup() method could call dsa_port_setup() from within itself, to
> ensure that the needed structres exist.

I thought of another solution, one that does not need new DSA
operations. What if dsa_port_enable was called for CPU/DSA ports after
in dsa_port_setup_switches, after all ports are setup, and
dsa_port_disable called for CPU/DSA ports in dsa_port_teardown_switches?

This seems to me as cleaner solution.

Marek
