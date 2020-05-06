Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EB11C7DF5
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEFXgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:36:05 -0400
Received: from hs2.cadns.ca ([149.56.24.197]:61352 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgEFXgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 19:36:05 -0400
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 67C9421756C
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 19:36:03 -0400 (EDT)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.208.52) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-ed1-f52.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-ed1-f52.google.com with SMTP id a8so3702709edv.2
 for <netdev@vger.kernel.org>; Wed, 06 May 2020 16:36:03 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ74SRFWuKmP8r0/dn2ms3rZbHQpLjfh1g+3tWWNYgy4N8KdRe8
 hLXAcYlYo72UfsSodmQnISX70fvln1z6LKDNcLA=
X-Google-Smtp-Source: APiQypIKF4aK5CJsEKE1QOyAu/TKyWWmD0W1yBBKQljms9Lq27/KdNwBFXz+HilVTmp/dqgTZU9rRwJZ+wVmbrzzB+w=
X-Received: by 2002:aa7:dd84:: with SMTP id g4mr9695876edv.257.1588808162220;
 Wed, 06 May 2020 16:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAOK2joE-4AWxvT5YWoCFTUb6WhwpSST2bLavKvL8SZi1D3_2VQ@mail.gmail.com>
In-Reply-To: <CAOK2joE-4AWxvT5YWoCFTUb6WhwpSST2bLavKvL8SZi1D3_2VQ@mail.gmail.com>
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Wed, 6 May 2020 19:35:50 -0400
X-Gmail-Original-Message-ID: <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
Message-ID: <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
Subject: Kernel crash in DSA/Marvell 6176 switch in 5.4.36
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-PPP-Message-ID: <20200506233603.10363.33566@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For this device tree with new binding, there was no crash with 4.19.16
kernel on an NXP imx6 device but there is with 5.4.36.
         eth0: igb0 {
                         compatible = "intel,igb";
                        /* SC: New binding for the Marvell 6176 switch
attached to the Intel Gigabit Ethernet Controller via SERDES link */
                          mdio1: mdio@0 {
                              #address-cells = <2>;
                              #size-cells = <0>;
                              status = "okay";
                              switch0: switch0@0 {

                                compatible = "marvell,mv88e6085";
                                reg = <0 0>;
                                interrupt-parent = <&gpio2>;
                                interrupts = <31 IRQ_TYPE_LEVEL_LOW>;
                                dsa,member = <0 0>;
                                mdio2: mdio@1{
                                 ports
                                 {

                                   #address-cells = <1>;
                                   #size-cells = <0>;
                                   port@0 {
                                          reg = <0>;
                                          label = "port0";
                                   };
                                   port@1 {
                                         reg = <1>;
                                         label = "port1";
                                   };

                                   port@2 {
                                        reg = <2>;
                                        label = "port2";
                                  };

                                   port@5 {
                                        reg = <5>;
                                        label = "cpu";
                                        ethernet = <&eth0>;
                                  };
                                 };
                            };
                          mdio3: mdio@2{ /*SC: External configuration
MDIO bus. Followed example in
Documentation/devicetree/bindings/dsa/marvell.txt */
                            compatible = "marvell,mv88e6xxx-mdio-external";
                            #address-cells = <1>;
                            #size-cells = <0>;
                          };
                     };
   Here is log of the 5.4.36 kernel crash. Can someone point to what
could be going on here?

63] mdio_bus !soc!pcie@1ffc000!pcie@2,1!pcie@3,0!igb0!mdio@0!switch0@0!md:
ports has invalid PHY address
[    2.239378] mdio_bus
!soc!pcie@1ffc000!pcie@2,1!pcie@3,0!igb0!mdio@0!switch0@0!md: scan phy
ports at address 0
[    2.240858] mmcblk1: mmc1:0007 SDCIT 29.2 GiB
[    2.244341] ------------[ cut here ]------------
[    2.244355] WARNING: CPU: 2 PID: 44 at kernel/kmod.c:137 0x800433d0
[    2.244359] Modules linked in:
[    2.244372] CPU: 2 PID: 44 Comm: kworker/u8:3 Not tainted 5.4.36 #0
[    2.244377] Hardware name: Freescale i.MX6 Quad/DualLite (Device
Tree)
[    2.244386] Workqueue: events_unbound 0x80041cbc
[    2.244402] Function entered at [<80016344>] from [<8001299c>]
[    2.244408] Function entered at [<8001299c>] from [<8053a850>]
[    2.244413] Function entered at [<8053a850>] from [<80024108>]
[    2.244418] Function entered at [<80024108>] from [<80024174>]
[    2.244423] Function entered at [<80024174>] from [<800433d0>]
[    2.244429] Function entered at [<800433d0>] from [<802e8ec0>]
[    2.244435] Function entered at [<802e8ec0>] from [<802ea4c0>]
[    2.244440] Function entered at [<802ea4c0>] from [<802ea63c>]
[    2.244444] Function entered at [<802ea63c>] from [<803d5a40>]
[    2.244449] Function entered at [<803d5a40>] from [<803d617c>]
[    2.244456] Function entered at [<803d617c>] from [<802ed25c>]
[    2.244461] Function entered at [<802ed25c>] from [<802ef0c0>]
[    2.244466] Function entered at [<802ef0c0>] from [<802ebb0c>]
[    2.244470] Function entered at [<802ebb0c>] from [<8027804c>]
[    2.244475] Function entered at [<8027804c>] from [<80278340>]
[    2.244479] Function entered at [<80278340>] from [<802765d8>]
[    2.244484] Function entered at [<802765d8>] from [<80277dec>]
[    2.244488] Function entered at [<80277dec>] from [<802771f0>]
[    2.244493] Function entered at [<802771f0>] from [<802748e8>]
[    2.244498] Function entered at [<802748e8>] from [<802ebbb0>]
[    2.244502] Function entered at [<802ebbb0>] from [<803d604c>]
[    2.244506] Function entered at [<803d604c>] from [<8032acd8>]
[    2.244511] Function entered at [<8032acd8>] from [<8021d0d8>]
[    2.244516] Function entered at [<8021d0d8>] from [<8027804c>]
[    2.244521] Function entered at [<8027804c>] from [<80278340>]
[    2.244524] Function entered at [<80278340>] from [<802765d8>]
[    2.244529] Function entered at [<802765d8>] from [<80277dec>]
[    2.244533] Function entered at [<80277dec>] from [<80211c84>]
[    2.244537] Function entered at [<80211c84>] from [<80211cfc>]
[    2.244542] Function entered at [<80211cfc>] from [<80211d30>]
[    2.244552] ---[ end trace 4bc0e4b8c964c71c ]---
[    2.245041] mv88e6085 0000:03:00.0-1538:00: no ports child node found
