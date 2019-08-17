Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD2912EF
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfHQVFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36313 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id g4so3921385plo.3
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fp4fQXmbQWiRT3Tg1PjQ+KQDvMa3B/ngssjpquIumrY=;
        b=JEHCNWi2jB+byrJJK1SlV2kQX3mymcC+kU9vCfPMUbYibjLEF1XvYVDI9l6MkFP8I0
         bY79QxJ9+uQsHGEcDkGDTtjeoFb2GgzYPQmdjnIYKtL8moQ8qvBORFv2ktrYiMZZgdpv
         XnJ/3S343L8u53Q57IJVvmPG6ueapY535rv4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fp4fQXmbQWiRT3Tg1PjQ+KQDvMa3B/ngssjpquIumrY=;
        b=ZhF/qyBxMUe2uZQXYt2bnbBpgFSc5zo3QKvzxDRvvjzgCqRYU722S/dcR5TmjW//ZB
         ZhCtFSsOCcDij+o9gPeaLsDzAlAsJvwBMHeU4jxIlQimMAHUP9VI9Svf97dxJAZpuU2a
         +vl7TCXrLBTZS2XMsv0bWPWzsyGs7lS1WUFwGEVflaEtYVIX552jbwHHJ6aWCvlwoAdz
         VAo2QZN4kkz0pLNSUCBv3a1FZLwzCxb0ckXpDAzjwAYM7jb5ccFszOXPoMggW2WmWVTf
         CKhaAaVmI8tDzgj1FV3RM7PaIcgmQ9Iq1/CaOb38L9vAwhnen0tSOuXqYTRGSJgd1g3Z
         OFwg==
X-Gm-Message-State: APjAAAUq31jPEKQkP7sbg6VHuA0HBvffD8uqRuIEj2TCIlgB6bRzYFKC
        DKYw6S50GBjoClvtv0Q1DTCF1w==
X-Google-Smtp-Source: APXvYqxvhAzv1bko0yd263PCMKxm+WYfpiaKqQPt9qQdxS3Ew8b57ovxy+yFJNX87nDKlRRqTfO12g==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr15577128plq.43.1566075933648;
        Sat, 17 Aug 2019 14:05:33 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:33 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net v2 4/6] bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command
Date:   Sat, 17 Aug 2019 17:04:50 -0400
Message-Id: <1566075892-30064-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

For newly added NVM parameters, older firmware may not have the support.
Suppress the error message to avoid the unncessary error message which is
triggered when devlink calls the driver during initialization.

Fixes: 782a624d00fa ("bnxt_en: Add bnxt_en initial params table and register it.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 549c90d3..c05d663 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -98,10 +98,13 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	if (idx)
 		req->dimensions = cpu_to_le16(1);
 
-	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE))
+	if (req->req_type == cpu_to_le16(HWRM_NVM_SET_VARIABLE)) {
 		memcpy(data_addr, buf, bytesize);
-
-	rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+		rc = hwrm_send_message(bp, msg, msg_len, HWRM_CMD_TIMEOUT);
+	} else {
+		rc = hwrm_send_message_silent(bp, msg, msg_len,
+					      HWRM_CMD_TIMEOUT);
+	}
 	if (!rc && req->req_type == cpu_to_le16(HWRM_NVM_GET_VARIABLE))
 		memcpy(buf, data_addr, bytesize);
 
-- 
2.5.1

