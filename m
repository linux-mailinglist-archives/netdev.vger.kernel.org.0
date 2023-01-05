Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C010265E458
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAEEFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjAEEFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273833724E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5214B818C0
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502FBC433F1;
        Thu,  5 Jan 2023 04:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891538;
        bh=XOCilgeby2gtUym8YDqPuE6zFySZjbmEniCvhWIcN6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipvxauwfrKwxcrkBji457HOCl+1mR1hFNsibjmi/Ayz5xcQi377OFdNhOQtBdbcbu
         Ug+uLaX8/z8y6CYU12dJu+FN8HA07P3gTrbRR8VKw+a7CN5DBI4Z7nKDhXtz/zuu3s
         IgQhEZyPIPfQeKhp57p2SpGPnGlNmuebCrqaPa7yLgC5xzXvmEGJGIoNQdz9Fc7UKG
         cCVLKe+HRHIVd3NWKL5KMZwk3KjTMHvbd+kEGE69uItRZagOR2aHzkJ7QNAxwh6dCa
         HEI2JK7Khp8NUqoYTjy8Nov9a20ZL4noIlzBvGr9P775QVkz4OQnQcXKA/Y70hGsqM
         oU2UOPYOp9RQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 01/15] devlink: move code to a dedicated directory
Date:   Wed,  4 Jan 2023 20:05:17 -0800
Message-Id: <20230105040531.353563-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/Makefile                               | 1 +
 net/core/Makefile                          | 1 -
 net/devlink/Makefile                       | 3 +++
 net/{core/devlink.c => devlink/leftover.c} | 0
 4 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 net/devlink/Makefile
 rename net/{core/devlink.c => devlink/leftover.c} (100%)

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
index 000000000000..3a60959f71ee
--- /dev/null
+++ b/net/devlink/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y := leftover.o
diff --git a/net/core/devlink.c b/net/devlink/leftover.c
similarity index 100%
rename from net/core/devlink.c
rename to net/devlink/leftover.c
-- 
2.38.1

