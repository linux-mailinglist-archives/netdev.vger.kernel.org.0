Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BCCA30F0
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfH3H0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfH3H0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 03:26:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6335E7BDA0;
        Fri, 30 Aug 2019 07:26:40 +0000 (UTC)
Received: from ceranb (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366435D9CA;
        Fri, 30 Aug 2019 07:26:37 +0000 (UTC)
Date:   Fri, 30 Aug 2019 09:26:37 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
Message-ID: <20190830092637.7f83d162@ceranb>
In-Reply-To: <20190830061327.GM2312@nanopsycho>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
        <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
        <20190829095100.GH2312@nanopsycho>
        <20190829132611.GC6998@lunn.ch>
        <20190829134901.GJ2312@nanopsycho>
        <20190829143732.GB17864@lunn.ch>
        <20190830061327.GM2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 30 Aug 2019 07:26:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 08:13:27 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Thu, Aug 29, 2019 at 04:37:32PM CEST, andrew@lunn.ch wrote:
> >> Wait, I believe there has been some misundestanding. Promisc mode
> >> is NOT about getting packets to the cpu. It's about setting hw
> >> filters in a way that no rx packet is dropped.
> >> 
> >> If you want to get packets from the hw forwarding dataplane to
> >> cpu, you should not use promisc mode for that. That would be
> >> incorrect.  
> >
> >Hi Jiri
> >
> >I'm not sure a wireshark/tcpdump/pcap user would agree with you. They
> >want to see packets on an interface, so they use these tools. The
> >fact that the interface is a switch interface should not matter. The
> >switchdev model is that we try to hide away the interface happens to
> >be on a switch, you can just use it as normal. So why should promisc
> >mode not work as normal?  
> 
> It does, disables the rx filter. Why do you think it means the same
> thing as "trap all to cpu"? Hw datapath was never considered by
> wireshark.
> 
> In fact, I have usecase where I need to see only slow-path traffic by
> wireshark, not all packets going through hw. So apparently, there is a
> need of another wireshark option and perhaps another flag
> IFF_HW_TRAPPING?.

Agree with Jiri but understand both perspectives. We can treat
IFF_PROMISC as:

1) "I want to _SEE_ all Rx traffic on specified interface"
that means for switchdev driver that it has to trap all traffic to CPU
implicitly. And in this case we need another flag that will say "I
don't want to see offloaded traffic".

2) "I want to ensure that nothing is dropped on specified interface" so
IFF_PROMISC is treated as filtering option only. To see offloaded
traffic you need to setup TC rule with trap action or another flag like
IFF_TRAPPING.

IMO IFF_PROMISC should be considered to be a filtering option and
should not imply trapping of offloaded traffic.

Thanks,
Ivan 
