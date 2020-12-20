Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFA02DF56B
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 13:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgLTMlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 07:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLTMlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 07:41:19 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C16C0617B0
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 04:40:03 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e2so4145527plt.12
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 04:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtxiRMfkRL1YRiP7RlXXAREOdwgbveWdB9KWOtaNwU4=;
        b=RqpWxpaTDaliHG3jV+Hzf3asb5bZ1FMSpbLtNNFwHSDEkmuBQO4yU7nV7ajtqaeevu
         BJ0qaGsaxDTGsA0AtVSANKYJ15N1HMG/fsN3Su4q8DBjMvaEn1VNkwUpi2fdmLMChHHL
         UW+4X/tziA2JSgPYKmuVYgVF+0gGEM+nptNEF88Il8xdhsCLoXMwjYeyMwnoPSXmRTp8
         wZyhjVdlbtyUJL3Z77+OmXUjyTUeQg6A+f+IDPllNgH6fmAoZi+tocaJJoLM9Y3G67+l
         /QCmc3BpTWLueqmKnO9lYIbrErvNdCZY7WJKyV8KHdhrHm0zlRYVgAEP5Tmp2cFzkn2s
         GGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtxiRMfkRL1YRiP7RlXXAREOdwgbveWdB9KWOtaNwU4=;
        b=TxVkpoN+XbSX6EV3rGqu+sd6S0IURLk4SRzO703KrIPbCvx3vWyos0kVl1boj/Z9+x
         sGD7jv0Bns2gcrmFxuxBou5NK4o3Hq43E25aRyAZySJEICyBh4mE//nFGZhahkzhJmvA
         TXzxriTORO886fCrrGok+4y0Hq06hoBsjeo9t57c+LBEJl3YiIDCdoMduiwt/9bHWeRO
         DKWfOgbl3qABxDhhXc8L79GVPafZ6u3yQNoO0YfBLzAQYrB9fNP5IIcgxkytGI3M5eie
         4eu+dCrdxIHFSKkwv5oESlY1qiYSd9/ol166eneE42c9805TSwHu1z3NRJUqxK2xLkg5
         AxzQ==
X-Gm-Message-State: AOAM532+i4FtW+YzQ/IUcJNfKkjIILbDWkQBUSEAZ8B0bsQ7Bsci26xB
        hhMXk3B+WMzBi+3FiGda1piF/w==
X-Google-Smtp-Source: ABdhPJyVwAzyLybxUH37C7/5e2VQOzyFvgGDV7+GpK0DQa07WEAiMo45Ff9QoKqRzlPH0cK1E3t9cA==
X-Received: by 2002:a17:90b:203:: with SMTP id fy3mr13281579pjb.231.1608468002812;
        Sun, 20 Dec 2020 04:40:02 -0800 (PST)
Received: from localhost ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id f64sm14421047pfb.146.2020.12.20.04.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 04:40:02 -0800 (PST)
From:   John Wang <wangzhiqiang.bj@bytedance.com>
To:     xuxiaohan@bytedance.com, yulei.sh@bytedance.com, joel@jms.id.au
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net/ncsi: Use real net-device for response handler
Date:   Sun, 20 Dec 2020 20:39:57 +0800
Message-Id: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When aggregating ncsi interfaces and dedicated interfaces to bond
interfaces, the ncsi response handler will use the wrong net device to
find ncsi_dev, so that the ncsi interface will not work properly.
Here, we use the net device registered to packet_type to fix it.

Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
---
 net/ncsi/ncsi-rsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index a94bb59793f0..60ae32682904 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1120,7 +1120,7 @@ int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
 	int payload, i, ret;
 
 	/* Find the NCSI device */
-	nd = ncsi_find_dev(dev);
+	nd = ncsi_find_dev(pt->dev);
 	ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
 	if (!ndp)
 		return -ENODEV;
-- 
2.25.1

