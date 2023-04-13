Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD66E0D04
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDMLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjDMLsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:48:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68B75A5D0;
        Thu, 13 Apr 2023 04:47:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0E9B13D5;
        Thu, 13 Apr 2023 04:48:04 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FFCC3F73F;
        Thu, 13 Apr 2023 04:47:19 -0700 (PDT)
From:   Kevin Brodsky <kevin.brodsky@arm.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 2/3] net/compat: Update msg_control_is_user when setting a kernel pointer
Date:   Thu, 13 Apr 2023 12:47:04 +0100
Message-Id: <20230413114705.157046-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230413114705.157046-1-kevin.brodsky@arm.com>
References: <20230413114705.157046-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cmsghdr_from_user_compat_to_kern() is an unusual case w.r.t. how
the kmsg->msg_control* fields are used. The input struct msghdr
holds a pointer to a user buffer, i.e. ksmg->msg_control_user is
active. However, upon success, a kernel pointer is stored in
kmsg->msg_control. kmsg->msg_control_is_user should therefore be
updated accordingly.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 net/compat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/compat.c b/net/compat.c
index 000a2e054d4c..6564720f32b7 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -211,6 +211,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 		goto Einval;
 
 	/* Ok, looks like we made it.  Hook it up and return success. */
+	kmsg->msg_control_is_user = false;
 	kmsg->msg_control = kcmsg_base;
 	kmsg->msg_controllen = kcmlen;
 	return 0;
-- 
2.38.1

