Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D82718E9
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgIUBJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIUBJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99986C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so6255633pjb.0
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eVE/wTmHBl6bSkNlq0VZJ/8lE4P9Tx7/CR7H5cw5vM0=;
        b=fZaAJCI8gxkN9CRgkWlHLdbz1Zin9Hhw6ikO6jM9hXRpeHspNzfSNnY25nJiUo4CVP
         k0HCHsahOnQqSSjtPZPgYXSrVEWYKmnj9kRaLj5tGyykvIOz4mMTf/L1BAeCRGhkVJzk
         miaE68toDpca33VXbiyAu2j5L5IyQq0/TypGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eVE/wTmHBl6bSkNlq0VZJ/8lE4P9Tx7/CR7H5cw5vM0=;
        b=pGCZn4FMWoHNHxDW0leT07NLYeAKjyzu+Gya5PAKaUXQEXoe1BB0Z4hTYzF3XCwYdd
         37J3LxFJrwZQPTWeCT/vUNYJuljv0kaps1AVoU1iTcHK+oeW6l00FjIYa2ReX9uqkj2t
         cirVn0mn/jmYQDVSAmdkJbeh2ewVeR62kQrddNxysjtPm+M/dAR+oLEtLFjd+3IOzE6H
         If2+7qJ3J8afSwbV+Woks3hnq8tqCeWESC4tGAZFF4S1wr5L/TJuK4SOXQXk0WqIYLz7
         GqjjAW5rPoM/e43J+GAwmqE++9nAi+M5CZyiDPL0i8nK0QHq4EswC55ZukmEkLLIBlhX
         0ltw==
X-Gm-Message-State: AOAM532+HRmF9JgIi12zscimNUUNBo2kDRY44ks7PZplhioApz1A4oze
        bTeef2aHTeqBmYZ/mTo8mzXANw==
X-Google-Smtp-Source: ABdhPJw5GUh5llwxpsYg8oZMLW2JSudLIXK61H/aUs3cfrlXf02X+CLa07Du6DeDmsmYhZJFUfPEIA==
X-Received: by 2002:a17:90a:cb93:: with SMTP id a19mr20606377pju.207.1600650560062;
        Sun, 20 Sep 2020 18:09:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 1/6] bnxt_en: Use memcpy to copy VPD field info.
Date:   Sun, 20 Sep 2020 21:08:54 -0400
Message-Id: <1600650539-19967-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Using strlcpy() to copy from VPD is not correct because VPD strings
are not necessarily NULL terminated.  Use memcpy() to copy the VPD
length up to the destination buffer size - 1.  The destination is
zeroed memory so it will always be NULL terminated.

Fixes: a0d0fd70fed5 ("bnxt_en: Read partno and serialno of the board from VPD")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8eb73fe..4af42b1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12090,7 +12090,7 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
 static void bnxt_vpd_read_info(struct bnxt *bp)
 {
 	struct pci_dev *pdev = bp->pdev;
-	int i, len, pos, ro_size;
+	int i, len, pos, ro_size, size;
 	ssize_t vpd_size;
 	u8 *vpd_data;
 
@@ -12125,7 +12125,8 @@ static void bnxt_vpd_read_info(struct bnxt *bp)
 	if (len + pos > vpd_size)
 		goto read_sn;
 
-	strlcpy(bp->board_partno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	memcpy(bp->board_partno, &vpd_data[pos], size);
 
 read_sn:
 	pos = pci_vpd_find_info_keyword(vpd_data, i, ro_size,
@@ -12138,7 +12139,8 @@ static void bnxt_vpd_read_info(struct bnxt *bp)
 	if (len + pos > vpd_size)
 		goto exit;
 
-	strlcpy(bp->board_serialno, &vpd_data[pos], min(len, BNXT_VPD_FLD_LEN));
+	size = min(len, BNXT_VPD_FLD_LEN - 1);
+	memcpy(bp->board_serialno, &vpd_data[pos], size);
 exit:
 	kfree(vpd_data);
 }
-- 
1.8.3.1

