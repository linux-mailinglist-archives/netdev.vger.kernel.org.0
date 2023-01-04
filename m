Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7233165CC51
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbjADERT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbjADEQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AD7167F8
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E792CE13CE
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB09C433F1;
        Wed,  4 Jan 2023 04:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805808;
        bh=sj3VgfSW0G6NtpI1jJaM2AZ7ovOoaknLMLuEXmNCU1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYXRSoK8frTWPVn8Yr4EhxssmRILSutd5mxzRWoqTGVrF5xV9k/SWKBsxEeeVQ0Ik
         XSe1uwzKSuIh9+SiXnZGt00UmiiURHDthqncJ8wAQPd939XrSh2lp3ez8cUb3Thr3O
         R3WNs1aHokN59nFPMI6/YLFTO87N2s3pJ6JURXYzmTLNyElVFPhfkD/LtzzGn+TZX6
         GLb6AMkSvvGmlal7mkZ5lOFnLYAv2oR7hNowMKC9Hj7sTcfUNhO0ugl8nNUcbtef/7
         IEkdMtbp9ztWGHg/A83mPIsXHz3wazsdEWAzmcwHSAERMHKGjp58qyqg8GoKG3F4ho
         983Ag75T8YE8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/14] devlink: health: combine loops in dump
Date:   Tue,  3 Jan 2023 20:16:30 -0800
Message-Id: <20230104041636.226398-9-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 9aac82dc7269..e3cfb64990b4 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
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

