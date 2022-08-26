Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FDE5A1F4F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiHZDJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiHZDJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC996CD52C
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DA6D61E74
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B554DC43141;
        Fri, 26 Aug 2022 03:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483381;
        bh=EhTrSCPKNzWIAIXbE8ng9ksYIDXALC8dYGCbzbg8bj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEiTfMBDi4Wte0b1zG0191cXL2XGIqRS8ifgH6IOuRhzvMbtKf32mOMks9waBjoGx
         l29Rf5ZR1O0dgN94XLE72cOAZUBSKjo90N8Ce2DDNaufXslC03cHIKHnbjmK3lT6i0
         S4FWmb3qSXJCnPZeVQREdcJ90GHxMaDGtQd7aaSS6KtWOX6s/w1EY7tbvVfxTHTV24
         +cJEb9nX3x88RngWa7gDmpVLzgDAQUSPwc5YdITJoVbDJ39DxbsZzthDEHSn5rQKP8
         bNdL9l8gQWRWnncYrTGAcA9z6RHgEjftwIEF69EH7cAXThf9fbl13nUYgOQ9BV5dUy
         E9sxc/ydhaPvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 5/6] ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
Date:   Thu, 25 Aug 2022 20:09:34 -0700
Message-Id: <20220826030935.2165661-6-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
References: <20220826030935.2165661-1-kuba@kernel.org>
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

Strset needs ETHTOOL_A_STRINGSET_ID, use it as an example of
reporting attrs missing in nests.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 2d51b7ab4dc5..3f7de54d85fb 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -167,7 +167,7 @@ static int strset_get_id(const struct nlattr *nest, u32 *val,
 			       get_stringset_policy, extack);
 	if (ret < 0)
 		return ret;
-	if (!tb[ETHTOOL_A_STRINGSET_ID])
+	if (NL_REQ_ATTR_CHECK(extack, nest, tb, ETHTOOL_A_STRINGSET_ID))
 		return -EINVAL;
 
 	*val = nla_get_u32(tb[ETHTOOL_A_STRINGSET_ID]);
-- 
2.37.2

