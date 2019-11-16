Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93F9FF124
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfKPPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbfKPPtS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2CF2081E;
        Sat, 16 Nov 2019 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919357;
        bh=iEFg2OgAmaWRd0RDYXvJ8JsJ2QGa+NeD4y94Xt9Om80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToROOiu1zTbO08vu3xRDSYK7FzREfvYlI9KWtsFUUKs4nqUNBUiBtz9COuuuJU4aM
         ShL2st/s/fSzW1PjDgViUPl1KI72T/26Lb52hvzR196jWGzzI2rSpaO2h7t1q9SBNr
         7zHH+s7fOCVVbF9I2+vLzG2/QFypYjLW9MX5GdDk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Radu Rendec <radu.rendec@gmail.com>,
        Patrick Talbert <ptalbert@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 081/150] macsec: update operstate when lower device changes
Date:   Sat, 16 Nov 2019 10:46:19 -0500
Message-Id: <20191116154729.9573-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit e6ac075882b2afcdf2d5ab328ce4ab42a1eb9593 ]

Like all other virtual devices (macvlan, vlan), the operstate of a
macsec device should match the state of its lower device. This is done
by calling netif_stacked_transfer_operstate from its netdevice notifier.

We also need to call netif_stacked_transfer_operstate when a new macsec
device is created, so that its operstate is set properly. This is only
relevant when we try to bring the device up directly when we create it.

Radu Rendec proposed a similar patch, inspired from the 802.1q driver,
that included changing the administrative state of the macsec device,
instead of just the operstate. This version is similar to what the
macvlan driver does, and updates only the operstate.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: Radu Rendec <radu.rendec@gmail.com>
Reported-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9bcb7c3e879f3..40e8f11f20cbf 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3273,6 +3273,9 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		goto del_dev;
 
+	netif_stacked_transfer_operstate(real_dev, dev);
+	linkwatch_fire_event(dev);
+
 	macsec_generation++;
 
 	return 0;
@@ -3444,6 +3447,20 @@ static int macsec_notify(struct notifier_block *this, unsigned long event,
 		return NOTIFY_DONE;
 
 	switch (event) {
+	case NETDEV_DOWN:
+	case NETDEV_UP:
+	case NETDEV_CHANGE: {
+		struct macsec_dev *m, *n;
+		struct macsec_rxh_data *rxd;
+
+		rxd = macsec_data_rtnl(real_dev);
+		list_for_each_entry_safe(m, n, &rxd->secys, secys) {
+			struct net_device *dev = m->secy.netdev;
+
+			netif_stacked_transfer_operstate(real_dev, dev);
+		}
+		break;
+	}
 	case NETDEV_UNREGISTER: {
 		struct macsec_dev *m, *n;
 		struct macsec_rxh_data *rxd;
-- 
2.20.1

