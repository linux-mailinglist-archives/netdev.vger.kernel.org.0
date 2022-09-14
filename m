Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723815B83A3
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiINJCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiINJBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CCD1F2F2;
        Wed, 14 Sep 2022 02:01:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA9E6198B;
        Wed, 14 Sep 2022 09:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB4BC433D7;
        Wed, 14 Sep 2022 09:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146093;
        bh=y8jWLfysQsf6BXCmjPZ/j5UlOD1U/85VlQyScpueEhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAMEHiWus5Rzm59gYI0BHhFIdX6TvI2NSMmrwwaqp7taF9gcuORnBUPV6JrWqiKF2
         Rac59k7HHhdlg4c3BOOn6WzW5+0NwLNd8is1rMILmHQ6tBEUwOqjMBnx9VUhuWhToT
         U8K8jFD8mYwIpnSj26uxUxsI38VjYJe0/2X3FDJBNzN2tHAoovzEOydE/dYseago+D
         qgwuWi04vQu67vicySKgBGLnASbtYLuDQBvq7mg4LdPsmdNuEG1/UP3j8plIZeLV88
         0jYVfyKqZCILgtCjkumNFQx7jzdzMEOmInyn14lx9vxXG9QAtirY6CxsmX44Zndu2Y
         1GALsRQfUsndA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 08/22] rxrpc: Fix local destruction being repeated
Date:   Wed, 14 Sep 2022 05:00:49 -0400
Message-Id: <20220914090103.470630-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit d3d863036d688313f8d566b87acd7d99daf82749 ]

If the local processor work item for the rxrpc local endpoint gets requeued
by an event (such as an incoming packet) between it getting scheduled for
destruction and the UDP socket being closed, the rxrpc_local_destroyer()
function can get run twice.  The second time it can hang because it can end
up waiting for cleanup events that will never happen.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/local_object.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 96ecb7356c0fe..790c270c06785 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -405,6 +405,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  refcount_read(&local->ref), NULL);
 
-- 
2.35.1

