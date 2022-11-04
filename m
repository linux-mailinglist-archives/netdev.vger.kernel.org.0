Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A4361A0A2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiKDTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKDTNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D204732F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18135B82F46
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E70C43470;
        Fri,  4 Nov 2022 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589227;
        bh=7bmUIvTh7m11eJkhXFQR5xxfAyOxMEzxBo/osUEWGsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjvvT8oQ4r4o/y1qrvvT2rdq/YwNhf8MooVxrM06NnMiLb8oRRefvNamd4535GSH8
         dHcgDqRE/F+3yjuHt6B6ecgJS/pPIW8Ub4TyrTyVG3KcE5MRwjI7iNrkj3qXe/rlr9
         80BgurDDod6Xr9EL3Cq2QROMgUwCMe3p8tcwe1//xfc0NtKUh2eQB09+Hr9AMY6jnn
         NLuz+EPHK7pQGTwYsHfFB+iR0jUqRPX1BzJarBQ3BiIhGpHrAKfj84dGADFf0H6xHJ
         RdrWIbZDWiL1mzungz0cFAy4gpcx059nyOyYjfoR6b2F1+kBwMjirZKg9h+IfoFRWD
         2ln6AkL+N5Zdg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net-next v3 02/13] genetlink: move the private fields in struct genl_family
Date:   Fri,  4 Nov 2022 12:13:32 -0700
Message-Id: <20221104191343.690543-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104191343.690543-1-kuba@kernel.org>
References: <20221104191343.690543-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the private fields down to form a "private section".
Use the kdoc "private:" label comment thing to hide them
from the main kdoc comment.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
I did this cleanup to add more private fields but ended up
not needing them. Still I think the commit makes sense?
---
 include/net/genetlink.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 9f97f73615b6..81180fc6526a 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -23,7 +23,6 @@ struct genl_info;
 
 /**
  * struct genl_family - generic netlink family
- * @id: protocol family identifier (private)
  * @hdrsize: length of user specific header in bytes
  * @name: name of family
  * @version: protocol version
@@ -43,8 +42,6 @@ struct genl_info;
  * @resv_start_op: first operation for which reserved fields of the header
  *	can be validated and policies are required (see below);
  *	new families should leave this field at zero
- * @mcgrp_offset: starting number of multicast group IDs in this family
- *	(private)
  * @ops: the operations supported by this family
  * @n_ops: number of operations supported by this family
  * @small_ops: the small-struct operations supported by this family
@@ -58,12 +55,10 @@ struct genl_info;
  * if policy is not provided core will reject all TLV attributes.
  */
 struct genl_family {
-	int			id;		/* private */
 	unsigned int		hdrsize;
 	char			name[GENL_NAMSIZ];
 	unsigned int		version;
 	unsigned int		maxattr;
-	unsigned int		mcgrp_offset;	/* private */
 	u8			netnsok:1;
 	u8			parallel_ops:1;
 	u8			n_ops;
@@ -81,6 +76,12 @@ struct genl_family {
 	const struct genl_small_ops *small_ops;
 	const struct genl_multicast_group *mcgrps;
 	struct module		*module;
+
+/* private: internal use only */
+	/* protocol family identifier */
+	int			id;
+	/* starting number of multicast group IDs in this family */
+	unsigned int		mcgrp_offset;
 };
 
 /**
-- 
2.38.1

