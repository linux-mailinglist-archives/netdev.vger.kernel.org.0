Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957E811D816
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbfLLUtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:49:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbfLLUtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 15:49:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZHoU3IAj9vIOIpdUdIlgIwi9co80WT5unLMZtFmwK4Y=; b=0TBtfmbdsmEZOB6vwmHAEhxeKJ
        cSXvoEwIa4X7A+H01h8xwaLAjsARjxm3Co/1u7QD4Rt020gA0mMe//5xG2QXZaA7pbapjVHYzHb6p
        4xvjaG1OJxePtOstitWXpZwnxgeQMPciSUoh+ol+GUScyRtra2QGRQzExIF265CL7yFU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ifVOe-0004qu-CX; Thu, 12 Dec 2019 21:49:16 +0100
Date:   Thu, 12 Dec 2019 21:49:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212204916.GG30053@lunn.ch>
References: <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
 <20191212193129.GF30053@lunn.ch>
 <20191212204141.16a406cd@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212204141.16a406cd@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Baruch, if the cpu port is in 2500 base-x, remove the fixed-link and do
> this:
> 
> port@5 {
> 	reg = <5>;
> 	label = "cpu";
> 	ethernet = <&cp1_eth2>;
> 	phy-mode = "2500base-x";
> 	managed = "in-band-status";
> };
> 
> Andrew, if the dsa driver is expected to do that, the code certainly
> does not do so. For example in mv88e6xxx_port_set_cmode you have:
>  /* Default to a slow mode, so freeing up SERDES interfaces for
>   * other ports which might use them for SFPs.
>   */
>  if (mode == PHY_INTERFACE_MODE_NA)
>          mode = PHY_INTERFACE_MODE_1000BASEX;

Yah, Ports 9 and 10 of 6390X are a bit odd. They can do 10Gbps. But
only if you set the correct phy-mode. Then they will default to 10G.
If these ports are not doing 10Gbps they can lend there SERDES
interfaces to other ports. There are a few boards which want this
lending, connecting lots of SFPs using these SERDES interfaces. And
there are other boards which do use the ports at 10G as DSA links. DSA
links also default to the maximum speed of the port, and that does
work if you set the correct phy-mode.

So in general, if the port supports > 1Gbps, you need to set the
phy-mode for CPU and DSA ports. It will then default to the maximum
speed for that mode.

     Andrew
