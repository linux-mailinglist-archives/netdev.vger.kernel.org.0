Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88BA2433A0
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 07:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHMFaD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 01:30:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52968 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgHMFaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 01:30:03 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1k65oL-00043S-Tt; Thu, 13 Aug 2020 05:29:58 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 3D5635FDD5; Wed, 12 Aug 2020 22:29:56 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 3758B9FB5C;
        Wed, 12 Aug 2020 22:29:56 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: show saner speed for broadcast mode
In-reply-to: <20200813035509.739-1-jarod@redhat.com>
References: <20200813035509.739-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Wed, 12 Aug 2020 23:55:09 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27388.1597296596.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 12 Aug 2020 22:29:56 -0700
Message-ID: <27389.1597296596@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Broadcast mode bonds transmit a copy of all traffic simultaneously out of
>all interfaces, so the "speed" of the bond isn't really the aggregate of
>all interfaces, but rather, the speed of the lowest active interface.

	Did you mean "slowest" here?

>Also, the type of the speed field is u32, not unsigned long, so adjust
>that accordingly, as required to make min() function here without
>complaining about mismatching types.
>
>Fixes: bb5b052f751b ("bond: add support to read speed and duplex via ethtool")
>CC: Jay Vosburgh <j.vosburgh@gmail.com>
>CC: Veaceslav Falico <vfalico@gmail.com>
>CC: Andy Gospodarek <andy@greyhouse.net>
>CC: "David S. Miller" <davem@davemloft.net>
>CC: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>

	Did you notice this by inspection, or did it come up in use
somewhere?  I can't recall ever hearing of anyone using broadcast mode,
so I'm curious if there is a use for it, but this change seems
reasonable enough regardless.

	-J

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_main.c | 21 ++++++++++++++++++---
> 1 file changed, 18 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 5ad43aaf76e5..c853ca67058c 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4552,13 +4552,23 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
> 	return ret;
> }
> 
>+static u32 bond_mode_bcast_speed(struct slave *slave, u32 speed)
>+{
>+	if (speed == 0 || speed == SPEED_UNKNOWN)
>+		speed = slave->speed;
>+	else
>+		speed = min(speed, slave->speed);
>+
>+	return speed;
>+}
>+
> static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
> 					   struct ethtool_link_ksettings *cmd)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
>-	unsigned long speed = 0;
> 	struct list_head *iter;
> 	struct slave *slave;
>+	u32 speed = 0;
> 
> 	cmd->base.duplex = DUPLEX_UNKNOWN;
> 	cmd->base.port = PORT_OTHER;
>@@ -4570,8 +4580,13 @@ static int bond_ethtool_get_link_ksettings(struct net_device *bond_dev,
> 	 */
> 	bond_for_each_slave(bond, slave, iter) {
> 		if (bond_slave_can_tx(slave)) {
>-			if (slave->speed != SPEED_UNKNOWN)
>-				speed += slave->speed;
>+			if (slave->speed != SPEED_UNKNOWN) {
>+				if (BOND_MODE(bond) == BOND_MODE_BROADCAST)
>+					speed = bond_mode_bcast_speed(slave,
>+								      speed);
>+				else
>+					speed += slave->speed;
>+			}
> 			if (cmd->base.duplex == DUPLEX_UNKNOWN &&
> 			    slave->duplex != DUPLEX_UNKNOWN)
> 				cmd->base.duplex = slave->duplex;
>-- 
>2.20.1
>
