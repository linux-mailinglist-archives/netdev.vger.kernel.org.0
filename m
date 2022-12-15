Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FA464D529
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLOCCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLOCCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1E2ED6D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E26C61CDC
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3211C433F0;
        Thu, 15 Dec 2022 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069723;
        bh=TnwWScaAbx1vkDIDX8iL6dKOyPdEilyhQsp91d2UDM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnBA7d3VjRvTefR5q1dXKLQ6WnGqisu44TjhkOsrajZtFoAW3XAJ9zJ2eS6lNrXoP
         usKotGYmnavN4GkthYHvaxN4VsLqadQs0p0Z6SBQIfkohd5ajlvbXPIs80WP/4txTU
         8Br8nc3UH/YPvC7LaBFfwTQGl/4Gtlv1wYH5cdqEAdYrkvBUCtjpUM852eKGPkUIr8
         P918D7o20vdby9wYM0wDBvC0HXR5fCPxgIUEJeHgtg6llO8jJWSFYiYH4FtPOhHxoF
         Z8eUwKgavKoIyfVrQysCe9lBaLq7lanXZfqMzKTPopVguqOtwoDXDhqOZzKnCpu/DQ
         fIG64RwIhciRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 01/15] devlink: move code to a dedicated directory
Date:   Wed, 14 Dec 2022 18:01:41 -0800
Message-Id: <20221215020155.1619839-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
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

The devlink code is hard to navigate with 13kLoC in one file.
I really like the way Michal split the ethtool into per-command
files and core. It'd probably be too much to split it all up,
but we can at least separate the core parts out of the per-cmd
implementations and put it in a directory so that new commands
can be separate files.

Move the code, subsequent commit will do a partial split.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/Makefile                            | 1 +
 net/core/Makefile                       | 1 -
 net/devlink/Makefile                    | 3 +++
 net/{core/devlink.c => devlink/basic.c} | 0
 4 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 net/devlink/Makefile
 rename net/{core/devlink.c => devlink/basic.c} (100%)

diff --git a/net/Makefile b/net/Makefile
index 6a62e5b27378..0914bea9c335 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
 obj-$(CONFIG_BRIDGE)		+= bridge/
+obj-$(CONFIG_NET_DEVLINK)	+= devlink/
 obj-$(CONFIG_NET_DSA)		+= dsa/
 obj-$(CONFIG_ATALK)		+= appletalk/
 obj-$(CONFIG_X25)		+= x25/
diff --git a/net/core/Makefile b/net/core/Makefile
index 5857cec87b83..10edd66a8a37 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
 obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
 obj-$(CONFIG_DST_CACHE) += dst_cache.o
 obj-$(CONFIG_HWBM) += hwbm.o
-obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
diff --git a/net/devlink/Makefile b/net/devlink/Makefile
new file mode 100644
index 000000000000..ba54922128ab
--- /dev/null
+++ b/net/devlink/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y := basic.o
diff --git a/net/core/devlink.c b/net/devlink/basic.c
similarity index 100%
rename from net/core/devlink.c
rename to net/devlink/basic.c
-- 
2.38.1

