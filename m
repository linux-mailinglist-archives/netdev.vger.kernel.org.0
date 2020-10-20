Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C07829371A
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392164AbgJTIuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:50:13 -0400
Received: from mailout02.rmx.de ([62.245.148.41]:49571 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392124AbgJTIuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 04:50:13 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4CFnPr18QDzNrNK;
        Tue, 20 Oct 2020 10:50:08 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CFnPW3FF1z2TS9Z;
        Tue, 20 Oct 2020 10:49:51 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.97) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 20 Oct
 2020 10:38:45 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: microchip: ksz9477: add Pulse Per Second (PPS) support
Date:   Tue, 20 Oct 2020 10:38:44 +0200
Message-ID: <7715832.IkuprK9oYb@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201019174617.uf7andznyij75mpd@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <20201019172435.4416-9-ceggers@arri.de> <20201019174617.uf7andznyij75mpd@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.97]
X-RMX-ID: 20201020-104955-4CFnPW3FF1z2TS9Z-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 19 October 2020, 19:46:17 CEST, Vladimir Oltean wrote:
> On Mon, Oct 19, 2020 at 07:24:34PM +0200, Christian Eggers wrote:
> >  static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct
> >  ptp_clock_request *req, int on) {
> > 
> > -	return -ENOTTY;
> > +	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
> > +	int ret;
> > +
> > +	switch (req->type) {
> > +	case PTP_CLK_REQ_PPS:
> > +		mutex_lock(&dev->ptp_mutex);
> > +		ret = ksz9477_ptp_enable_pps(dev, on);
> > +		mutex_unlock(&dev->ptp_mutex);
> > +		return ret;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > 
> >  }
> 
> Nope, this is not what you're looking for. Please implement
> PTP_CLK_REQ_PEROUT.
Are you sure? I have implemented both (see patch 9/9). I cannot see that the
PTP_ENABLE_PPS(2) ioctls are translated into PTP_CLK_REQ_PEROUT. 

PTP_CLK_REQ_PEROUT is also called in pps_enable_store().

regards
Christian



