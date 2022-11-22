Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6A633181
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKVAnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKVAn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:43:28 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373771759C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:27 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id c14-20020a5ea80e000000b006d6e9b05e58so6371409ioa.23
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1cikfrkurmvRa8/G7HUdyQfKGZctJAIb9KYmB2ipPFo=;
        b=pFwmxqA+3qE3kF46Thz0fZX02FG0OHe7aFgzePcCq30YD2labt79XtjjdVM5Q9kqA/
         zaXAwz+ib5yr17CciAeLU5pihwINQT8bYCJYpvwoifzz4av2kRTd/5iPf2acbW5i2Rr9
         VSzTckE1KLUiskOpig70a3M4yKDw9eJLrWQPwt3RwaK6bVUwiVyqF/PyCwMBsMNxaQSu
         pgEIU3P1MUTLeMoQM4gcf5GmactW2fgCfSxQ2W4FqG8Ljdw0rBPCOVmsK8QQhHs/lDX1
         ZMfqV5LRNS4BZ+qbSGjwUDhxX2l13MjM+yi3lbr/YLucZzaF9PwYyB8wsiC+TAofLfzT
         7hdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cikfrkurmvRa8/G7HUdyQfKGZctJAIb9KYmB2ipPFo=;
        b=XT6rw8yhbaiwqMTCcakiWMoZj5+o1GNdXwu5wl0KilFp098e99NHBgwNfy1buOXtuI
         kjT5Im9h2zp5xunOtg3NOkO6ze8OWCTFCfLn8Tx5J8wcKK0K2lyWrksLxtiVcwmDVucY
         rfgRrq63b5L3BxBDmf6qPIu+vJPL6o9VlJJaoLXzpCI3gtVvH8ypZruGrVMKvLKkqQgo
         m+rX36vaM46/THMdag/O7TVx3ErroZGpkkZveP9Q/8RUpGhcFw0+vCpUqnel3+fu992l
         T2a7yqOUwCXyfpjBS3uYOCmTEKvOJfg7ghN7CksJbicLroa/bwdkxtvBz8XvcLqhpRG2
         FS6g==
X-Gm-Message-State: ANoB5pmMKM6jtY/016dS6nu9kRBd7ZzgD8LlODZeoMAumzGn9tzeB5Og
        Akwc61kObGE01c62qEbLyEsewu0ZQ+w0N1Q=
X-Google-Smtp-Source: AA0mqf4kK4vRIiwaPxyZfh8AXO2N+QV3wqhI8rXhAT+iOKHnEigWPuWwBzn8oG08HD49pVAEQRYspEpci2LRvrU=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a92:d311:0:b0:302:d31c:46c2 with SMTP id
 x17-20020a92d311000000b00302d31c46c2mr602962ila.304.1669077806586; Mon, 21
 Nov 2022 16:43:26 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:42:45 -0600
In-Reply-To: <20221122004246.4186422-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221122004246.4186422-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122004246.4186422-3-mfaltesek@google.com>
Subject: [PATCH net v2 2/3] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
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
Reviewed-by: Guenter Roeck <groeck@google.com>
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

