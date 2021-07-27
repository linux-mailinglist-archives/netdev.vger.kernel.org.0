Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37683D7C73
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhG0Rn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhG0Rnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41644C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso5903638pjo.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eJboIgN6rqQCMY+eN7klOl1I+UbW2F4nnjZaOibNPb4=;
        b=oFNz7aKpPZ3aBpvTmeHhqz1WqNs5Gl6ocE6aMATn3nTWnxkyqQ9MugdaRtgxsfZlEG
         2Bnvu50uZW77rHLPtfvHTVD6HnlbVfDM6AerXgT2ofmjsRyyonZikX/wr3cT7fms43Qx
         uYrWMIYzavvVg+fqBtNW2+95KpbSkoQFiSIcgY4OVJMt2zd3snH834LRAcwdvMDLyCZh
         MA/s1vCEmvuukpqkSpf5o4r1h7Ci3gH9lR+65twlO9SJ4v4A5R9GuKWo9V8bbTGNidQg
         GuOYgy8dqlJVxq9gN2kr4A0uYhMVGl1VJbOpi5J1vnHH7hnGuam6VpHRXVKLbAyBt/H1
         tJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eJboIgN6rqQCMY+eN7klOl1I+UbW2F4nnjZaOibNPb4=;
        b=sDn1RCXooHTk6i2dN8hdK5mXPhVSwpQ9dEhjoIDiqzLKq/ID7bnwgIV2p6ZB/vrSW8
         sTddW0OxEp/ALA+BWlEx8t6S40nfr9RBsMc50hbUGLN3HNO7y99FmDGTZfA/JJPFr5cW
         8hOoI3ITW4XFUa41nmww/O4aKOhURZP5SJWIdK7mYT1HcfKHJXk5n4JLAAVzVpRYGUht
         aKrnMFC2/oF6dXdLtkn6QrR3da7kVnlwQbUyDR1EWF8VrEw4BTDPmkXmJUdT5/oG+KgZ
         Ejhf4sk5wjNhGWzXQrlyu/PjJmt6nVEMep+6I38OWhDHRP7RQ4oMfqvwFZVkFzsBW0tH
         ipbg==
X-Gm-Message-State: AOAM5305r+sDfjmFxDRVx5kxQykGo0KRkz0PqDCANSsGQcTzUPACQAq7
        yvx/FZyIrBH1Nb5saCCOnFh+gQ==
X-Google-Smtp-Source: ABdhPJyG8TXOwc1jVVoab8Y3fsQAVdqxSCuPAO+bv7avPztDsaHLbc1yyAEmA5mZT4Z7oO9UjDbOoA==
X-Received: by 2002:a17:90b:d82:: with SMTP id bg2mr23232190pjb.28.1627407831828;
        Tue, 27 Jul 2021 10:43:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 08/10] ionic: block some ethtool operations when fw in reset
Date:   Tue, 27 Jul 2021 10:43:32 -0700
Message-Id: <20210727174334.67931-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few things that we can't safely do when the fw is
resetting, as the driver may be in the middle of rebuilding
queue structures.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6583be570e45..adc9fdb03e86 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -32,6 +32,9 @@ static void ionic_get_stats(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	u32 i;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return;
+
 	memset(buf, 0, stats->n_stats * sizeof(*buf));
 	for (i = 0; i < ionic_num_stats_grps; i++)
 		ionic_stats_groups[i].get_values(lif, &buf);
@@ -274,6 +277,9 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 	struct ionic *ionic = lif->ionic;
 	int err = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	/* set autoneg */
 	if (ks->base.autoneg != idev->port_info->config.an_enable) {
 		mutex_lock(&ionic->dev_cmd_lock);
@@ -320,6 +326,9 @@ static int ionic_set_pauseparam(struct net_device *netdev,
 	u32 requested_pause;
 	int err;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	if (pause->autoneg)
 		return -EOPNOTSUPP;
 
@@ -372,6 +381,9 @@ static int ionic_set_fecparam(struct net_device *netdev,
 	u8 fec_type;
 	int ret = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	if (lif->ionic->idev.port_info->config.an_enable) {
 		netdev_err(netdev, "FEC request not allowed while autoneg is enabled\n");
 		return -EINVAL;
@@ -528,6 +540,9 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	struct ionic_queue_params qparam;
 	int err;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	ionic_init_queue_params(lif, &qparam);
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
@@ -597,6 +612,9 @@ static int ionic_set_channels(struct net_device *netdev,
 	int max_cnt;
 	int err;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	ionic_init_queue_params(lif, &qparam);
 
 	if (ch->rx_count != ch->tx_count) {
@@ -947,6 +965,9 @@ static int ionic_nway_reset(struct net_device *netdev)
 	struct ionic *ionic = lif->ionic;
 	int err = 0;
 
+	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		return -EBUSY;
+
 	/* flap the link to force auto-negotiation */
 
 	mutex_lock(&ionic->dev_cmd_lock);
-- 
2.17.1

