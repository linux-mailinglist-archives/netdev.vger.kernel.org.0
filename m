Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410CA5717C6
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiGLK56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbiGLK5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D83AEF58
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f11so6944905plr.4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LGkTbdioxug+o55nGFoCPR9/jxeWCQA+0+9cOAeyyAI=;
        b=eqkN3TXtj1AGrUY3MhlIPi0Zew5y8+UJlE7qSJPnNFshCyfrAJvoY11MN9Q0I3UJX4
         Okh/89SRXJHepTB5EZlQ4n/MxjVBh2ymfS++LPSqwahBYQ5z/z0jLfogrABgDpvhOndi
         StTro1Zv1SxsbritxpElwUqCMwHswL+pnZgY3r5DL95U1RlZxIlNchfDURl2SPZkPW0/
         /Q0LjIRs6w38B2qW/05dAJSsfA0oHtCcrHNE3U74xpz/aM/tnxJ3qagvON/LDsgqJi9+
         p5H0NdSSyK6cn8LbCrkXYTmC5ilblZPk8MOKblJlVleCssvxpGEyKsjwy6brI6PN7Wrj
         o1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LGkTbdioxug+o55nGFoCPR9/jxeWCQA+0+9cOAeyyAI=;
        b=gW0vpfTCPjke8XKdjnTO03x852Pe+9AQNweaRs3iTCXwfQ8JB97ZJW5+gwLMcpDOyV
         TLlWqivmOVEe7aoE6PG2Lw5z3SdwtuScpsh4ZgLfLlFlHi8iNnZe+nSmRgAlTPJpX0v2
         xilpvKStZTg5iFoOjZ59aYp5naYOUfqXI4g6aEMtpRYGsLG6qxyDlKJsPwuqc4hsupkY
         lNX7XZGQ9flWtGjRZp8LxAcWfXSgipPDlFsUS3wkCR8UL3IjkfzljDxARxgIMoRX0UH7
         cdkyNmaLvMKcrlBHdiQNGsZceu3rYu1A0LOnRppdrP52lJAfE+J0R/MSXzqFySxUaIuV
         NIbA==
X-Gm-Message-State: AJIora+hD7yBH7gOx7vtVMoN78EquhvELFWAi+75rrNUbuoHR/HN6v7L
        cZTeJDwVVO8Re5wFh4HWkzc=
X-Google-Smtp-Source: AGRyM1s7j96viMyWqmgG0MdBvQohds9buEzvyctWytiHHlmepsfCi1jxqpiRhzzOwCpnaLd8igP5wA==
X-Received: by 2002:a17:90a:5101:b0:1ef:7fbb:7a22 with SMTP id t1-20020a17090a510100b001ef7fbb7a22mr3598461pjh.24.1657623457645;
        Tue, 12 Jul 2022 03:57:37 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:36 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 5/8] amt: drop unexpected advertisement message
Date:   Tue, 12 Jul 2022 10:57:11 +0000
Message-Id: <20220712105714.12282-6-ap420073@gmail.com>
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

AMT gateway interface should not receive unexpected advertisement messages.
In order to drop these packets, it should check nonce and amt->status.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index da2023d44da4..6a12c32fb3a1 100644
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
@@ -2972,6 +2976,7 @@ static int amt_dev_open(struct net_device *dev)
 
 	amt->req_cnt = 0;
 	amt->remote_ip = 0;
+	amt->nonce = 0;
 	get_random_bytes(&amt->key, sizeof(siphash_key_t));
 
 	amt->status = AMT_STATUS_INIT;
-- 
2.17.1

