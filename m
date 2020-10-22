Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFD295D37
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897072AbgJVLNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:13:00 -0400
Received: from mailout04.rmx.de ([94.199.90.94]:34163 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897062AbgJVLNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 07:13:00 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CH4Tg5b6Qz3r1qD;
        Thu, 22 Oct 2020 13:12:55 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CH4TR0tBFz2xqR;
        Thu, 22 Oct 2020 13:12:43 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.94) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 22 Oct
 2020 13:11:41 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Thu, 22 Oct 2020 13:11:40 +0200
Message-ID: <2541271.Km786uMvHt@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201022105014.gflswfpie4qvbw3h@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <20201022090126.h64hfnlajqelveku@skbuf> <20201022105014.gflswfpie4qvbw3h@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.94]
X-RMX-ID: 20201022-131243-4CH4TR0tBFz2xqR-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thursday, 22 October 2020, 12:50:14 CEST, Vladimir Oltean wrote:
> If the hardware supports p2p one-step, it subtracts the ingress time
> stamp value from the Pdelay_Request correction field.  The user space
> software stack then simply copies the correction field into the
> Pdelay_Response, and on transmission the hardware adds the egress time
> stamp into the correction field.
> 
> So we were correct about the behavior, just not about the target
> hardware.
> 
> So, that's just not how this hardware works. What do you recommend?
> Keeping a FIFO of Pdelay_Req RX timestamps, and matching them to
> Pdelay_Resp messages on TX, all of that contained within tag_ksz.c?

after applying the RX timestamp correctly to the correction field (shifting 
the nanoseconds by 16), it seems that "moving" the timestamp back to the tail 
tag on TX is not required anymore. Keeping the RX timestamp simply in
the correction field (negative value), works fine now. So this halves the 
effort in the tag_ksz driver.

Best regards
Christian



