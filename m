Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592E48209D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 23:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhL3W0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 17:26:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231871AbhL3W0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 17:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hNjK71O7mMIC8AMPd7oDz/3HuTmKXzhAdSc9pJRyQ6I=; b=rc+6L78phGKb6tT+/GugrabJks
        z645oXYHlAS/b9/j0DeFiw4Hluwjd+w3hGBXuTD/6yzOQ9JRijuuqYiZGBFD/o8Xwhupp/7AOekqT
        3DojyuBsLdEUfQCXm4XfFZkqFcC9BoKuPIKPPvBjZ+Lnc84DlMDjeownO7/glrxToEO0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n33rz-000C8u-JE; Thu, 30 Dec 2021 23:25:59 +0100
Date:   Thu, 30 Dec 2021 23:25:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <Yc4x97vqj2fU9Zg/@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com>
 <Yc30mG7tPQIT2HZK@lunn.ch>
 <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I _think_ this is wrong. pause->autoneg means we are autoneg'ing
> > pause, not that we are using auto-neg in general. The user can have
> > autoneg turned on, but force pause by setting pause->autoneg to False.
> > In that case, the pause->rx_pause and pause->tx_pause are given direct
> > to the MAC, not auto negotiated.
> 
> Having this mixed mode needs device FW support, which isn't there today.

So if you are asked to set pause with pause->autoneg False, return
-EOPNOTSUPP. And pause get should always return True. It is O.K, to
support a subset of a feature, and say you don't support the
rest. That is much better than wrongly implementing it until your
firmware gets the needed support.

> If you force pause, then the link flaps and negotiates FW will apply the new
> negotiated settings. For your scenario you'd want it to support only partial
> application. Meanwhile the partner doesn't know we don't obey the negotiated
> settings so I am suspicious that all of this would work.

What happen when Linux is controlling the hardware, not firmware, is
that phylib makes a callback into the MAC driver telling it the
results of the autoneg. Part of those results are what pause has been
negotiated, if pause is part of the negotiation. The MAC driver then
needs to program the MAC hardware with that information. If pause
autoneg is not being used, you directly program the hardware. When you
have hidden the hardware from Linux, you need a similar API to the
firmware to tell it how to program the hardware.

Forcing pause is mostly there to work around broken link peers who get
pause wrong. And unfortunately, lots of drivers get pause wrong, and
it is not helped by the API being poorly defined, and people
re-inventing the wheel by using firmware, not Linux to control the
hardware. But it also means you don't care too much if the link peer
is confused, it was probably doing the wrong thing anyway.

      Andrew
