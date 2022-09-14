Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6205B83F6
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiINJF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiINJFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BC07645E;
        Wed, 14 Sep 2022 02:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B514B81710;
        Wed, 14 Sep 2022 09:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402BCC433D7;
        Wed, 14 Sep 2022 09:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146160;
        bh=NvezmI3d7W+8AX0mx7jHsMUs30zLiUmUclKmxS3In2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFIjt2dInjLvbvEQ6nK7NnXLRuw4o4uhS/s9WEISQSkGkfDuWJ6EDH3ffYWkRJFyl
         30IsQgb+aUCIiNC+46Z8Z6yR6+fyuFhNMKWXi1H4YOeyFE0bMmSTCN7dab8WPGUbNn
         tJrU6KB2f/ip0n9vE6oxXV7vsFmQX+XuS4YbcrFZGLPtVolcwqpKR3FwpDlK3q6f2N
         3S60OY32eugliyV7G2h4DkqzjSOOEALex5SEDsyrMbUfOdSJC2WWQ0NobKUOGBUfEk
         b71c/0eItmD7zNnJ6fPHJzk4gD8p47FXdgD0EWid23RPNUNcd0KXJyN6gO58pMJtc3
         AuNKXDRuCHfHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/16] rxrpc: Fix local destruction being repeated
Date:   Wed, 14 Sep 2022 05:02:13 -0400
Message-Id: <20220914090224.470913-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
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
index 6a1611b0e3037..5445c8e77785d 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -405,6 +405,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
-- 
2.35.1

