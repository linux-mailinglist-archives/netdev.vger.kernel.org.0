Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA416D8E2F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 06:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbjDFEDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 00:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbjDFEDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 00:03:13 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A06EF8A66;
        Wed,  5 Apr 2023 21:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=zqUsr
        WEJN0EiZ0bTUfv4/qeAkVy9cBKYCLeIfX7cEo8=; b=J7ZByYFYppM8MUiCvP0jc
        ulA6W6BWRLqFwwZOuKXbqOQQ891n1880EbUgGcKkjcTqAZ2FX54JRxn9GKyhUSlt
        Ryr7TfM/KHeo/PjhjxRlsgNMC2XM6B8p+qui7tXkUJw2K9PCTo9C7qv8rjpMOohb
        rlld0/z32qXAFHpAJKu6p4=
Received: from localhost.localdomain (unknown [119.3.119.19])
        by zwqz-smtp-mta-g4-0 (Coremail) with SMTP id _____wC3s2FARC5klsq6Ag--.47216S2;
        Thu, 06 Apr 2023 12:02:09 +0800 (CST)
From:   Chen Aotian <chenaotian2@163.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Aotian <chenaotian2@163.com>
Subject: [PATCH] netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT
Date:   Thu,  6 Apr 2023 12:01:51 +0800
Message-Id: <20230406040151.1676-1-chenaotian2@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3s2FARC5klsq6Ag--.47216S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrykKFy3GF18ZFy8tF1fJFb_yoW3ZwcEkr
        yvqF40krWrJrZFgr1rJayqyrWSga18Z3WS9a4fZFZ0yayrGw48uFZ7XF1rZan8Ww4UA3W5
        ZwnFqF1DJw1jkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbc4S5UUUUU==
X-Originating-IP: [119.3.119.19]
X-CM-SenderInfo: xfkh0tprwlt0qs6rljoofrz/1tbiHQJJwGI69pVlIgAAsq
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For memory alloc that store user data from nla[NFTA_OBJ_USERDATA], 
use GFP_KERNEL_ACCOUNT is more suitable.

Signed-off-by: Chen Aotian <chenaotian2@163.com>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6004d4b24..cd52109e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7052,7 +7052,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-- 
2.25.1

