Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138E169B92D
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjBRJuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBRJuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:50:50 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B45727D79;
        Sat, 18 Feb 2023 01:50:49 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id a27so593042lfk.9;
        Sat, 18 Feb 2023 01:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JIrnvpX1nY0h4eC0Pi2vBEJRVCNqCIABCuqr3MNdQ4c=;
        b=qgWAtXhnlg5FnUBogvNrMkeo03Sa+sbzB5bKNWtnsfNRJGF7vPGisc2PYCIGwOz3MX
         tfdrlf5asopocZCXWNj0fxpZVrqO11yK62wzzi/p9/l4R+guIABvnTm/sPu+TH0a9EIu
         ZVL4/bhiOmSzmSo9K9pHyePKqrhfNBmH8frqm7D10sElmIuFdMX/KH6E2Vqt2DjX/heP
         U4Y7sEm3T6gS1c+7FeDnpmG5XI6wkLmtYCLNm8tBOn/jss0rNu3IW728A4LC5iN7pKs6
         IiBu8X2/W15QUACWwW6IVxVAdzz0fqRrvsTZ+09UtT9jwGL+Wdz+H3EqClEC1oMsCWrp
         foGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JIrnvpX1nY0h4eC0Pi2vBEJRVCNqCIABCuqr3MNdQ4c=;
        b=EFuMlS8LGcky+kDlC1s29vR0A5hmdzggZj+MzdKmuKQkYNexcMLHtOyw+dtvlg1Lbq
         lSMW2q9XnC5Vp0lLTbJg3rfgGfBg4+CI/VdlOtuEjydi2wwTGNjZAHbSV9tOAVWR+iek
         j+vDQ9UFx5UcOrVUOkJuUiL/cI2Pr1rPhunJUnpqhaSoRE+Pym6S1jL9iPGPUxCiMJG0
         sb8n8nKAr2CxFn0mQxk8yGfUw8XvKcXcvPP1nQ4mYpKjnaFe5Om/qq59odqXmnizkObE
         LdeD1fbRoL3Hleq7IzvKGQ7iPalglcesFbXaJtPCjFGHm2BO51gPDCbZN0luZ3RmqQb6
         2mKg==
X-Gm-Message-State: AO0yUKXjYEef1igHYlLzrL8OkOLCbmT7g/7KJ8Jqpm6EIvR7UZbSeRKX
        x2VrWfjLCPspPdV2RGU0maA=
X-Google-Smtp-Source: AK7set86QJtV6xdp2HAMzDJSu2QzMeMkFhIVaa3qxPqkFqVvFtZY+emBG2gE3lOVvlToTBh42Sp13A==
X-Received: by 2002:ac2:528f:0:b0:4db:398e:699 with SMTP id q15-20020ac2528f000000b004db398e0699mr1343120lfm.12.1676713847750;
        Sat, 18 Feb 2023 01:50:47 -0800 (PST)
Received: from mkor.. (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id o5-20020ac24345000000b004cb139616a2sm927789lfl.186.2023.02.18.01.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 01:50:47 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] bnxt: avoid overflow in bnxt_get_nvram_directory()
Date:   Sat, 18 Feb 2023 12:50:24 +0300
Message-Id: <20230218095024.23193-1-korotkov.maxim.s@gmail.com>
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

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
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

