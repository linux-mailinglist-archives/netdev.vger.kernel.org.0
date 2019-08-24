Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280309BAF0
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfHXCnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:43:01 -0400
Received: from mail.nic.cz ([217.31.204.67]:37266 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHXCnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 22:43:01 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 7341D140D0D;
        Sat, 24 Aug 2019 04:42:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566614579; bh=8cktA2t0gNbPrKbO1811mv89l+iDHa3zL9IZwEnwwBk=;
        h=From:To:Date;
        b=Bsh0Tdo6R5I8s8LwX+KI8nC8GqOH1UsoBc0/QaGFa+BAAQR2hzbWeJE6TlxWcPAhZ
         R2R4F85FEaifcOVb9LFLhB16Qg0vuh8AZ9PHPGerLhOJmFNfcxzPsN4F4zW0my9gkz
         CaStjeGpF47Pw0HzouzZOcb/2In2/ICU0+IOSer0=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Date:   Sat, 24 Aug 2019 04:42:47 +0200
Message-Id: <20190824024251.4542-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
this is my attempt to solve the multi-CPU port issue for DSA.

Patch 1 adds code for handling multiple CPU ports in a DSA switch tree.
If more than one CPU port is found in a tree, the code assigns CPU ports
to user/DSA ports in a round robin way. So for the simplest case where
we have one switch with N ports, 2 of them of type CPU connected to eth0
and eth1, and the other ports labels being lan1, lan2, ..., the code
assigns them to CPU ports this way:
  lan1 <-> eth0
  lan2 <-> eth1
  lan3 <-> eth0
  lan4 <-> eth1
  lan5 <-> eth0
  ...

Patch 2 adds a new operation to the net device operations structure.
Currently we use the iflink property of a net device to report to which
CPU port a given switch port si connected to. The ip link utility from
iproute2 reports this as "lan1@eth0". We add a new net device operation,
ndo_set_iflink, which can be used to set this property. We call this
function from the netlink handlers.

Patch 3 implements this new ndo_set_iflink operation for DSA slave
device. Thus the userspace can request a change of CPU port of a given
port.

I am also sending patch for iproute2-next, to add support for setting
this iflink value.

Marek

Marek Behún (3):
  net: dsa: allow for multiple CPU ports
  net: add ndo for setting the iflink property
  net: dsa: implement ndo_set_netlink for chaning port's CPU port

 include/linux/netdevice.h |  5 +++
 include/net/dsa.h         | 11 ++++-
 net/core/dev.c            | 15 +++++++
 net/core/rtnetlink.c      |  7 ++++
 net/dsa/dsa2.c            | 84 +++++++++++++++++++++++++--------------
 net/dsa/slave.c           | 35 ++++++++++++++++
 6 files changed, 126 insertions(+), 31 deletions(-)

-- 
2.21.0

