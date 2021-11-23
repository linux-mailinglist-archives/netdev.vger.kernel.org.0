Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E7445A34A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhKWMyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:54:18 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55728 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhKWMyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:54:16 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 8CBF120274; Tue, 23 Nov 2021 20:51:07 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] mctp: serial: enforce fixed MTU
Date:   Tue, 23 Nov 2021 20:50:41 +0800
Message-Id: <20211123125042.2564114-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123125042.2564114-1-jk@codeconstruct.com.au>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current serial driver requires a maximum MTU of 68, and it doesn't
make sense to set a MTU below the MCTP-required baseline (of 68) either.

This change sets the min_mtu & max_mtu of the mctp netdev, essentially
disallowing changes. By using these instead of a ndo_change_mtu op, we
get the netlink extacks reported too.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-serial.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index c958d773a82a..5687ad3220cd 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -410,7 +410,14 @@ static const struct net_device_ops mctp_serial_netdev_ops = {
 static void mctp_serial_setup(struct net_device *ndev)
 {
 	ndev->type = ARPHRD_MCTP;
+
+	/* we limit at the fixed MTU, which is also the MCTP-standard
+	 * baseline MTU, so is also our minimum
+	 */
 	ndev->mtu = MCTP_SERIAL_MTU;
+	ndev->max_mtu = MCTP_SERIAL_MTU;
+	ndev->min_mtu = MCTP_SERIAL_MTU;
+
 	ndev->hard_header_len = 0;
 	ndev->addr_len = 0;
 	ndev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
-- 
2.33.0

