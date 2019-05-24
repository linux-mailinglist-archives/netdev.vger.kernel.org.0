Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B59328ED3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbfEXBeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:34:25 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:21282
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387983AbfEXBeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:34:25 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2019 21:34:25 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CNAADNRudc/zXSMGcNWRwBAQEEAQE?=
 =?us-ascii?q?HBAEBgVQEAQELAYg4k1cBAQEBAQEGgQiEC4VwkQQJAQEBAQEBAQEBNwEBAYQ?=
 =?us-ascii?q?/gl03Bg4BAwEBAQQBAQEBAwGGYicVQRsNDQImAl8NCAEBgx6Bd6VkcYEvGoU?=
 =?us-ascii?q?tgy+BRoEMKAGBYIoIeIEHgTiCaz6HToJYBJNTlGsJgg+TCAYbjGgDiU2kUIF?=
 =?us-ascii?q?5MxoIKAiDKIJFjh6PGwEB?=
X-IPAS-Result: =?us-ascii?q?A2CNAADNRudc/zXSMGcNWRwBAQEEAQEHBAEBgVQEAQELA?=
 =?us-ascii?q?Yg4k1cBAQEBAQEGgQiEC4VwkQQJAQEBAQEBAQEBNwEBAYQ/gl03Bg4BAwEBA?=
 =?us-ascii?q?QQBAQEBAwGGYicVQRsNDQImAl8NCAEBgx6Bd6VkcYEvGoUtgy+BRoEMKAGBY?=
 =?us-ascii?q?IoIeIEHgTiCaz6HToJYBJNTlGsJgg+TCAYbjGgDiU2kUIF5MxoIKAiDKIJFj?=
 =?us-ascii?q?h6PGwEB?=
X-IronPort-AV: E=Sophos;i="5.60,505,1549900800"; 
   d="scan'208";a="225572736"
Received: from unknown (HELO [10.44.0.22]) ([103.48.210.53])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 24 May 2019 09:25:04 +0800
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Greg Ungerer <gerg@kernel.org>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Set correct interface mode for
 CPU/DSA ports
Message-ID: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
Date:   Fri, 24 May 2019 11:25:03 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I have a problem with a Marvell 6390 switch that I have bisected
back to commit 7cbbee050c95, "[PATCH] net: dsa: mv88e6xxx: Set correct
interface mode for CPU/DSA ports".

I have a Marvell 380 SoC based platform with a Marvell 6390 10 port
switch, everything works with kernel 5.0 and older. As of 5.1 the
switch ports no longer work - no packets are ever received and
none get sent out.

The ports are probed and all discovered ok, they just don't work.

   mv88e6085 f1072004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
   libphy: mv88e6xxx SMI: probed
   mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv88e6xxx-1:01] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv88e6xxx-1:02] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv88e6xxx-1:03] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv88e6xxx-1:04] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan5 (uninitialized): PHY [mv88e6xxx-1:05] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan6 (uninitialized): PHY [mv88e6xxx-1:06] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan7 (uninitialized): PHY [mv88e6xxx-1:07] driver [Marvell 88E6390]
   mv88e6085 f1072004.mdio-mii:10 lan8 (uninitialized): PHY [mv88e6xxx-1:08] driver [Marvell 88E6390]
   DSA: tree 0 setup

Things like ethtool on the ports seem to work ok, reports link correctly.
Configuring ports as part of a bridge or individually gets the same result.

Reverting just this single commit gets the ports working again
with a linux-5.1 kernel.

Any ideas?

Regards
Greg
