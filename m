Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244F6149BB9
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAZP7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:59:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgAZP7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 10:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8H7oBxxzV8H5KiIO5X5joVplBafQm/GcWFDIybtF6AU=; b=CBCmLEhF/9QV+BcUdP01FIWxn4
        mOMOSj+Gf8QdkJE3sa5utrfYpmxcu8+PsixQRq6t84Xf0muSU8FN5I8nwQMxS1XuiFIKOLvHm1oOE
        qEoARg4Vg1GbaIUet3J1KVuhldgvCI11meMb8oojrQ0V98HriAc7pUZuJZQCQV8Jq16k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivkJb-0002A6-Iv; Sun, 26 Jan 2020 16:59:11 +0100
Date:   Sun, 26 Jan 2020 16:59:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Message-ID: <20200126155911.GJ18311@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
 <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 02:22:13PM +0100, Horatiu Vultur wrote:
> The 01/25/2020 17:35, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > > SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
> > >   MRP_Test frames on the mrp ring ports. This is called only on nodes that have
> > >   the role Media Redundancy Manager.
> > 
> > How do you handle the 'headless chicken' scenario? User space tells
> > the port to start sending MRP_Test frames. It then dies. The hardware
> > continues sending these messages, and the neighbours thinks everything
> > is O.K, but in reality the state machine is dead, and when the ring
> > breaks, the daemon is not there to fix it?
> > 
> > And it is not just the daemon that could die. The kernel could opps or
> > deadlock, etc.
> > 
> > For a robust design, it seems like SWITCHDEV_OBJ_ID_RING_TEST_MRP
> > should mean: start sending MRP_Test frames for the next X seconds, and
> > then stop. And the request is repeated every X-1 seconds.
> 
> I totally missed this case, I will update this as you suggest.

Hi Horatiu

What does your hardware actually provide?

Given the design of the protocol, if the hardware decides the OS etc
is dead, it should stop sending MRP_TEST frames and unblock the ports.
If then becomes a 'dumb switch', and for a short time there will be a
broadcast storm. Hopefully one of the other nodes will then take over
the role and block a port.

    Andrew
