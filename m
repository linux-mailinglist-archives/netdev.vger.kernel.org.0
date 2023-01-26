Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6D67C4C3
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjAZHOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbjAZHOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A437153B24
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 551EBB81D07
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1A5C433D2;
        Thu, 26 Jan 2023 07:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717273;
        bh=nVVUlspspDg13zwAMMv2/mmowEDE+DMviHhhe3yS938=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vyc8HBUJcQpWK7N2bVtrLP+mIxvjTpqhMBBm9rq/Qgou0LV1QboEfP8hbPzhIA/q+
         O+oVo6qfhg8d4ENyaFnMiFVDTDQu1Ukps89MIhRmi6GCwPTeMTAvYT/0xGRQvugslp
         Xl1Pee98SKsobVZRmjkYRMu9gtgfW/Vs2/ZmWGkx0+MMVjibdX175gTi+3lJB2aalt
         hctJuiokkSkW5kaC7YLTwxhw+wcgxwN4fXXseZhekoPhKy9OGzJpUJfpAmtNi+moc3
         zvJUglVbUTDWM+jYUqmJE8YDIe9YiA721JNeOtFaRbQeTyklItRo76RPzmL75Y3Gpx
         BrTv5L2jxbyDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 10/11] net: skbuff: drop the linux/hrtimer.h include
Date:   Wed, 25 Jan 2023 23:14:23 -0800
Message-Id: <20230126071424.1250056-11-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/hrtimer.h include was added because apparently it used
to contain ktime related code. This is no longer the case
and we include linux/time.h explicitly.

Sadly this change is currently a noop because linux/dma-mapping.h
and net/page_pool.h pull in half of the universe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c6fd5d5b50e0..5ba12185f43e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <net/checksum.h>
 #include <linux/rcupdate.h>
-#include <linux/hrtimer.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdev_features.h>
 #include <net/flow_dissector.h>
-- 
2.39.1

