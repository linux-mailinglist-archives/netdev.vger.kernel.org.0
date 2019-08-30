Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F98A2DA7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfH3Dzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44101 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfH3Dze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so2788415pgl.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0RWgCDiREWydzn0J+RSjYRBA9+dlesV7SsAFrSa+WyQ=;
        b=hPQeo4/E5ZIhfMMIwB9UUxKOMW4XUbFycdYJjeyDi83sfXlzuskIP3pW32jM+mIynO
         cowFaymDZK5rCDSybVC+6D1UamNRvvOBvZtnHjyFeaKkx/CXkfj+Wt5MOUElT+XXCGfw
         UAmfubHUxXYV2+Qb4qu386iFvj0q0b6zcitsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0RWgCDiREWydzn0J+RSjYRBA9+dlesV7SsAFrSa+WyQ=;
        b=sHYhzzrDX8z80A+hjWGxUz1ZOABHT717HEXWCN7cbVUmoAyOgqjgcyB87c734ZSz4q
         D7Y7yZd4SZgH4rtbsHiVE5odR+uyj0MzO34sorBfL5lmCnq9E+P4oz2jKTBlf5R69jze
         gc3kW7sW7IMooUzgJwwNpp6plLtYPXE/CSrWEvVkqV9OnxsUi3olTT/cdBJhOzWEZR01
         lCgsYVRvTp3N/Nk2sbuGSO2a296YooW1noIYn3OhCQ23ufTyjN4cNz5OBqp/VIkMUU0g
         KMmCwWMiw2nq8nT545bCVHZ/7IUFKISo4pY4w1yaNMjy9OZARfnblkAThNvH5HNRiPRC
         wACw==
X-Gm-Message-State: APjAAAVrunk5uIo3HdrKhj8V/ZwsMyoJmMfrPv0UVw6LaF0gjOUSCs9c
        C9wxrm69R4WUN9p7x5MVgLv1IA==
X-Google-Smtp-Source: APXvYqypKw73o7V7hpByshidytYG/3MmNI4jrRf5cPSavHiBx6tkCUigvLmkXfRH8yDyd33VFPC8Cg==
X-Received: by 2002:a17:90b:289:: with SMTP id az9mr13778492pjb.5.1567137333341;
        Thu, 29 Aug 2019 20:55:33 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:32 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 02/22] bnxt_en: Remove the -1 error return code from bnxt_hwrm_do_send_msg().
Date:   Thu, 29 Aug 2019 23:54:45 -0400
Message-Id: <1567137305-5853-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the non-standard -1 code with -EBUSY when there is no firmware
response after waiting for the maximum timeout.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b9ad43d..c8550ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4162,7 +4162,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
 			netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
 				   le16_to_cpu(req->req_type));
-			return -1;
+			return -EBUSY;
 		}
 		len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
 		      HWRM_RESP_LEN_SFT;
@@ -4190,7 +4190,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 				   HWRM_TOTAL_TIMEOUT(i),
 				   le16_to_cpu(req->req_type),
 				   le16_to_cpu(req->seq_id), len);
-			return -1;
+			return -EBUSY;
 		}
 
 		/* Last byte of resp contains valid bit */
@@ -4208,7 +4208,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 				   HWRM_TOTAL_TIMEOUT(i),
 				   le16_to_cpu(req->req_type),
 				   le16_to_cpu(req->seq_id), len, *valid);
-			return -1;
+			return -EBUSY;
 		}
 	}
 
-- 
2.5.1

