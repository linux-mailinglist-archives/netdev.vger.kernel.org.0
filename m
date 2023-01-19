Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC1867406A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjASSAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjASSAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:00:19 -0500
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FFDBBA2;
        Thu, 19 Jan 2023 10:00:17 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id mg12so7782297ejc.5;
        Thu, 19 Jan 2023 10:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uhGSZMqi2aufJJkiKEGoA6YS10J2IXaPL/Dyh2uKG04=;
        b=q+FnHNuKsHuTeFvXotGrHGe1TsnllqijPOhv5Q8SO+B/F7zG95G1Epo7BVp4N26tGT
         tvbcMwQYN1pKy4lAcISF9ykI/uUdPxl1eGa03Vd8EnIGeNNo/FdZCmlRHWrC06Vw/JQJ
         QznyhgAOIhsBclS4yGQB4vwJYfGLCryKdsDPfLHKHnF49T8l6DHxe2SKQbWtkrlCCfXM
         lQg7DmrZ4Gs5ljtwM81AbAQ0tSX8pH1Rp7V4mv+zsd94I8nyFKYhYXch7VNYxgr8WxS8
         XxaqbxYRkQRndgMndMYy5b5m57r3e7o4yVrLTzlvhGI0YMIEIE1UY2AYeg23DRfEUtkX
         mfHA==
X-Gm-Message-State: AFqh2kqHarTwhDBNX/2Rt4eWyKJ8kjEUARZpcGjSGE1lDu4CfPdPc6iu
        lsxkbhL1cQW6iLZrFhEOCcQ=
X-Google-Smtp-Source: AMrXdXugoUmatU0PqR0IqVqvbFeUzXBYWevXbkAtaVizDH3qJVUY83HHeEYKHD6SyPkpKY8a1AJ0gQ==
X-Received: by 2002:a17:907:d406:b0:846:8c9a:68a0 with SMTP id vi6-20020a170907d40600b008468c9a68a0mr13877829ejc.30.1674151216208;
        Thu, 19 Jan 2023 10:00:16 -0800 (PST)
Received: from localhost (fwdproxy-cln-024.fbsv.net. [2a03:2880:31ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id vo13-20020a170907a80d00b0086a4bb74cf7sm8959930ejc.212.2023.01.19.10.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:00:15 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     leitao@debian.org, kuba@kernel.org, netdev@vger.kernel.org
Cc:     leit@fb.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sa+renesas@sang-engineering.com,
        linux-kernel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: [RFC PATCH v2] netpoll: Remove 4s sleep during carrier detection
Date:   Thu, 19 Jan 2023 10:00:08 -0800
Message-Id: <20230119180008.2156048-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119164448.1348272-1-leitao@debian.org>
References: <20230119164448.1348272-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch proposes to remove the msleep(4s) during netpoll_setup() if
the carrier appears instantly.

Modern NICs do not seem to have this bouncing problem anymore, and this
sleep slows down the machine boot unnecessarily

Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/core/netpoll.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d042..a089b704b986 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -682,7 +682,7 @@ int netpoll_setup(struct netpoll *np)
 	}
 
 	if (!netif_running(ndev)) {
-		unsigned long atmost, atleast;
+		unsigned long atmost;
 
 		np_info(np, "device %s not up yet, forcing it\n", np->dev_name);
 
@@ -694,7 +694,6 @@ int netpoll_setup(struct netpoll *np)
 		}
 
 		rtnl_unlock();
-		atleast = jiffies + HZ/10;
 		atmost = jiffies + carrier_timeout * HZ;
 		while (!netif_carrier_ok(ndev)) {
 			if (time_after(jiffies, atmost)) {
@@ -704,15 +703,6 @@ int netpoll_setup(struct netpoll *np)
 			msleep(1);
 		}
 
-		/* If carrier appears to come up instantly, we don't
-		 * trust it and pause so that we don't pump all our
-		 * queued console messages into the bitbucket.
-		 */
-
-		if (time_before(jiffies, atleast)) {
-			np_notice(np, "carrier detect appears untrustworthy, waiting 4 seconds\n");
-			msleep(4000);
-		}
 		rtnl_lock();
 	}
 
-- 
2.30.2

