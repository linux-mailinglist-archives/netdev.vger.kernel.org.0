Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7211EF8F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733016AbfEOLcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 07:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733005AbfEOLcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 07:32:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD220206BF;
        Wed, 15 May 2019 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919939;
        bh=LxcjEKip1v8N/ANBHPxLhn8/Pw2YaorBIk4I7k7IVPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWQwTQhpkd6R1rW05m+xxQsEXfCpGoGfDyNf1ZNuaFSW39iyIk3/GLtG7CO8WEz4r
         zQ+vVgtesRWLvUWsYGHaCegIsn2jQvNhmBzjo6EF6FCotOwDuQoMSGHjs5kXUWqrqk
         Fw5JUYXkjrJ4dbigMCyy4u0GGyWCRkCWTr3ykJOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 5.1 14/46] bonding: fix arp_validate toggling in active-backup mode
Date:   Wed, 15 May 2019 12:56:38 +0200
Message-Id: <20190515090622.798553525@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>

[ Upstream commit a9b8a2b39ce65df45687cf9ef648885c2a99fe75 ]

There's currently a problem with toggling arp_validate on and off with an
active-backup bond. At the moment, you can start up a bond, like so:

modprobe bonding mode=1 arp_interval=100 arp_validate=0 arp_ip_targets=192.168.1.1
ip link set bond0 down
echo "ens4f0" > /sys/class/net/bond0/bonding/slaves
echo "ens4f1" > /sys/class/net/bond0/bonding/slaves
ip link set bond0 up
ip addr add 192.168.1.2/24 dev bond0

Pings to 192.168.1.1 work just fine. Now turn on arp_validate:

echo 1 > /sys/class/net/bond0/bonding/arp_validate

Pings to 192.168.1.1 continue to work just fine. Now when you go to turn
arp_validate off again, the link falls flat on it's face:

echo 0 > /sys/class/net/bond0/bonding/arp_validate
dmesg
...
[133191.911987] bond0: Setting arp_validate to none (0)
[133194.257793] bond0: bond_should_notify_peers: slave ens4f0
[133194.258031] bond0: link status definitely down for interface ens4f0, disabling it
[133194.259000] bond0: making interface ens4f1 the new active one
[133197.330130] bond0: link status definitely down for interface ens4f1, disabling it
[133197.331191] bond0: now running without any active interface!

The problem lies in bond_options.c, where passing in arp_validate=0
results in bond->recv_probe getting set to NULL. This flies directly in
the face of commit 3fe68df97c7f, which says we need to set recv_probe =
bond_arp_recv, even if we're not using arp_validate. Said commit fixed
this in bond_option_arp_interval_set, but missed that we can get to that
same state in bond_option_arp_validate_set as well.

One solution would be to universally set recv_probe = bond_arp_recv here
as well, but I don't think bond_option_arp_validate_set has any business
touching recv_probe at all, and that should be left to the arp_interval
code, so we can just make things much tidier here.

Fixes: 3fe68df97c7f ("bonding: always set recv_probe to bond_arp_rcv in arp monitor")
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_options.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1098,13 +1098,6 @@ static int bond_option_arp_validate_set(
 {
 	netdev_dbg(bond->dev, "Setting arp_validate to %s (%llu)\n",
 		   newval->string, newval->value);
-
-	if (bond->dev->flags & IFF_UP) {
-		if (!newval->value)
-			bond->recv_probe = NULL;
-		else if (bond->params.arp_interval)
-			bond->recv_probe = bond_arp_rcv;
-	}
 	bond->params.arp_validate = newval->value;
 
 	return 0;


