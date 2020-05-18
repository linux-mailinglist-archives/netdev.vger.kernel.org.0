Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE011D894E
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgERUe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:34:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgERUe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V0hUCdZRE2aQ0OAd4JagZgLT493qRfoUuMn4+XBpcNw=; b=EXPcOwSvzc/kvh5HmOjUqjo8Ny
        8p0wFFbBo2hW+J2m/1mcR27CYAiwRvz1S03ex4x3tAgwSwqB0YO9zHaa4qOQmAlCE2pgwdjqRQugq
        Kq6HFcSeHqzt85hDdC/OpAyxNNAldrek/GBD+ZKjqbQJtZD4Htd/ygn+jtRYKEuiqTW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jamTH-002e2q-Qj; Mon, 18 May 2020 22:34:47 +0200
Date:   Mon, 18 May 2020 22:34:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link support
Message-ID: <20200518203447.GF624248@lunn.ch>
References: <20200516192402.4201-1-rberg@berg-solutions.de>
 <20200517183710.GC606317@lunn.ch>
 <6E144634-8E2F-48F7-A0A4-6073164F2B70@berg-solutions.de>
 <20200517235026.GD610998@lunn.ch>
 <EB9FB222-D08A-464F-93C0-5885C010D582@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EB9FB222-D08A-464F-93C0-5885C010D582@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I double checked the vendor documentation and according to the data
> sheet in this device the MAC detects speed and duplex mode. It uses
> PINs, traces clocks … Also according to an application note of the
> vendor duplex and speed detection should be enabled in the MAC
> registers.

In general, the MAC should not perform MDIO requests on the PHY.  The
MAC has no access to the mutex which phylib users. So if the MAC
directly accesses registers in the PHY, it could do it at the wrong
time, when the PHY driver is active.

This can be particularly bad when Marvell PHYs are used. They have
paged registers. One example is the page with the temperature sensor.
This can be selected due to a read on the hwmon device. If the MAC
tried to read the speed/duplex which the temperature sensor is
selected, it would wrongly read the temperature sensor registers, not
the link state.

There is no need for the MAC to directly access the PHY. It will get
told what the result of auto-neg is. So please turn this off all the
time.

	Andrew
