Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE9F96436
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfHTPXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:23:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbfHTPXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9u3D2OwuAYkomknxfe7nI/uhFErIGYgeOUnr7FlThfo=; b=m+ndBfXqTovUnl033Fp+MDqeeN
        Mv/HnN0m3aWleaTRaHzZul7L8Er7+l7d/NR7kGEqIcomDNa9WAwfJ5oxQdC8r1lFkm65PTL0Dq5bj
        /LvOajNBLmUOR9UgA1af7HDshm1/WnFVz7UOqvrxUYOt2GSRsnA5BLiiC3w49eKMH8Js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i05yU-0006Ah-GW; Tue, 20 Aug 2019 17:23:06 +0200
Date:   Tue, 20 Aug 2019 17:23:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation
 to mdiobus_write_sts
Message-ID: <20190820152306.GJ29991@lunn.ch>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at>
 <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820142537.GL891@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - take a second "post" system timestamp after the completion

For this hardware, completion is an interrupt, which has a lot of
jitter on it. But this hardware is odd, in that it uses an
interrupt. Every other MDIO bus controller uses polled IO, with an
mdelay(10) or similar between each poll. So the jitter is going to be
much larger.

Even though the FEC is special with its interrupt completion, i would
like to see the solution being reasonably generic so that others can
copy it into other MDIO bus drivers. That is what is nice about taking
the time stamp around the write which triggers the bus transaction. It
is independent of interrupt or polled, and should mean about the same
thing for different vendors hardware.

      Andrew
