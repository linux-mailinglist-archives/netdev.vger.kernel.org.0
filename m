Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55C335CBC9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243683AbhDLQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:25:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243519AbhDLQXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76E361352;
        Mon, 12 Apr 2021 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244615;
        bh=HhQczqzlz3kb8CmUecPkJkVX82K4ZVjXr4Kv4vS7uiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HaBw1iB2XppfcRIMu/15HJRtgRjIesg/Srmg5CbHXLepwtS4azEhj2j+J5sYR5LP7
         lrv2eoPiBiRIlx7n7UPMaPugO+e268CR9xw3DVjZmylhrGGe29czpkWWC5b7QTHDKY
         ENFBjsspecMEmk3cBYDFaSA6TNkt9eumS8f1ZCsNgjcCkpjZdgdrjdsW0k7vqDxI93
         NwqqP9+6+hw3Ce/mY6A9OsCmCpNuU/vFckVH27VpfGuZBLjgpD5om2KJbhfJvAR8jM
         3nGaRridORpe1HDGZKNwxaYgElW0XWIc2VDRZFkO8iK3LI5BYbBWeCMQRVBb4Lhp99
         l7aqVdCKeLuzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 31/51] net: ieee802154: forbid monitor for del llsec key
Date:   Mon, 12 Apr 2021 12:22:36 -0400
Message-Id: <20210412162256.313524-31-sashal@kernel.org>
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

