Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9161A1C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 06:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfGHEmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 00:42:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbfGHEmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 00:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=95LVqDfvWrexjilvILPfhiRz12KB/E9HZD332mFUWbM=; b=Uavy7v0G9LFF5LKjlxRUY+5bVp
        Ii0IO0L3BhWE2uOu6UDKwC2n+phnnsUMv76YvCuCJ+zlAslUAAtv2rhf+EXhFFnAh0u/pK7jn5Ay3
        4wr7UNEqzdx2102Mf1KkyznsT+s8PyeqoYPNdRJ/btUbqdacMPFxKDqHO3NSon5asjMc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkLTw-0008Tq-JM; Mon, 08 Jul 2019 06:42:28 +0200
Date:   Mon, 8 Jul 2019 06:42:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "kwangdo.yi" <kwangdo.yi@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
Message-ID: <20190708044228.GA32068@lunn.ch>
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 07, 2019 at 06:32:12PM -0400, kwangdo.yi wrote:
> When mdio driver polling the phy state in the phy_state_machine,
> sometimes it results in -ETIMEDOUT and link is down. But the phy
> is still alive and just didn't meet the polling deadline. 
> Closing the phy link in this case seems too radical. Failing to 
> meet the deadline happens very rarely. When stress test runs for 
> tens of hours with multiple target boards (Xilinx Zynq7000 with
> marvell 88E1512 PHY, Xilinx custom emac IP), it happens. This 
> patch gives another chance to the phy_state_machine when polling 
> timeout happens. Only two consecutive failing the deadline is 
> treated as the real phy halt and close the connection.

Hi Kwangdo

I agree with Florian here. This does not seem like a PHY problem. It
is an MDIO bus problem. ETIMEDOUT is only returned from
xemaclite_mdio_wait().

What value are using for HZ? If you have 1000, jiffies + 2 could well
be too short.

   Andrew
