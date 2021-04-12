Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4AF35CDD4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344200AbhDLQjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343556AbhDLQfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D36B613C0;
        Mon, 12 Apr 2021 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244814;
        bh=PpqaGiOjnfLNVyvOqEIrI5mc3b+VlvEadeVSW7AucP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzBW3CsJh3mlV/5fd8gSxb05Uf6wMuvb/PYOuEq8lJtkju8wDtb4tAWtQvftSexMB
         KxqoQzcDoWcEADWdnV7qTdsJQs1Bhh5EfHkZW7FU78h/hL7TrN5tVB76LeeT6EeNCb
         3nGnqoM6h1D90BqWiSMF8hiBLMDZYZAUN1Ks8wZ+KljAI+K6R7Z/fgzXxXXF70Kr2i
         Fc+u7D+CT8BFWi47Q4Y7v7U8ij+sXI59PiRqgjJ1e7xVsJYtE+NLIi4wmpYCYPAN3K
         yR1moafG5fkHa20bC+WCCbHJNFgW/nIP1k0k3tzIyhhNsKbvY2tgibM0XziTd6Vc3n
         FWjVj1uPH8ecA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/25] net: ieee802154: forbid monitor for del llsec seclevel
Date:   Mon, 12 Apr 2021 12:26:23 -0400
Message-Id: <20210412162630.315526-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 9dde130937e95b72adfae64ab21d6e7e707e2dac ]

This patch forbids to del llsec seclevel for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Reported-by: syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-15-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 8cf71f637ead..138aa41fb6f7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2147,6 +2147,9 @@ static int nl802154_del_llsec_seclevel(struct sk_buff *skb,
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_seclevel sl;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_LEVEL] ||
 	    llsec_parse_seclevel(info->attrs[NL802154_ATTR_SEC_LEVEL],
 				 &sl) < 0)
-- 
2.30.2

