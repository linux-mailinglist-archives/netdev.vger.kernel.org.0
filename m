Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA141304DE
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 23:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgADWFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 17:05:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgADWFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jan 2020 17:05:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6qaFRHn5+CKjUMpDrE+I93BDIrr67iIOP7igS1MNER4=; b=zX7zhcOcn+RRaw9KSRZgZLux71
        /uE+xfwbcuDEmoM3iuVRf4GI9Jn2i1Y0ayMw5xDlUXphtpSCMjk+Y3EVUabip9QxLib+ImOHXCIOb
        yoiQSg64nXuGtfpg9H0zuYuP+o9fbrA/w366mz+qb0YBFKFQK3x/wOEpQJrZ1NXU+0uA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inrXT-0002W2-FU; Sat, 04 Jan 2020 23:04:55 +0100
Date:   Sat, 4 Jan 2020 23:04:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Preserve priority went setting
 CPU port.
Message-ID: <20200104220455.GC27771@lunn.ch>
References: <20200104161335.27662-1-andrew@lunn.ch>
 <CA+h21hoxY=4L53JGFmRTx5=CGbjY0pNpTSKd=ynDLdP_-CTO5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoxY=4L53JGFmRTx5=CGbjY0pNpTSKd=ynDLdP_-CTO5g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 04, 2020 at 08:56:12PM +0200, Vladimir Oltean wrote:
> Hi Andrew,
> 
> Is there a typo in the commit message? (went -> when)

Yep. Thanks for pointing it out.

> 
> On Sat, 4 Jan 2020 at 18:16, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > The 6390 family uses an extended register to set the port connected to
> > the CPU. The lower 5 bits indicate the port, the upper three bits are
> > the priority of the frames as they pass through the switch, what
> > egress queue they should use, etc. Since frames being set to the CPU
> > are typically management frames, BPDU, IGMP, ARP, etc set the priority
> > to 7, the reset default, and the highest.
> >
> > Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> 
> Offtopic: Does the switch look at VLAN PCP for these frames at all, or
> is the priority fixed to the value from this register?

I _think_ it is fixed. But this is just for "management"
frames. Normal data frames heading to the CPU because of MAC address
learning should have all the normal QoS operations the switch supports
to determining their priority.

> >  drivers/net/dsa/mv88e6xxx/global1.c | 5 +++++
> >  drivers/net/dsa/mv88e6xxx/global1.h | 1 +
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
> > index 120a65d3e3ef..ce03f155e9fb 100644
> > --- a/drivers/net/dsa/mv88e6xxx/global1.c
> > +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> > @@ -360,6 +360,11 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
> >  {
> >         u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
> >
> > +       /* Use the default high priority for manegement frames sent to
> 
> management

Humm. What happened to my spell checker?

> > +        * the CPU.
> > +        */
> > +       port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
> > +
> >         return mv88e6390_g1_monitor_write(chip, ptr, port);
> >  }
> >
> > diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> > index bc5a6b2bb1e4..5324c6f4ae90 100644
> > --- a/drivers/net/dsa/mv88e6xxx/global1.h
> > +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> > @@ -211,6 +211,7 @@
> >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST         0x2000
> >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST          0x2100
> >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST             0x3000
> > +#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI     0x00e0
> 
> I suppose this could be more nicely expressed as
> MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI(x)    ((x) << 5 &
> GENMASK(7, 5)), in case somebody wants to change it from 7?

It could be. But i'm not aware of any suitable existing API to
configure this. So i went KISS and used the hard coded value.

	  Andrew
