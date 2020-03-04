Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C98A1796EB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgCDRm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:42:28 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38481 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgCDRm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 12:42:28 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so1322084pgh.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 09:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=+jY/JarIb4uExVOLu9StDm6WCnErxuOElk5BfVnTQZs=;
        b=1alGs+Z9/kHKAv95KaZlTYeBlZF6snA1Rw1ZzjcrA5kIZjJNG/IJxjEsz5+0QE0oLZ
         ZDzo56PEtJrHetLgyQeHAq11L6yCw8nJC/O7HItvTcC6Y0N3m9zJpONq/vm1e6UKUjV3
         TqX9SrcaC/fsAeEklWYA2eZMaUuflXfUCIsPPIec6F1L70veQnQBvuVfKWo+PQyt/wtv
         s6XN3nXXLmb7Uw0KhshFirqoox1nDu/m2alULdPl5q1MnOFi+XtmCf0e5UQ+wmaRSuDZ
         zpGJPHqMcRCZiE3o3aKssZKRXdFKVh2S7eMDLpWoySDDqHbJnOpjm6V0FOSJRfI+7rqM
         q6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+jY/JarIb4uExVOLu9StDm6WCnErxuOElk5BfVnTQZs=;
        b=doHiNDR8+CwQRCP09+rysReOgm12AU7qWMPbaEkLI+HFO13EhpG8JnGN9y2K6QfoS+
         f88bzkOkRMBWCAI7t+3lU9UvKa+xfI1s/NJYVoAigdZAUwiyhIstnLtMsCNi5tnR+yGH
         Va26uGWaGbXAjj69Vlb1BrWl1Bvidhu4IVLfQl6iaRv835jei4g2U/NqNXxh+GUQZAG9
         a930AV1kSR46PaVf/rg0YT5qgB4Q5HtgfT8P8Bn2l89P51E9OH2twprbL83c9+46lzxZ
         JyBOvvkWOybk/hBuuQBdd/8/PbRM7gRmfJpzNL8TzYKo19nSbZiZaUeNXHKhJNaplRCj
         T62A==
X-Gm-Message-State: ANhLgQ2OiSzPdr3/YQxvoMS2nbGU2OWRvXqIWk9L9Q8/PpRhPR+i8f37
        QSzWpMsKMeNrvaxCmeEcu0ZUxxZ/ruk=
X-Google-Smtp-Source: ADFU+vtXc6wQm4UlHYanfHO2pSXCfcdWwvupWECfV+YyTy4ApZjkzOWuwzmmCH4NXtB/4r5mN63dcg==
X-Received: by 2002:a63:7c4:: with SMTP id 187mr3418490pgh.369.1583343747188;
        Wed, 04 Mar 2020 09:42:27 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o2sm23125835pfh.26.2020.03.04.09.42.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 09:42:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     parav@mellanox.com, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net] ionic: fix vf op lock usage
Date:   Wed,  4 Mar 2020 09:42:10 -0800
Message-Id: <20200304174210.63954-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of read locks that should be write locks.

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Parav Pandit <parav@mellanox.com>
---
v2 - fixed the Fixes line

 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 191271f6260d..c2f5b691e0fa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1688,7 +1688,7 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
 		return -EINVAL;
 
-	down_read(&ionic->vf_op_lock);
+	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
@@ -1698,7 +1698,7 @@ static int ionic_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 			ether_addr_copy(ionic->vfs[vf].macaddr, mac);
 	}
 
-	up_read(&ionic->vf_op_lock);
+	up_write(&ionic->vf_op_lock);
 	return ret;
 }
 
@@ -1719,7 +1719,7 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
-	down_read(&ionic->vf_op_lock);
+	down_write(&ionic->vf_op_lock);
 
 	if (vf >= pci_num_vf(ionic->pdev) || !ionic->vfs) {
 		ret = -EINVAL;
@@ -1730,7 +1730,7 @@ static int ionic_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan,
 			ionic->vfs[vf].vlanid = vlan;
 	}
 
-	up_read(&ionic->vf_op_lock);
+	up_write(&ionic->vf_op_lock);
 	return ret;
 }
 
-- 
2.17.1

