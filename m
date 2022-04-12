Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC824FDBA3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350477AbiDLKFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343901AbiDLJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D315708;
        Tue, 12 Apr 2022 01:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C35B81B76;
        Tue, 12 Apr 2022 08:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC35C385A8;
        Tue, 12 Apr 2022 08:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649751303;
        bh=NQjXyMGVp6+C0UwowNnJIzpOMvx2ZN0GwcrTxKcb1lQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WNGRtZEEX4BwRZV84heEIQuYLkTHuIfYkrxj23mwH2scSSnxdBzuLpkpUW5nHd+RA
         rbgQsIyAb4rlav2oC7/SYE80Ywidigj4Bmsp2DSE/ONxE5dt98Ksrs3nc/f7jbE7NK
         3jRT2hZ31ANTQxFak0ujIpc/OMf2lbI9rZaoSGk9TiTHVMGc31Cz4eEyxw/Pnj7vGJ
         x5cryOWL4tPCl9i4DbLGCviNJFmRy4djcX/q3EHrDp3apeo6UAR1uX0E8qDYsYmFoB
         x0GlSOmGHR3fbq/a0CsntAlQ+EDBI1Oh57gFt9CbD40XGJDZ89EFKc3z6mUuc5T73z
         5zSh8x0Li9IrA==
From:   Antoine Tenart <atenart@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     Antoine Tenart <atenart@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: nft_parse_register can return a negative value
Date:   Tue, 12 Apr 2022 10:14:59 +0200
Message-Id: <20220412081459.263276-1-atenart@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 6e1acfa387b9 ("netfilter: nf_tables: validate registers
coming from userspace.") nft_parse_register can return a negative value,
but the function prototype is still returning an unsigned int.

Fixes: 6e1acfa387b9 ("netfilter: nf_tables: validate registers coming from userspace.")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 128ee3b300d6..16c3a39689f4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9363,7 +9363,7 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
+static int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
-- 
2.35.1

