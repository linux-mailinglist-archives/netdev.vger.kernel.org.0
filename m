Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376A5390335
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhEYN77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:59:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhEYN7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sPaJW/Il9ErmSBbs6Hk5DgV4qQ0guIp9vCliYsHttHE=; b=4QrlbN/fW3Q62FhG3qSf0aNIhq
        BOty2FrNt9vgbmGKGJJ2yor5HYAgOr5vj3B6d5GjDs5CPTF1FMDIH+0/DmEElSn76FdD44cC0B3f5
        MIFN2noHIv97e6Gx9SqmNenuSvHUDn8KTobJ03FNnp/CRA7C5KprtlhM4I09qIH8HE8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llXZb-006BG3-EN; Tue, 25 May 2021 15:58:19 +0200
Date:   Tue, 25 May 2021 15:58:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Message-ID: <YK0Ce5YxR2WYbrAo@lunn.ch>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com>
 <YKpqtK7YBVFnqRSw@lunn.ch>
 <DB8PR04MB67957EA8964DB8CE625F6CFFE6259@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67957EA8964DB8CE625F6CFFE6259@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On Sun, May 23, 2021 at 06:20:19PM +0800, Joakim Zhang wrote:
> > > From: Fugang Duan <fugang.duan@nxp.com>
> > >
> > > As we know that AVB is enabled by default, and the ENET IP design is
> > > queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of
> > > queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
> > > tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.
> > 
> > How is the driver currently scheduling between these queues? Given the
> > 802.1q priorities, i think we want queue 2 with the highest priority for
> > scheduling. Then queue 0 and lastly queue 1.
> 
> I think currently there is no schedule between these queues in the driver.

So queues 1 and 2 are limited to 50% the total bandwidth, but are
otherwise not prioritised over queue 0? That sounds odd.

> Could you please point me where I can find mapping between priorities and queues? You prefer to below mapping?
> static const u16 fec_enet_vlan_pri_to_queue[8] = {1, 1, 0, 0, 0, 2, 2, 2};

https://en.wikipedia.org/wiki/IEEE_P802.1p

I'm not sure i actually believe the hardware does not prioritise the
queues. It seems to me, it is more likely to take frames from queues 1
and 2 if they have not consumed their 50% share.

PCP value 0 is best effort. That should really be given the same
priority as a packet without a VLAN header. Which is why i suggested
putting those packets into queue 0.

Also, if the hardware is performing prioritisation, PCP value 1,
background, when put into queue 1 will end up as higher priority then
best effort?

     Andrew

