Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8EE35CB59
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243722AbhDLQYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243521AbhDLQXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C824A61350;
        Mon, 12 Apr 2021 16:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244616;
        bh=2pjS5ZqasrTBB1xW9gK+Ycx/cZGON+/PMmVlv+QVoXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVJXkc34g7YLe4qiOrCYaUcTBX7UI4rxA+9ySEw6UFYYYEBZbGc0AOUCciZYmke6z
         hKdnXfe9Lmic8O75M/g3qSt7mykHpLCaw8IInFK9bsaxO2mQZCH4KskVlfGndlrKfo
         JF6upIXNpgiYogRI6wIptjEOZo6JRXkn9ZylZIC4z2nYqmudLTEfDL4SlCXN1s4IPz
         iHvz8W3yBe4J9Gg+Riy6+uOqfgd4EE7zSYllAQRmLuThF0egeNuNcHSoa6hwRbF4y+
         RmtIrHDoN9lHH3E/gkpCAG4FtRH+kKIQA0vUvXzUgRHL6mA8hpesAqhtKnNyVq3Ohj
         la/MIwkmRcuaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 32/51] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 12 Apr 2021 12:22:37 -0400
Message-Id: <20210412162256.313524-32-sashal@kernel.org>
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

[ Upstream commit 5582d641e6740839c9b83efd1fbf9bcd00b6f5fc ]

This patch stops dumping llsec devs for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-7-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 9cdc1457c97c..39a81602e5b5 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1672,6 +1672,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

