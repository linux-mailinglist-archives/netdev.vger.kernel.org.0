Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E401FC893
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgFQI2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:28:02 -0400
Received: from mail.intenta.de ([178.249.25.132]:42144 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgFQI2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 04:28:02 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 04:28:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=kkDhNBhEaYT5JLHZAjti8L6jDzOErc/SYnWwcbAl2Yk=;
        b=IfO5zOFo1uA2tFb6c5GJbs8cpSrqpriAP0yxcUvMxm3yci4LF2AwpZ+wvPGaOQ8oaiG/eR95ZDFYmOE4Q/ALrqXv9ASnmDQ/uWrIiKoBKSX2OujceftvbQtZhkyYsX/KwkaY9eW9lReunQ9hBvktxtLtC7jgnS4xo4puii+CmZh9ZW3xwiKUGHovZOVLX+kuV9Nc4sJARHIqSo0n3WfJTWfJndZyw4P9B3yF6AikDAUThwxY92Do+PnkCC/68JjBJmCjJomSq7rrlJRyvqQoRZVz/+025Wf2wrBuhuKdQZdoB4hc2C6AHADi4v3BPZAcb6DqSHFjs4MMPlKddUSCeQ==;
Date:   Wed, 17 Jun 2020 10:22:37 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>
Subject: net/dsa/microchip: correct placement of dt property phy-mode?
Message-ID: <20200617082235.GA1523@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

According to Documentation/devicetree/bindings/net/dsa/dsa.txt, the
phy-mode property should be specified on port nodes rather than the
enclosing switch node.

In drivers/net/dsa/microchip/ksz_common.c, ksz_switch_register parses
the phy-mode property from the switch node instead:
| int ksz_switch_register(struct ksz_device *dev,
|                         const struct ksz_dev_ops *ops)
| {
...
|         /* Host port interface will be self detected, or specifically set in
|          * device tree.
|          */
|         if (dev->dev->of_node) {
|                 ret = of_get_phy_mode(dev->dev->of_node, &interface);
|                 if (ret == 0)
|                         dev->interface = interface;
...

In drivers/net/dsa/microchip/ksz9477.c, this phy_interface_t is used to
configure the MAC ports:
| static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
| {
...
|                 switch (dev->interface) {
...
|                 }
|                 ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);

KSZ9477 has two MAC interfaces (GMAC 6 -> RGMII/MII/RMII and GMAC 7 ->
SGMII). Now we're trying to configure the same interface mode for both
MACs here even though these MACs only support distinct interface modes.
This may not be problematic in practice as GMAC 7 ignores most of the
settings on the XMII Port Control 1 Register, but it still sounds wrong.

If nothing else, it makes the device tree unintuitive to use.

Is this placement of the phy-mode on the switch intentional?

If yes: I think this should be prominently documented in
Documentation/devicetree/bindings/net/dsa/ksz.txt.

If no: The microchip driver should follow the documented dsa convention
and place the phy-mode on the relevant port nodes.

If no: Do we have to support old device trees that have the phy-mode
property on the switch?

Helmut
