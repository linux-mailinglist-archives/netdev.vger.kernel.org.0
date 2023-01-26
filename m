Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803F967C4B6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjAZHOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAZHOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB6747427
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17BC8616E9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36172C433A1;
        Thu, 26 Jan 2023 07:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717269;
        bh=9j15Ep0nu0WysCQ4h6OrfZIeyPyI/W/4+W0JkVkEDgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m066/kCsziP9RsmEhJr1JOqFo9rsJ15B4KpkFvpUxLRNxV4VziiLlQ41bf61aQR/l
         bxacaI5AmfVPrUB4z/xsE+BNeZtQNJ6aKbyOLVE5k8zPgTD0jPbP+ssr91u+GuCErs
         cZwiHUdDUoWznJqBX0uiVadWgS5gS+BEEw94LjYdqxoUMdQgXyZVzpSJAarWkJXSTm
         7/oeNwmqEUyzOP08uXkpdABRmmGpIZGfZdZbxJOKvAF78LBunGMHktOCLBCAOlh/8T
         7b4FE+ql0D4yP2Vmi2/AU0LaVOnaCjd33HwbGTA54LAZumae1Rh/bysHissK588j9C
         ov6nsLAosOYbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 04/11] net: skbuff: drop the linux/textsearch.h include
Date:   Wed, 25 Jan 2023 23:14:17 -0800
Message-Id: <20230126071424.1250056-5-kuba@kernel.org>
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

This include was added for skb_find_text() but all we need there
is a forward declaration of struct ts_config.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 2 +-
 net/core/skbuff.c      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b93818e11da0..7eeb06f9ca1f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -23,7 +23,6 @@
 #include <linux/atomic.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
-#include <linux/textsearch.h>
 #include <net/checksum.h>
 #include <linux/rcupdate.h>
 #include <linux/hrtimer.h>
@@ -279,6 +278,7 @@ struct napi_struct;
 struct bpf_prog;
 union bpf_attr;
 struct skb_ext;
+struct ts_config;
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 180df58e85c7..bb79b4cb89db 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -79,6 +79,7 @@
 #include <linux/capability.h>
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/textsearch.h>
 
 #include "dev.h"
 #include "sock_destructor.h"
-- 
2.39.1

