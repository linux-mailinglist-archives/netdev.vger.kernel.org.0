Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA7135CDC8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243369AbhDLQim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245098AbhDLQbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FEEE611AD;
        Mon, 12 Apr 2021 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244775;
        bh=KlcYCbh/aOwdIZJA/TMT/dsRi9umog+EcNG2foDfu7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCPT55BW4Hl4RqdR+4wcGt9FFK95ccatNgkj7K9YZHdJKT2NmTPCRHgtopUHlPYFN
         WwPoGs5K3jq5K4D0CKuX6V8HOfVSPPHh/JBofX9Xsv8TIh5FW3UF+CL+xmCo3L+nDj
         EwTrw+YcnfsxiBJEtn9xz8WCZfTkMJDcSNSpB9PQGuzzpJYkWRO2y/fcMldew8sBSc
         bh6ArrRdy9WEKGdQjAkGYYMNb2B96FGLodXkslBirURLIKJIK8W/9AUwXAT/6NFcmA
         KwCAMaUMRcwBj4P3s1OGSIrMx4+0cwpwtGtky9BqWP8A1EiImI/WAFS6pFHzLMpL0S
         ORMLP4pp4aD6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/28] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 12 Apr 2021 12:25:42 -0400
Message-Id: <20210412162553.315227-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
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
index 10858c31cb47..b770837b3379 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1866,6 +1866,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
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

