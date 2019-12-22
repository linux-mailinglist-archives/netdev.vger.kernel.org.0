Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA0A128FB8
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 20:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfLVTWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 14:22:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57368 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfLVTWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 14:22:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q+dnYQRpdJ9XMCIcbhAo2DV0Ohg8WcWTEPIeiDyjL4Y=; b=WmQbiiTjWMyRMZEYs+7PaQZPJ
        xSXaUNHyi+h1RXbA1T8u/rlsGswCucUi8MVY03TRnKDoxvOwysyDGEBzn3EFezjpl/4rRFwMUbwxu
        rn80Lu7zl4mpkCB3uULd8gnkJDpJqslsWXnOKNxVOSP9W7KEzCmNrH2FJbGhjCsTXYoUcFggfxPCW
        wggT4Yqc35x0D66qiLo1IaIt3N1DGTygaYqxJHT3phj9JbM0CwAhgoq4q3vErWEpaMncZMXmWeX+k
        Xp2bibWN4YoXJ8XLzg6sj3eh2xuJuC4WrXloEMcVV7cAqEjAzpBxGTYxWLaocVDQH5z+A1GC6o/My
        on3jdChSA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56584)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ij6oK-0005qU-2w; Sun, 22 Dec 2019 19:22:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ij6oF-00008M-JK; Sun, 22 Dec 2019 19:22:35 +0000
Date:   Sun, 22 Dec 2019 19:22:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20191222192235.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been trying to configure DSA for VLANs and not having much success.
The setup is quite simple:

- The main network is untagged
- The wifi network is a vlan tagged with id $VN running over the main
  network.

I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
setup to provide wifi access to the vlan $VN network, while the switch
is also part of the main network.

However, I'm encountering problems:

1) vlan support in DSA has a different behaviour from the Linux
   software bridge implementation.

    # bridge vlan
    port    vlan ids
    lan1     1 PVID Egress Untagged
    ...

   shows the default setup - the bridge ports are all configured for
   vlan 1, untagged egress, and vlan 1 as the port vid.  Issuing:

    # ip li set dev br0 type bridge vlan_filtering 1

   with no other vlan configuration commands on a Linux software bridge
   continues to allow untagged traffic to flow across the bridge.
   
   This difference in behaviour is because the MV88E6xxx VTU is
   completely empty - because net/dsa ignores all vlan settings for
   a port if br_vlan_enabled(dp->bridge_dev) is false - this reflects
   the vlan filtering state of the bridge, not whether the bridge is
   vlan aware.
   
   What this means is that attempting to configure the bridge port
   vlans before enabling vlan filtering works for Linux software
   bridges, but fails for DSA bridges.

2) Assuming the above is sorted, we move on to the next issue, which
   is altogether more weird.  Let's take a setup where we have a
   DSA bridge with lan1..6 in a bridge device, br0, with vlan
   filtering enabled.  lan1 is the upstream port, lan2 is a downstream
   port that also wants to see traffic on vlan id $VN.

   Both lan1 and lan2 are configured for that:

     # bridge vlan add vid $VN dev lan1
     # bridge vlan add vid $VN dev lan2
     # ip li set br0 type bridge vlan_filtering 1

   Untagged traffic can now pass between all the six lan ports, and
   vlan $VN between lan1 and lan2 only.  The MV88E6xxx 8021q_mode
   debugfs file shows all lan ports are in mode "secure" - this is
   important!  /sys/class/net/br0/bridge/vlan_filtering contains 1.

   tcpdumping from another machine on lan4 shows that no $VN traffic
   reaches it.  Everything seems to be working correctly...
   
   In order to further bridge vlan $VN traffic to hostapd's wifi
   interface, things get a little more complex - we can't add hostapd's
   wifi interface to br0 directly, because hostapd will bring up the
   wifi interface and leak the main, untagged traffic onto the wifi.
   (hostapd does have vlan support, but only as a dynamic per-client
   thing, and there's no hooks I can see to allow script-based config
   of the network setup before hostapd up's the wifi interface.)

   So, what I tried was:

     # ip li add link br0 name br0.$VN type vlan id $VN
     # bridge vlan add vid $VN dev br0 self
     # ip li set dev br0.$VN up

   So far so good, we get a vlan interface on top of the bridge, and
   tcpdumping it shows we get traffic.  The 8021q_mode file has not
   changed state.  Everything still seems to be correct.

     # bridge addbr br1

   Still nothing has changed.

     # bridge addif br1 br0.$VN

   And now the 8021q_mode debugfs file shows that all ports are now in
   "disabled" mode, but /sys/class/net/br0/bridge/vlan_filtering still
   contains '1'.  In other words, br0 still thinks vlan filtering is
   enabled, but the hardware has had vlan filtering disabled.

   Adding some stack traces to an appropriate point indicates that this
   is because __switchdev_handle_port_attr_set() recurses down through
   the tree of interfaces, skipping over the vlan interface, applying
   br1's configuration to br0's ports.

   This surely can not be right - surely
   __switchdev_handle_port_attr_set() and similar should stop recursing
   down through another master bridge device?  There are probably other
   network device classes that switchdev shouldn't recurse down too.

   I've considered whether switchdev is the right level to do it, and
   I think it is - as we want the check/set callbacks to be called for
   the top level device even if it is a master bridge device, but we
   don't want to recurse through a lower master bridge device.

Some proposed patches are attached.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
