Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D605E35CCAE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbhDLQa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244910AbhDLQ3K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B89613A1;
        Mon, 12 Apr 2021 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244732;
        bh=2hwUrLe0wvVWhSQUTgYjJdusZNq8zVj9ojizmwJXStY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAUFFUZ12a3xPuuHa7pYvxmOO/2mIfWaX8otCj+xNhYfTrSZ4wTcE1zjOr+p7/xJr
         LxBbQIBH25DjbHXaLdo4pTFlgWd055olR2k25JrKhPK2XRVwDgw+68H8xd8xQ8OFCF
         6rz3BnYwME66TLUsyEQMSkmC7zUxWGk7lB/AoSw7QE1RnclW96sZJ85T5KaH2684SJ
         jVa/7kmw0atPXOBK7b9/C7pQy1PKD4zuDKfpfaHk7nvXzH8y0A/YRUPIY7bk2/NKxK
         rh+5XrEbg7pHc5hq6Y8zHWHvl86SmXvj2qtunQ6f7vdT0eufdD6gugV+cO/72wSHan
         v+SraQniNWHCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/39] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 12 Apr 2021 12:24:46 -0400
Message-Id: <20210412162502.314854-24-sashal@kernel.org>
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

[ Upstream commit 5303f956b05a2886ff42890908156afaec0f95ac ]

This patch forbids to add llsec dev for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-8-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8e996ed8b3db..500317d30284 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1779,6 +1779,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_device dev_desc;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (ieee802154_llsec_parse_device(info->attrs[NL802154_ATTR_SEC_DEVICE],
 					  &dev_desc) < 0)
 		return -EINVAL;
-- 
2.30.2

