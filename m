Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167035EE470
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiI1SfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiI1SfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:35:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0BE286FF
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC07DB82186
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8094C433C1;
        Wed, 28 Sep 2022 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664390117;
        bh=ffCylb8tV986+n0BpD+n1ShDQKMVVkXi51coeGnyDqU=;
        h=From:To:Cc:Subject:Date:From;
        b=lGH55AttciAIBz6KUcmSO2k8TmloJk6KAsaIkdWsKrgjwGEpc9c9oDBhqjr3Ghsbp
         +M5D8axqcFqpkb1ns7GxYtJLSbWHYhKD25D0/N0os1pxodX5l+U65XxlS0WJP+m4CP
         +D6b6V2mH9i6Qjn2QLuUhX9JtYSDwaTdabn5wZ+YHui3qoiZFbQSTTaeuYZzL1zIrL
         q1Gf6w2XhlZ93Hjo6O1lrWPGu8JDfzIkSp6F7AUMQtsTa/YKnkOVQQCcWQEsfGDMtg
         e9L2FEpYv3ox6VhhlcvjwdMqbVmtJRhzH6HAMxvC5ELbGdZxThe/m9smW+xKQAmfao
         pysbNA1L6MGNw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] genetlink: reject use of nlmsg_flags for new commands
Date:   Wed, 28 Sep 2022 11:35:15 -0700
Message-Id: <20220928183515.1063481-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
introduced extra validation for genetlink headers. We had to gate it
to only apply to new commands, to maintain bug-wards compatibility.
Use this opportunity (before the new checks make it to Linus's tree)
to add more conditions.

Validate that Generic Netlink families do not use nlmsg_flags outside
of the well-understood set.

Link: https://lore.kernel.org/all/20220928073709.1b93b74a@kernel.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Florent Fourcot <florent.fourcot@wifirst.fr>
CC: Nikolay Aleksandrov <razor@blackwall.org>
CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Florian Westphal <fw@strlen.de>
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Jacob Keller <jacob.e.keller@intel.com>
CC: Guillaume Nault <gnault@redhat.com>
CC: Hangbin Liu <liuhangbin@gmail.com>
---
 net/netlink/genetlink.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 7c136de117eb..39b7c00e4cef 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -739,6 +739,36 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	return err;
 }
 
+static int genl_header_check(const struct genl_family *family,
+			     struct nlmsghdr *nlh, struct genlmsghdr *hdr,
+			     struct netlink_ext_ack *extack)
+{
+	u16 flags;
+
+	/* Only for commands added after we started validating */
+	if (hdr->cmd < family->resv_start_op)
+		return 0;
+
+	if (hdr->reserved) {
+		NL_SET_ERR_MSG(extack, "genlmsghdr.reserved field is not 0");
+		return -EINVAL;
+	}
+
+	/* Old netlink flags have pretty loose semantics, allow only the flags
+	 * consumed by the core where we can enforce the meaning.
+	 */
+	flags = nlh->nlmsg_flags;
+	if ((flags & NLM_F_DUMP) == NLM_F_DUMP) /* DUMP is 2 bits */
+		flags &= ~NLM_F_DUMP;
+	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
+		NL_SET_ERR_MSG(extack,
+			       "ambiguous or reserved bits set in nlmsg_flags");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int genl_family_rcv_msg(const struct genl_family *family,
 			       struct sk_buff *skb,
 			       struct nlmsghdr *nlh,
@@ -757,7 +787,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
 
-	if (hdr->cmd >= family->resv_start_op && hdr->reserved)
+	if (genl_header_check(family, nlh, hdr, extack))
 		return -EINVAL;
 
 	if (genl_get_cmd(hdr->cmd, family, &op))
-- 
2.37.3

