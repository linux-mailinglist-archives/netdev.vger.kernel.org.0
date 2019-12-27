Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED10C12B9AB
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfL0SCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfL0SCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:02:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7273721775;
        Fri, 27 Dec 2019 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469760;
        bh=4FTqzjfn+w4KqdDw37CbAaA3bjTre5V3IOWDORrU7oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffd+3BTXV2C/zD5kzbRWOHzA0ut8s8IPw6cvs+gLlIF/y7kWfLxoxY8EVd0tReTgI
         GWnMKqUkYb0BuSRYEIFxKF208I+pU8O7wYk+t3nxF7RtUZPCdkd/xUEbcc9F2/TuiL
         FNm2o5fEK0ZLfj+vqBZo/WLAet//3h/ShDB8W7fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/57] netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
Date:   Fri, 27 Dec 2019 13:01:38 -0500
Message-Id: <20191227180222.7076-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit bffc124b6fe37d0ae9b428d104efb426403bb5c9 ]

Only NFTA_SET_ELEM_KEY and NFTA_SET_ELEM_FLAGS make sense for elements
whose NFT_SET_ELEM_INTERVAL_END flag is set on.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7ef126489d4e..91490446ebb4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3917,14 +3917,20 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
 		    !(flags & NFT_SET_ELEM_INTERVAL_END))
 			return -EINVAL;
-		if (nla[NFTA_SET_ELEM_DATA] != NULL &&
-		    flags & NFT_SET_ELEM_INTERVAL_END)
-			return -EINVAL;
 	} else {
 		if (nla[NFTA_SET_ELEM_DATA] != NULL)
 			return -EINVAL;
 	}
 
+	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
+	     (nla[NFTA_SET_ELEM_DATA] ||
+	      nla[NFTA_SET_ELEM_OBJREF] ||
+	      nla[NFTA_SET_ELEM_TIMEOUT] ||
+	      nla[NFTA_SET_ELEM_EXPIRATION] ||
+	      nla[NFTA_SET_ELEM_USERDATA] ||
+	      nla[NFTA_SET_ELEM_EXPR]))
+		return -EINVAL;
+
 	timeout = 0;
 	if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
-- 
2.20.1

