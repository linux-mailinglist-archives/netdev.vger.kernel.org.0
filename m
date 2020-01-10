Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8142A13758A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgAJR4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:56:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbgAJR4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:56:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tFD8L80AsAe/peAMgmqdDb1tPStURhWLKJa2Uvdi4vU=; b=fKvuaQLtH4HcOSF5kILzhiKsch
        57abGmvJNwtg/YVurNp6yl/6XsT3LGnrARvgVUqWlEjJGpwf9xo3oOcTHHUEhs44h6EniGwDjWW0A
        rJ7T6A014uAM1f0nQmq/+6uaoOseT07TreQx/MJIeis6pjwZTmb8jtflRl2vVr1RNxyw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipyW0-0002YJ-Ik; Fri, 10 Jan 2020 18:56:08 +0100
Date:   Fri, 10 Jan 2020 18:56:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anirudh.venkataramanan@intel.com, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200110175608.GK19739@lunn.ch>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
 <20200110160456.enzomhfsce7bptu3@soft-dev3.microsemi.net>
 <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
 <20200110172536.42rdfwdc6eiwsw7m@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110172536.42rdfwdc6eiwsw7m@soft-dev3.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Horatiu, could you also give some references to the frames that need
> > to be sent. I've no idea what information they need to contain, if the
> > contents is dynamic, or static, etc.
> It is dynamic - but trivial...

If it is trivial, i don't see why you are so worried about abstracting
it?

> Here is a dump from WireShark with
> annotation on what our HW can update:
> 
> Ethernet II, Src: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1), Dst: Iec_00:00:01 (01:15:4e:00:00:01)
>     Destination: Iec_00:00:01 (01:15:4e:00:00:01)
>     Source: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
>     Type: MRP (0x88e3)
> PROFINET MRP MRP_Test, MRP_Common, MRP_End
>     MRP_Version: 1
>     MRP_TLVHeader.Type: MRP_Test (0x02)
>         MRP_TLVHeader.Type: MRP_Test (0x02)
>         MRP_TLVHeader.Length: 18
>         MRP_Prio: 0x1f40 High priorities
>         MRP_SA: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
>         MRP_PortRole: Primary ring port (0x0000)
>         MRP_RingState: Ring closed (0x0001)
>         MRP_Transition: 0x0001
>         MRP_TimeStamp [ms]: 0x000cf574             <---------- Updated automatic
>     MRP_TLVHeader.Type: MRP_Common (0x01)
>         MRP_TLVHeader.Type: MRP_Common (0x01)
>         MRP_TLVHeader.Length: 18
>         MRP_SequenceID: 0x00e9                     <---------- Updated automatic
>         MRP_DomainUUID: ffffffff-ffff-ffff-ffff-ffffffffffff
>     MRP_TLVHeader.Type: MRP_End (0x00)
>         MRP_TLVHeader.Type: MRP_End (0x00)
>         MRP_TLVHeader.Length: 0
> 
> But all the fields can change, but to change the other fields we need to
> interact with the HW. Other SoC may have other capabilities in their
> offload. As an example, if the ring becomes open then the fields
> MRP_RingState and MRP_Transition need to change and in our case this
> requires SW interference.

Isn't SW always required? You need to tell your state machine that the
state has changed.

> Would you like a PCAP file as an example? Or do you want a better
> description of the frame format.

I was hoping for a link to an RFC, or some standards document.

  Andrew
