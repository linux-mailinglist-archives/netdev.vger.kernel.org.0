Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE759F2D5
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 06:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiHXEun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 00:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiHXEuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 00:50:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F657857D4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14DD6B822E9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 04:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C784C43141;
        Wed, 24 Aug 2022 04:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661316628;
        bh=te7kUDmCFIfrbbsJ8YzueEn2LIUVzMN7tn59AolRa0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hN78gy/z6w92XoDAfsovcoC4WglmlKN68x+sqHcyNwtgGGbR2vqlaigNIgPK5iqHT
         qir/LzZLkSL8uoXn5daxocpy9EBWD1gkKNZDh/XS+KJuY8x+q+xHX4uOrHrarPCwYI
         DM71h4f6LG0aCseF8XXA49FJhxl4CHezlR7ljw+A00mdFbIc85wLFqjTdw4rJpR6tH
         RFGwv72s3psB5BsxiA/BnLjZIeVDcqKeeEbN6l/Iw2DqeEKfTx00Yx98S9LB55ZYAk
         Nnie3EjsnY9cKZQepGIk+dIpOXsuHuhAZ4dwt1nB38pOZjA1/Lr1ZLfGWXC19R1OmM
         D8UbYxcBWKScA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/6] netlink: add helper for extack attr presence checking
Date:   Tue, 23 Aug 2022 21:50:20 -0700
Message-Id: <20220824045024.1107161-3-kuba@kernel.org>
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

Being able to check attribute presence and set extack
if not on one line is handy, add a helper.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netlink.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 24f9fece7599..d20007ad7e26 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -139,6 +139,17 @@ struct netlink_ext_ack {
 	}						\
 } while (0)
 
+#define NL_REQ_ATTR_CHECK(extack, nest, tb, type) ({		\
+	struct nlattr **__tb = (tb);				\
+	u32 __attr = (type);					\
+	int __retval;						\
+								\
+	__retval = !__tb[__attr];				\
+	if (__retval)						\
+		NL_SET_ERR_ATTR_MISS((extack), (nest), __attr);	\
+	__retval;						\
+})
+
 static inline void nl_set_extack_cookie_u64(struct netlink_ext_ack *extack,
 					    u64 cookie)
 {
-- 
2.37.2

