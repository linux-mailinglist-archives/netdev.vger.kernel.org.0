Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B72198A7A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgCaD2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:28:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34554 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCaD2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:28:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id a23so7600626plm.1;
        Mon, 30 Mar 2020 20:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WhvIKiAZ62YDlD1oWveLP+fNPkAUs0qLIZB4yIs6/dg=;
        b=bNf3rzkgLVBSncpOONhhDp4K7PRzDa+Yzl/FsqGoGmv/dtEwZ+P6HsEA2KCXF2aYXa
         7goBcZk1N5lG2V4WWL/qySJ4mMKAsVew3ufGxgJuAa5QYsaQjC/iVmk5GzSPBpINeSaK
         KiANoTI9nZgMqUTbjDYTVTDH+b9AbfMixl60l5p+MfJWnpPZQUQqTIF+6p79iBSPcnEf
         Xjt9GYxR7t5eVyK8nxLrsiK/SbilC3xQ2XN1yaG4mgyhulinoYUxS9x+7V1Ktwu4dP/p
         TNfbOD8FEXqZdXDqV34tjsug9RwixqmxgExoWEPWQYdtwANAXDC60t4Sxi71Ym9IE6ak
         66LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WhvIKiAZ62YDlD1oWveLP+fNPkAUs0qLIZB4yIs6/dg=;
        b=P5LS8wg8gDkCNrPYzO9ASrwsXcXiCu5BrkcfS4IUVceqaoB/v4hDpc9LOzloW/XPgW
         38FCXUso1UQWWwhw/MDkgseqqGMZpIFxKNARiu0sadcPOOZCi0IpUl4dBtZwEyT/6HZx
         hZm6Kc+6iDESKy5GlYnv4PRYvJd0yrUljGKihtDa0O7Wixm5p5+RB6h2K6CXoyqOREni
         IfQZKyAPZnbE3WNT9FzSMHPXJUdh/BE5iIv7nl0ZIx/vO70QAI2Sb6LwODSHku54I8eF
         iPhepnOrLgWrMhiCfZclfWcnevaQOAlIDieaVdwWT57uEiZWj2N8pvxypFvZWkszb3Mw
         A2EQ==
X-Gm-Message-State: ANhLgQ2ZVBIptdxvMj2mYh+SRgIirA/PKO4VpNu/Rv/cCFZPQ+WPZVGz
        bAYoVYO/4B6CUOnW6E64lJga8O7M
X-Google-Smtp-Source: ADFU+vs1bNwqTVCuFgh6LE546VHpMUSdu5Q9jb1K8Wh8hI7LsW3Q99gMy03oWAW0Bf9aW5kCaNsUww==
X-Received: by 2002:a17:902:aa97:: with SMTP id d23mr15465999plr.244.1585625302223;
        Mon, 30 Mar 2020 20:28:22 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id v59sm761223pjb.26.2020.03.30.20.28.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 20:28:21 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] ath9k: fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
Date:   Tue, 31 Mar 2020 11:28:16 +0800
Message-Id: <1585625296-31013-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add barrier to accessing the stack array skb_pool.

Reported-by: syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dd0c323..c4a2b72 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -612,6 +612,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			hif_dev->remain_skb = nskb;
 			spin_unlock(&hif_dev->rx_lock);
 		} else {
+			if (pool_index == MAX_PKT_NUM_IN_TRANSFER) {
+				dev_err(&hif_dev->udev->dev,
+					"ath9k_htc: over RX MAX_PKT_NUM\n");
+				goto err;
+			}
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
 				dev_err(&hif_dev->udev->dev,
-- 
1.8.3.1

