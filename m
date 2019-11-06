Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A41F22A5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbfKFXbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:31:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36612 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfKFXbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:31:35 -0500
Received: by mail-pl1-f195.google.com with SMTP id g9so12306638plp.3;
        Wed, 06 Nov 2019 15:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XQlBjJQQjlLiOw6f2ULlsVGlJrKy32umFggc4zmnopc=;
        b=gwQTp+0U9NUDWWwM66Vo43vKr5F6kMz6YnYStCt7FNFJHX+scw5dGwfAbuEShRbc8v
         XcmX1D+eSJZYvdO0k9WgO/00JGvL5kjTxBS3D/FLPLBDgT2lLsa6Gho9KRe04ezZreU7
         ttLGuXono0x8uy6S0YxD0shypeQWo1wKv5Z08VuRXS0KnWBtOCZwzJPgnDzTEWTuq18j
         azzWsYkZWIWokwnvKfvCfdBwDww9XJV8XRquLpogRYv8WMBwwo5SUBM1XZNZVmzI/Tez
         1OSlIqNp3kGEIeR9fRxGBHKxWT9pIGy2pEzMpOU+X5UCTFQrjf/QBMNRR9EsM0929Ccd
         z4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XQlBjJQQjlLiOw6f2ULlsVGlJrKy32umFggc4zmnopc=;
        b=Jppb/Fql/riqbrEgE6d4nwJIl4nGCWf2ZeFzm8BYZOEvis3Hf+EKsjeueruN/JR7ef
         d0OTOaRd/pjPrD9Cc5L0Oo3N9VPBQywmnkY9l4oNzoMvq17WUBASb+3nawMiC6Vc3IR2
         PyTBrX7oTs06M1CZbyUC4fzmKqbYMFKS+jSsoafKGVC+ModB7HdYVxvWSOlzLojt96BT
         WQ1Jwksh7wRoCtoct79YwkOoLvuS6eI3xqlU7ZtwAne93OhYM1083EXSJ9YG0be9LxHg
         fXZ86TxdEWMoZfOLnekRp4dsQCnY96Pb4sZGPVZKqpzpj03v6gi9BBTLhV3GYfpVHqE9
         uzhw==
X-Gm-Message-State: APjAAAXJ+pUDmwJ19HPKQz1tSui3khv3dvkXvUjfQ+mHpa5ErkUb9DJ/
        0aPTA/my6MlKwlriCOADO5mH3rVb
X-Google-Smtp-Source: APXvYqyxj6AvcxSxTZ1uXkDQ4TdMBL4b+00frqdfXS3bHWC4a2N3B+rJNl7uiZQ1SRrjJzBidWs0oQ==
X-Received: by 2002:a17:902:b10c:: with SMTP id q12mr239799plr.97.1573083094431;
        Wed, 06 Nov 2019 15:31:34 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id f7sm70667pfa.150.2019.11.06.15.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 15:31:34 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH] ath10k: Handle when FW doesn't support QMI_WLFW_HOST_CAP_REQ_V01
Date:   Wed,  6 Nov 2019 15:31:30 -0800
Message-Id: <20191106233130.2169-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firmware with the build id QC_IMAGE_VERSION_STRING=WLAN.HL.1.0.2-XXXX does
not support the QMI_WLFW_HOST_CAP_REQ_V01 message and will return the
QMI not supported error to the ath10k driver.  Since not supporting this
message is not fatal to the firmware nor the ath10k driver, lets catch
this particular scenario and ignore it so that we can still bring up
wifi services successfully.

Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 545ac1f06997..eb618a2652db 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -614,7 +614,9 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
 	if (ret < 0)
 		goto out;
 
-	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+	/* older FW didn't support this request, which is not fatal */
+	if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
+	    resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
 		ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
 		ret = -EINVAL;
 		goto out;
-- 
2.17.1

