Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB21F109
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 13:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfEOLTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 07:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbfEOLTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 07:19:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C0A52166E;
        Wed, 15 May 2019 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919190;
        bh=svzfr6ww1SG7IFsfc8tDxKlG+G/RnbdZqTMRIy6WTvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq7yXbkQ4Vd6Pfc+Mqr7IU/UHMtmGLwkMjgmc3NzIvu7d0I9othUeQRSE4WMy8WhZ
         iTp9+FB+doRec/ke7hpCEilHYPjI1PeVvKS50jzsM+f5aMQa6ytjefF3jzCF6xiMcH
         nUD8dso1/uAUjQNJraXyX3HkpOF+5LhSZhHU+iJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 4.14 099/115] bonding: fix arp_validate toggling in active-backup mode
Date:   Wed, 15 May 2019 12:56:19 +0200
Message-Id: <20190515090706.340590100@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
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
 drivers/net/bonding/bond_options.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 4d5d01cb8141..80867bd8f44c 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1098,13 +1098,6 @@ static int bond_option_arp_validate_set(struct bonding *bond,
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
-- 
2.20.1



