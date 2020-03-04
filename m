Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69968179697
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbgCDRV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:21:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42689 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgCDRV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 12:21:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id f5so1277151pfk.9
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 09:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GnMVRwItin65rN035C3kgTLrbEaLD/UPZ2QfvXy79qs=;
        b=uD0yPRrHOSENAEcrpBVUIyWXTwIYo8uyDZ6qLSrwUWDHfgn/Yv1jvRrSNZuqAzUK4K
         haQxvz6aG40nM4lq1Xu8AbeMffBQvhwXM4MKNYVQm+sE1sCq/XfgMHLIWpszUNBCaRnh
         AjSbEszHFyvFHGz5BMJ43bqv584TSjPwxL1k/lNIrpOxPqgHdaAiP0Jr0qFkWPIpTWXS
         pg5fEDaXhM3cThf9xUl2OfLGGo9wfVNXc9Wxtm5oOuCRZ7hCY6qKldVYI+MyWt0l+DAm
         mNnlPa47iO73/rU5U0RMVamBRMy1nTGd9g+7z1yjGFTPAQfi23BA1yIOCXg4rczyaxUJ
         AuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GnMVRwItin65rN035C3kgTLrbEaLD/UPZ2QfvXy79qs=;
        b=e5lR8SvHCiRF/MjjwkVXNJRslRN8Q25crDLwQgU81UBXGQuy3nSdhOpD5DtbY46ABs
         rXn0DDraZv9xHxZoexiH6+u9C7XthnVdZy0Z63exvjisgVToQEiohpHjN2JW6ymbI64b
         hdtX3539qfu5xA4sXlpY+L6jgvlW1PBmkVtc59w/3oMO78MPhKgj8fIHacBJDfIJQVzd
         bMl732KPOap7eNGBWlgBAqMYnYG4dPKMWHs6gyWFAynRTOE4k13kqFvEMpgFZx6M25uE
         hfyNtkzp0ggMAhYlZAj/BF8zvQmbFSpXfgA7AsTk9078Gsln9pO/n/MxLIdPl48NXAEN
         2P1A==
X-Gm-Message-State: ANhLgQ2kZ696/GkruNnWMzdnBvNEy8oGyNmxrO77+AxubzFq+9bqIHeS
        YWDDSjWgAgsOvxKexFjbe/pFhMe46r8=
X-Google-Smtp-Source: ADFU+vuPDA9fBxDOWPkZ73FcoeNpfIlgzUXwONa2qL99tj0m3jJWxXNxUvbK2WovXroUv8B9sU9Q/A==
X-Received: by 2002:a63:d149:: with SMTP id c9mr1934881pgj.253.1583342516182;
        Wed, 04 Mar 2020 09:21:56 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v123sm3650194pfv.146.2020.03.04.09.21.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 09:21:55 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix vf op lock usage
Date:   Wed,  4 Mar 2020 09:21:48 -0800
Message-Id: <20200304172148.63593-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of read locks that should be write locks.

Fixes: commit fbb39807e9ae ("ionic: support sr-iov operations")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
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

