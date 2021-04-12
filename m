Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A96B35CDA4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhDLQhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245049AbhDLQd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B65A613BB;
        Mon, 12 Apr 2021 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244805;
        bh=Voh8y93ylmYb0hpiuVCM2v210dVWOSiD+VcoCZTIfQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTa9OIxyu3+Nl1lyxq23W98Z647nbrY22QnV6Unr6rh8bnArCCqdZVCp20bmY01KE
         C+fxd/8hSutruLIlkZta5vXVFndvnCAKtpJpz0YN4pq5HUZcZrIiV/4a80IiRuI0mR
         Mwf8BM6D8isZ2D0HhAQ5lp6cFu03ZchuxvQH18SjqnUzXaHKZqfnmVDKJm2dE5Q1/3
         gZn1449M67IfFB9QQhH/bQID0jXuMRhuFQM3BGexyd+UM+owZoSBxIyXWaW/vXWxhR
         +uP1KnxMqcMqS1R2rux3K+F20BkV+/iGwz52VjHTar6pJOmbaUBx0J8Cj4i5gTRRxt
         AAkR5PvtzeXXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/25] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:26:16 -0400
Message-Id: <20210412162630.315526-11-sashal@kernel.org>
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

[ Upstream commit fb3c5cdf88cd504ef11d59e8d656f4bc896c6922 ]

This patch stops dumping llsec keys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e07624fd8b3b..8ca3a83b260a 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1511,6 +1511,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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

