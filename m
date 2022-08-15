Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BEE59385D
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 21:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbiHOSaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbiHOS3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:29:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02A8101F1
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7766AB80F99
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 18:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3999C433D6;
        Mon, 15 Aug 2022 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660587624;
        bh=T+gFMN0Kf6m7QGgxx/t8KjjgWMq5WmNFpduH8FDgDIY=;
        h=From:To:Cc:Subject:Date:From;
        b=qYfr1iep96D1Qk7tD1/B2KAb8/nsjwoTwLfZBFdQUfoHKgMBabGHnJc1zvMiINuDQ
         Kyj2McNpSA3W9PQpnTbKKsihHSSXBuzRackAlySsAUBNkptvRoIWnyc+MH71rHyaDg
         3a7wvN0vCgqwpO+AHiC+/NDWxBHptQg9VEv4t6b1ckOWWQEmTkFzmm1aZxR3Yq1VWn
         4hlKC/QRJEHhzxsTh4Rg+AKRXvivQIR8uhQE7suaSzwHY2aY7p8N6eXvzncUjBpUdV
         vJQ8IZXG8C/vNrzZ2CJ5XYgfGoi9RMWu/hFJ8Yd37Z8+XvdhI2EdEqbwaTbQGOBJ79
         35aKlMQ86O0fg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes.berg@intel.com, Jakub Kicinski <kuba@kernel.org>,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Subject: [PATCH net] net: genl: fix error path memory leak in policy dumping
Date:   Mon, 15 Aug 2022 11:20:21 -0700
Message-Id: <20220815182021.48925-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
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

If construction of the array of policies fails when recording
non-first policy we need to unwind.

Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com
Fixes: 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1afca2a6c2ac..57010927e20a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1174,13 +1174,17 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 							     op.policy,
 							     op.maxattr);
 			if (err)
-				return err;
+				goto err_free_state;
 		}
 	}
 
 	if (!ctx->state)
 		return -ENODATA;
 	return 0;
+
+err_free_state:
+	netlink_policy_dump_free(ctx->state);
+	return err;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
-- 
2.37.2

