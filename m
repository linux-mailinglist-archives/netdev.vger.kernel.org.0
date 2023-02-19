Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2195969BF35
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjBSIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBSIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:47:25 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08869F765;
        Sun, 19 Feb 2023 00:47:24 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id g15so446613lfv.13;
        Sun, 19 Feb 2023 00:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ziwZvdGBjC5QmLz6LAeCUqa/woQQ0jjFzWjYeqSimI=;
        b=bd5QqhhTmBVB5xaEjZtxqcjdkX3XKP8c47ctmOIq0eVQ/m5LvoetAnzhNrjMbNWS39
         rAbKbbk0Yt5An4w0mD0zJ4CJG8U5tHAOyv+vemoJZedYOj7+pQEuArWnao8cMxOXI2VB
         OqJ1S5PsQhH6YacR4U4c3XIbvomRqyliXmusrXOdhOgCVy+p/1yXWbQQH2q5UAvA/yT+
         /52Og3DDLiele4DKV94Dy0sf91rJ1/IrFP3DUuCLzo1WLhHYUsvzBKQ7SqEb19xCy8ZW
         5cYVCJQERVV1H2PsVrRbNX4O4IMRA1yMzG3MOktm0axAFIRfBl6lFtOtImz9fCjowhxl
         jzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ziwZvdGBjC5QmLz6LAeCUqa/woQQ0jjFzWjYeqSimI=;
        b=bV/J5DVW4ujV+kUm2q2vmOl8plT0pKmEZg3miFHHGv1RUaFFcuSaO6i2TG7s2xbsws
         d36fgNy4IrkWOir8Rr/HTs73NW05ju6547XHcPLbLCrcYPZGh91uOP3GYcvspZ1y6uxD
         9IU6EFnltQlFXuVRhofGlCKzj8OtfGfT7+qc8JTcDYcDLVxsoBNd7+98bg77lyDdQSI7
         kuc3xR8GU9qjXSXhXlKLkWJ3LbUiV1tbBjq5n/6+8GN6/leRWyi5T90ZaFG0NNO9cxrk
         cL97YReMdL7DK32EO+QMYmUyYveqoebuiWYcv7FDlKGgFP88VzO5YvqLQizol6rTaq1T
         HGdg==
X-Gm-Message-State: AO0yUKX61AQ/ckF8h4rv6j4ontxervXKMJwrdOAX0edhecYT2KSTEJPu
        y+uKizbbVOZrT+tarHMC27c=
X-Google-Smtp-Source: AK7set+yDPESZWaoR6RzOhPutvN0a27o+mO8fyHJbB8aGsZYTHWB2VvfPE/HBz/d088980mgqh00sw==
X-Received: by 2002:ac2:52b1:0:b0:4dc:5457:8ebc with SMTP id r17-20020ac252b1000000b004dc54578ebcmr173667lfm.21.1676796442281;
        Sun, 19 Feb 2023 00:47:22 -0800 (PST)
Received: from mkor.. (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id g1-20020a19ac01000000b004db45648d78sm1198368lfc.13.2023.02.19.00.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 00:47:21 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH v2] bnxt: avoid overflow in bnxt_get_nvram_directory()
Date:   Sun, 19 Feb 2023 11:46:56 +0300
Message-Id: <20230219084656.17926-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of an arithmetic expression is subject
of possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
---
changelog:
- added "fixes" tag.
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ec573127b707..696f32dfe41f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2862,7 +2862,7 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc)
 		return rc;
 
-	buflen = dir_entries * entry_length;
+	buflen = mul_u32_u32(dir_entries, entry_length);
 	buf = hwrm_req_dma_slice(bp, req, buflen, &dma_handle);
 	if (!buf) {
 		hwrm_req_drop(bp, req);
-- 
2.37.2

