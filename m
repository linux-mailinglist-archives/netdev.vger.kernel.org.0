Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9711000D5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKRI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:13 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35294 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKRI5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:12 -0500
Received: by mail-pf1-f194.google.com with SMTP id q13so10064051pff.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XZOuiVlW2cPQbbFZuW7NLV61qYptqivl5rDfyw5OpjM=;
        b=C8p7MLJshIbDP4cU0K1oQSRIxkn+nhhmyz8pdCFp6WNhe9UWLRC/zK1gXuD9BduWuu
         lF8UYu7a/6+/9I/EXiSW/a4+5U11+Hbvz0CxY+OAzTXTBYhbVCQs53LO7XUShOoYo0kz
         OHngyB2zV3nY1yzTti/jmEEbLbeQgjZrPd6P4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XZOuiVlW2cPQbbFZuW7NLV61qYptqivl5rDfyw5OpjM=;
        b=Kn3HI4i4i4BcCk0lFTl8QlDhvkUxipMFO7Jv/lVg58Jk07ShbVKkdbbTGNwvuzjgGd
         ahK/ehCofenVLvOmE1besvnaDX4SoElsNBm9Z3GOUEhvJfyZkYlXikMKzq72DJr71Z5K
         E/7p2koL60H3Myydm/McO+cyg1EzIORHuAJfkxq9F+HOwG7G/8aPI0DVu7xLcTANd3XU
         LnzQ+pb1rD4VqAIgkMxTaOq4TNFaYlRq1FmMfJ/RRRTtfpdEp8G3za4qi6mX3eT/36hb
         mx2bLdTdh8ttpqkGJXLVjM6qwD04vfz+p4HQn9HULqdT3jpItpMUZBKLblec6K4jqbXz
         0Gqg==
X-Gm-Message-State: APjAAAWIWduUMjPs+hAqCis99rnz9XiqfUtN0hIl+t6E6q6UDLyJgi+I
        EdawaKN4qXNhJb477lB/fI3utg==
X-Google-Smtp-Source: APXvYqwulfufvYLd9+gtgEcWp4Fwxs43yaSzNbQmj7OIPoaA023Znr88wMo5E9wc5V1OIJlJDGyEWA==
X-Received: by 2002:a65:670d:: with SMTP id u13mr29811922pgf.19.1574067431895;
        Mon, 18 Nov 2019 00:57:11 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:11 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 7/9] bnxt_en: Return proper error code for non-existent NVM variable
Date:   Mon, 18 Nov 2019 03:56:41 -0500
Message-Id: <1574067403-4344-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

For NVM params that are not supported in the current NVM
configuration, return the error as -EOPNOTSUPP.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index d85e439..7078271 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -335,10 +335,17 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	} else {
 		rc = hwrm_send_message_silent(bp, msg, msg_len,
 					      HWRM_CMD_TIMEOUT);
-		if (!rc)
+		if (!rc) {
 			bnxt_copy_from_nvm_data(val, data,
 						nvm_param.nvm_num_bits,
 						nvm_param.dl_num_bytes);
+		} else {
+			struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
+
+			if (resp->cmd_err ==
+				NVM_GET_VARIABLE_CMD_ERR_CODE_VAR_NOT_EXIST)
+				rc = -EOPNOTSUPP;
+		}
 	}
 	dma_free_coherent(&bp->pdev->dev, sizeof(*data), data, data_dma_addr);
 	if (rc == -EACCES)
-- 
2.5.1

