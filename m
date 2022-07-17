Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079BA57773D
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiGQQMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiGQQMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB47413CE0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o15so9733392pjh.1
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tskLN9RRTBYf0z1bjTfnQUZRCpE2NkGGXvIE/jPwV8I=;
        b=lZcNujBKhnReognLOX3uMRASdM3tJ4oZvoDmTqf9FHG9NcUCaoPTZ/VmwfhsJ2zl74
         aAFWYPTmq6WBr7g+9U0/9kmps6ULNP0OOPAFe29xWzW7rd4SbV5QxCzLk+kBBvmi3RIE
         /fAUFcVQ/MMs0MHHMmI1mVvtb8aPu9JS/aG+o9Dh4dnJtTp4uJUiwSimdB5v9/n3kGFG
         m4fa8FmofERE5KgqG2JnnMuEf8YvVbJ3xgETKJlCzBT5im2xGmU0xlClvR0/7N6ht188
         MagOhigIK9/C0rZCrGeAvMl3VOLe7Opn6+kZinpG9uRS188XIrdPLvqvgtSL71RU1oEu
         jOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tskLN9RRTBYf0z1bjTfnQUZRCpE2NkGGXvIE/jPwV8I=;
        b=GzdZYU/tdFPHldsjBYdKm/zO23OgkjprMdTniAvz+7f1ViwzqBTOLIgK+DGIAUnP/W
         qnWbAur1hfAmCdfFq6ujWofUJ2Y/XrSKYGidZ6r74UpLV9V22HNaMuPdXbf6n/RvBbPK
         82djZwuhau2CsELruw6v1fcr9INavf2lql43KRt7V3B6891uaROg+Y3MvIjHeG73yQhG
         j0MYzFRog8vnJT8bs7fkBOIVv4g4YiAQbVBRMrAD08sZyMWCBi221clPk0Pcb5+ab9BW
         9sD3qhwp9XD2m9zHiFilHI9mqzg15T63RmD6aeG2+p4v1KDomTp6bWqvdeGKA54KNQ4q
         Uhaw==
X-Gm-Message-State: AJIora/+YpPlmDyDQYIRu1qo8vmYlzvusDsEs0pgwCcw/RnP2CuiTLbC
        rOufivzZYQEzU5Yg0s7Lu8M=
X-Google-Smtp-Source: AGRyM1ukhO0qHfgBeqmLvOq5kNS6CAMmWUJvBQzazU8Kfv0I6v9CGldLIo737OxYtWcF/d4yWru6TA==
X-Received: by 2002:a17:90a:7784:b0:1ef:c0fe:968c with SMTP id v4-20020a17090a778400b001efc0fe968cmr33582300pjk.26.1658074349234;
        Sun, 17 Jul 2022 09:12:29 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:28 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 4/8] amt: add missing regeneration nonce logic in request logic
Date:   Sun, 17 Jul 2022 16:09:06 +0000
Message-Id: <20220717160910.19156-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v2:
 - No changes.

 drivers/net/amt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f0703284a1f1..60e77e91a2b6 100644
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

