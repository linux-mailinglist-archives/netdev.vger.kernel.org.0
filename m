Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46F749F4C6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346870AbiA1H6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiA1H6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:58:15 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C69C061714;
        Thu, 27 Jan 2022 23:58:15 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id o3so4517804qtm.12;
        Thu, 27 Jan 2022 23:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5HhBimjNoWs3dWyI50Lk0slVr7Jipa0Z/bMMBUtzHA=;
        b=g13qFEEItG6X6sg/PdakSJkgV6hzeSRAl4NkP39ehB3t0YKihjR7u5OiLiP4SG0gwq
         mxzB1OTJk02mmn3ILzfVOUI31favGFQuLR/0/fS0wyg5wIQo1pnXsrSowuxZr4fGh0hS
         ljjKofmfdOWZTMlkY9lVUTxrUplFYv2gCPk0Sn3nOR8NehfshnySb7ghyI2E7xjkyD5D
         i6kDDat8JdybeyMaQJ/70lcAILRlrDcefwBErWpiUE5ImuA7ooYmwQn7MiNSt7kcAHza
         RgUJnJgvwKeZQ3TC2X9DenazrS1bQu2N8sUEdL4J/+oEKptJZtoMSLuzGdKf+IL5RD6P
         pbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5HhBimjNoWs3dWyI50Lk0slVr7Jipa0Z/bMMBUtzHA=;
        b=BoqvDVbpUZY8fkDx0MIX/lGIqn+aLcrBatW6IXbSFM6yH88Nkj6wIYugiqeL+6s5qh
         gfd3Zzuoto8/uxC34yiy5UkRUsSj/fTU6KgxrI6RD91EeBElSTATqm42g6hUhIKL2bI0
         7ttDIdt0tIlH2zgcMvgmTP0/Pb6CM8QvPcSqSD5b0co7+4349ALUapKDm3ohtTOEbwLs
         x15F8MZIuCYbh3JQOP8Scn9x8UejbVAv5H47qROtJn9f6HNACTSAY9F5HD8supXunCyb
         j8guBqV8BxsbOhX+1PUYB5PEEcvDdvL2qZ6wKrmxfX+0Dx2leVykTYrSlWq9ytBP+aXF
         yx3A==
X-Gm-Message-State: AOAM533XwJ76DCUt+o0uPA6T/0iTWcL7D3Y7n+wn6BJolQcr07F7bz9q
        MWY5kLUa1Ukaqr7AepVwbNA=
X-Google-Smtp-Source: ABdhPJzL4vdl7b84zi3Bkp4l11ujbRs9IP0YuxYNqU3rGURuPjFyrPhBLeQMPH+dbQ1JKw812QJtzA==
X-Received: by 2002:ac8:5f88:: with SMTP id j8mr5204992qta.213.1643356694212;
        Thu, 27 Jan 2022 23:58:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s2sm2483457qti.14.2022.01.27.23.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:58:13 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jiri@resnulli.us
Cc:     ivecera@redhat.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/switchdev: use struct_size over open coded arithmetic
Date:   Fri, 28 Jan 2022 07:57:29 +0000
Message-Id: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct switchdev_deferred_item {
	...
	unsigned long data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/switchdev/switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index b62565278fac..b3aedd0ef4d0 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -85,7 +85,7 @@ static int switchdev_deferred_enqueue(struct net_device *dev,
 {
 	struct switchdev_deferred_item *dfitem;
 
-	dfitem = kmalloc(sizeof(*dfitem) + data_len, GFP_ATOMIC);
+	dfitem = kmalloc(struct_size(*dfitem, data, data_len), GFP_ATOMIC);
 	if (!dfitem)
 		return -ENOMEM;
 	dfitem->dev = dev;
-- 
2.25.1

