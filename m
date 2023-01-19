Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C30B673F30
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjASQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjASQpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:45:14 -0500
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1011705;
        Thu, 19 Jan 2023 08:45:11 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id hw16so7168067ejc.10;
        Thu, 19 Jan 2023 08:45:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S3XFiwA48FVt7ooeBVg2ln1Mbp9zE3lmEQIQYj9HHGE=;
        b=gfozHTCqwtg2sKLvzAxYI4/9u63yxUyEXT4+kupCTpk27PuXdsN9vEw5xXHQQSg8bD
         yvmvPWfCn4RMu22IeJyjmghhgpXGwxNDAr8/7jqJlpWqGjY9zUjAPPZfrry/p47gWEYN
         TnONmrEBACAOGK4fEh0pfba1sq7lo5RR1WbSPuleihGjhCTMZu830/4J0nBt7TupS/3z
         K8EWjNmuoi4DifWZA9iD0YLElHxkFzTciEMMYALuZUlDs/LE0yaxcfLSi35dXru8Tx0S
         V97OB9wPk4x/zDTP3x9NIs7nuvjWYvczuxvfoFywQpY+CKg7jyfT9sZheuIIof8Pfvpm
         75Ew==
X-Gm-Message-State: AFqh2kqrCCFGH5uyhFPrKSab8uxYP55Fa3GMHL3J8Gptlo+qWquoG9pV
        TzWg17hGYs1R7HxuaTuEVyTYhdQcyBXJOA==
X-Google-Smtp-Source: AMrXdXvd+IHs+PU8UvPU11tLVdvAhnTwo1VieUGhGtuhjWt8bxjrq2O9JJDVHVuzbiDOOetsXdX1dw==
X-Received: by 2002:a17:906:95d5:b0:872:5c57:4a32 with SMTP id n21-20020a17090695d500b008725c574a32mr11609764ejy.51.1674146710280;
        Thu, 19 Jan 2023 08:45:10 -0800 (PST)
Received: from localhost (fwdproxy-cln-002.fbsv.net. [2a03:2880:31ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id gk8-20020a17090790c800b0084d35ffbc20sm15478643ejb.68.2023.01.19.08.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 08:45:09 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     leitao@debian.org, kuba@kernel.org, netdev@vger.kernel.org
Cc:     leit@fb.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sa+renesas@sang-engineering.com,
        linux-kernel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: [PATCH] netpoll: Remove 4s sleep during carrier detection
Date:   Thu, 19 Jan 2023 08:44:48 -0800
Message-Id: <20230119164448.1348272-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
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
 net/core/netpoll.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d042..6f45aeaf3da0 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -704,15 +704,6 @@ int netpoll_setup(struct netpoll *np)
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

