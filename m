Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C6F35CC7B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244830AbhDLQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243299AbhDLQ0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6224961371;
        Mon, 12 Apr 2021 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244704;
        bh=b0XojnXsO9Hyyecq96fEMRKMafR34w5GEc7zCToFUOU=;
        h=From:To:Cc:Subject:Date:From;
        b=rDb19yRC54w/qhqznXBC6OZDUD/7/NF6nPp5RmKRCXdf3FzsVgvvBq0avK1x6Lvnn
         48+Ve+snhb40c2e+YFZSM4e7DFQVM2P2alvS4Qqaap2pey3vhidjU5s88AyF3cUHrI
         XceZJ9DO6PZg27mP9Smtdv36hGCL0ODXnAyN/5+GjChPRCnCjISW27QqhIDJOpmyn8
         p1YOe6WXUrfgC2b0asg23rsaQmY9NuPGSz+TDdSc7v45IsYbvB1qrmDXR0KDmUBFwt
         246KCZnLwuIcn++AxAj7KqAPKCFZkfp/EFBfdOoyvE8DrxqEQqps/lUg2CPi01iu+t
         BCr/MCK2PdVRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/39] net: ieee802154: fix nl802154 del llsec key
Date:   Mon, 12 Apr 2021 12:24:23 -0400
Message-Id: <20210412162502.314854-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 37feaaf5ceb2245e474369312bb7b922ce7bce69 ]

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_KEY is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index ffcfcef76291..44df73d73fc9 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1608,7 +1608,8 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
-- 
2.30.2

