Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3435CB0C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbhDLQX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243282AbhDLQXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE24161287;
        Mon, 12 Apr 2021 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244582;
        bh=i8OFDWmtkhlZ2o/xLejnGFjudfCyDewPIs5/dJNhUic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2om7s1lsax950V1GJK5zCYtOsxqiXFtPE9FdxmUvMuaWJXt2HGKPfO72rX0oQmRD
         C/vhPF0yqn1ilREUEYd9F54xau5f2ZVFeQgT/fmgCK9OCv5nt6Ibkowzi5+YSa7X0y
         3HnKILad/IkXn0dcBlKiqV2Y584AyqPyAJpzZvK30kz2Nn9NZMwTqd3oPK8U81hZqs
         0PwlbDt5+WYhKjmNZ8WMAkE+C8nyXmUNBAUlyCy3vUj3YkwM2GV26/ZDaf0jZT8L/N
         BLsev9DME0a2/YDBxWPMqHf0T5cxIuDaXIE5TBzJPZxHu8KAWV+KXdoi4zqoQenBoT
         7sh1dsJZz6lsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+368672e0da240db53b5f@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 04/51] net: ieee802154: fix nl802154 del llsec devkey
Date:   Mon, 12 Apr 2021 12:22:09 -0400
Message-Id: <20210412162256.313524-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
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
index 3f6d86d63923..e9e4652cd592 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1916,7 +1916,8 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEVKEY_ATTR_EXTENDED_ADDR])
-- 
2.30.2

