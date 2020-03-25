Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E60192762
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgCYLls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:41:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46459 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgCYLls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:41:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id k191so1013811pgc.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 04:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qmYeK8nNi26wRGT3hyMV0EJjmbwoY+JgsoFbdv4O5J0=;
        b=Ndlgg6w8jRRMt4WwL94yA/RxHaZoq4K5x853xs3M8hey6BEO8f996HvO/yzfzJFQes
         yKmYd6/Ic4ZBzyrSuSBzBzhhLy/RExu7rz6xc6mWbBrrSTvg+WgVcg+vBwFgpUUzO135
         8qUUDkIUUXMHfSQzUAgDcRMwRrB+qTJ3aq8xIKcrHZbX+4bOZCCP7YZqtglho/LomFHQ
         bAHBpdCjNVYaf3pmseEusj6nfH9roxhI2mFN6ckXNyCND1DssHwj+pb0qwwbAUW85Lpp
         IsX7Jxo/PWUw34yyG2IaDt4YtaXC55l+sqL0elivyrcq8JzXpuQ73+rbnee0hWY3Y41A
         D+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qmYeK8nNi26wRGT3hyMV0EJjmbwoY+JgsoFbdv4O5J0=;
        b=FZpdPUzlozyMZW4afonC88lXv7QW/w4OvsIgUD8E6AYZ+qhUme5PkW4+d6ym1SR78e
         O86QQsnxsoZzLEd+xKh7OZw709ZjBDiA5nWOeJBW52IYaWAV78Lk5iM9Yp8tpRrJY7CH
         3oC2xzx8EILrdGKXMZu1VD7r+/CIB3L1k6u4bE4tLo6bEYHNfoqtY2wI3AKntRCxxmfj
         9wDKMRTE8hf3J1QeEALXAe2N4PBzzwhuOtOd9IbwoeQLqmTiZniG5gs3lzGT0VmaP5qH
         ETY/X4VjZ89nuI+BChXOCuJGfrOEemDHrhq+EJL824JVOSIWjy5yYKNdj5DMBfTSr0kF
         Qh+Q==
X-Gm-Message-State: ANhLgQ3ucOlxhTXQztIniyW6OuMCmuQSH4g3sMZxBM4aVVKDbVaLbDCU
        hbYCjCjQqhlANmf6cMZi7tfCbGwsbs8=
X-Google-Smtp-Source: ADFU+vsH89u28EYhpY/nuLjyfjLxNySAX4SZ5R0pXiov/WooRv1qTNgpBfOHrQEUACgEpv0dS7GWPg==
X-Received: by 2002:a63:c64d:: with SMTP id x13mr2804955pgg.124.1585136505337;
        Wed, 25 Mar 2020 04:41:45 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id h11sm2846632pfn.125.2020.03.25.04.41.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 04:41:44 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 2/2] octeontx2-pf: Fix ndo_set_rx_mode
Date:   Wed, 25 Mar 2020 17:11:17 +0530
Message-Id: <1585136477-16629-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Since set_rx_mode takes a mutex lock for sending mailbox
message to admin function to set the mode, moved logic
to a workqueue.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 29 ++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index eaff5f6..018c283 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -243,6 +243,8 @@ struct otx2_nic {
 	struct workqueue_struct	*flr_wq;
 	struct flr_work		*flr_wrk;
 	struct refill_work	*refill_wrk;
+	struct workqueue_struct	*otx2_wq;
+	struct work_struct	rx_mode_work;
 
 	/* Ethtool stuff */
 	u32			msg_enable;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 4618c90..411e5ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1679,6 +1679,14 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 static void otx2_set_rx_mode(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
+
+	queue_work(pf->otx2_wq, &pf->rx_mode_work);
+}
+
+static void otx2_do_set_rx_mode(struct work_struct *work)
+{
+	struct otx2_nic *pf = container_of(work, struct otx2_nic, rx_mode_work);
+	struct net_device *netdev = pf->netdev;
 	struct nix_rx_mode *req;
 
 	if (!(netdev->flags & IFF_UP))
@@ -1740,6 +1748,17 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_get_stats64	= otx2_get_stats64,
 };
 
+static int otx2_wq_init(struct otx2_nic *pf)
+{
+	pf->otx2_wq = create_singlethread_workqueue("otx2_wq");
+	if (!pf->otx2_wq)
+		return -ENOMEM;
+
+	INIT_WORK(&pf->rx_mode_work, otx2_do_set_rx_mode);
+	INIT_WORK(&pf->reset_task, otx2_reset_task);
+	return 0;
+}
+
 static int otx2_check_pf_usable(struct otx2_nic *nic)
 {
 	u64 rev;
@@ -1924,14 +1943,16 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = OTX2_MAX_MTU;
 
-	INIT_WORK(&pf->reset_task, otx2_reset_task);
-
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
 		goto err_detach_rsrc;
 	}
 
+	err = otx2_wq_init(pf);
+	if (err)
+		goto err_unreg_netdev;
+
 	otx2_set_ethtool_ops(netdev);
 
 	/* Enable link notifications */
@@ -1943,6 +1964,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_unreg_netdev:
+	unregister_netdev(netdev);
 err_detach_rsrc:
 	otx2_detach_resources(&pf->mbox);
 err_disable_mbox_intr:
@@ -2089,6 +2112,8 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 	otx2_sriov_disable(pf->pdev);
+	if (pf->otx2_wq)
+		destroy_workqueue(pf->otx2_wq);
 
 	otx2_detach_resources(&pf->mbox);
 	otx2_disable_mbox_intr(pf);
-- 
2.7.4

