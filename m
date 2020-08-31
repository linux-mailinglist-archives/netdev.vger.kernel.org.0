Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E9258473
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgHaXgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgHaXgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FC0C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id np15so683220pjb.0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VhyCl3TFZWppqzE6e3zLdA7+NywekEPhIa79WgzIgnQ=;
        b=Bel4hS0ynfUMmynFQcG3/20GTN/sWW4ZtNKiFYK+8XwfnioSGco/hASVymMW1DMZit
         JKHswuIhAyLOnX4iY9F6xPzos9yhIzM3I1K5AgrfqAdOKHwjMv54FdsG8z9ynUUlwvb/
         AkjWXkgfqsN8dXUHcE8I0mTkuyDcWCURoYbZuiDiPUJfaPgZhIG56yRyc1BOtj6niYQF
         cYoOdjMMdjD0JoaLfoCd/2QA/Bz/AeynkgUD6PrZosd8vabSWR9UMh5jt4+/GmNQSKqK
         cmqaio6aj9pj4tBONq8y8gjzguZaKJqHY5bu4p8LXgE5VQYb1AhszDnQwvx6IpshGWYe
         9X9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VhyCl3TFZWppqzE6e3zLdA7+NywekEPhIa79WgzIgnQ=;
        b=auh4kuZaRPXVZs+8JiuQgQRnlDXRMFEyD+WCG5VpdUGZ447k/D/XKeFY+AKOie713J
         dyQzJboWvDNk6xbyi1yhfYxVdWDf/ciE9P+NScxzDS6VTQH6eKH6+9ZSCJiRfsE2n3Rv
         gOTnTUAVXc45nTzoq41OMSAG9LEmNm0w6ikuLwmA+wuLPSLGZmqr3RJBpdFzmEdb4MdH
         +rZSOL+yEHRQrceQ6Tjp0W/+8Q2kMTxHzvKJuFPSxfALx82gttL57NYSWUHh4KblD2Ut
         aLYGJ5VPk1Jtl0YcI2gsGWIyeSG1ryo+Ow0K4LbyVbU1X7x+iLwrwJJ3qicNhpbDCBMF
         euOw==
X-Gm-Message-State: AOAM533ltJVxUizZmfQzl4610FVZkYJfHBB6Cz835DxyIxBK/TLXK7LT
        KwbfTF4DO3VZIaW8XYoOixVwcWCzJadzFQ==
X-Google-Smtp-Source: ABdhPJxmwRYwmSlEFJHe22SP2YdQL/4sGFuTs0X7VeL35sl+9LQyBloSTRquefwt7YgzhWhaNexkww==
X-Received: by 2002:a17:90b:34e:: with SMTP id fh14mr1582125pjb.186.1598916968124;
        Mon, 31 Aug 2020 16:36:08 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:07 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/5] ionic: smaller coalesce default
Date:   Mon, 31 Aug 2020 16:35:55 -0700
Message-Id: <20200831233558.71417-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've found that a smaller default value for interrupt coalescing
works better for latency without hurting general operations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 9e2ac2b8a082..2b2eb5f2a0e5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -16,7 +16,7 @@
 #define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
 #define IONIC_WATCHDOG_SECS		5
-#define IONIC_ITR_COAL_USEC_DEFAULT	64
+#define IONIC_ITR_COAL_USEC_DEFAULT	8
 
 #define IONIC_DEV_CMD_REG_VERSION	1
 #define IONIC_DEV_INFO_REG_COUNT	32
-- 
2.17.1

