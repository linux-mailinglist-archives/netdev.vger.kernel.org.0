Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC29B479C0F
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 19:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhLRScu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 13:32:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33552 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232110AbhLRScu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 13:32:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xdAElQbK3eYxJSM8ns4jJZpeB2KYRyByv11FcMKhd4Y=; b=nLnQj0XQfG7MbbHrOxgWbbFuiF
        bGbhDzXDE6ei5kAkgzD7+qFdmjgWjsgXDpFxpksEKvRq7PAeTnD5YYNHwsddlqUWS/Fo6cHEr1NpM
        JErDKLZpbwpuPrSV7qG2/yL62kKtEH2GGcx3VpAtc8ypW3mOSv1NytiOQ05+lJxz8ILQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1myeVi-00GuxM-5k; Sat, 18 Dec 2021 19:32:46 +0100
Date:   Sat, 18 Dec 2021 19:32:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gabriel Hojda <ghojda@yo2urs.ro>
Cc:     Martyn Welch <martyn.welch@collabora.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Markus Reichl <m.reichl@fivetechno.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
Message-ID: <Yb4pTu3FtkGPPpzb@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch>
 <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
 <Yb4m3xms1zMf5C3T@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yb4m3xms1zMf5C3T@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> O.K, stab in the dark. Does the hardware need to be programmed with
> the MAC address? When does this happen? If this is going wrong, it
> could explain the promisc mode. If the MAC address has not been
> programmed, it has no idea what packets are for itself. Put it into
> promisc mode, and it will receive everything, including what it is
> supposed to receive. But looking at the offending patch, it is not
> obvious how it has anything to do with MAC addresses. The only
> unbalanced change in that patch is that smsc95xx_reset(dev) has
> disappeared, not moved to somewhere else.

Ah!

smsc95xx_reset() calls smsc95xx_set_mac_address(). So that fits.
smsc95xx_reset() is also called in smsc95xx_bind(), but maybe that is
not enough?

	Andrew
