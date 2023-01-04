Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CD865CC45
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbjADEQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjADEQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFDF167FB
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86186B811DC
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4193C433EF;
        Wed,  4 Jan 2023 04:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805804;
        bh=yB67eUQu4zQNlY24rNK7bJOcMXPsgawBVUB0zgz3K04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8wK2myHh86lNOohibMZ8dvosSP7dwM45IjehCJHfXTCjNZmUuTMR0CyHkq12jlYd
         R9RAE9TffLO8smX/Ia8LfWwgCbwC4XqWKE2UHhlDbcNIbU0QuiY0MHJHX4bUvW0Qcf
         pF/rsk+Rdc8N6ORcF3R+rVvJkhlso6twgbVDtT0OtXpIW2lw54vFkmrLPFwY5T6Xxg
         P9uGdUf271XEA9fHDuccpew3C4/nfvb+jrWqr8oh4baLsyxiLqbRlfFxIMCcSNxKjp
         ZebfRHuYOLLfIpxuH3Z+ETNIVebMWVzzUudp54l73eakJYMQDhWsLaQy2uKDAXRQNa
         ZZcCQ1+/NgJaA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/14] devlink: move code to a dedicated directory
Date:   Tue,  3 Jan 2023 20:16:23 -0800
Message-Id: <20230104041636.226398-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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
v1: rename basic.c -> leftover.c
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

