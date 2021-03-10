Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2438F3342C0
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhCJQLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:11:37 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:56214 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhCJQLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:11:23 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d63 with ME
        id egAx2400D3PnFJp03gB5sC; Wed, 10 Mar 2021 17:11:11 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 10 Mar 2021 17:11:11 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v2 0/1] Allow drivers to modify dql.min_limit value
Date:   Thu, 11 Mar 2021 01:10:50 +0900
Message-Id: <20210310161051.23826-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract: would like to directly set dql.min_limit value inside a
driver to improve BQL performances of a CAN USB driver.

CAN packets have a small PDU: for classical CAN maximum size is
roughly 16 bytes (8 for payload and 8 for arbitration, CRC and
others).

I am writing an CAN driver for an USB interface. To compensate the
extra latency introduced by the USB, I want to group several CAN
frames and do one USB bulk send. To this purpose, I implemented BQL in
my driver.

However, the BQL algorithms can take time to adjust, especially if
there are small bursts.

The best way I found is to directly modify the dql.min_limit and set
it to some empirical values. This way, even during small burst events
I can have a good throughput. Slightly increasing the dql.min_limit
has no measurable impact on the latency as long as frames fit in the
same USB packet (i.e. BQL overheard is negligible compared to USB
overhead).

The BQL was not designed for USB nor was it designed for CAN's small
PDUs which probably explains why I am the first one to ever have
thought of using dql.min_limit within the driver.

The code I wrote looks like:

> #ifdef CONFIG_BQL
>	netdev_get_tx_queue(netdev, 0)->dql.min_limit = <some empirical value>;
> #endif

Using #ifdef to set up some variables is not a best practice. I am
sending this RFC to see if we can add a function to set this
dql.min_limit in a more pretty way.

For your reference, this RFQ is a follow-up of a discussion on the
linux-can mailing list:
https://lore.kernel.org/linux-can/20210309125708.ei75tr5vp2sanfh6@pengutronix.de/

Thank you for your comments.

Yours sincerely,
Vincent

** Changelog **

RFC v1 -> RFC v2
  - Fix incorect #ifdef use.
Reference: https://lore.kernel.org/linux-can/20210309153547.q7zspf46k6terxqv@pengutronix.de/

Link to RFC v1:
https://lore.kernel.org/linux-can/20210309152354.95309-1-mailhol.vincent@wanadoo.fr/T/#t


Vincent Mailhol (1):
  dql: add dql_set_min_limit()

 include/linux/netdevice.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

-- 
2.26.2

