Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D113C9F23
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhGONL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 09:11:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhGONL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 09:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=crnV8WiEsXkYRDOXGKgUcdIiSuJkX3wBykL63bhych8=; b=PGteHXKTX7HAeE/TZ52+tsm07W
        9QaWn3GT1Ew2am1IQgb/Zg5KPHd/9AGcLQqee+1eG+bxEDBAFTV7c/px87wrf5mwaGNIsIC3z7NCQ
        NaGzfMgVGeRCL9F2tbD5hiTf4Ftph5Gc81Zxe1tEhfrj79pWa39uX3K1d0pMfX/t7tSQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m416j-00DUS1-Gx; Thu, 15 Jul 2021 15:08:53 +0200
Date:   Thu, 15 Jul 2021 15:08:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <YPAzZXaC/En3s4ly@lunn.ch>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
 <YO9F2LhTizvr1l11@lunn.ch>
 <20210715065455.7nu7zgle2haa6wku@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715065455.7nu7zgle2haa6wku@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - If we inherit NETIF_F_HW_CSUM from the master for tail taggers, it is
>   actively detrimential to keep this feature enabled, as proven my Lino.
>   As for header taggers, I fail to see how this would be helpful, since
>   the DSA master would always fail to see the real IP header (it has
>   been pushed to the right by the DSA tag), and therefore, the DSA
>   master offload would be effectively bypassed.

The Marvell MACs know about DSA and should be able to perform hardware
checksumming. It is a long time since i looked at how this works, but
i think there is a field in the descriptor which gets set with the
offset to the IP header, so it work for DSA as well as EDSA.

I _think_ Broadcom MACs also know about Broadcom tags and can do the
right thing.

So we need to be a bit careful here to prevent performance regressions
for same vendor MAC+Switch combinations.

    Andrew
