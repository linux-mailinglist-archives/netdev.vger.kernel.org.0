Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F80B62FFAE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiKRWEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiKRWEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:04:32 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E917614B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:31 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f71-20020a25384a000000b006dd7876e98eso5555734yba.15
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv51K3HwLt6OIg+puHbmbntegxSl0LaK7fxQ9MCyipU=;
        b=f9UHwhzKtRUmJDZ6jA0lXMv0c05foVRAS68iVwaWPwGqjN3uDG7+dPwYJ3Uk9dCXkK
         9Yns4Pm/ohg46V8OPMepC1PxiPPdfwYEfM6PqNYA8kgVAJEtWP2BS94XvDVI2jJhHyBv
         F7dfeAY9la8TCCBKuLoXuXTEkpk6ZoBS1zjz7gzzBQyzfNhuD0xQiFU0BQz7QxNhbA5b
         Kt5Y3H3kvc+W3EtuBdEUhkt1W/MMeHEhB9onlpsolT6vCQ2q9R0K7uK4SiiTNQIl6Wf2
         9ku+bSSAzGVxGiYprPqMaiBWxFawyfVMfiTALQARcG/zJN1H2tmzs/Ia7lJPwKWV5MCL
         gpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cv51K3HwLt6OIg+puHbmbntegxSl0LaK7fxQ9MCyipU=;
        b=KtPsL2pzOPDXqa6X8CiQTc5zI5bCStW9PDJtrB5FpTMgCOvtA72MyzhEiJKxABU5Xd
         +1HyQAgzobr2ni3oOBI5jmftAPirOn3R7X7+ds4nX97Zl4DuPijMr4mjqS0hVh9GpcrL
         nVwnG1+IwAoHCzh8sdnvas1p7WoBnjl6vT0dQqikhtH7yGUvVqM6qgsRleBdGlA9DY5D
         tljTbYQRnG/2zRmIg4mAuQZRYXVF8WM6WMJOiL8tzLFL344C/XVLbydp69kF4dPAeYjB
         6cD+E368me2jcZT9tUphg68eg/yGbaTI6kOb6SFttmQzb4sctK+HrWrsc3LgP3ey6flz
         CeUQ==
X-Gm-Message-State: ANoB5pnlKv8xXNZlK/B9avKBVrmcHcafKB1DZesE6j74vAgoRPdXdT4R
        8Tlh9YohTf8v/J4uTmCvT3irmA1xecOCXCE=
X-Google-Smtp-Source: AA0mqf59TYDkhkBqv5MVgW9QHCa62oT2vaedALBIFfIXZmeF49ncWC2s8ikgc7QZazs6wekIiHfnRdDje12bHJo=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a81:62c3:0:b0:37d:577:8d11 with SMTP id
 w186-20020a8162c3000000b0037d05778d11mr2ywb.465.1668809070616; Fri, 18 Nov
 2022 14:04:30 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:04:22 -0600
In-Reply-To: <20221118220423.4038455-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221118220423.4038455-3-mfaltesek@google.com>
Subject: [PATCH net 2/3] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, sameo@linux.intel.com,
        theflamefire89@gmail.com, duoming@zju.edu.cn,
        Denis Efremov <denis.e.efremov@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Error path does not free previously allocated memory. Add devm_kfree() to
the failure path.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st-nci/se.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 589e1dec78e7..fc59916ae5ae 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -339,8 +339,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
-- 
2.38.1.584.g0f3c55d4c2-goog

