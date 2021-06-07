Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDC939E24F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhFGQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhFGQPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD6361407;
        Mon,  7 Jun 2021 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082401;
        bh=/KOVpH4rv9fwOqe9CmwxcXiyoVX1h85wYnu2sLJMTgc=;
        h=From:To:Cc:Subject:Date:From;
        b=DkVbRWXQVNF5k0ZPI7AVXdZViVDNltT+Ilf6Mm6GZuCTzhhrY4OWEFBnmjsTDG1kz
         ZzcEJ6+GYB5dMaQMo7sJPyTvvZYp1IUqkvcgyohbG2CQWDAJtRiav4J/q6oeTT5n1g
         B5P9A+jQmtCdsJmTsDUMmyCjt7rtKgpFEpLeFUbD2NBBpRTZth+/pz81SKT0poMtbG
         Sqnayjl2Hs7QRIj0RlWM4LdlevQeKOC4f6VyCX/6SobY9J9xAUnI6KHYh7fQRYqNcf
         PFtpB+wufSHS3Zvdk+7f67Hu2L3v8+tsU4TGptOD+sT/QjNTrMFZzszxjt8UwORfrw
         jCNj1hN05rtyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/39] net: ieee802154: fix null deref in parse dev addr
Date:   Mon,  7 Jun 2021 12:12:40 -0400
Message-Id: <20210607161318.3583636-1-sashal@kernel.org>
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
index f0b47d43c9f6..b34e4f827e75 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1298,19 +1298,20 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
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

