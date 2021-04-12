Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE235CCD2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244984AbhDLQb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245055AbhDLQ31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E38613AA;
        Mon, 12 Apr 2021 16:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244736;
        bh=eVB+zifHxtc2kYe57/FSGJW5C68BZmpGQ4SynQVbQnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBSCyoZNMzxnU3EEUfoAYQNNAwXs+R9VJVQxKrIkTXWV74+Og5ScYHjopBo4QPA9b
         S6QUuZvinsgC88PERW6VfQxHQsBStu8lEx7HTS7PFRN6bVq0OKotOJy+MCQmk+fVXK
         JALAWh3xAELJn9jK91GUA7IiS478boTGYSRkCKnG1EzmbKLkXiuZzWaasWH8ns+Fcx
         y+Os4VcwQsdePax1L6eybb/4tHVn0dZ/Pvd8Rgu9FqSY/vlCuH39HtO6A0z1EhLNAl
         O4zWG0rr7Tpf8nsxpCJSlfijnM+X7wyK6mwpiXaLohXDOj/5s4bAvxa7gET/UdXSxN
         /iGl1L2Cv7jpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/39] net: ieee802154: forbid monitor for add llsec devkey
Date:   Mon, 12 Apr 2021 12:24:49 -0400
Message-Id: <20210412162502.314854-27-sashal@kernel.org>
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
index 61d42b4a1375..6ab746517f13 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1931,6 +1931,9 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
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

