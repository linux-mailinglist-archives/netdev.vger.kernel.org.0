Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3885717C4
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiGLK5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiGLK5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:36 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933AAEF5D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso7576147pjj.5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/lasAI/mgs5KIK9C1Khk06SG6KwVYMLAc7wApcYxGdE=;
        b=NAaqxTb4mnvCxZvbPFHtRLaUb1uxId/KhvNkJSCxFlhcGoiAIRVSqz9DD1glFtulU+
         y1kQQav0RtxglUgE9rYInS0mH71Lt/wgegBK1sPNi9XphkYvYDofjZlmqlHhRrk3teX5
         iu0MtbRwRnogbYNoXi892ySJ3sVw87V5KOs6E0Sb4R66Ug/C5LOw6DtekFTKbwbzHnma
         2GDhXmDmkq/fHiK1HyvLAGcGIJpWhIUJP152fepp/EhRl4lNpYBMQYsvlPzhdoA0xvs3
         wZmR2+myyPtzwKOcsSpa0TYB8MsNv3N7DPS5RQfDDewbHRJa3DVufiuxNY1EguHtBuwq
         gUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/lasAI/mgs5KIK9C1Khk06SG6KwVYMLAc7wApcYxGdE=;
        b=aSR2fT6lZpSCd849LLPzQ1FFQpTeHlQszd4beMBEsIU6+cn9vhCsOk0BKJIZ305m9h
         pb4Sz3sUhNmmg2F1hYxiU1Uy8IEf5EWGgSglic8ok5FC2OFe4qsz35W6YH3wZdIu4cgt
         vKs50Frd+jey2OBEuB83AEfLwPnjunK7BL7M84OgbNII8JeQXYzgDMVNVAv30YTmI3ME
         vfilkxJeo9dDQ5O4JmbU/0XR7rSc0JyOiRMPBcNiVbtQw3rcLhC8CZpsRRxldPJ9357x
         lUqwFd6yW7ge0yOXFmmBQJqxx5oNdCFEF4fHtWT+ztyXSiK6/ZMVVc+0RSV0J5ISbahu
         J1Kg==
X-Gm-Message-State: AJIora9GBt6ulJ7xxJ2WOEaUBrriE2qWNaOoTfiPOU7qOfcbZY+MvJ+X
        pAZkQKCM/oqHEHrU9B7Ns5jPGOLVIBE=
X-Google-Smtp-Source: AGRyM1s86fF73ORB2EHZ8QE0RSz3r2Bp4tjnO10oICj3GwZZgP9mNz6N05foVUnVZ8GFQZPcPX3Svw==
X-Received: by 2002:a17:902:c405:b0:16c:3cd:db84 with SMTP id k5-20020a170902c40500b0016c03cddb84mr23514085plk.6.1657623454708;
        Tue, 12 Jul 2022 03:57:34 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 4/8] amt: add missing regeneration nonce logic in request logic
Date:   Tue, 12 Jul 2022 10:57:10 +0000
Message-Id: <20220712105714.12282-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When AMT gateway starts sending a new request message, it should
regenerate the nonce variable.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 9977ce9e5ae0..da2023d44da4 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -963,9 +963,13 @@ static void amt_event_send_request(struct amt_dev *amt)
 		amt->remote_ip = 0;
 		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		amt->nonce = 0;
 		goto out;
 	}
 
+	if (!amt->req_cnt)
+		get_random_bytes(&amt->nonce, sizeof(__be32));
+
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
 	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
-- 
2.17.1

