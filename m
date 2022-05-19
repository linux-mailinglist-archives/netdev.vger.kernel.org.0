Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284D452CA2C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiESDQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiESDQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:16:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB6B175B5
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h186so3875353pgc.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7cGWxABWTSRnqkdVtl2RjsmthyMxxZ7L/JYrNk80LP8=;
        b=UYuzASZxKGeGCcE9fYC/vEyWX9E/NY4zkkS0tXi8T13+AhebTygGF7o9/RhwBdIzwW
         iTJk+i6b22Cp77qeVsGZ2Tzix5hjebDSSCiT2rY2ErWlg4Z6HTzhrKkWe0LpCzeaCu4F
         jR5+LjBuzTBozLA3nbJSYo/0p9v+SdT3vfnMBGu2soPyyRsDTxnhGTJ327K1k5tzlsUc
         hDRVidYhf7HGjyvHStTguykxRvnboftohCpQkFSm0Gg1y6x0+Fc+BYX/usyDCcofI0Oe
         YMPtfD40IxKlLjNmxIQigx3qcoFwjWe6h+DD0gH4WYNJSX7oh18lU8l0sED5/7/atOCU
         4Iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7cGWxABWTSRnqkdVtl2RjsmthyMxxZ7L/JYrNk80LP8=;
        b=QBbniJ6rVphvDSqWXwIbD9oOGlwlT38x+wxfGlYtjDpYyxW7ROzacbW4QIyH7Exmt+
         oOhmmisHEAXWM4eC3ERWM1CrVNqNhq85mTm34B699xa1Xv0KvaTO665xBxEF0oU5cLmj
         V+Hmo/86Mbn18QTTzdadis4fi6ugmJiR4f1oXyvvq5P88bZZDYeg6nuAlFsna9JgSJ2X
         DXkTO4Q8eZXnXH/VjFROyTrJYEgqU1eV1jE+7qXHm+NxgSeRB1DPXoHVQJ1UVVzER52d
         m1SaQFyKWfmNkiQt/fddmVIH2ewrxbyQDtZHLTVXAXF0Ipm8X0JbL1gXj2o5G2nD6EEc
         Hnsw==
X-Gm-Message-State: AOAM5328QHuTSnDavINsXs1qlthO5QYqqWWbDi432KYFRxfjI9zWXrti
        BUluf9qqxNumDi1HbOgcd/A=
X-Google-Smtp-Source: ABdhPJw814agA3//hKtA2T6GO8o6Y3lu4bS1FABulsjhExk9ezEBpjRBMvx9Iyxqu+HXdYqQ9nTmiA==
X-Received: by 2002:a63:111f:0:b0:3da:ed0d:7623 with SMTP id g31-20020a63111f000000b003daed0d7623mr2223445pgl.586.1652930170492;
        Wed, 18 May 2022 20:16:10 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050dc7628133sm2833459pfg.13.2022.05.18.20.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:16:09 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 1/2] amt: fix gateway mode stuck
Date:   Thu, 19 May 2022 03:15:54 +0000
Message-Id: <20220519031555.3192-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220519031555.3192-1-ap420073@gmail.com>
References: <20220519031555.3192-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a gateway can not receive any response to requests from a relay,
gateway resets status from SENT_REQUEST to INIT and variable about a
relay as well. And then it should start the full establish step
from sending a discovery message and receiving advertisement message.
But, after failure in amt_req_work() it continues sending a request
message step with flushed(invalid) relay information and sets SENT_REQUEST.
So, a gateway can't be established with a relay.
In order to avoid this situation, it stops sending the request message
step if it fails.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - No changed.

v2:
 - Separate patch.

 drivers/net/amt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 10455c9b9da0..2b4ce3869f08 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -943,7 +943,7 @@ static void amt_req_work(struct work_struct *work)
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
-	if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
+	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
 		amt->ready4 = false;
@@ -951,13 +951,15 @@ static void amt_req_work(struct work_struct *work)
 		amt->remote_ip = 0;
 		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		goto out;
 	}
 	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
-- 
2.17.1

