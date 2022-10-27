Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E79610447
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiJ0VVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbiJ0VVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED61458DFD
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89A486235C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 21:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DC0C433C1;
        Thu, 27 Oct 2022 21:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666905671;
        bh=7/9iyXdv01Dp2uYWt0COltnSucifFUnlqkgBC/SoNwo=;
        h=From:To:Cc:Subject:Date:From;
        b=LZ+0V/ww+s2OsDvfohlMY+sAW9WOeYNB3Ox+eS6DfqZUUyPlcw/blINq+1knocEoN
         7j9FLV2mFh3PR2Xg7LothwfaePzErPShjJuuR2LW0wO3isik7jOcYym7X42hfj0000
         UpSWOWsOJKHplEnB58WD2dnUejMJVZC22Y5ER/Yyi1Iub/27SoTyFJMwucMmjRRaUy
         i+M9Q6WZwDXhpS8yj/1xNdsOnPnbdmSYWSYdzznvc1b41ZScSGfD+j9ffVCEVN4FB7
         loYOpIqEsyAd9EEycM9JqpT+Pxb2+9LXYOx541wPD5fTaHspR7ioj+FpQOVZ9jw/Cs
         0eW+X8Gv2hMSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] netlink: hide validation union fields from kdoc
Date:   Thu, 27 Oct 2022 14:21:07 -0700
Message-Id: <20221027212107.2639255-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark the validation fields as private, users shouldn't set
them directly and they are too complicated to explain in
a more succinct way (there's already a long explanation
in the comment above).

The strict_start_type field is set directly and has a dedicated
comment so move that above the "private" section.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/netlink.h | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..7db13b3261fc 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -317,19 +317,10 @@ struct nla_policy {
 	u8		validation_type;
 	u16		len;
 	union {
-		const u32 bitfield32_valid;
-		const u32 mask;
-		const char *reject_message;
-		const struct nla_policy *nested_policy;
-		struct netlink_range_validation *range;
-		struct netlink_range_validation_signed *range_signed;
-		struct {
-			s16 min, max;
-			u8 network_byte_order:1;
-		};
-		int (*validate)(const struct nlattr *attr,
-				struct netlink_ext_ack *extack);
-		/* This entry is special, and used for the attribute at index 0
+		/**
+		 * @strict_start_type: first attribute to validate strictly
+		 *
+		 * This entry is special, and used for the attribute at index 0
 		 * only, and specifies special data about the policy, namely it
 		 * specifies the "boundary type" where strict length validation
 		 * starts for any attribute types >= this value, also, strict
@@ -348,6 +339,20 @@ struct nla_policy {
 		 * was added to enforce strict validation from thereon.
 		 */
 		u16 strict_start_type;
+
+		/* private: use NLA_POLICY_*() to set */
+		const u32 bitfield32_valid;
+		const u32 mask;
+		const char *reject_message;
+		const struct nla_policy *nested_policy;
+		struct netlink_range_validation *range;
+		struct netlink_range_validation_signed *range_signed;
+		struct {
+			s16 min, max;
+			u8 network_byte_order:1;
+		};
+		int (*validate)(const struct nlattr *attr,
+				struct netlink_ext_ack *extack);
 	};
 };
 
-- 
2.37.3

