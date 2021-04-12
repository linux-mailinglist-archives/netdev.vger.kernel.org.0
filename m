Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8D35CDA7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245382AbhDLQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245103AbhDLQeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:34:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76879613CD;
        Mon, 12 Apr 2021 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244810;
        bh=3bgBpdWtx7URtqSsxm+WZoyWoK8X5xD+e/jneOPoXZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCeQfuqDvkvN/IfBDBDo5GMDvf0WD6y6AX5qDfuKjaNDFBNCMHoZgLKUsIA/xyqyf
         HCl/RgXv1Xlaie58OeOWHoT57koSqajvRqFokdEc0axSTq4hEaINmcRlR+ZREzw7e7
         dX2BohuxUMuCQQVlSYHk4rrUfx9tLOU8ScYNZHJHDIO64tU6oo1Tdoa4WXQzVagZ/q
         V85UNjxLolV77gGVuupT7BVoXmiagcB/uUQ3CLy03yD7V7TUzrgxWE/rr02DxH0pU4
         k44+cL+3cgGLLXnnD4wYAVswOmc1N65/kvVFi5xt3offOzx7zRy927BLmEjOOJdRQO
         EDNVbreOo9inw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/25] net: ieee802154: forbid monitor for add llsec devkey
Date:   Mon, 12 Apr 2021 12:26:20 -0400
Message-Id: <20210412162630.315526-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
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
index b770837b3379..07139905e63e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1928,6 +1928,9 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
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

