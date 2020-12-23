Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F422E1688
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgLWCTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgLWCTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2AE22D73;
        Wed, 23 Dec 2020 02:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689960;
        bh=h2zF7WsF0kn+m51N13kQ8pFg/eImiX8gIVmjxPTyqio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIe6lrOCT6v/28k8cj/gr3WStdLMSiu0lxF3mg4KOaiUcIY70lRE6N8KM0fts43ow
         P/fuEbAxA3LqDhyrEOfpI/YyYOFax/paEO+FaWgT0SLBw9jwSmTgqFEsMQnl/cE/Y8
         IDZoifVGEEpULLDbYNUOnAxlD3lIhoACXVi71GLmhQdwwl0xLpe1kZWfQM8OaFHZiq
         lGQt65GiTQ6R9ss97lWPBKnnT9FS2gGSGURXE2nc4/0fqJE9fGiyqFZ2c/x8i75UL9
         dRcpOj5xHff0UAvrxVEo5ZWijOKxw9NXR2n/Sgq/fivQAFsGbYFU98G9YUimY33t3o
         bdKyBf8qQ65RA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 052/130] net: dsa: avoid potential use-after-free error
Date:   Tue, 22 Dec 2020 21:16:55 -0500
Message-Id: <20201223021813.2791612-52-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 30abc9cd9c6bdd44d23fc49a9c2526a86fba4305 ]

If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
immediately. Shouldn't store a pointer to freed memory.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201119110906.25558-1-ceggers@arri.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f734ce0bcb56e..2b657e88d8017 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -476,10 +476,10 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	if (!clone)
 		return;
 
-	DSA_SKB_CB(skb)->clone = clone;
-
-	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
+	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type)) {
+		DSA_SKB_CB(skb)->clone = clone;
 		return;
+	}
 
 	kfree_skb(clone);
 }
-- 
2.27.0

