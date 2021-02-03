Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E802730D3E4
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhBCHJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBCHIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:08:53 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607BC061786
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:12 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id e15so11633383lft.13
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=HZq6xd0jrau2UUGd8RazP2caKKcGOEUws5DW2iUGYC7CbtpHAIQ0EZdazimixZb4Q7
         roE1csgP0IxWmHK1dLAqHzvFB0y11IYSDaoWK//DZgoTjcz6xPoYi/6rpVp3u/Fo7zC7
         UXeRDm7AMQ2d9cWMEQC8duCWWaAr3qhjyjD097JyWXHd6PhmPDHdpRDx9etIL7vGkQoJ
         8HhuZDx6xuHDC4RnsKnRWELsWyZS+6QetLgebKyEwxI4qiZiaybWxQQsiyCEWN9I8KPW
         zjXui9NHcrALSkAu62ZQEO2QPzEC480jYpaqxtx+nGRWH5NtVDOjvfvcDlyE75rbFhjQ
         FfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qm3Xf/zORcOQpWtLlmivgXe4uJE/D2V+lZIMUhUMIQ=;
        b=thVJBxEYR2rXOIVudR8Xb9PrQj2HKWqwFOvFCV1GfJSgI6BxhleLTk2qTvQyi6PbMY
         aAu29gY+zCcd1ekGhH2WbgiZno+/nX9LB/NCHzWayyrl5dFmxc4+8Hxfl7jFodo+1zXB
         n7ZeZ/R+XEYQMif0L8edO2eUKUQve4KbSC1jj9Zjh+vWvEob8v1FUjYJF+4/7IHu3md2
         I5A98lw+DPK70Yl+Bkq3X/hM92kFVpEU2uHvoKc5YJMMB9VBbH25VfsQDOt64KiUPj/1
         Lh3HDnmaWy/E8ej3F9mb8Dd/9MCEmo6AlYe+oLw+I/PTy/F7OlYy+mYqyG28eM7TAY1G
         ueNw==
X-Gm-Message-State: AOAM530s5F8pHaeeDf7S99GUphFfzdbYWgkWjdvhkREwVsNY15HBlH59
        6zrr9vYBZ/u73s1FcHR9U7pcKg==
X-Google-Smtp-Source: ABdhPJw6F5kU3B/MzIKWyYBLE/GYEcSy3gLixgfBje5xBPQPkddClKblYR96BKPElFoCfPT7ca3g/g==
X-Received: by 2002:a19:5f0a:: with SMTP id t10mr976931lfb.568.1612336091447;
        Tue, 02 Feb 2021 23:08:11 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:10 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 4/7] gtp: really check namespaces before xmit
Date:   Wed,  3 Feb 2021 08:08:02 +0100
Message-Id: <20210203070805.281321-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
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

