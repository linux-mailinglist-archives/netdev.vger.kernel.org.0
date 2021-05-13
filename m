Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A919B37FBE5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhEMQ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 12:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhEMQ7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 12:59:55 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D50C061574;
        Thu, 13 May 2021 09:58:44 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id v18so3964490qvx.10;
        Thu, 13 May 2021 09:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4TWjC1hfXEfVrvLAQnVOIqFRZBHVMMLoVo982DH+h84=;
        b=vX0N2sa4uRb9zLH+H7/Sxi4hez/NpFkjMK2ANDZqVkPDbZzvtHmM+tk9hKc07zskuD
         3h7KUb7FWxM21v/Ap66RcKwe81OeDyyHfOnSueHaAeeivGf/eySQwoo8OUKfsIdoy/dH
         g5EMU+oekrJl1lit5fdN05qUmDYbp9Sxi99mYpGrPBwF60EEGAa+4T6kjW549/cHob5A
         gr18NoJHB7vYZ79KO85mbeeYuVrPxflZGdJ+IvF10DXPh1toNjp0gLS++74vWL80U7kh
         Wy21S4+iKT3xJzgG+2nErwSZyV5DZ4j3BbkpkwQ5i3XP303usS2xw1UbWyXRfM8gcHVx
         T+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=4TWjC1hfXEfVrvLAQnVOIqFRZBHVMMLoVo982DH+h84=;
        b=arentv2+hNXFuHD64ydRGdIoivK6EiyfIDqCmNWMkjrCeHIIvL++9X0Fi/DUNACVtQ
         7+ub4DgECHbAGdQITycP0yyi5YrfjYTr7p5qRw9uuR/JQ3nQFo99WpkQMiU22Zdi26TP
         1BV1/BvFbo4vSZhl7xDh/Qa9dfn1uxia0pG+2AASvHz4HRhCxzYL95SasoTtrgfThUZ7
         PI+KJNyS09JrX/og3HQqQjFFDeA5+7Sdvo9PjHt2o0KXs8Om966+njFxF5IzU3wEFwgh
         7v4BqvxZW3LVP4iiXF+3002nKVJopjIvmwI6+GroD+nPq0xkraz76N2pRtdVpzeFx5Th
         2BCw==
X-Gm-Message-State: AOAM532GpsoV+6GBaOeNBMGe/0O4NU8eGCVBywto/mAERgP9iLNQXDWu
        vAhO1tadQ8LH0wfDW1WCzgLqh7uVxqY=
X-Google-Smtp-Source: ABdhPJw1UQWRxdqcLhAoOeZVbQw9joMbO460MCL1F23+mzsh9tbUcS38w7+jxHYbJ2WsxbG6ZhTnIw==
X-Received: by 2002:a0c:ee62:: with SMTP id n2mr33186135qvs.20.1620925123331;
        Thu, 13 May 2021 09:58:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l16sm2693356qtj.30.2021.05.13.09.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:58:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: caif: Drop unnecessary NULL check after container_of
Date:   Thu, 13 May 2021 09:58:40 -0700
Message-Id: <20210513165840.1339544-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first parameter passed to chnl_recv_cb() can never be NULL since all
callers dereferenced it. Consequently, container_of() on it is also never
NULL, even though the reference into the structure points to the first
element of the structure. The NULL check is therefore unnecessary.
On top of that, it is misleading to perform a NULL check on the result of
container_of() because the position of the contained element could change,
which would make the test invalid. Remove the unnecessary NULL check.

This change was made automatically with the following Coccinelle script.

@@
type t;
identifier v;
statement s;
@@

<+...
(
  t v = container_of(...);
|
  v = container_of(...);
)
  ...
  when != v
- if (\( !v \| v == NULL \) ) s
...+>

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 net/caif/chnl_net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index fadc7c8a3107..37b67194c0df 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -76,8 +76,6 @@ static int chnl_recv_cb(struct cflayer *layr, struct cfpkt *pkt)
 	u8 buf;
 
 	priv = container_of(layr, struct chnl_net, chnl);
-	if (!priv)
-		return -EINVAL;
 
 	skb = (struct sk_buff *) cfpkt_tonative(pkt);
 
-- 
2.25.1

