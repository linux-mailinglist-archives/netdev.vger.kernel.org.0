Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD60C5A075B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiHYClj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiHYClb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC779AF98
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D74F6174D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 02:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B837C43147;
        Thu, 25 Aug 2022 02:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661395288;
        bh=ojq6wlISyTkyJeXOZPis19ffBEI8OFjJy4JVvuA4lmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBEybGFf7jUS0JvTkcoxYlMJzdVaP8y11WAgWyR38NxnEY/5Jbfi9BBLj9/wmIKfv
         w5Jmxhqml0dAFRXmSWk+7pqq0b6lygOKD4i1RbiofIwRhdfrguObcLg0ITAUzucPE/
         WkIZipcNvTLs5HtFVk4X8hHerKM/gV0I3ovXt9qb3g/2vAsPJpdecUdjgqdFx4THar
         BTKyQ0I/Dv+7VkQSrQeGhJ2lcXVymBOrUiYgQQtJF9C7hgF4ewhHxV0ltYrW2j8776
         m6Z5GAZ09XZXhs0oiMMijLuBv4POyYWMKoaW6XjS4sE8yuZRwisj++cDC6/5r945PN
         7XWU10MitKwBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/6] ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
Date:   Wed, 24 Aug 2022 19:41:21 -0700
Message-Id: <20220825024122.1998968-6-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825024122.1998968-1-kuba@kernel.org>
References: <20220825024122.1998968-1-kuba@kernel.org>
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

