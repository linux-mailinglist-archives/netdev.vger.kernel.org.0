Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACBB59F2CE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiHXEul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiHXEub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BC08304F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC7961879
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BCEC43145;
        Wed, 24 Aug 2022 04:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661316629;
        bh=Z4BIZjSth0QZM0wg8cda7ha2lAEVbwO3hyYSkVfe2t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8lHEjySswvxK+K2iZzfksUlc3gbnAOtR7EzNPrZgnuFc1xnpP8zFqh+zrkX2fpJH
         WAmwbpocpecH9njfq0TFzM/hjXcbwQEl1zp+kRdbuXNHp58mvm4b0MCZ3BauMj6krs
         RNDLekvKcABxkfGxr+97vd0UylMVw1Znf9d3HkQuY7fJIB6iMcGMRbLXqL2lPkp+42
         +NfVbKBTxYOIInubuE/0m0cDOm9JufoURHS9v40yxgY+ju7V5qCSrShor7KJ1ILTfL
         TuEkH298I/b6mznQTqHlpuOIGr+zQ4i9qZHCCeWLwNwoyZOH7QKcfzSQz2Hiol9xev
         ObMIjQ9S/A/cA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
Date:   Tue, 23 Aug 2022 21:50:23 -0700
Message-Id: <20220824045024.1107161-6-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220824045024.1107161-1-kuba@kernel.org>
References: <20220824045024.1107161-1-kuba@kernel.org>
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

