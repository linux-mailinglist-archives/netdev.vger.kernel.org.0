Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD80F5B844B
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiINJJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiINJIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A7679A74;
        Wed, 14 Sep 2022 02:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF46619A0;
        Wed, 14 Sep 2022 09:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55140C433D6;
        Wed, 14 Sep 2022 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146256;
        bh=TiY34QjLj2xNodH4Rrpadv/SaL+Rtg2gcM00I70tAPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJO35S4a7qNE8yi5VpyxErE21AAaiM57P1mqzV6MJXHEQPGb8s0TVhaFrfJlz8vPo
         q6i5IIzkN1fCvWvG5MRYOVX+326wbdgwtsrkZO83K/4Zkn8Ygw925umah1m98HpWlw
         AVBy4RqoEWr+WR1FmOXR/DU/3DsamUNuY+8qbJW9y9jFaF0shYewo377hgPvVPXZ5g
         jD9HaPY2vHa7ddBKL5MuP9Y3ZkJNcTNJolNKJhIu+UcIzdce5+G+9/xcPpaNqpEYKK
         MhSER1z1Iom3rk8h3NVRDWbFc1Wk8YgSp92CWCBLzG4A0X8lxgnh8eKXzTLqiU9kEs
         9X1IUwlxLWf7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/12] rxrpc: Fix local destruction being repeated
Date:   Wed, 14 Sep 2022 05:03:56 -0400
Message-Id: <20220914090407.471328-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090407.471328-1-sashal@kernel.org>
References: <20220914090407.471328-1-sashal@kernel.org>
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
index 01135e54d95d2..fc784fcc3a947 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -448,6 +448,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
-- 
2.35.1

