Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41AE332A55
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCIPYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:24:50 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:31246 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhCIPYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:24:30 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d20 with ME
        id eFQD2400T3PnFJp03FQMkA; Tue, 09 Mar 2021 16:24:28 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 09 Mar 2021 16:24:28 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH 0/1] Modify dql.min_limit value inside the driver
Date:   Wed, 10 Mar 2021 00:23:53 +0900
Message-Id: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr>
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


Vincent Mailhol (1):
  dql: add dql_set_min_limit()

 include/linux/dynamic_queue_limits.h | 3 +++
 lib/dynamic_queue_limits.c           | 8 ++++++++
 2 files changed, 11 insertions(+)

-- 
2.26.2

