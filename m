Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76235CAF8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbhDLQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238872AbhDLQXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 178B660200;
        Mon, 12 Apr 2021 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244578;
        bh=o0WNHqBMyuqM8Ik2gpVug7ta1h9XY8Z9+PSnQlQ5404=;
        h=From:To:Cc:Subject:Date:From;
        b=UyP7gt6X9SgUeYDLWqnAZZ06m2lpbxMUrbYE93F8bdBUhZGvsZ6mJhagOvQ/DCKf9
         lbxIq5u1Zup2lhslfjwmVN87bYc2ADWAeH5JOZEJfkj/88xcEgvHLmoHU95sUJMKKv
         WzxCz488LpPwrIiJNfIV13yCBhxhstq7O0BOUUaVtmVvCetxo7TRHdkOqg5tjRIsYD
         yVkSlyuGKU+bgif41tfLsQbyn6yTjNkl3+bQk+zr4iCkxiSujrR61Qg19VNRLGbcOa
         CTtlBewVa9Anuv8A/ijZLfEb/vJ9VsoRQhGYs7Il6g6rpJWerolwcyxNHotp8vogfu
         rPTT+z/OC6auQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 01/51] net: ieee802154: fix nl802154 del llsec key
Date:   Mon, 12 Apr 2021 12:22:06 -0400
Message-Id: <20210412162256.313524-1-sashal@kernel.org>
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
index 7c5a1aa5adb4..2f0a138bd5eb 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1592,7 +1592,8 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
-- 
2.30.2

