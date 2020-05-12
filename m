Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5E61CE9E4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgELA74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgELA7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:53 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EDAC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x10so4653983plr.4
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m7SJCe+UbTcHszmzbBcWx6eGQntoYvfvj432IB6qsik=;
        b=x10/MuGQU6KmeOd15oPizJ4vYD6ibRVe98ymsRCBu0oMv2I+apqWbMRbBkZaLjh5x5
         MaaHB85aRLWXy9Rctq2vL25bAIKhGp5p+MTQXoOPm+aRauFNhiOg1w6xmgyxg5ZbiweF
         cBRNz5BP5rrWOIWFYfuLmuJWi/9qtHyTP6yFGD1VtC58v5ttidIgeIUWrV9vG0jRv9b4
         iKbN60VjyZwrBYgQM8wy7OlzVa8xGPJHCClR5LRL/6FNWcxbnkbsYaOz4tqEwBQH3APQ
         NgN59sfhxOiorpcFkqgzZviVol3BcFwdchGE8IsZm+up58wNxqDNEql48ZVBTWA64MxB
         UtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m7SJCe+UbTcHszmzbBcWx6eGQntoYvfvj432IB6qsik=;
        b=p4Zh17QhOejQzQeNHLM1A3hKP2rcocuTHsq7BDCPTOxoF+p8gpdZ9BbsffjfHdgZhb
         ysr1wGSwevDZKmWElg1YZtpYxxiStGt3Ao1mdSe67qz1yHhNC3iUv9CsDpg1M8B5solB
         g0+uaskCFqRACEMt0D8ZVHwu/82Uh5TvzvBfFhyMkikEoSFBOAZARBQxvQdH/JQt4605
         168KQ3zb6UdeExkzeqkXzYhejMPC+qqxkSckbxfstedLVprkCC3LZpcI0H3oVvAl5c9B
         3w/F0eY1t/rQtpidGZ/NycjVtNXpps4RD5ONubKGSynB50yhgppFfoK2CYOFPE4Hcz/I
         ftMg==
X-Gm-Message-State: AGi0PuY6QuOaENXtx3z//IQcP+pT6R24NLZt2qSM3gDvl5zrxmcxarFi
        TENPfRLLu02NxkfaUs9XkCiTAY4b4XI=
X-Google-Smtp-Source: APiQypJtcb7jSSy6jnWxyyRDzSfbZFHgmOb0J2bkK4xH+EaY6DGdCwGYeACNoy/9cuxIC00vbou93Q==
X-Received: by 2002:a17:90b:3018:: with SMTP id hg24mr25100179pjb.130.1589245191740;
        Mon, 11 May 2020 17:59:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 03/10] ionic: protect vf calls from fw reset
Date:   Mon, 11 May 2020 17:59:29 -0700
Message-Id: <20200512005936.14490-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When going into a firmware upgrade cycle, we set the device as
not present to keep some user commands from trying to change
the driver while we're only half there.  Unfortunately, the
ndo_vf_* calls don't check netif_device_present() so we need
to add a check in the callbacks.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0049f537ee40..5f63c611d1fd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1707,7 +1707,7 @@ int ionic_stop(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	if (test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+	if (!netif_device_present(netdev))
 		return 0;
 
 	ionic_stop_queues(lif);
@@ -1724,6 +1724,9 @@ static int ionic_get_vf_config(struct net_device *netdev,
 	struct ionic *ionic = lif->ionic;
 	int ret = 0;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1751,6 +1754,9 @@ static int ionic_get_vf_stats(struct net_device *netdev, int vf,
 	struct ionic_lif_stats *vs;
 	int ret = 0;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_read(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1786,6 +1792,9 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
 		return -EINVAL;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1817,6 +1826,9 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1843,6 +1855,9 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 	if (tx_min)
 		return -EINVAL;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1865,6 +1880,9 @@ static int ionic_set_vf_spoofchk(struct net_device *netdev, int vf, bool set)
 	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1887,6 +1905,9 @@ static int ionic_set_vf_trust(struct net_device *netdev, int vf, bool set)
 	u8 data = set;  /* convert to u8 for config */
 	int ret;
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
@@ -1923,6 +1944,9 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 		return -EINVAL;
 	}
 
+	if (!netif_device_present(netdev))
+		return -EBUSY;
+
 	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
-- 
2.17.1

