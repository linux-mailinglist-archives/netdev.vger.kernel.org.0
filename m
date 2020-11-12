Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6992B086D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgKLPaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:30:06 -0500
Received: from mailout10.rmx.de ([94.199.88.75]:39703 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbgKLPaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:30:04 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CX5Bb6tBRz314x;
        Thu, 12 Nov 2020 16:29:59 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5BM1rkLz2xDy;
        Thu, 12 Nov 2020 16:29:47 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:28:45 +0100
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
Date:   Thu, 12 Nov 2020 16:28:44 +0100
Message-ID: <2477133.fPTnnZM2lx@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201110193245.uwsmrqzio5hco7fb@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <20201110164045.jqdwvmz5lq4hg54l@skbuf> <20201110193245.uwsmrqzio5hco7fb@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-162947-4CX5BM1rkLz2xDy-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tuesday, 10 November 2020, 20:32:45 CET, Vladimir Oltean wrote:
> But something is still wrong if you need to special-case the negative
> correctionField, it looks like the arithmetic is not done on the correct
> number of bits, either by the driver or by the hardware.
I got it! The problem was caused because I subtracted the "full" timestamp 
(reconstructed 64 bit seconds) from the correction field. When the KSZ updates 
the correction field of the PDelay_Resp message on tx, only the "partial" (2 
bit seconds) egress time stamp will be added. So the invalid values in the 
correction field were caused because much more seconds were subtracted on rx 
than added on tx.

> And zeroing out the correctionField of the Pdelay_Resp on transmission,
> to put that value into t_Tail_Tag? How can you squeeze a 48-bit value
> into a 32-bit value without truncation?
The answer is simple: Only the lower 32 bit (tail tag) must be subtracted as 
only 32 bit will be added on egress.

v2 is on the way...

regards
Christian



