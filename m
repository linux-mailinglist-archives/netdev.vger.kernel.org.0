Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7454AA804
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 11:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiBEKGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 05:06:17 -0500
Received: from mxout013.mail.hostpoint.ch ([217.26.49.173]:57596 "EHLO
        mxout013.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233009AbiBEKGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 05:06:17 -0500
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nGHxM-0008Yj-Cr; Sat, 05 Feb 2022 11:06:12 +0100
Received: from [2001:1620:50ce:1969:65d6:ee42:8561:f134]
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nGHxM-000H6J-9A; Sat, 05 Feb 2022 11:06:12 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
Date:   Sat, 5 Feb 2022 11:06:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     thomas.lendacky@amd.com
Cc:     netdev@vger.kernel.org
From:   Thomas Kupper <thomas@kupper.org>
Subject: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B based
 board
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got an OPNsense DEC740 firewall which is based on the AMD V1500B CPU.

OPNsense runs fine on it but on Linux I'm not able to get the 10GbE 
interfaces to work.

My test setup is based on Ubuntu 21.10 Impish Indri with a v5.17-rc2 
kernel compiled from Mr Torvalds sources, tag v5.17-rc2. The second 
10GbE interface (enp6s0f2) is set to receive the IP by DHCPv4.

The relevant dmesg entries after boot are:

[    4.763712] libphy: amd-xgbe-mii: probed
[    4.782850] amd-xgbe 0000:06:00.1 eth0: net device enabled
[    4.800625] libphy: amd-xgbe-mii: probed
[    4.803192] amd-xgbe 0000:06:00.2 eth1: net device enabled
[    4.841151] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
[    5.116617] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1

After that I see a link up on the switch for enp6s0f2 and the switch 
reports 10G link speed.

ethtool reports:

$ sudo ethtool enp6s0f2
Settings for enp6s0f2:
         Supported ports: [ FIBRE ]
         Supported link modes:   Not reported
         Supported pause frame use: No
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  Not reported
         Advertised pause frame use: No
         Advertised auto-negotiation: No
         Advertised FEC modes: Not reported
         Speed: Unknown!
         Duplex: Unknown! (255)
         Auto-negotiation: off
         Port: None
         PHYAD: 0
         Transceiver: internal
         Current message level: 0x00000034 (52)
                                link ifdown ifup
         Link detected: no


Manually assigning an IP and pull the interface up and I end up with:

$ sudo ifconfig enp6s0f2 up

SIOCSIFFLAGS: Device or resource busy

... and dmesg reports:

[  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs) 
vs. 00000000 (enp6s0f2-pcs)
[  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed

After that the lights are out on the switch for that port and it reports 
'no link'

Would that be an known issue or is that configuration simply not yet 
supported?


Kind Regards

Thomas Kupper

