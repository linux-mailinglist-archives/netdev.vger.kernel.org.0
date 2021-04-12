Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDCB35CC0A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbhDLQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243470AbhDLQY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017E261356;
        Mon, 12 Apr 2021 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244674;
        bh=hD5+h9rx/iTLDFNOKaU/RhNebTCrLUD67CNBZP7/j4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL7zkANN6vq+4KmS+c9sa8PUn15rR5jqaKX4f3xVEFriFuqfZM/JOEnFxZec7Ekbp
         YX9hoLKVPnM3uTFCLMKR1ZDLkIQZ5HFK5AzyBJT/PbOjf8rGc9qmcyMLGQU5arEs1t
         Sa6sEn3dVpKVlkYfe4TC1/AAyGtRr0EBn7FK8QaDtpHWis3QVIEPY9kzXVM+SvHi9F
         FX7cKRaylUQ3cMVNniMdOYs3f/eckUA1E4UJGX8ecRaW66pOWIBfrmuqgMdby1ekcS
         gxuO6imOr0Trz0IvQeys1R6mYEVgM+tgqEKy/clPt74XvMdKLCGlPLSBwU3vfAzDBO
         VDFHxOMDVcEVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/46] net: ieee802154: forbid monitor for add llsec key
Date:   Mon, 12 Apr 2021 12:23:41 -0400
Message-Id: <20210412162401.314035-26-sashal@kernel.org>
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

[ Upstream commit 08470c5453339369bd3d590c4cbb0b5961cdcbb6 ]

This patch forbids to add llsec key for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-5-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index c85e4230ec60..c10fc3479d3e 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1552,6 +1552,9 @@ static int nl802154_add_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2

