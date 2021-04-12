Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C935CB67
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbhDLQY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243548AbhDLQX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BE096101B;
        Mon, 12 Apr 2021 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244620;
        bh=0tqVyUvTZ3gESgbCoj3FyaA1zpkb8A2bHdLABKbDKJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnJnm14trx7yrAd4iOwmEBfcxV6RnZ+inQAoWm1qtPOw+5fNMw455wGKv8iuejihv
         cTzMl0+sXKkFOz6NaoptOKc01lvoytSvcVyvkEd0fsDBubpszb1fnqGAbnswvzgcu4
         J3IV/Yuc+MIADFXvGbg1xLXVaWcsDD1cNyKUDGGuNvi03Wo7h8ZJAMNU7MVw+/hqnf
         gfkvJCRmfay1OxzdSS+26E6qj3ZwFfWo43XL6HH0Sdu5BAKNIf9rdnshsgUOaUo4Zw
         RPTwGmXgAZec4qVrC+XPQg9nzCDufEgOVX/wy3FQpZIWsdZ1fTqiOlXIfrvxZeCY1f
         /mnzacuEBZPbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 35/51] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 12 Apr 2021 12:22:40 -0400
Message-Id: <20210412162256.313524-35-sashal@kernel.org>
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

[ Upstream commit 080d1a57a94d93e70f84b7a360baa351388c574f ]

This patch stops dumping llsec devkeys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-10-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 5c386575aec0..f63fbb237be8 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1853,6 +1853,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.30.2

