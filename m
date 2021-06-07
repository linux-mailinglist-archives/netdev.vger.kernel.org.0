Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC1239E38C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhFGQ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhFGQW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDF446192C;
        Mon,  7 Jun 2021 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082519;
        bh=jJYjTdoHxHUi8n/6g8UQTWTBJcpkxStl1jXbNNZZ7Bg=;
        h=From:To:Cc:Subject:Date:From;
        b=Lce5rJRYoA42b7wc0NrZsN5aBAmfIEWgdMjANj7tws/2VY45lYs5LhlddcYj5qf0g
         RJcztFjbUCs/YatlfEqb8IuufBm0/myBvra0IcVjv6ro9x0pdt11yKOe1bxGYAZTxc
         FwEH5KSlBAdypr2Cck6IbPb12h/QyTlBDk3yvF8beBEp5hWBgZYEKah6M+7xg9D6Y0
         WSTWR2PIEXC8U56RXu1JwDnHIc2cOpWGrUfkgA+yw9QQlTYHwNHpC3Fu4llloQDI/R
         21AC/3bwAZ7KA4MQcB0dKFCKXsTAVniqZdRrPEQo20r8zdJcZ3uDJFtDYOo9NKLCIG
         d5xKiJ8PkJmkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/18] net: ieee802154: fix null deref in parse dev addr
Date:   Mon,  7 Jun 2021 12:14:59 -0400
Message-Id: <20210607161517.3584577-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit 9fdd04918a452980631ecc499317881c1d120b70 ]

Fix a logic error that could result in a null deref if the user sets
the mode incorrectly for the given addr type.

Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210423040214.15438-2-dan@dlrobertson.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index b1c55db73764..6d4c71a52b6b 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1315,19 +1315,20 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
 				     nl802154_dev_addr_policy, NULL))
 		return -EINVAL;
 
-	if (!attrs[NL802154_DEV_ADDR_ATTR_PAN_ID] ||
-	    !attrs[NL802154_DEV_ADDR_ATTR_MODE] ||
-	    !(attrs[NL802154_DEV_ADDR_ATTR_SHORT] ||
-	      attrs[NL802154_DEV_ADDR_ATTR_EXTENDED]))
+	if (!attrs[NL802154_DEV_ADDR_ATTR_PAN_ID] || !attrs[NL802154_DEV_ADDR_ATTR_MODE])
 		return -EINVAL;
 
 	addr->pan_id = nla_get_le16(attrs[NL802154_DEV_ADDR_ATTR_PAN_ID]);
 	addr->mode = nla_get_u32(attrs[NL802154_DEV_ADDR_ATTR_MODE]);
 	switch (addr->mode) {
 	case NL802154_DEV_ADDR_SHORT:
+		if (!attrs[NL802154_DEV_ADDR_ATTR_SHORT])
+			return -EINVAL;
 		addr->short_addr = nla_get_le16(attrs[NL802154_DEV_ADDR_ATTR_SHORT]);
 		break;
 	case NL802154_DEV_ADDR_EXTENDED:
+		if (!attrs[NL802154_DEV_ADDR_ATTR_EXTENDED])
+			return -EINVAL;
 		addr->extended_addr = nla_get_le64(attrs[NL802154_DEV_ADDR_ATTR_EXTENDED]);
 		break;
 	default:
-- 
2.30.2

