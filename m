Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C5164D535
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiLOCCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiLOCCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A63C54374
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D29B2B81AD5
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDF1C43398;
        Thu, 15 Dec 2022 02:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069727;
        bh=90fkK+9J8eA8u8r4Ukf0ozZ6A6LhZgjZb5IZjvOdQ48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8kEsxImzK88CJqi7D3qYNxPkTrwAGs3mbMdPSlgTbwN0S372xwjfpyf+Ysymmjkx
         7rdc+Wbg6J8QAHbJ57iLarpFH86b+ioGR2EH3YbkvHUBFQUBj5HT3TO/dsu4QTVb65
         JfEiPhB5qJi+4k3ZRc+YBEKfeHTylLO2Di264IAI02eW/k9AeLR56TUspggDoCPna6
         4J2sfS2UTAUNXhxfU7ABTd1LEEEoF2DQLGWaSz/+wMdoPRh+SRW4vBX8OjLY0zwu2V
         jBejNuTIsPSLsqrySkmIUEFtAPvH7Ukse/ugaDuPifaeOIkmH4Qo3Th7DiE52MBR9p
         IXWjUbAeeQYnQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 09/15] devlink: health: combine loops in dump
Date:   Wed, 14 Dec 2022 18:01:49 -0800
Message-Id: <20221215020155.1619839-10-kuba@kernel.org>
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

Walk devlink instances only once. Dump the instance reporters
and port reporters before moving to the next instance.
User space should not depend on ordering of messages.

This will make improving stability of the walk easier.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 9aac82dc7269..e3cfb64990b4 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -7940,10 +7940,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			idx++;
 		}
 		mutex_unlock(&devlink->reporters_lock);
-		devlink_put(devlink);
-	}
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
-- 
2.38.1

