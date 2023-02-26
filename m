Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA96A30EF
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjBZOzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjBZOzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:55:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823F11B333;
        Sun, 26 Feb 2023 06:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFB660C4F;
        Sun, 26 Feb 2023 14:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FB7C433EF;
        Sun, 26 Feb 2023 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422875;
        bh=7nlw+z4ihYtQPm2r4XX/GLLJtAiJkGwxBfDCnSTO3EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ij+y52OavgvjdHLTm7aenl5fOdcpPbs+1xY1iOJqmBWaPbEFTtSqDVDaDPjIaslkj
         XbOgvKLJrEoZNMTeCevTYXhWgHzurCYpPaNFnhBWYM3yRhMfgcWaUUl3errSz7fpJx
         qZ5sfUQMkOpjLuljFEyv+BiDFCkLnyZE461yhU9urMLI3DkE8Cxc8ZCIwU0r4Zv5qd
         QDorPO7BAl9Wb+jaijpwG1xJQWjBS+39CuQi51OpxOLychzeUIyNXYXa4KHz+f1MXr
         pp/91jNR3hT97G34xQZlo0B1yl16dJ50D8fwcXMR/kzmHxe2d62Wnzhpemy/LcYNg8
         aRykweVjIM0zA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alok Tiwari <alok.a.tiwari@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 28/49] netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()
Date:   Sun, 26 Feb 2023 09:46:28 -0500
Message-Id: <20230226144650.826470-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dac7f50a45216d652887fb92d6cd3b7ca7f006ea ]

static analyzer detect null pointer dereference case for 'type'
function __nft_obj_type_get() can return NULL value which require to handle
if type is NULL pointer return -ENOENT.

This is a theoretical issue, since an existing object has a type, but
better add this failsafe check.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3ba8c291fcaa7..dca5352bdf3d7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6951,6 +6951,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 
 		type = __nft_obj_type_get(objtype);
+		if (WARN_ON_ONCE(!type))
+			return -ENOENT;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
-- 
2.39.0

