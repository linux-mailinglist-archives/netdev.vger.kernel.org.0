Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668D857773B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiGQQMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGQQMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:35 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947F13DC2
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x21so7104159plb.3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c8OkwLcbGuzYC0abfME/JKh+XFIW52Kra8iG6OA4zeM=;
        b=lECtfNMOZvceShvfJ7Z6/ISyR/wlQ/wjCsC/2p2L8vTqXBVDn/95EKk6UffagerVlO
         aTVzA+PM8avH1KTDyF4WCQ9v18BC5KCKy5hzEcXs/emJLpjXeNKoxDiW1TOUfTsWgok7
         6+jxTSqlvjv4ZKV6Dgb0pZSE0GW+oZCsw7IT6p21bHhbiRvyk9njAdBDbHiXJY0He0/S
         KH70ZPwD71KmBwIj5UlK1mkV3DNT9m7F1gridCRbpEqVt6UqPJqa259/QWkRJqXwy/xi
         XQbnZj/4Fe08bGwWi4bpiOWk2Oih0sY31vw9R7wvQSRpDNfRnHdljvU/+P9KgR6o16Nh
         I7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c8OkwLcbGuzYC0abfME/JKh+XFIW52Kra8iG6OA4zeM=;
        b=MR1gHacB17bs7+pOkiV07VW/FsYCV27J6pQQk41mpV8xsRtaIV7cWZkHcQwfk8Fwx3
         hcMCAsy2bY2oqrDzKwi0B1chRZH2+bboOb90O75vrqdPCTqc/CZSTL3dyxNDW/AeuAe1
         8OqX3OQA+b6kSthMrDU9sILQsM0R3yPfIsChIvuAYWZi3dK3iWVg7mGDgP7yb/7UPhXy
         3ysaGvOnUQQgVH60ZZUEqf4XnaC4XU30wGPdnxVrSX0kK02S3ihDc8g532DMlsJLVdOZ
         B1tpQM757VR2TSe5QWkhOLj6llLorVx+0+A9mOgDoU7X5/XoHKsjNQwQH/z3fbB9hnv/
         HbOg==
X-Gm-Message-State: AJIora/MdZvSQEV6/wIUcNrjMSZbZGIuX2jsJUeuE2a4t02vqX6n2Aa2
        Kx5CoxlsqC6ZcWFVgxyHZdw=
X-Google-Smtp-Source: AGRyM1tQwkn/lmPN56ltfGfRA/dyqb3Y8uBf1K62uVJh3BKCKR+U3F1xpYcgNGBNmBCNKUlv+wAyJg==
X-Received: by 2002:a17:90a:68c3:b0:1f1:874a:e0c6 with SMTP id q3-20020a17090a68c300b001f1874ae0c6mr9567499pjj.102.1658074351705;
        Sun, 17 Jul 2022 09:12:31 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:31 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 5/8] amt: drop unexpected advertisement message
Date:   Sun, 17 Jul 2022 16:09:07 +0000
Message-Id: <20220717160910.19156-6-ap420073@gmail.com>
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

AMT gateway interface should not receive unexpected advertisement messages.
In order to drop these packets, it should check nonce and amt->status.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes.

 drivers/net/amt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 60e77e91a2b6..3e41dc6235b7 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2260,6 +2260,10 @@ static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 	    ipv4_is_zeronet(amta->ip4))
 		return true;
 
+	if (amt->status != AMT_STATUS_SENT_DISCOVERY ||
+	    amt->nonce != amta->nonce)
+		return true;
+
 	amt->remote_ip = amta->ip4;
 	netdev_dbg(amt->dev, "advertised remote ip = %pI4\n", &amt->remote_ip);
 	mod_delayed_work(amt_wq, &amt->req_wq, 0);
@@ -2975,6 +2979,7 @@ static int amt_dev_open(struct net_device *dev)
 
 	amt->req_cnt = 0;
 	amt->remote_ip = 0;
+	amt->nonce = 0;
 	get_random_bytes(&amt->key, sizeof(siphash_key_t));
 
 	amt->status = AMT_STATUS_INIT;
-- 
2.17.1

