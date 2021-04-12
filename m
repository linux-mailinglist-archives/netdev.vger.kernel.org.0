Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD9D35CC2A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244190AbhDLQ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244207AbhDLQZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A33461362;
        Mon, 12 Apr 2021 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244682;
        bh=6Nh8PVk0yinlMXghRdnEvXQx8ASuT9fRE7BuJ+VxrvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yyo3MAPN0vqBqCX9YsfZ3RiNptxBzWQaNgxFuI2ixj5k8qXMz0Zw0F36E+WGEbK7g
         cRJQIQ7BKG/na899hbZbFDUyhvUd/4k27ZeKx1J52Lm2gbJQEDDMdpCi89GQAGUFfS
         7o+V3go2cIJDSsQ3v6q6BS0UvbyZ/Si3ff6/sJCwuPSRvCERrSwfL5czfdlMr4xTcB
         wdHdYT1kUaH+dnhosDqH1vZ6mo5KlTc6rYIM+pKmykR9+v4TvxHvIyP2LunW5Q1Vko
         9/HpLo1bau+Dl6IQ1Veim6zBXQ38HJyFUcmbtjTd0/YZa3NtSaa1kqX0rJclDONrJD
         6gG4l9TLkOEOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/46] net: ieee802154: forbid monitor for add llsec devkey
Date:   Mon, 12 Apr 2021 12:23:47 -0400
Message-Id: <20210412162401.314035-32-sashal@kernel.org>
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

[ Upstream commit a347b3b394868fef15b16f143719df56184be81d ]

This patch forbids to add llsec devkey for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-11-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index f63fbb237be8..1e437de5e7c9 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1915,6 +1915,9 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack) < 0)
 		return -EINVAL;
-- 
2.30.2

