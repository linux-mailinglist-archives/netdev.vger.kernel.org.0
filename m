Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571665B841E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiINJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiINJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3715A76749;
        Wed, 14 Sep 2022 02:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8AC2B8170C;
        Wed, 14 Sep 2022 09:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F8BC43141;
        Wed, 14 Sep 2022 09:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146211;
        bh=wWLBRCoyI+A/DImeDDnxC1KCwDlW7lSe99pqruGvWlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd7sZkg0kRIiCakCsXdqYLY+IkyLX3iaAKP8hh3ScqoXc91pLHpwpZP+92DzH7HDL
         JL5LhScAtsmFa7OUFVS1K+XHkS1TOMz9Pxu5tPeqwHcbd6TYorB/arq93juSpnTRLy
         j6C462GuNIfGmbWvvEk+J4eEEl6c+qOkP9B0oIXPyXPRre/nrtgnsdHKtIlYCz7qOr
         MbKTt2gF3hnz7Qqa5Ge1+Gvu2/fzUs3jTCv3Bqa08ce9vr3+NHH+UJM8bjphQP797q
         f9u1Jz3gnW/FyB23oWGlG28T/KfUibj015kwKHC3C6x6HFRsEVTLzAdR356WWIdTrR
         dMlNQbUjE8oIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/13] rxrpc: Fix calc of resend age
Date:   Wed, 14 Sep 2022 05:03:06 -0400
Message-Id: <20220914090317.471116-4-sashal@kernel.org>
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

[ Upstream commit 214a9dc7d852216e83acac7b75bc18f01ce184c2 ]

Fix the calculation of the resend age to add a microsecond value as
microseconds, not nanoseconds.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index f8ecad2b730e8..2a93e7b5fbd05 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -166,7 +166,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
+	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
-- 
2.35.1

