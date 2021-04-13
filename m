Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D526F35D884
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhDMHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:10:00 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:52255 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhDMHJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:09:57 -0400
Received: from [10.0.29.110] (unknown [10.0.29.110])
        by uho.ysoft.cz (Postfix) with ESMTP id 4717FA0494;
        Tue, 13 Apr 2021 09:09:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1618297777;
        bh=GvpKB9CHk+oE3F7nATUj71fejlSAjH2cyD8zl2T6k5k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eicssWZL/wbFjZc7kGyPoyNLPgQfMzOsEJl/gAttDoYuXOLAJJl1OPBuQr/ni8UVZ
         PkqffUt/X1OMGC2PQRNehfgbYqqf3AW9sIP0iu3crHIM6CT8Zf1TLu0hX2JgKFJyKt
         an6tQ23k0whlElbqFGeq/aF1Y271xvK+effbqg5Y=
Subject: Re: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK
 conversion
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
 <YHRVv/GwCmnRN14j@lunn.ch>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
Date:   Tue, 13 Apr 2021 09:09:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHRVv/GwCmnRN14j@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12. 04. 21 16:14, Andrew Lunn wrote:
>> [1] https://elixir.bootlin.com/linux/v5.12-rc7/source/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi#L101
> 
> &fec {
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&pinctrl_enet>;
> 	phy-mode = "rgmii-id";
> 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
> 	phy-reset-duration = <20>;
> 	phy-supply = <&sw2_reg>;
> 	phy-handle = <&ethphy0>;
> 	status = "okay";
> 
> 	mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		phy_port2: phy@1 {
> 			reg = <1>;
> 		};
> 
> 		phy_port3: phy@2 {
> 			reg = <2>;
> 		};
> 
> 		switch@10 {
> 			compatible = "qca,qca8334";
> 			reg = <10>;
> 
> 			switch_ports: ports {
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 
> 				ethphy0: port@0 {
> 					reg = <0>;
> 					label = "cpu";
> 					phy-mode = "rgmii-id";
> 					ethernet = <&fec>;
> 
> 					fixed-link {
> 						speed = <1000>;
> 						full-duplex;
> 					};
> 				};
> 
> The fec phy-handle = <&ethphy0>; is pointing to the PHY of switch port
> 0. This seems wrong.

I do not understand. Why this seems wrong?
The switch has four ports. Ports 2 and 3 have a PHY and are connected
to the transformers/RJ45 connectors. Port 0 is MII/RMII/RGMII of
the switch. Port 6 (not used) is a SerDes.

> Does the FEC have a PHY? Do you connect the FEC
> and the SWITCH at the RGMII level? Or with two back to back PHYs?
> 
> If you are doing it RGMII level, the FEC also needs a fixed-link.

The FEC does not have PHY and is connected to the switch at RGMII level.
Adding the fixed-link { speed = <1000>; full-duplex; }; subnode to FEC
does not help.

Michal
