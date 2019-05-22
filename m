Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D54426858
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfEVQc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:32:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43449 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbfEVQc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 12:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=D1gNmludZPL6B4lsx5OVu/bZnY4sDzVHbOdpDCpBdLk=; b=uRcA362GqDkw4mWK0tQWUdtzw6
        A4nAbsDB/a9eOPTlEJdYFtxPdCzgXtX6+J44zcuqnNS3FZexh+4GU3huoHfa/LdwZU/w0KDLAcuI/
        eUAKyueQiDbBAS6SKsy76v3i/ZzIXtIchsST9fbzIDv4OlaZiPm/joZ2uPrkXPWVSrG4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTUAh-00008e-Hn; Wed, 22 May 2019 18:32:55 +0200
Date:   Wed, 22 May 2019 18:32:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA setup IMX6ULL and Marvell 88E6390 with 2 Ethernet Phys - CPU
 Port is not working
Message-ID: <20190522163255.GA25130@lunn.ch>
References: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 10:33:29AM +0200, Benjamin Beckmeyer wrote:
> Hi all,
> 
> I'm currently working on a custom board with the imx6ull processor and the 6390 
> switching chip. This is our hardware setup. 
> 
> ------------     ---------         ---------    MAC     ------------
> |   i.MX   | MAC |  PHY  |   PHY   |  PHY  |------------|  88E6390 |
> |   6ULL   |-----|KSZ8081|---------|LAN8742|	MDIO	|P0        |
> |          |     |ID 0x1 |         | ID0x0 |------------|          |
> |          |     ---------         ---------            |          |
> |          |	     |                                  |MULTI CHIP|
> |          |	     |MDIO                              |ADDR MODE |
> |          |	     |                                  |          |
> |          |--------------------------------------------|   PHY ID |
> |          |                    MDIO                    |     0x2  |
> ------------						------------

Hi Benjamin

KSZ8081 is a 10/100 PHY, i think.
LAN8742 is also a 10/100 PHY.

However, DSA will configure the CPU port MAC to its maximum speed. So
port 0 will be doing 1G. I don't know if specifying phy-mode = "rmii"
is enough. You should take a look at the port status and configuration
registers, see if the MAC is being forced to 1G, or 100M.

You could add a fixed-phy to port 0 with speed 100. That will at least
get the MAC part configured correctly.

Is the LAN8742 strapped so that on power on it will auto-neg? I've
seen a few board with this back-to-back PHY setup, and they just rely
on the PHYs doing the right thing on power up, no software involved.

   Andrew
