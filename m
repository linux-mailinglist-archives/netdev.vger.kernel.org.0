Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45EAF8AA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfIKJQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:16:05 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53402 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfIKJQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:16:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 2B8C228E4C5
Message-ID: <ad302835a98ca5abc7ac88b3caad64867e33ee70.camel@collabora.com>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 11 Sep 2019 10:16:01 +0100
In-Reply-To: <aa0459e0-64ee-de84-fc38-3c9364301275@gmail.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
         <20190910154238.9155-2-bob.beckett@collabora.com>
         <20190910182635.GA9761@lunn.ch>
         <aa0459e0-64ee-de84-fc38-3c9364301275@gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-09-10 at 11:29 -0700, Florian Fainelli wrote:
> On 9/10/19 11:26 AM, Andrew Lunn wrote:
> > On Tue, Sep 10, 2019 at 04:41:47PM +0100, Robert Beckett wrote:
> > > This enables us to negoatiate pause frame transmission to
> > > prioritise
> > > packet delivery over throughput.
> > 
> > I don't think we can unconditionally enable this. It is a big
> > behaviour change, and it is likely to break running systems. It has
> > affects on QoS, packet prioritisation, etc.
> > 
> > I think there needs to be a configuration knob. But unfortunately,
> > i
> > don't know of a good place to put this knob. The switch CPU port is
> > not visible in any way.
> 
> Broadcast storm suppression is to be solved at ingress, not on the
> CPU
> port, once this lands on the CPU port, it's game over already.

It is not just for broadcast storm protection. The original issue that
made me look in to all of this turned out to be rx descritor ring
buffer exhaustion due to the CPU not being able to keep up with packet
reception.

Although the simple repro case for it is a broadcast storm, this could
happen with many legitimate small packets, and the correct way to
handle it seems to be pause frames, though I am not traditionally a
network programmer, so my knowledge may be incorrect. Please advise if
you know of a better way to handle that.

Fundamentally, with a phy to phy CPU connection, the CPU MAC may well
wish to enable pause frames for various reasons, so we should strive to
handle that I think.


