Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2EF2CC86D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbgLBU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:56:45 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:40232 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbgLBU4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:56:45 -0500
Date:   Wed, 02 Dec 2020 20:55:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1606942562;
        bh=FLkifQjXxyu0aeM6OMx13zZXQzHi1EHZwqH+p8C5HPI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=EQg8p9JMosMZx1q/xB8DGHRXAXIwzIecR+1PSI7WhZgo7cQjGCL6cXX+LndQHjIf1
         ZwZlULhpXhC42Qw3RRUfAl8pRs7uO5ZGYJqE6lXwcKYgq51Fm4fl6rgtNq6OQbJkpW
         D1FBCN5dtQT5wIX1OLTVJEf364tL/w9wcpdyofNU=
To:     linux-kernel@vger.kernel.org
From:   Lars Everbrand <lars.everbrand@protonmail.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Reply-To: Lars Everbrand <lars.everbrand@protonmail.com>
Subject: [PATCH net-next] bonding: correct rr balancing during link failure
Message-ID: <X8f/WKR6/j9k+vMz@black-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates the sending algorithm for roundrobin to avoid
over-subscribing interface(s) when one or more interfaces in the bond is
not able to send packets. This happened when order was not random and
more than 2 interfaces were used.

Previously the algorithm would find the next available interface
when an interface failed to send by, this means that most often it is
current_interface + 1. The problem is that when the next packet is to be
sent and the "normal" algorithm then continues with interface++ which
then hits that same interface again.

This patch updates the resending algorithm to update the global counter
of the next interface to use.

Example (prior to patch):

Consider 6 x 100 Mbit/s interfaces in a rr bond. The normal order of links
being used to send would look like:
1 2 3 4 5 6  1 2 3 4 5 6  1 2 3 4 5 6 ...

If, for instance, interface 2 where unable to send the order would have bee=
n:
1 3 3 4 5 6  1 3 3 4 5 6  1 3 3 4 5 6 ...

The resulting speed (for TCP) would then become:
50 + 0 + 100 + 50 + 50 + 50 =3D 300 Mbit/s
instead of the expected 500 Mbit/s.

If interface 3 also would fail the resulting speed would be half of the
expected 400 Mbit/s (33 + 0 + 0 + 100 + 33 + 33).

Signed-off-by: Lars Everbrand <lars.everbrand@protonmail.com>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index e0880a3840d7..e02d9c6d40ee 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4107,6 +4107,7 @@ static struct slave *bond_get_slave_by_id(struct bond=
ing *bond,
 =09=09if (--i < 0) {
 =09=09=09if (bond_slave_can_tx(slave))
 =09=09=09=09return slave;
+=09=09=09bond->rr_tx_counter++;
 =09=09}
 =09}
=20
@@ -4117,6 +4118,7 @@ static struct slave *bond_get_slave_by_id(struct bond=
ing *bond,
 =09=09=09break;
 =09=09if (bond_slave_can_tx(slave))
 =09=09=09return slave;
+=09=09bond->rr_tx_counter++;
 =09}
 =09/* no slave that can tx has been found */
 =09return NULL;
--=20
2.29.2


