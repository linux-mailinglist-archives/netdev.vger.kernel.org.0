Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFD847DCCC
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbhLWBOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:15 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18102 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241904AbhLWBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=JGekckS+BkDawyQ24EmnCw50b1Ts4lgPiiG7L5RqiKE=;
        b=o7+eFSchQFMwUyNZH0kT4TN8VmPYEK4qWDay93h9P3QLO46155x/LnLGc6mZY0ZziPVM
        RacJ0GZtxEa08gUYZVK6suCAyjOZRIW7wjbHKTaw2rlO9qXPnY1zPh9oZSSCCS7AT5Iu8L
        7lOw8eryl6CgWJhQg+rsX6zO64f+0trjzSbh8mkEvZn4X+IUpdElOXrQwgEp7VSROsBwpd
        93YyI0zKfDBlp8b8ez8WFdlf5B6bqImO8QXJwMbG497VPwpnxvAOE/1RS8NyTLnXPOl7AA
        mZkrTZfpmJhcaBpUGxDsZSwQDLSMwmJfgP3mfG9vBmpNoKxTpeMbHp6x1K85ygcw==
Received: by filterdrecv-7bf5c69d5-rfl26 with SMTP id filterdrecv-7bf5c69d5-rfl26-1-61C3CD5E-C
        2021-12-23 01:14:06.309139133 +0000 UTC m=+9687195.050788963
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-0 (SG)
        with ESMTP
        id Rnh6AwIMRxeb54SvekpCHA
        Thu, 23 Dec 2021 01:14:06.168 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EDD5C700D6B; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 08/50] wilc1000: fix management packet type inconsistency
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-9-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvH8QYPm77HLoqzd6i?=
 =?us-ascii?Q?pELrLw2hwsFT5BXPNL6oemUucAN0NCztY18dpLk?=
 =?us-ascii?Q?nIyWtZNrLRCDESJBCsE8mIZKewcdLRDqpRKLOfF?=
 =?us-ascii?Q?N6HXJKKtN2lx2f7La5sqDrnZufuoPl48wnH2SHf?=
 =?us-ascii?Q?5IyY+XRZm1GMdMBKCaPwd=2FlR6peYxrV4S+6A5c?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queue type for management packets was initialized to AC_BE_Q
(best-effort queue) but the packet was then actually added to the
AC_VO_Q queue (voice, or highest-priority queue).  This fixes the
inconsistency by setting the type to AC_VO_Q.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 4e59d4c707ea5..1156498e66b81 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -507,7 +507,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
 	tqe->priv = priv;
-	tqe->q_num = AC_BE_Q;
+	tqe->q_num = AC_VO_Q;
 	tqe->ack_idx = NOT_TCP_ACK;
 	tqe->vif = vif;
 	wilc_wlan_txq_add_to_tail(dev, AC_VO_Q, tqe);
-- 
2.25.1

