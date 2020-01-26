Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343B6149AA7
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgAZNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:01:15 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:19163 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZNBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:01:15 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: yNCRfbb5cMs/w6zEcQdPDA6GeBmY+GKZJ5wCk1a4e0ElcxTwrjvSCEh4aY7OO3/Yf+PCymD+9y
 7iNAZVqxGAcwkU8B5v+UU8UyHxCoV0whApn/ab1bYQ9kUPqwI1OApR15ekPOFbm9UunnKlXbPF
 DbMIJst1Vazz82Q8noRpkiLpQV1Zivy+jOSLnsAqJWAtMm08duUVXycpszJrC6Va/Wbse4+q0s
 7gnkZBAYgNCrtwYDKlqJjhAhEKtdzSt0AIYcNJ7ZyES4AdQDepmDnTfNeT6C6uC4PLNZ7VLYjd
 2fA=
X-IronPort-AV: E=Sophos;i="5.70,365,1574146800"; 
   d="scan'208";a="63134271"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2020 06:01:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Jan 2020 06:01:12 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 26 Jan 2020 06:01:12 -0700
Date:   Sun, 26 Jan 2020 14:01:11 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 09/10] net: bridge: mrp: Integrate MRP into the
 bridge
Message-ID: <20200126130111.o75gskwe2fmfd4g5@soft-dev3.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-10-horatiu.vultur@microchip.com>
 <20200125161615.GD18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200125161615.GD18311@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/25/2020 17:16, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> >  br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
> > @@ -338,6 +341,17 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> >                       return RX_HANDLER_CONSUMED;
> >               }
> >       }
> > +#ifdef CONFIG_BRIDGE_MRP
> > +     /* If there is no MRP instance do normal forwarding */
> > +     if (!p->mrp_aware)
> > +             goto forward;
> > +
> > +     if (skb->protocol == htons(ETH_P_MRP))
> > +             return RX_HANDLER_PASS;
> 
> What MAC address is used for these MRP frames? It would make sense to
> use a L2 link local destination address, since i assume they are not
> supposed to be forwarded by the bridge. If so, you could extend the
> if (unlikely(is_link_local_ether_addr(dest))) condition.

The MAC addresses used by MRP frames are:
0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 - used by MRP_Test frames
0x1, 0x15, 0x4e, 0x0, 0x0, 0x2 - used by the rest of MRP frames.

If we will add support also for MIM/MIC. These requires 2 more MAC
addresses:
0x1, 0x15, 0x4e, 0x0, 0x0, 0x3 - used by MRP_InTest frames.
0x1, 0x15, 0x4e, 0x0, 0x0, 0x4 - used by the other MRP interconnect
frames.

Then maybe I shoukd change the check to be something like:
if (unlikely(skb->protocol == htons(ETH_P_MRP)))

> 
> > +
> > +     if (p->state == BR_STATE_BLOCKING)
> > +             goto drop;
> > +#endif
> 
> Is this needed? The next block of code is a switch statement on
> p->state. The default case, which BR_STATE_BLOCKING should hit, is
> drop.

Yes you are rigth, it is not needed anymore.

> 
> This function is on the hot path. So we should try to optimize it as
> much as possible.
> 
>      Andrew

-- 
/Horatiu
