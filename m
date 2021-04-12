Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054D435CCC9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbhDLQbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244938AbhDLQ3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 309EA6136C;
        Mon, 12 Apr 2021 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244733;
        bh=ARgNIH7sq9MUwtj3QCJOumoDorG7e6JkKpuvoyDIe8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fujPHNqtesO/YuG3/npdI5G/dyKGEQ5bMxtljdIMQWOEOokGNh7k3MGH8tXkrtDhv
         dPn9I+pI/xAESZKAx1wwcvC3xeINNYNgpyD7rXw6mv7f/GVWLvjesM+Xd8POn4fnbs
         5hGxE683hYy8v6tQHcTg3IJvtZisDubcoxwAV3AdwFLxqW6NNuETbecHc0mqgUDbY+
         8Qd62MXBKXJWBnPzeChniCS/nm9xgAgwsMWqkh8OVmYThWHYwCUWkxeSlmSH5HF+AA
         +QAC1O9gao2i0apvbPI14SJd9XVGyLNXAc6rF/QB+9mQzyCZA0IXPj4qo/j5qtUrtE
         3S0n4WNJgjNkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/39] net: ieee802154: forbid monitor for del llsec dev
Date:   Mon, 12 Apr 2021 12:24:47 -0400
Message-Id: <20210412162502.314854-25-sashal@kernel.org>
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
index 500317d30284..1af265409106 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1797,6 +1797,9 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
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

