Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE97839E2CA
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhFGQTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhFGQRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD77A61439;
        Mon,  7 Jun 2021 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082452;
        bh=vqjqIDbMlYZPAfIgI/fP7LY+EVjhIGlykwYrcE7qBug=;
        h=From:To:Cc:Subject:Date:From;
        b=omrtM2TYo7ref6dE53dt6tU58GeUO/caLqfJ+GuZz+A7cqyovjgXJVRPQoeNGNU96
         8H02yjxQ3aLyewXR7sK+ZXSHrxmu4T0/2O7Axr0dOVziSWtAgwfyQchUm7JMJPLnSf
         1iaaEjEgTpgP2GT9iVZ6iVuWAA/IvUW6B7rvgdP5IBpbojkEgLhRJUjOX28p5jOV4Z
         a1TSPyWV9LNlyoYX39k69K+IslGbENoxpgnB3F9Xg7j//e/5gFD+qvJOBFM5zSEbn8
         oqx+3jWJlMUy0BNK1qHKZCXFoe4E/T8gS4v+eM2C8VphgnSe7A9q8pWNYzBjxlZOVC
         cn9qXN3hxH5nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/29] net: ieee802154: fix null deref in parse dev addr
Date:   Mon,  7 Jun 2021 12:13:42 -0400
Message-Id: <20210607161410.3584036-1-sashal@kernel.org>
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
index 328bb9f5342e..b2ba1d2556f1 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1314,19 +1314,20 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
 	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_DEV_ADDR_ATTR_MAX, nla, nl802154_dev_addr_policy, NULL))
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

