Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74012C0682
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgKWMbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 07:31:38 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11277 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbgKWMbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 07:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606134693; x=1637670693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OLdDCWuWqpqn05lwFSC/SLaom41YK6TRggAoCaO8jHE=;
  b=YyLXJqDJRuEo2Lspc8ndXQLnntQzuH5h7frRuPjOFYmyRJ0hvBijKUuV
   qjW03Ji6CaVxJWKdnIfcIwe9NzYy96J/zm4aNolxfra+m3BW6j1cglrpJ
   mzCJhbBxv4RxddLOhO7l2PtLAM5Z52mtOaav4/ZL1nPSEMAZ4AQlDDtic
   CN4BUtO6yj8vLwycM4clLSRAMW7lxyZUJC/Ow7RYsFPstbTKtz+S8lxFD
   9818iwdoiYz52A5atnKQtLdfvI2YWallO/442NQIajqVWnpirP1h2/bAr
   56RJJ0mmfZFt8wSJY7BGGfocytDY6rGzSXVgeUJtNi+J2e7Eoex8O0vA6
   w==;
IronPort-SDR: W1ICdDpcMDhkKJbW/LJNxdyht0qv+Lb3C6KtSDBZLXpFLT5xBuHnhmD4lq485Rt0Z8bJnQdpli
 RSCSJ7P2D8Y/0zYBA/aMtlRuwcs+qM9I+SLo6IwcJ5gJd2KCASjnVvZzfNE96V97CzGOO/jbl8
 h5RdhB+MNoEsa1/+7C3Xwg1GxEEtRM435BScIL0xb5SZcRUHksP5W2kHN4VEFCHXztnTIY/0m+
 hi8lXsaEthvgNR+mP9C9tnRgdDRMkO6Tei3RahQcyfrQ5Lsl4Pb9Uu3j7zBqqJKsElrkp+SXUx
 lJ8=
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="100056419"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2020 05:31:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 23 Nov 2020 05:31:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 23 Nov 2020 05:31:32 -0700
Date:   Mon, 23 Nov 2020 13:31:32 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
Message-ID: <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
 <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/23/2020 14:13, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 23/11/2020 13:14, Horatiu Vultur wrote:
> > Extend MRP to support LC mode(link check) for the interconnect port.
> > This applies only to the interconnect ring.
> >
> > Opposite to RC mode(ring check) the LC mode is using CFM frames to
> > detect when the link goes up or down and based on that the userspace
> > will need to react.
> > One advantage of the LC mode over RC mode is that there will be fewer
> > frames in the normal rings. Because RC mode generates InTest on all
> > ports while LC mode sends CFM frame only on the interconnect port.
> >
> > All 4 nodes part of the interconnect ring needs to have the same mode.
> > And it is not possible to have running LC and RC mode at the same time
> > on a node.
> >
> > Whenever the MIM starts it needs to detect the status of the other 3
> > nodes in the interconnect ring so it would send a frame called
> > InLinkStatus, on which the clients needs to reply with their link
> > status.
> >
> > This patch adds the frame header for the frame InLinkStatus and
> > extends existing rules on how to forward this frame.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/mrp_bridge.h |  7 +++++++
> >  net/bridge/br_mrp.c             | 18 +++++++++++++++---
> >  2 files changed, 22 insertions(+), 3 deletions(-)
> >
> 
> Hi Horatiu,
> The patch looks good overall, just one question below.

Hi Nik,

Thanks for taking time to review the patch.

> 
> > diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> > index 6aeb13ef0b1e..450f6941a5a1 100644
> > --- a/include/uapi/linux/mrp_bridge.h
> > +++ b/include/uapi/linux/mrp_bridge.h
> > @@ -61,6 +61,7 @@ enum br_mrp_tlv_header_type {
> >       BR_MRP_TLV_HEADER_IN_TOPO = 0x7,
> >       BR_MRP_TLV_HEADER_IN_LINK_DOWN = 0x8,
> >       BR_MRP_TLV_HEADER_IN_LINK_UP = 0x9,
> > +     BR_MRP_TLV_HEADER_IN_LINK_STATUS = 0xa,
> >       BR_MRP_TLV_HEADER_OPTION = 0x7f,
> >  };
> >
> > @@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
> >       __be16 interval;
> >  };
> >
> > +struct br_mrp_in_link_status_hdr {
> > +     __u8 sa[ETH_ALEN];
> > +     __be16 port_role;
> > +     __be16 id;
> > +};
> > +
> 
> I didn't see this struct used anywhere, am I missing anything?

Yes, you are right, the struct is not used any. But I put it there as I
put the other frame types for MRP.

> 
> Cheers,
>  Nik
> 
> >  #endif
> > diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> > index bb12fbf9aaf2..cec2c4e4561d 100644
> > --- a/net/bridge/br_mrp.c
> > +++ b/net/bridge/br_mrp.c
> > @@ -858,7 +858,8 @@ static bool br_mrp_in_frame(struct sk_buff *skb)
> >       if (hdr->type == BR_MRP_TLV_HEADER_IN_TEST ||
> >           hdr->type == BR_MRP_TLV_HEADER_IN_TOPO ||
> >           hdr->type == BR_MRP_TLV_HEADER_IN_LINK_DOWN ||
> > -         hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP)
> > +         hdr->type == BR_MRP_TLV_HEADER_IN_LINK_UP ||
> > +         hdr->type == BR_MRP_TLV_HEADER_IN_LINK_STATUS)
> >               return true;
> >
> >       return false;
> > @@ -1126,9 +1127,9 @@ static int br_mrp_rcv(struct net_bridge_port *p,
> >                                               goto no_forward;
> >                               }
> >                       } else {
> > -                             /* MIM should forward IntLinkChange and
> > +                             /* MIM should forward IntLinkChange/Status and
> >                                * IntTopoChange between ring ports but MIM
> > -                              * should not forward IntLinkChange and
> > +                              * should not forward IntLinkChange/Status and
> >                                * IntTopoChange if the frame was received at
> >                                * the interconnect port
> >                                */
> > @@ -1155,6 +1156,17 @@ static int br_mrp_rcv(struct net_bridge_port *p,
> >                            in_type == BR_MRP_TLV_HEADER_IN_LINK_DOWN))
> >                               goto forward;
> >
> > +                     /* MIC should forward IntLinkStatus frames only to
> > +                      * interconnect port if it was received on a ring port.
> > +                      * If it is received on interconnect port then, it
> > +                      * should be forward on both ring ports
> > +                      */
> > +                     if (br_mrp_is_ring_port(p_port, s_port, p) &&
> > +                         in_type == BR_MRP_TLV_HEADER_IN_LINK_STATUS) {
> > +                             p_dst = NULL;
> > +                             s_dst = NULL;
> > +                     }
> > +
> >                       /* Should forward the InTopo frames only between the
> >                        * ring ports
> >                        */
> >
> 

-- 
/Horatiu
