Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACE91DC067
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgETUob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:44:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42046 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgETUob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a6QPITVk+6xXi5kvcJS5iU8GxNuNEtzpnALCwBE2+sA=; b=Dt2BB6xUa2vA74dYY4QxCZ1CYt
        0inLbZVVBkuw+cf0YPBypgCvHZcj2uc83iAS6HwHOaJIFIQfSHdUOc7krH7JjgIH3jh+NDasWuL1V
        wHRylaQpP3C7rBxXP5/wk6klOxNfRu/j5nDyQv0XZvJew7Wd0kVh787H9FmpRvLqOckA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbVZf-002qGB-CY; Wed, 20 May 2020 22:44:23 +0200
Date:   Wed, 20 May 2020 22:44:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200520204423.GA677363@lunn.ch>
References: <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
 <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
 <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
 <20200520192719.GK652285@lunn.ch>
 <0bba1378-0847-491f-8f21-ac939ac48820@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0bba1378-0847-491f-8f21-ac939ac48820@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think adding it in the core would be a bit of a challenge.  I think each
> PHY driver needs to handle parsing and validating this property on its own
> (like fifo-depth).  It is a PHY specific setting.

fifo-depth yes. But some delays follow a common pattern.

e.g.
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt

Device Tree Value     Delay   Pad Skew Register Value
  -----------------------------------------------------
        0               -840ps          0000
        200             -720ps          0001
        400             -600ps          0010
        600             -480ps          0011
        800             -360ps          0100
        1000            -240ps          0101
        1200            -120ps          0110
        1400               0ps          0111
        1600             120ps          1000
        1800             240ps          1001
        2000             360ps          1010
        2200             480ps          1011
        2400             600ps          1100
        2600             720ps          1101
        2800             840ps          1110
        3000             960ps          1111

Documentation/devicetree/bindings/net/adi,adin.yaml

 adi,rx-internal-delay-ps:
    description: |
      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
    enum: [ 1600, 1800, 2000, 2200, 2400 ]
    default: 2000

  adi,tx-internal-delay-ps:
    description: |
      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
    enum: [ 1600, 1800, 2000, 2200, 2400 ]
    default: 2000

Documentation/devicetree/bindings/net/apm-xgene-enet.txt

- tx-delay: Delay value for RGMII bridge TX clock.
            Valid values are between 0 to 7, that maps to
            417, 717, 1020, 1321, 1611, 1913, 2215, 2514 ps
            Default value is 4, which corresponds to 1611 ps
- rx-delay: Delay value for RGMII bridge RX clock.
            Valid values are between 0 to 7, that maps to
            273, 589, 899, 1222, 1480, 1806, 2147, 2464 ps
            Default value is 2, which corresponds to 899 ps

You could implement checking against a table of valid values, which is
something you need for your PHY. You could even consider making it a
2D table, and return the register value, not the delay?

	  Andrew
