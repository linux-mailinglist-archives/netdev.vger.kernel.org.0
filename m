Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E890236680
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfFEVMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33029 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFEVMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id 14so282987qtf.0
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5WvNLfzQkIj6Fjp6BUV6aaFi7+dj1Xot63IBgKfzxlY=;
        b=Jxj8MRa688aj4uIoC+lYBJ2y8z8l/kzuQROAGo3Fu9Lj5iOXg7v45KJOxHOjCBD3aj
         u76cy8JbW/30exEH9ktzKe0G0VFay24RtBUHIjZKshBEi6PB0vSTtjSnVDU4OS5dtBv5
         k489kBXo+/rj8RyGK/4OxGMnbKEBvElODO0cC1zq5f2X/4MStVyt/cs/QcKLFmsO+2kc
         7b3xKSTAiy8dIWwnjlg8qm8eNFbjgHeWpqKZCGvUGdybd7hYBamjU4eFYy3eDLcxRDne
         s1bfXu51WCZ5d0/7N5izXrHNW4ePo0OYFpbbHSmPFMm3xDU7niubHx5MPnO0poxtSlQP
         yqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WvNLfzQkIj6Fjp6BUV6aaFi7+dj1Xot63IBgKfzxlY=;
        b=G7CvJ5bOXDZ7lTKr0c53rUrtwxBJi1dun9WFU2aFs5cykEOng9Azwv0jUAytLdzCgL
         RZepX0+lmFcm/Derrwya/EJxKL7ZiEwmRgrj1Pn2m7xxOv+d48iXIajA7y28xB8vnB2l
         N9mrhbcbxOfkCA01W93YbszLDK4SSnfPo8mWToAMOPA7mfFcVLBE4DpNO9lMyy7lsB3L
         Jm+jlNRNIuKdVNOoY51LSXOIHQHrtQQHMx5jLSVkNU3KyWmcl+L9vmZacN8JAUBabx2z
         jB/ZCa3yzMpEpfgMDbmxvsfGoA7yVZKKznY9nu9IL96XLh1pex4n/dCMLVJGQcflAA/W
         iEAg==
X-Gm-Message-State: APjAAAUmxg7jZakOwPeNdCxB50MjSS+3hnPq6fEDx45/+KFX5PdSu/+A
        z1o0aseDvoYbmgmqZ8dDoKBQ1g==
X-Google-Smtp-Source: APXvYqx9eCH2T2XM2H+oAboPgnXITFSxLr4buzz40L+moHn5GF6+HJNsM7V4QhDxrTnfjm+ycD6fag==
X-Received: by 2002:aed:3bcf:: with SMTP id s15mr35879695qte.105.1559769124115;
        Wed, 05 Jun 2019 14:12:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:03 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 02/13] nfp: make bar_lock a semaphore
Date:   Wed,  5 Jun 2019 14:11:32 -0700
Message-Id: <20190605211143.29689-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will need to release the bar lock from a workqueue
so move from a mutex to a semaphore.  This lock should
not be too hot.  Unfortunately semaphores don't have
lockdep support.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h        | 7 ++++---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 +-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index df9aff2684ed..e006b3abc9f6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -17,6 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
+#include <linux/semaphore.h>
 #include <net/xdp.h>
 
 #include "nfp_net_ctrl.h"
@@ -620,7 +621,7 @@ struct nfp_net {
 	struct timer_list reconfig_timer;
 	u32 reconfig_in_progress_update;
 
-	struct mutex bar_lock;
+	struct semaphore bar_lock;
 
 	u32 rx_coalesce_usecs;
 	u32 rx_coalesce_max_frames;
@@ -848,12 +849,12 @@ static inline void nfp_ctrl_unlock(struct nfp_net *nn)
 
 static inline void nn_ctrl_bar_lock(struct nfp_net *nn)
 {
-	mutex_lock(&nn->bar_lock);
+	down(&nn->bar_lock);
 }
 
 static inline void nn_ctrl_bar_unlock(struct nfp_net *nn)
 {
-	mutex_unlock(&nn->bar_lock);
+	up(&nn->bar_lock);
 }
 
 /* Globals */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0c163b086de5..39d70936c741 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/lockdep.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
 #include <linux/page_ref.h>
@@ -275,8 +274,6 @@ static int __nfp_net_reconfig(struct nfp_net *nn, u32 update)
 {
 	int ret;
 
-	lockdep_assert_held(&nn->bar_lock);
-
 	nfp_net_reconfig_sync_enter(nn);
 
 	nfp_net_reconfig_start(nn, update);
@@ -331,7 +328,6 @@ int nfp_net_mbox_reconfig(struct nfp_net *nn, u32 mbox_cmd)
 	u32 mbox = nn->tlv_caps.mbox_off;
 	int ret;
 
-	lockdep_assert_held(&nn->bar_lock);
 	nn_writeq(nn, mbox + NFP_NET_CFG_MBOX_SIMPLE_CMD, mbox_cmd);
 
 	ret = __nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_MBOX);
@@ -3702,7 +3698,7 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 	nn->dp.txd_cnt = NFP_NET_TX_DESCS_DEFAULT;
 	nn->dp.rxd_cnt = NFP_NET_RX_DESCS_DEFAULT;
 
-	mutex_init(&nn->bar_lock);
+	sema_init(&nn->bar_lock, 1);
 
 	spin_lock_init(&nn->reconfig_lock);
 	spin_lock_init(&nn->link_status_lock);
@@ -3732,8 +3728,6 @@ void nfp_net_free(struct nfp_net *nn)
 {
 	WARN_ON(timer_pending(&nn->reconfig_timer) || nn->reconfig_posted);
 
-	mutex_destroy(&nn->bar_lock);
-
 	if (nn->dp.netdev)
 		free_netdev(nn->dp.netdev);
 	else
-- 
2.21.0

