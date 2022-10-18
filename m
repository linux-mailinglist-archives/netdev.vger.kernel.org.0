Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76683603664
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJRXHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJRXHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FF9437E2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2618B82154
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C261C43470;
        Tue, 18 Oct 2022 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134454;
        bh=SX5jkJ9Cm6nFzHnUTULEl7YvkjdwpQOFgCKyZVeROf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoPNe6pBOYAmEysOobuo12Nlk7tS7uGU54j2jy02dSx7gWDbfvFFbEOXivBsNNMEp
         6Pl/VjpfQiMo+nSfuipwAdlwin77dID8xXrMki3uKeBK52LiwhlHRhkPprPwy9JqrO
         ggrWf3maja3EUoAEJ/vE02yV1zrGo7HJYlyzE1Akh/snT2WIqzm9SM3brph1GZKPOA
         6Uf1gmofwVLHiAsNbbKqp9J18ueFn0RugOkaiE5AxizQ7PNEzlt3Ez/4hvBsDYF6Uz
         nvDs5UJrHorFy6QPwXrMnXyZ5cxoerXjpUp3ShhNlh9hq1TUo9tKwum58puImKOSjP
         IAmd5vIT709VQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/13] genetlink: move the private fields in struct genl_family
Date:   Tue, 18 Oct 2022 16:07:17 -0700
Message-Id: <20221018230728.1039524-3-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018230728.1039524-1-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
I did this cleanup to add more private fields but ended up
not needing them. Still I think the commit makes sense?
---
 include/net/genetlink.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 8f780170e2f8..f2366b463597 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -23,7 +23,6 @@ struct genl_info;
 
 /**
  * struct genl_family - generic netlink family
- * @id: protocol family identifier (private)
  * @hdrsize: length of user specific header in bytes
  * @name: name of family
  * @version: protocol version
@@ -41,20 +40,16 @@ struct genl_info;
  * @n_mcgrps: number of multicast groups
  * @resv_start_op: first operation for which reserved fields of the header
  *	can be validated, new families should leave this field at zero
- * @mcgrp_offset: starting number of multicast group IDs in this family
- *	(private)
  * @ops: the operations supported by this family
  * @n_ops: number of operations supported by this family
  * @small_ops: the small-struct operations supported by this family
  * @n_small_ops: number of small-struct operations supported by this family
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
@@ -72,6 +67,12 @@ struct genl_family {
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
2.37.3

