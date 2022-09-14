Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484335B841F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiINJHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiINJGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3566674DCC;
        Wed, 14 Sep 2022 02:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA8AD619E1;
        Wed, 14 Sep 2022 09:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99354C433C1;
        Wed, 14 Sep 2022 09:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146208;
        bh=0huOiptbVUn3jO0PL3RIEjElL0VLQUE1lKtQ04GdUhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfWZsLFocfTW+paaBSiQevrIjK51dTfRcjwWHVvvSq4ARopwUwLQrR5BQqscwsCOJ
         TNqpjSSrA53CcSxdCXXPP38soe3g/NyVn0Qmpsw8X7PkinavWnnnX1PfaZWYItTrFb
         iQy4nZ+FjUrDFmGLNpPl3LIWPckkHYN9v6P45FjGdbTbi0WzZeDpH64fGjYVq8QllE
         f5UOhRV6b2tVAMJXmHhFeK4286JFp+YsuNgr4bmxEB7+SE70QIhz2MwfVBtvKVGUXe
         5bIu8A0s1rL1xNcEqpjKeXcls1vP5a5R9K0MYueAghc5aBUR2y7tKk/df57sVwoPMA
         flkWcWsDQpUBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/13] rxrpc: Fix local destruction being repeated
Date:   Wed, 14 Sep 2022 05:03:05 -0400
Message-Id: <20220914090317.471116-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090317.471116-1-sashal@kernel.org>
References: <20220914090317.471116-1-sashal@kernel.org>
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
index 8c2881054266d..ebbf1b03b62cf 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -424,6 +424,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
-- 
2.35.1

