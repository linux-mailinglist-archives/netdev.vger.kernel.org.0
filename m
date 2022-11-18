Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136E962FFAD
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiKRWEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKRWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:04:30 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548B7614B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:29 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id z19-20020a056e02089300b002fffe186ac4so4104974ils.8
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lv+pNNog+K56ReiyTKVtHQrA0cVMp3V7NyRiIHQzaXk=;
        b=Xe5vLYPQ2Naf8AdxWMjtIK5wjNIFnSjtY3cktqRR6FBqewk3tfqtNt2Bq/kTJSTxDQ
         rUnbM9czzfvp1KfRI2iiGN3hHlalojhV4bWriMXmRjjd9vkDd0bs+hZ0BGni5SaAXjDi
         VPOxtLy9VQI2jDvukAm3dyhppeRIuf0X7jmg3QHCL0ZgDd8Ba+SRgdKi+Rj2QprFwQ9F
         7i7i266h46DkCAzmdbeDo9XiROJvwXr2TUTpE3MBeGKA1bL5UwlkzEH96xVRT/8Eqhvy
         CTm/RU+7Ph/E4B5yx9uP72a27T2ryqZx0G9DKu4SbkEycZRCgo7h6HpJdG0odl1VMUu0
         nD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lv+pNNog+K56ReiyTKVtHQrA0cVMp3V7NyRiIHQzaXk=;
        b=56uo+6WR+9pPXB+oeEAh3WbdQMVa5WriKjAXuu38mJK+Epr8nRmotE9VzrWoK779Dv
         0UzKJEopMNbltZVUnYAfqvfUpXmPXVTtMsMeqXQWBvr4kJO832L24SdrE+1RWaWouSog
         zc7Tcxiy8scU9v0DvND8bT1tp3NNRkhy9AhNOuh8qSs7xWgaWK8cqILyDWIgCBa2zqdc
         a2GM6eVGZcpL7aNjAFyr1JsjY7HSFCzn15gLrrX/mZRSGijasZVOj4o3uYm3lI2Tl7Ji
         80iQY2ng8EYKMFuHtW2WmOBvCz9Z9NeLltaFAXDFa4TiaZVEdtn5XBJNo4WxZoqGgQuf
         zhsw==
X-Gm-Message-State: ANoB5pkZO10EEsVyMaF9b/qmNCKqB4s91UnA/1fWFq6m4+joCMOp/LQV
        L6drQlwHneFfcbRMAtRRdjzEkAEgWLOQCxw=
X-Google-Smtp-Source: AA0mqf7fUpttnHdd78/V26O95Et9Rf+3udTXJ12jSZ8KKRa8lyYSH4X4MYBUM2wBcrv+drGbh6GUDUJYCWPLVPc=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a02:a86:0:b0:375:30f3:40b2 with SMTP id
 128-20020a020a86000000b0037530f340b2mr3633726jaw.316.1668809068735; Fri, 18
 Nov 2022 14:04:28 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:04:21 -0600
In-Reply-To: <20221118220423.4038455-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221118220423.4038455-2-mfaltesek@google.com>
Subject: [PATCH net 1/3] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
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

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered. The fix is to change && to ||.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st-nci/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 7764b1a4c3cf..589e1dec78e7 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -326,7 +326,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.38.1.584.g0f3c55d4c2-goog

