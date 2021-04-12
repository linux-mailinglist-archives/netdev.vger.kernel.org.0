Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63F535CC1F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbhDLQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243673AbhDLQZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC8A61363;
        Mon, 12 Apr 2021 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244679;
        bh=N+JzTV4PbYaeyO51wr5zkYJDqrGpsvK6zKixgy7vqFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGrWF0MkYZTiTDUchYgb+y6LGlYT6GhDs75Iqtn3F7upNJfTe0sswqiKrdw+r4vjj
         DU+1nxdbG4vl9J4bLsRl8W9HNdC+EgFg8YHmbdTrWnEAsACO1FC5T9N+UYAgQ8+S1/
         CO/EG7DE/sSoEpHiIPtBr6tm5esb1y9B3boT9gu+xE6R4QtBx95YwWdlQKqs2ccls6
         JziZ3oXNAZEoN75w+bNU56QE5x8jO2jeVJOMBqyZU4xbOHfW+26h4n2Z7BpEzn3Ktb
         AKejcwl2nAvxXQIBxoo7nhATlzp36rh7SwdqgMgii1QwowIN+1+Jyf3dDnyhtCjYI3
         B9sbicCl7gv6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/46] net: ieee802154: forbid monitor for del llsec dev
Date:   Mon, 12 Apr 2021 12:23:45 -0400
Message-Id: <20210412162401.314035-30-sashal@kernel.org>
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

[ Upstream commit ad8f9de1f3566686af35b1c6b43240726541da61 ]

This patch forbids to del llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-9-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 29aaeb094959..5c386575aec0 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1781,6 +1781,9 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
 	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
-- 
2.30.2

