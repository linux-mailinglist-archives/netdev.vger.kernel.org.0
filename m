Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02F535CC86
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbhDLQaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244659AbhDLQ1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4263E61383;
        Mon, 12 Apr 2021 16:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244708;
        bh=BEKUve7Q4K3KJGHHL+3o/XCjgyiAbJpb2NxXrdbqF+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbjNAA33ZROGXiiJie0h5GKW9o6AC1y0hSvHaVfr2vAdVj9CkJo+fOwqLZ3i+JY1v
         oNhmqeXobk9J8Yynf5a4ir56gLyW3E3yovGFOn7UFmjiSiaETZjKbVjWo4OBeSJ0N1
         w3EQkdUGqa3ze26924lxOxUk7DI2xtDKyqt5LIIi9cV/rOfgK0uuncjE/GYmrIj8SJ
         sv8gqlp6J7ghJtwLPpKFbTgAMb25cRtcV3XmxlV6nmYVFWVD4rHLZGA3fXeMYt4P2z
         ngB4UccUiYbvz3EplcTlP8Y7g0qcz2MOnSTJyeV3AKRr6hHy5eBSRbMtIPAaHO9xgP
         KgP9+3tPKbZ8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/39] net: ieee802154: fix nl802154 del llsec devkey
Date:   Mon, 12 Apr 2021 12:24:26 -0400
Message-Id: <20210412162502.314854-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 27c746869e1a135dffc2f2a80715bb7aa00445b4 ]

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVKEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 43003108be95..c398f1ac74b8 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1932,7 +1932,8 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEVKEY_ATTR_EXTENDED_ADDR])
-- 
2.30.2

