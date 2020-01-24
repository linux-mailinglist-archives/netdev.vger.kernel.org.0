Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A325F148740
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392239AbgAXOVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392230AbgAXOVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8296F21556;
        Fri, 24 Jan 2020 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875708;
        bh=WLHXPwq0EdaMgI+zF0ACG1Mj7qwQtreqZgVlFTlDgD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y5ADQw3Y8OTk3HOFRgS3yNtIaDiCrzH+wZpI/fB+/q24N7lnyhA40KjJdzCZcQg3G
         5BNvN/5zV6TNVFOxDsXgnaXUAuQEDzw/6iaIlWpd+bS5d8UvF+gXVAtkZ8WzKhfikK
         bFp56RFpxWTYSdjVWq1QQN1wrkZkKEjtTc5OnaHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/32] wireless: wext: avoid gcc -O3 warning
Date:   Fri, 24 Jan 2020 09:21:11 -0500
Message-Id: <20200124142119.30484-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142119.30484-1-sashal@kernel.org>
References: <20200124142119.30484-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e16119655c9e6c4aa5767cd971baa9c491f41b13 ]

After the introduction of CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3,
the wext code produces a bogus warning:

In function 'iw_handler_get_iwstats',
    inlined from 'ioctl_standard_call' at net/wireless/wext-core.c:1015:9,
    inlined from 'wireless_process_ioctl' at net/wireless/wext-core.c:935:10,
    inlined from 'wext_ioctl_dispatch.part.8' at net/wireless/wext-core.c:986:8,
    inlined from 'wext_handle_ioctl':
net/wireless/wext-core.c:671:3: error: argument 1 null where non-null expected [-Werror=nonnull]
   memcpy(extra, stats, sizeof(struct iw_statistics));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/x86/include/asm/string.h:5,
net/wireless/wext-core.c: In function 'wext_handle_ioctl':
arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here

The problem is that ioctl_standard_call() sometimes calls the handler
with a NULL argument that would cause a problem for iw_handler_get_iwstats.
However, iw_handler_get_iwstats never actually gets called that way.

Marking that function as noinline avoids the warning and leads
to slightly smaller object code as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200107200741.3588770-1-arnd@arndb.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 6cdb054484d66..5236a3c2c0ccf 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -659,7 +659,8 @@ struct iw_statistics *get_wireless_stats(struct net_device *dev)
 	return NULL;
 }
 
-static int iw_handler_get_iwstats(struct net_device *		dev,
+/* noinline to avoid a bogus warning with -O3 */
+static noinline int iw_handler_get_iwstats(struct net_device *	dev,
 				  struct iw_request_info *	info,
 				  union iwreq_data *		wrqu,
 				  char *			extra)
-- 
2.20.1

