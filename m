Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E3467B9E7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjAYSwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjAYSwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:52:49 -0500
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEFF171F;
        Wed, 25 Jan 2023 10:52:45 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id os24so6448643ejb.8;
        Wed, 25 Jan 2023 10:52:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RQeDdHynJPckR6TzoLgOIVW3N1/aAZvGLbwQhlPV21k=;
        b=sqHZNek6y90ncWo+JFnqD1P9uVxHTznNcifvTYvWJoGFjbCmCDK6/GTbUwXzn2b2La
         UUMNB3uhcFvJdCxJbDYvCYFfP0wXhBEn2PrFPe4aiV0zQiBi68wA9FdDusMXZQCQ7fn7
         +0Fv9FwCMlQNPU0d5aAIr+aDiJy4RAu31B+SzTjkVPYe+45RDP0lK6hlnN1kmnQi9svG
         mTKfhZ2uJ3u7AaKo8Bil/k4Pqya6CA+mU3eQQ3BxuK6rGsl0cryhBnDTewKSXR9Pv/tT
         4OYTMqAqjmv9ZhJGDpLo+Lh20p+v8wDOLO+4XA444UeRa9h/f6yY+ecaZcZ9MeuWKCly
         CsEw==
X-Gm-Message-State: AFqh2koIN0/Lk2J4Ff4aQtbGT4wKYi/f4G9yMpXrTui9Cy33jo2toAv4
        uIJCzykk52xKLwlR8wx7BUM=
X-Google-Smtp-Source: AMrXdXt9KVvifwzbI7QYwDKfgYLTPfsvX+seF3bVuy/8Ekey/CYt6oSHzdPyVitRNiPnqIRVr8UEYw==
X-Received: by 2002:a17:906:c409:b0:863:73ee:bb67 with SMTP id u9-20020a170906c40900b0086373eebb67mr34402293ejz.73.1674672763593;
        Wed, 25 Jan 2023 10:52:43 -0800 (PST)
Received: from localhost (fwdproxy-cln-007.fbsv.net. [2a03:2880:31ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709060e9000b008779570227bsm2675642ejf.112.2023.01.25.10.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 10:52:42 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     leitao@debian.org, leit@fb.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
Date:   Wed, 25 Jan 2023 10:52:30 -0800
Message-Id: <20230125185230.3574681-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the msleep(4s) during netpoll_setup() if the carrier
appears instantly.

Here are some scenarios where this workaround is counter-productive in
modern ages:

Servers which have BMC communicating over NC-SI via the same NIC as gets
used for netconsole. BMC will keep the PHY up, hence the carrier
appearing instantly.

The link is fibre, SERDES getting sync could happen within 0.1Hz, and
the carrier also appears instantly.

Other than that, if a driver is reporting instant carrier and then
losing it, this is probably a driver bug.

Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
--
v1->v2: added "RFC" in the subject
v2->v3: improved the commit message
---
 net/core/netpoll.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9be762e1d..a089b704b 100644
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

