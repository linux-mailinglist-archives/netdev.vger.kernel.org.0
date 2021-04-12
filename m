Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D935CE29
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343492AbhDLQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245628AbhDLQhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953CC613EF;
        Mon, 12 Apr 2021 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244875;
        bh=ICxLHv2VPB81IP9V2Da6OaL4Y83HIM0sz8nLFGmDXGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy5nQaiOBJpCjcji0NENZIrHUroRT7J5NZ2V7UsetQ3zs3TnVn76xzkqrQ6UXKfEE
         clm5jYq3WpsqU61s+PofHHpAn9IJ36b5lYj0bQ9/63+x4VpsmtBRhIvvtsq1yM2cEh
         Lca+qhVloXBizt+dACdI+9ZnK9lMmWP3nQQo0m6AaLuGu7fUAkjPeM+o2v/huKxSjn
         be+VcHmwOQpK4Jt3cWQDYS6lbumwRTLxYgeKjnDh8rpZo5KWsX8VVAj6zbl+zi3mSh
         RINJ7gmFgtLSTQqI8OP4/8/ydw3QOhWRp2FzLrDmxsVay4uY7TB8mAIFqP3M51mlun
         cZsT63a7paCoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/23] net: ieee802154: forbid monitor for add llsec devkey
Date:   Mon, 12 Apr 2021 12:27:27 -0400
Message-Id: <20210412162736.316026-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit a347b3b394868fef15b16f143719df56184be81d ]

This patch forbids to add llsec devkey for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-11-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index db45cb0d20b2..244fbbf3b58e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1893,6 +1893,9 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
 	    nla_parse_nested(attrs, NL802154_DEVKEY_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_DEVKEY],
-- 
2.30.2

