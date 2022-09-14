Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8082E5B844F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiINJJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiINJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:08:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AE779EC5;
        Wed, 14 Sep 2022 02:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB8A619C2;
        Wed, 14 Sep 2022 09:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1553CC433D7;
        Wed, 14 Sep 2022 09:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146258;
        bh=rsRPR9AfR8Vi+mgKsuG23j27Yn9SZDKSxqAR0fS3B4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7Nudv7+Xg8VrNqWxfiG6FSS55OeLSX1huoTZDMxaSPL2zZxfY/5bcIyQG2hEH1sb
         YXTwWtSOkf2ffmDlcBLGFWvfhp2CiihDJ8EAMJ4Kom3VyFwEFA2lmhkI5QqUOqyiAd
         WnG98cX4zvBv205gCk8FxBueXufGAZ815L30UOJwsSVyU7gdvvDz/pwi5UYy1HPySA
         4Clhshkflsl80XG9DvLpLLrFbH9FlCOKAx+up/hrS4poOmMrn1yvkW2P+TFL0sd0E7
         nyjHftU8f1hNh/aaAAO47K3qAchQxNITxVPKlU2tjBUxefQWRKZtA8RxYvt47Z+MHk
         e6Ogq03WfMbuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/12] rxrpc: Fix calc of resend age
Date:   Wed, 14 Sep 2022 05:03:57 -0400
Message-Id: <20220914090407.471328-4-sashal@kernel.org>
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

[ Upstream commit 214a9dc7d852216e83acac7b75bc18f01ce184c2 ]

Fix the calculation of the resend age to add a microsecond value as
microseconds, not nanoseconds.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 8574e7066d94c..b5f173960725b 100644
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

