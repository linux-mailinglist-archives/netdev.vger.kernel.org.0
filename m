Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A6BD5C7
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 02:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390197AbfIYAom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 20:44:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389492AbfIYAom (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 20:44:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cizScs+SXW+pOXrDDka/m3BoXhHDRTYnhi/xtiL0ii4=; b=BAvfgTI+pKQpZk16ITFXgvgIlJ
        Qbi0MTHeq1uHBjDmBX6EVDzD80t33o0k52X8Nvbhx2uvhAqad0EAyXD+yF1LV2j/VoPGt1oICwLCJ
        rzgesyVHRp4QeCOP4ETd73Oci3hMem6azpc/l74aPxU+6PjtvCmtnbkA90OTTQ6YVuIA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCvQ5-0000Qq-MU; Wed, 25 Sep 2019 02:44:37 +0200
Date:   Wed, 25 Sep 2019 02:44:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
Message-ID: <20190925004437.GA1253@lunn.ch>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
 <20190924123126.GE14477@lunn.ch>
 <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7bffa36-f218-d71e-c416-38aff73d35dd@ysoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 03:10:44PM +0200, Michal Vokáč wrote:
> On 24. 09. 19 14:31, Andrew Lunn wrote:
> I added the printk and the above fix and can confirm that it is the CPU
> port and the phy is NULL pointer:
> 
> [    6.976366] qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
> [    6.992021] qca8k 2188000.ethernet-1:0a: port: 0, phy: 0
> [    7.001323] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
> [    7.014221] qca8k 2188000.ethernet-1:0a eth2 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
> [    7.030598] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]
> [    7.043500] qca8k 2188000.ethernet-1:0a eth1 (uninitialized): phy: setting supported 00,00000000,000062ef advertising 00,00000000,000062ef
> [    7.063335] DSA: tree 0 setup
> 
> Now the device boots but there is a problem with the CPU port configuration:

Hi Michal

Thanks for testing. I will post a different fix very soon.

> root@hydraco:~# ifconfig eth0 up
> [  255.256047] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
> [  255.272449] fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> [  255.286539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> root@hydraco:~# ifconfig eth1 up
> [  268.350078] qca8k 2188000.ethernet-1:0a: port: 3, phy: -393143296
> [  268.364442] qca8k 2188000.ethernet-1:0a eth1: configuring for phy/ link mode
> [  268.375400] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//Unknown/Unknown adv=00,00000000,000062ef pause=10 link=0 an=1
> [  268.393901] qca8k 2188000.ethernet-1:0a eth1: phy link up /1Gbps/Full
> [  268.404849] qca8k 2188000.ethernet-1:0a eth1: phylink_mac_config: mode=phy//1Gbps/Full adv=00,00000000,00000000 pause=0e link=1 an=0
> [  268.420740] qca8k 2188000.ethernet-1:0a eth1: Link is Up - 1Gbps/Full - flow control rx/tx
> [  268.432995] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> root@hydraco:~# udhcpc -i eth1
> udhcpc (v1.23.2) started
> Sending discover...
> Sending discover...
> Sending discover...

This i think is something different. What looks odd is
imx6dl-yapp4-common.dtsi

&fec {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_enet>;
        phy-mode = "rgmii-id";
        phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
        phy-reset-duration = <20>;
        phy-supply = <&sw2_reg>;
        phy-handle = <&ethphy0>;
        status = "okay";


	mdio {

               switch@10 {
                        compatible = "qca,qca8334";
                        reg = <10>;

                        switch_ports: ports {
                                #address-cells = <1>;
                                #size-cells = <0>;

                                ethphy0: port@0 {
                                        reg = <0>;
                                        label = "cpu";
                                        phy-mode = "rgmii-id";
                                        ethernet = <&fec>;

Both the FEC and the CPU port are set to use rgmii-id". So we are
getting double delays.

Try changing one of these to plain rgmii.

    Andrew
