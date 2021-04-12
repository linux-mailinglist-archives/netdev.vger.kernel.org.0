Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9EF35CB5D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243796AbhDLQYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243525AbhDLQXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0592D60FD7;
        Mon, 12 Apr 2021 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244617;
        bh=ERB2TuorPERWoiYpSCdrSnzqUHhaINVZft2pDls/WiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6z2x6dvfNqyxPuJ5h1FymPmQGAbL6r9TnssBavvt7Wba/QZGE1Xkfqlz+RT9DnLI
         1zIYKYG97vmIUqmPbCpUdExF/qQEJKRfY8/AIz7x1GPJ6SVVd7Zw+JiMHyTx7u7KnJ
         BiARffo63QgpOfi8ajM1pUbG5Mc2e9Ydt9zBaSjSFs6eLIQgnhXsMmVBItAImm/iN3
         FeSrsdJgsiFMUV2ffN+tHYfXtZPGIT+ytNGKsPt64Z+YyLceRi/nBxps3AoFIFC696
         HmTAuAKAsarBFd79Q2DMKD8aGfe4g4I5p8Mvem9hia08uQZL4ofLhEVS/VWjn5rFxB
         kcdDlhMtdd5Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 33/51] net: ieee802154: forbid monitor for add llsec dev
Date:   Mon, 12 Apr 2021 12:22:38 -0400
Message-Id: <20210412162256.313524-33-sashal@kernel.org>
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
index 39a81602e5b5..29aaeb094959 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1763,6 +1763,9 @@ static int nl802154_add_llsec_dev(struct sk_buff *skb, struct genl_info *info)
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

