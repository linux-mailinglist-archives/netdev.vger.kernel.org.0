Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB99B2998D2
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 22:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388380AbgJZVcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 17:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388283AbgJZVcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 17:32:19 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C3D520829;
        Mon, 26 Oct 2020 21:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603747938;
        bh=d6pPfEEbX5k/KDYCx6kqlaHhLndASZeYrNepQsjxTcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDcrZbBEXvP4JfDpeCvOwiqU3bVDQW3cnF0+E9aLr+odeTZbpAxXgrZh4wIJndFEP
         tNy+SVhHz+fU1E2lrzNAtmHbOju6xeWyI4Yx8iZPZOU88uyeHtS+xexVS0/P3Y6Llj
         Q8nLlyRaC1P4gSGvVCNbWav1EiviHhmTD/48PAvk=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/11] wimax: fix duplicate initializer warning
Date:   Mon, 26 Oct 2020 22:29:51 +0100
Message-Id: <20201026213040.3889546-4-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra points out multiple fields that use the same index '1'
in the wimax_gnl_policy definition:

net/wimax/stack.c:393:29: warning: initialized field overwritten [-Woverride-init]
net/wimax/stack.c:397:28: warning: initialized field overwritten [-Woverride-init]
net/wimax/stack.c:398:26: warning: initialized field overwritten [-Woverride-init]

This seems to work since all four use the same NLA_U32 value, but it
still appears to be wrong. In addition, there is no intializer for
WIMAX_GNL_MSG_PIPE_NAME, which uses the same index '2' as
WIMAX_GNL_RFKILL_STATE.

Johannes already changed this twice to improve it, but I don't think
there is a good solution, so try to work around it by using a
numeric index and adding comments.

Cc: Johannes Berg <johannes.berg@intel.com>
Fixes: 3b0f31f2b8c9 ("genetlink: make policy common to family")
Fixes: b61a5eea5904 ("wimax: use genl_register_family_with_ops()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/wimax/stack.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/wimax/stack.c b/net/wimax/stack.c
index b6dd9d956ed8..3a62af3f80bf 100644
--- a/net/wimax/stack.c
+++ b/net/wimax/stack.c
@@ -388,17 +388,24 @@ void wimax_dev_init(struct wimax_dev *wimax_dev)
 }
 EXPORT_SYMBOL_GPL(wimax_dev_init);
 
+/*
+ * There are multiple enums reusing the same values, adding
+ * others is only possible if they use a compatible policy.
+ */
 static const struct nla_policy wimax_gnl_policy[WIMAX_GNL_ATTR_MAX + 1] = {
-	[WIMAX_GNL_RESET_IFIDX] = { .type = NLA_U32, },
-	[WIMAX_GNL_RFKILL_IFIDX] = { .type = NLA_U32, },
-	[WIMAX_GNL_RFKILL_STATE] = {
-		.type = NLA_U32		/* enum wimax_rf_state */
-	},
-	[WIMAX_GNL_STGET_IFIDX] = { .type = NLA_U32, },
-	[WIMAX_GNL_MSG_IFIDX] = { .type = NLA_U32, },
-	[WIMAX_GNL_MSG_DATA] = {
-		.type = NLA_UNSPEC,	/* libnl doesn't grok BINARY yet */
-	},
+	/*
+	 * WIMAX_GNL_RESET_IFIDX, WIMAX_GNL_RFKILL_IFIDX,
+	 * WIMAX_GNL_STGET_IFIDX, WIMAX_GNL_MSG_IFIDX
+	 */
+	[1] = { .type = NLA_U32, },
+	/*
+	 * WIMAX_GNL_RFKILL_STATE, WIMAX_GNL_MSG_PIPE_NAME
+	 */
+	[2] = { .type = NLA_U32, }, /* enum wimax_rf_state */
+	/*
+	 * WIMAX_GNL_MSG_DATA
+	 */
+	[3] = { .type = NLA_UNSPEC, }, /* libnl doesn't grok BINARY yet */
 };
 
 static const struct genl_small_ops wimax_gnl_ops[] = {
-- 
2.27.0

