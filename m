Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28D0453F1B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhKQDr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKQDr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:47:57 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA62C061570;
        Tue, 16 Nov 2021 19:44:59 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x5so1400809pfr.0;
        Tue, 16 Nov 2021 19:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P9e5mA6KGfTBnuJHny5iXGo3h9f1H7d32VJPydHg12U=;
        b=DgD1MfTHZ1NfgjFdYzKihABAqTvbfmw3tX48zC+inXwpnmvFT1ZgxhU1a/RdAJeHW5
         o9xLRNn7a69rnK697tDpdcX4B1nLs1iWxLe7l+1z+S4REr5FXLbIcSPzb1Mqnv3Wfsm9
         OfU6Z+e95d5sfYLhvdlkiHtGL7C0RcKWJ3lycwSLGnaJNs4eUFiQdtj7rNI6Y7lverAs
         vN02lzLhjMdrjNha+4AsB+AGjSuZCMU2heZNFwRazbvUwXbj7pskRdd07arR+ZgMEAvt
         VSlD6IGXQ8Ayao0H8bY362iBZ+xOBv4xjzuFJgT+b7MVzPTOQRLu7MBqIzYjmhGQnT1K
         awjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P9e5mA6KGfTBnuJHny5iXGo3h9f1H7d32VJPydHg12U=;
        b=Xv1hVdJoPEDxIkuxp8HjKvp71gN8bWYgH1Dst1Lsw5PXUWtvAESZD9VUg0iKj4YG/7
         r2H5BpgvbfKCA0iAvOtD73fzQoTaYJ81owZG50+C8Qu0d9cLI1Ss2OrPB+faZ0XrIUdb
         8UJy8pm1KYQtQSPrPWPxGpJJqut/nnnY+AvvJd890I9/R1Pt5KPZuygNdASPoxGjSDbJ
         r5TGyO4QGrSx2UotTlC1EFKKNAecJEvKdq1Q2U6zZ588D5bQ3JrncJqqsK+KNAmvwL68
         NEmQwu7C6jz9Q7YilMBEkoAbr0LimMbEUkkraTtfOLpr2zjyYT+Qmudn2l4bl64fIV5N
         rSmg==
X-Gm-Message-State: AOAM5315UxfC4Fu1TT4of8TgPZURVkDDX7XA+Mr9UAXiCercPpNwGwJK
        YGBGJlFqlEToPXxSzl0VZ4c=
X-Google-Smtp-Source: ABdhPJxwiQcoKhjko7/VD4nK2tqGCfdukMEEtBbHkk6annOYvrUGkIzPMstbcBDrF/r/eOn6HZd6FA==
X-Received: by 2002:a65:56c5:: with SMTP id w5mr3146791pgs.184.1637120699376;
        Tue, 16 Nov 2021 19:44:59 -0800 (PST)
Received: from localhost ([219.142.138.170])
        by smtp.gmail.com with ESMTPSA id co4sm3646772pjb.2.2021.11.16.19.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:44:58 -0800 (PST)
From:   Teng Qi <starmiku1207184332@gmail.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, lipeng321@huawei.com,
        huangguangbin2@huawei.com, zhengyongjun3@huawei.com,
        liuyonglong@huawei.com, shenyang39@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, islituo@gmail.com,
        Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Wed, 17 Nov 2021 11:44:53 +0800
Message-Id: <20211117034453.28963-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The if statement:
  if (port >= DSAF_GE_NUM)
        return;

limits the value of port less than DSAF_GE_NUM (i.e., 8).
However, if the value of port is 6 or 7, an array overflow could occur:
  port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;

because the length of dsaf_dev->mac_cb is DSAF_MAX_PORT_NUM (i.e., 6).

To fix this possible array overflow, we first check port and if it is
greater than or equal to DSAF_MAX_PORT_NUM, the function returns.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 23d9cbf262c3..740850b64aff 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -400,6 +400,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
 		return;
 
 	if (!HNS_DSAF_IS_DEBUG(dsaf_dev)) {
+		/* DSAF_MAX_PORT_NUM is 6, but DSAF_GE_NUM is 8.
+		   We need check to prevent array overflow */
+		if (port >= DSAF_MAX_PORT_NUM)
+			return;
 		reg_val_1  = 0x1 << port;
 		port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
 		/* there is difference between V1 and V2 in register.*/
-- 
2.25.1

