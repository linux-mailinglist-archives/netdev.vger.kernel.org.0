Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB0D35CC7E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhDLQ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244622AbhDLQ0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3BE661368;
        Mon, 12 Apr 2021 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244705;
        bh=BS/LfDsZBPJpKuL+h00rRtwRHlq8dK+Y9cPa2uHAavY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abkEt/wxU8AAkaCV3BQRRED0Zdb7iDfRZLgN9P6GZ+zTmEtunm7rkJSaXJG6djCNz
         yTLKs2eXF3V8dBJjlDBCQv6D/dNaCUc8Nj/E2QjCHdzVZGsX2Q+nyLuIwuULnAB9AW
         vSh0+oyNoh90AhEJZ9X2CooPHpk+VZV0NtcKXt3GDhAcIanX8e/8UY3cwWxOyJXw68
         H3FdGZtaW6u84DzSQZXHUzYJHaTTvwtpJzfwyNqOzFTNdpMcxxgrUkyrt+rSF7jZKn
         iN3PLYiacq+Doxmd63xKOKbJOye3JCJyxf6oKPIVZkDvItwOlFQ5hiT9rUxFas5qH7
         EbsQqanu9g8Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/39] net: ieee802154: fix nl802154 del llsec dev
Date:   Mon, 12 Apr 2021 12:24:24 -0400
Message-Id: <20210412162502.314854-2-sashal@kernel.org>
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

[ Upstream commit 3d1eac2f45585690d942cf47fd7fbd04093ebd1b ]

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVICE is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-2-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 44df73d73fc9..829696a3e2c7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1774,7 +1774,8 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEV_ATTR_EXTENDED_ADDR])
-- 
2.30.2

