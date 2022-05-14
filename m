Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924675271D1
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiENORc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiENOR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:17:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7CC13DE1;
        Sat, 14 May 2022 07:17:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p12so10181020pfn.0;
        Sat, 14 May 2022 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pAzFdjEJParU598emBsl070uimancTgMuaJbOmtBt7k=;
        b=d8eqcu82P+nAhSF3059Qr9BeFLQsomJZ1TaqY20pGfAgXswcfXpKv0f2VocHWwtosV
         F9EWLZL+yyt/59pHZN/vhm2cEIvBuvqYruXeMHLrnqx7DmeOL9FKhjq3AmT5y2tk7pXE
         CVpvbrJzNF91a7uMGXwKeiLqLlFNzhDz/0a/6Jj9K4Rl0iVoPwZ/06rVjH3h1sK8c1rB
         kFAr3REwU/TpgqfkcqZRxXiqoefVkpiT1HWhotrvzDHcDe1Fyl5grXesaywBqOlgs7Gk
         TQnXdkLXg9AVxHRcLy9k1iMPC6LQhyte/3mq+jsf7/OTuQiFkeflc8g08MDbtHhTEN20
         rmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=pAzFdjEJParU598emBsl070uimancTgMuaJbOmtBt7k=;
        b=zraycUm5dmjnM9VX1HZXgjRwSoXxORbu2PBEQQ81xVnXoGjxQciN8WSTSTwTPBPB4+
         qZyHqsf3KRCREm19MBnL9s336PbmqPoVHltBPZe6vplRxKZk3vkPl71e0dQLfJg4Yk/O
         Z1Scca8oTng9zt/D6ALdceSMFF9zOcKyJH8iA74F5RReKdjMWfa/nw0LBTDnaNeXIOb+
         m81Fbx2tZieR52EH+VyaxEUumXRQZIOmu8HiVC129nFgXtMsyJeVtwWmK75LQOX5pmQ4
         j9/zdK5pdzGN4faJjoNf4+39XJa0+KJWaWLbTqvMD24SBNP3lqNsJaIgmAbtrwcXi8eJ
         ZD7w==
X-Gm-Message-State: AOAM531nEn6GWrGeb3IokdwG53IKOzZkjb0JxdPoeqvoOkJvaiDFGnCW
        3J7QXdzlAW5nNg55muHz6heq10sKsl4mVmYL
X-Google-Smtp-Source: ABdhPJxd/RDJzx7lKZe59yNSKHsumNxO0ixX84ZL8czVhN91aHTpIdUf2vl4nGO6EEVos1sTB8QCkQ==
X-Received: by 2002:a05:6a00:170a:b0:50d:3e40:9e0 with SMTP id h10-20020a056a00170a00b0050d3e4009e0mr9258287pfc.48.1652537843910;
        Sat, 14 May 2022 07:17:23 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a530800b001cd4989feccsm5298541pjh.24.2022.05.14.07.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:17:23 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 1/4] can: slcan: use can_dropped_invalid_skb() instead of manual check
Date:   Sat, 14 May 2022 23:16:47 +0900
Message-Id: <20220514141650.1109542-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

slcan does a manual check in slc_xmit() to verify if the skb is
valid. This check is incomplete, use instead
can_dropped_invalid_skb().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/slcan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 27783fbf011f..1879b50391ee 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -359,8 +359,8 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 
-	if (skb->len != CAN_MTU)
-		goto out;
+	if (can_dropped_invalid_skb(dev, skb))
+		return NETDEV_TX_OK;
 
 	spin_lock(&sl->lock);
 	if (!netif_running(dev))  {
-- 
2.35.1

