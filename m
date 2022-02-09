Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2184AF254
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiBINGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiBINGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:07 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3587FC05CBAB;
        Wed,  9 Feb 2022 05:06:10 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id bx31so3387669ljb.0;
        Wed, 09 Feb 2022 05:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=C074Ts6t1RuR/7tYyDWuvKC2BHBuBtLTBdnTVQAyV3k=;
        b=BHfF3zx0V2sP0D4d9+4rLjIs4WhIhNDY1dUvDT1BnjD0DoY60k4YLXk4vZ/2sX9o0l
         ic6L8cfdLiZwXPn5XfgUwasbajiL1E2a5wbpCgI6OGunSPXEFeCHRvsRaszS+yqW7zHl
         0z42UAceKzRPgDE4Oo3DVcEfpJpyibXlIyVO3AdbvOSZz+EzcH8dX89ru+ljSjs23hEN
         Xzq7uvf29dXyR0yipFZ+NlhDZ63/YaepY2Hp5JhBWesdCFraQ4h0hKYQYZTb0NDIkPES
         R0KoHPC0Je6Y/1d9iaoX3c/w7ncJs99GNDZknH303itEaVbPUWhO+GfapMddu0S3bTCB
         +MRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=C074Ts6t1RuR/7tYyDWuvKC2BHBuBtLTBdnTVQAyV3k=;
        b=JnvyBALoMPT+8SNrxyha3j+FgqEyxVkf+RQtA/dyLIF1wURwA/eMbvEVvbPMo+NNCF
         u6+WvNajwlpQ53NC5z5HjofmN1h/QDeTlOU8+fyZz0ZxFt9//DDQYCvNOri/mBBKk23L
         9uYrATPElXvjsUKxTQBmtW5EqyLKGThbND6KrZaM//kSVnQRiMtK1FjrTNk+UdowKwMG
         H/MXeDxWNljBCVcbaH3uzLLbzWLKuTTQHQpcDC3Gv0YKNTxbPCuN+hK7QTnksHVxkCtp
         URbWB+fOfL4u61i+2vKUF/yI8CNh9pt6WvPkWoFZ/Gjq5KvXuUZaAPdSsQkJ9yFAw5t9
         Cw+Q==
X-Gm-Message-State: AOAM531+5Lm+0x/aUHJwOu8lr82GWsYl+5srfb4JOpx5/mPRTF7m8LaR
        9TnMcKDCwz9yWEgquM7oanQ=
X-Google-Smtp-Source: ABdhPJyUubsoPOivNzS5dMGUwz5s440Yasi/ch4y35pJf4bQpsMQNQcSBZglFFfHu+ruwaOUzM0VTw==
X-Received: by 2002:a2e:8081:: with SMTP id i1mr1513730ljg.506.1644411968590;
        Wed, 09 Feb 2022 05:06:08 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k3sm2352608lfo.127.2022.02.09.05.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 05:06:08 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/5] net: bridge: Add support for offloading of locked port flag
Date:   Wed,  9 Feb 2022 14:05:34 +0100
Message-Id: <20220209130538.533699-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various switchcores support setting ports in locked mode, so that
clients behind locked ports cannot send traffic through the port
unless a fdb entry is added with the clients MAC address.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/bridge/br_switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..bf549fc22556 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -72,7 +72,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 
 /* Flags that can be offloaded to hardware */
 #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
-				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
+				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED)
 
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
-- 
2.30.2

