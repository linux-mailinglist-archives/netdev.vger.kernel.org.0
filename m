Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F264D536
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLOCCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLOCCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C01033C26
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F54B81AD3
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62231C43396;
        Thu, 15 Dec 2022 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069724;
        bh=GybzyQAcg/LS7o9xF4iZP593RvEgSS7GEsqT7qUwvkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6ZIpPF3oBfAScddkWofPF11lKuMDdfaJhAECPsbxLlWGstupIy0QUjFzsE/2rtiY
         7/sFlGQfq8pdjH4De3MkgiGSioB6jbg7/s4/h9G7taM8nKFdNOb+gjeLrPGFNbfPmx
         U1EWhxtZFYeAnin0yoU7iB+9ij8XaaZn6kp3NHKH7KXkA/pyzc2/jV3cfi3l8/Z5//
         O5gjJT1j5tluZ+grcgtKfZ8W5THhd3iy7WlI2YaWH3k9Ww8wic1EzVZ/7Oz6VX1fIj
         MPduA9hQBBbBSzyVJqJc9pwSKo0DaPqMT5IYc+TdZN2X5tHa3/n5Mi/ISfaZ3DwsPC
         ifKbazrPb7SFQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 04/15] devlink: protect devlink dump by the instance lock
Date:   Wed, 14 Dec 2022 18:01:44 -0800
Message-Id: <20221215020155.1619839-5-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the instance lock around devlink_nl_fill() when the dumping.
We are only dumping basic info so in the worst case we were only
risking data races until now.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 4b0938a1854e..e01ba7999b91 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -1330,10 +1330,13 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 			continue;
 		}
 
+		devl_lock(devlink);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		devl_unlock(devlink);
 		devlink_put(devlink);
+
 		if (err)
 			goto out;
 		idx++;
-- 
2.38.1

