Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407135CC9D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244377AbhDLQah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244795AbhDLQ2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9568C61384;
        Mon, 12 Apr 2021 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244730;
        bh=uGQxDhVq7UCroyKLRCigIEZQYrW+RpCYWby/1AnMY0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r11rl6y7Fk/XdR4Gw0f4a3Ey1DZqrl3a762YDu4Lmj1SxCXCE9KBxzQkTM6DJ7viN
         ruacuI/4q5BPpD43fTcBiaJKNH7A0fAxCpNfRzZ5HXWqg8pGKy4ouZErQ/D3u0w4hN
         augfZmGIVLVgIuZGVFFd1G7gn5xZvyXa/40FvM9n8XpB0s6TWWgNylvMQGCYd7JmQ1
         rP2/dDBcrDScT5pjp9y9z+u1DcDlBVS0KLa1zkkeZ4QnHwQxEDUd4t2l09rslTf6F3
         iMDnXB6v6smwBNWvIDgHqqMHnFRQ1u90tt32HBgFS1UCccT7ZVg/QDBNZT6l4bsJlI
         ZnERGOCHCVuAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/39] net: ieee802154: forbid monitor for del llsec key
Date:   Mon, 12 Apr 2021 12:24:44 -0400
Message-Id: <20210412162502.314854-22-sashal@kernel.org>
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

[ Upstream commit b6e2949544a183f590ae6f3ef2d1aaaa2c44e38a ]

This patch forbids to del llsec key for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-6-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8758a805ef40..2eaf29d15baa 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1620,6 +1620,9 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2

