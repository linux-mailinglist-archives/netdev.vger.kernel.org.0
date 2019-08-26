Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD619C818
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfHZDzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:55:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34791 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfHZDzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so9734342pgc.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wTMD9NPPLS5BASVvapJrC0+0HJv16MRBlABAlZIQqbw=;
        b=EGbtrHokiAr+nWO6mS0+5Xa/SVq/djm1OqQptXXvy7PBP87/1yHVMCLQavTgtdYdBM
         RTzi3+ltVMW4QSb0CpL8dvrgR9M6OCqc1XCQJhmI30H4jSbHh/RcxGWknWi2QTFZV/CU
         PUH4cCMNX2i8oaN9A7oDKGVUmIde3PfnBayaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wTMD9NPPLS5BASVvapJrC0+0HJv16MRBlABAlZIQqbw=;
        b=hx78dzhw2CTcbvIuSNUBA5X36HDmkIzoJCtD61eDCG+pUawMrtqsOq13CM2ivJTziW
         aRFTpC0/eS57t+6xvAJDxVmHtwi65SAjJomamYFh5OXJX+eHO37zhEL1wilmGktR7b4K
         OHQoxhvZWb6K6HFwxcG57xf2wV1Pkr7Iv3efGuNArGuB8VepP+Na+RWkrp6Vtwg8YxF2
         MgMX0/m1iGbABgKpcLdggG5dqiT30ZcMouTHUj+Lh3GAI1TkD3YIOpUPn3nUflRvUKXe
         G9n1YGNrEcBtljXhNnoReJk4nXKvjoYTcjIoTkNakabEKQiGThmyZOD2JZqv+DYxKZeY
         1ZNQ==
X-Gm-Message-State: APjAAAWErg2OgWSoRo8Dd3jhQxe7xY1sbw3uQNAEB+7sngnNiDsKkcEt
        BZ1uiz3gnkTHPPhjjn8FOpx0sw==
X-Google-Smtp-Source: APXvYqzNYsb9zqvrFU2dLlLO7qdy9dIQYC8QL7mkgGnIGHZ4RZ7glQHrK6dVTbXtc4pRDos8aC+8tA==
X-Received: by 2002:a17:90a:2525:: with SMTP id j34mr18233586pje.11.1566791752794;
        Sun, 25 Aug 2019 20:55:52 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:52 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 01/14] bnxt_en: Suppress all error messages in hwrm_do_send_msg() in silent mode.
Date:   Sun, 25 Aug 2019 23:54:52 -0400
Message-Id: <1566791705-20473-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the silent parameter is set, suppress all messages when there is
no response from firmware.  When polling for firmware to come out of
reset, no response may be normal and we want to suppress the error
messages.  Also, don't poll for the firmware DMA response if Bus Master
is disabled.  This is in preparation for error recovery when firmware
may be in error or reset state or Bus Master is disabled.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b9ad43d..b1d4c2d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4129,6 +4129,9 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	/* Ring channel doorbell */
 	writel(1, bp->bar0 + doorbell_offset);
 
+	if (!pci_is_enabled(bp->pdev))
+		return 0;
+
 	if (!timeout)
 		timeout = DFLT_HWRM_CMD_TIMEOUT;
 	/* convert timeout to usec */
@@ -4160,6 +4163,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
+			if (silent)
+				return -EBUSY;
 			netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
 				   le16_to_cpu(req->req_type));
 			return -1;
@@ -4186,6 +4191,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (i >= tmo_count) {
+			if (silent)
+				return -EBUSY;
 			netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
 				   HWRM_TOTAL_TIMEOUT(i),
 				   le16_to_cpu(req->req_type),
@@ -4204,6 +4211,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
+			if (silent)
+				return -EBUSY;
 			netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
 				   HWRM_TOTAL_TIMEOUT(i),
 				   le16_to_cpu(req->req_type),
-- 
2.5.1

