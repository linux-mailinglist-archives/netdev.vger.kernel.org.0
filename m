Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E8D521F2C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346053AbiEJPmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346601AbiEJPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:41:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B023021F
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k14so14968984pga.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gPGlKIAYkvzGWLOdfcrBZK0/pi/ThcFLRN561k+SIq0=;
        b=g+aNfmsOTKV9L938IyOgO8Izs2wS87w3lmVqxRZX0o+wPycccd0FeJLy8XaqPzn330
         3NkoONUxC2HzwTvA2cTUw7NopSvtOCCN09jzGL6I2A+CUEj6L/2YzBzKjYeagdzhAOhs
         P6zFQkwrpbTVLoauFCShihmSzlKwes6lFR5y8DVpxH5tbjSBixVoAZUvxro+EjERihFS
         ElLAryCHEMUUYO55/kJahW6fRwE/2TeWOl2vcPbMYtT6yg0x55U5+Qlv5oxSlg8+EQz0
         7pelDMJ8AtyMA2pSKl5OaV/5BQwX8QL1AM31d6TQJuIA5C7D6ZrvWWjiOY1tCkzaTFMw
         XDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gPGlKIAYkvzGWLOdfcrBZK0/pi/ThcFLRN561k+SIq0=;
        b=bJPf+DL5JO0MAvaxWoTx9JR5QKbAFQsErRpj6qo8A1vVdzUZ14cPiSvzp1Jj9Se9YU
         pgVqNMG2HcoiBtdWW1ySNu2BPmFOkPax+RUuNTBA6gcMCP74BrUt5ml7AXPwLuNuIxy+
         t79TYfJvdhIj7m5iDYsX0N7PlbRyEii/7vrKHiwTKKSy2NVXA3tBuyR2b5neKxdlrSMf
         chI7I4XhNQDXEGXkJAvgfoTGQlakSTQWi6wMygjmpPEb6ZQAaZ/irqBCQubf3T6Uv90i
         B/DAJ8FReQtvuMQCTp9vFpH9xFFE68znOkDZRF9gJegdl5iVL37JOxo8twroC7AYjdaw
         0b8Q==
X-Gm-Message-State: AOAM5319CI4ywqyk7YcotKAeyDUFtBxjOScZpRMTwcch6IHpEVDkbJqF
        gAbRVVjKLgsp+6dMjGY8OGpVGitJMTM=
X-Google-Smtp-Source: ABdhPJziHOCfemtpV57d0K+VJns9sNam6jPE+Wj4l4C3uzDm26CjaEoFTJJvbSZPlD29jYthb/PbWQ==
X-Received: by 2002:a05:6a00:2186:b0:4f7:5544:1cc9 with SMTP id h6-20020a056a00218600b004f755441cc9mr20797008pfi.62.1652197063657;
        Tue, 10 May 2022 08:37:43 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id bi10-20020a170902bf0a00b0015e8d4eb1fcsm2211308plb.70.2022.05.10.08.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:37:42 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/2] net: sfc: siena: fix memory leak in siena_mtd_probe()
Date:   Tue, 10 May 2022 15:36:19 +0000
Message-Id: <20220510153619.32464-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220510153619.32464-1-ap420073@gmail.com>
References: <20220510153619.32464-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the NIC ->probe callback, ->mtd_probe() callback is called.
If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
In the ->mtd_probe(), which is siena_mtd_probe() it allocates and
initializes mtd partiion.
But mtd partition for sfc is shared data.
So that allocated mtd partition data from last called
siena_mtd_probe() will not be used.
Therefore it must be freed.
But it doesn't free a not used mtd partition data in siena_mtd_probe().

Fixes: 8880f4ec21e6 ("sfc: Add support for SFC9000 family (2)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/sfc/siena.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index ce3060e15b54..8b42951e34d6 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -939,6 +939,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
 		nvram_types >>= 1;
 	}
 
+	if (!n_parts) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = siena_mtd_get_fw_subtypes(efx, parts, n_parts);
 	if (rc)
 		goto fail;
-- 
2.17.1

