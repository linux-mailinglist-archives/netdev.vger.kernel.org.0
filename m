Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5690C35CC14
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243919AbhDLQ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243813AbhDLQY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34AD86137B;
        Mon, 12 Apr 2021 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244676;
        bh=HhQczqzlz3kb8CmUecPkJkVX82K4ZVjXr4Kv4vS7uiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqP/EWf46dNjNvcQgCrXL5QD4JPTzNRPG2IFitrEDiUo3EcoRWSYU0NkMMZf0pugh
         p+mAP03XXIt2uygC8v/zXnQQCoiIpzIt50ZkEV3xc50q93U6k+kpTRFb6RZ2embpDQ
         7WsLqLUlpbtk2FBBgnWsSypL9y98L1u33YjEu3c663rrEmyEf5drrw/bJezLxoPHY4
         F0RdS596/s5tLVm/KxUq0nmOvyE9bmx2/G+Tb+/nNiJqKMyPswGn1KSZ8DECPkmJ8B
         oYFI6S7btUAk42Fs/MX6pGPk8bBzR3RFQIOe7i8tgkEqQOFWx1Ulnfv9E+N4Ws37gz
         VKcxBzwImxxGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/46] net: ieee802154: forbid monitor for del llsec key
Date:   Mon, 12 Apr 2021 12:23:42 -0400
Message-Id: <20210412162401.314035-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index c10fc3479d3e..9cdc1457c97c 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1604,6 +1604,9 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
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

