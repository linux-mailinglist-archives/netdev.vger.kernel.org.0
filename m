Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11191292943
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgJSO0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 10:26:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgJSO0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 10:26:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUW75-002Vj0-KQ; Mon, 19 Oct 2020 16:26:15 +0200
Date:   Mon, 19 Oct 2020 16:26:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     michael alayev <mic.al.linux@gmail.com>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, adror@iai.co.il
Subject: Re: Dts for eth network based on marvell's mv88e6390x crashes
 Xilinx's linux-kernel v5.4
Message-ID: <20201019142615.GS139700@lunn.ch>
References: <CANBsoPmgct2UTq=Cuf1rXJRitiF1mWhWwdtH2=73yyZiJbT0rg@mail.gmail.com>
 <20201016033142.GB456889@lunn.ch>
 <CANBsoPkCEZadmBaeZ=8EAOP6Ctw5deLen7yKQk__1-ZVoJE6yA@mail.gmail.com>
 <20201018155818.GB456889@lunn.ch>
 <CANBsoPm1Ln=59cGKbaA5OKdjA5dwEFA0pcg2tPUa5i2Db747Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANBsoPm1Ln=59cGKbaA5OKdjA5dwEFA0pcg2tPUa5i2Db747Fw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 05:05:08PM +0300, michael alayev wrote:
> Hello Andrew,
> 
> 
>     > Please fix your email client and
> 
> 
>     > post the DT file for review. I will
> 
>     > then point out some of the errors.
> 
> 
> 
>     &gem0 {
>         status = "okay";
>         phy-mode = "rgmii-id";
>         phy-handle = <&phy0>;

The diagram you showed had gem0 connected directly to the switch. So
this phy-handle is wrong. Or the diagram is wrong.

> 
>         mdio {
>             #address-cells = <1>;
>             #size-cells = <0>;
> 
>             phy0: ethernet-phy@0 {
>                 compatible = "marvell";
>                 reg = <0>;
>                 device_type = "ethernet-phy";
>                 fixed-link {
>                     speed = <1000>;
>                     full-duplex;
>                 };
>             };
> 
>             debug_phy: ethernet-phy@1 {
>             compatible = "marvell";
>             reg = <1>;
>             device_type = "ethernet-phy";
>             label = "debug-phy";
>         };

indentation is all wrong here.

>         switch0: switch@2 {
>             compatible = "marvell,mv88e6190";
>             #address-cells = <1>;
>             #size-cells = <0>;
>             reg = <2>;
> 
>             dsa,member = <0 0>;
> 
>             ports {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 switch0phy1: port@0 {
>                     reg = <0>;
>                     label = "uid208-cpu";
>                     ethernet = <&gem0>;
>                     phy-mode = "rgmii-id";

You have gem0 using gphy-mode = "rgmii-id" as well. Both doing delays
will not work. You should drop the one in gem0.

>                     fixed-link {
>                         speed = <1000>;
>                         full-duplex;
>                     };
>                 };
> 
> 
>                 port@1 {
>                     reg = <1>;
>                     label = "uid201-1A";
>                 };
> 
>                 port@2 {
>                     reg = <2>;
>                     label = "uid202-2A-p9-1A";
>                     phy-mode = "1000base-x";
>                     fixed-link {
>                         speed = <1000>;
>                         full-duplex;
>                     };

Why both 1000base-x and fixed link? Do you have an SFP connected? If
so, describe the SFP in DT.

>                 };
> 
>                 switch0port10: port@10 {
>                     reg = <10>;
>                     label = "dsa";
>                     link = <&switch1port10>;
>                     phy-mode = "1000base-x";
>                     fixed-link {
>                         speed = <1000>;
>                         full-duplex;
>                     };
>                 };

This is a 6390X right? Why limit it to 1000base-X when it could be
doing 10G?

      Andrew
