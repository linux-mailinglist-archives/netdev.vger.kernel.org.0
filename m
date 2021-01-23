Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78C7301835
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbhAWUHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbhAWUAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:09 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E607C0617AB
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id f11so10521121ljm.8
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=Err4PtLSUkFp4zv98VxIIz0YinhScNfFH/vnWUFXbBFsHDzwac782SPg5AMUbDmihi
         4ctyJJYGODeR23SgWIydpiYmx6yLBq6lnmZ+LZ/UaYoBAXW/nY0zEpmutNRdgH9+BZwE
         GkAo6UBBsXKoGUy5Gy8wst7drHoSDF1zQv1ctUxWo4UrvJstM7+CNsH3myd2p2JdGqCY
         on2ZwpVgjZufUKf79WEvHX6regG/CNpS/GK43AQcvSPpH1X3vSgmUBfYY7QEDY9lO/3A
         f2TCYcpaXE1hpxfKJFXF0JY843W3GrZ37Cr5sPtJMGqsfMyoiymK6EJ/mnfB9TpnHIau
         QKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=tb9MRzP4K1XyiP6m5303SukoNDI4IcEQPVPogkn9Pmpaitg+Aax9qYBFFYWuiVBkf7
         xGFXH9x4QxXEcwXuehSRaoaBUA8DyWi+sLqmmJBLNUJI65OWK7kv+7bMwju3LZ8LRKca
         M+0x6Sd3ObJptZsnxP6fK+jws0xv3DZ7d8IPf4T44KeryCADcbQp+xknfmjq6JryaMcY
         mY9uVPD3RJq8U5i+9nkAqUovpAR8kDYQ/ZAfc5/ZhzwKBKFiaU9GkVJLuz0nHvrXYQ7m
         Axq7APMc1jHYB8RYUCmq5bMF74hkzrqYpkbQ94N7aTrvsVFsFbUv4lWEU6m2ecM/I9lc
         8EDw==
X-Gm-Message-State: AOAM533o2vR7/pUnGpn74cNkQxnGfX/wA8/ZObWKSFsSi1eNmLfTN1mD
        9kPDKRDZT/1p+5V74AU2dI905Q==
X-Google-Smtp-Source: ABdhPJwO0/aWCoAoKbhOm269ZIxIUozevsO4mFtZ8DmcMnJFh8x12bW8pg8Oamv4w/dX7hvMQh5jVQ==
X-Received: by 2002:a2e:3317:: with SMTP id d23mr1361692ljc.199.1611431973876;
        Sat, 23 Jan 2021 11:59:33 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:33 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 04/16] gtp: really check namespaces before xmit
Date:   Sat, 23 Jan 2021 20:59:04 +0100
Message-Id: <20210123195916.2765481-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Blindly assuming that packet transmission crosses namespaces results in
skb marks being lost in the single namespace case.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5682d3ba7aa5..e4e57c0552ee 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -592,7 +592,9 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 				    ip4_dst_hoplimit(&pktinfo.rt->dst),
 				    0,
 				    pktinfo.gtph_port, pktinfo.gtph_port,
-				    true, false);
+				    !net_eq(sock_net(pktinfo.pctx->sk),
+					    dev_net(dev)),
+				    false);
 		break;
 	}
 
-- 
2.27.0

