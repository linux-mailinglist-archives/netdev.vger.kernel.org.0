Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C221D521FB3
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346476AbiEJPw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346367AbiEJPu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BB828ABAA;
        Tue, 10 May 2022 08:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80706614AF;
        Tue, 10 May 2022 15:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B63C385CB;
        Tue, 10 May 2022 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197508;
        bh=2OX837V48LPWy+fohNmbgAQwoavPUJVKqMpgPMB4Acg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePpNm/iiAm5IsIQnmP9iykSNAPrmCbCsv6rmrFRooSwffD3bIjErVEsfaoh3V9YIT
         HdX7XNWBxL/cupuzxBcbMJWxs+pvyyfpSl9G31a1ce0500JgUW1+ofS6EQpmGWMAH8
         71kRmGIl5yQDgVdsyL4kBdkymux1hGgc1SWphZApXxqTMIuzcqgPV7lpsXgWmc8+np
         edQi7QMVINLZsb8imsPY4Mr/NW7GBwmQ4007z5tgQRudT4c8GwQFtYBI2J9WRIKEK8
         FAhil2PhKbe+2iR8JdHveZOX3d4XsKXC+Zi8bxlZjf//HI1TyQiXgfkeVOj1p3YmKW
         xYY4pIDtJpoJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/19] tcp: drop the hash_32() part from the index calculation
Date:   Tue, 10 May 2022 11:44:28 -0400
Message-Id: <20220510154429.153677-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154429.153677-1-sashal@kernel.org>
References: <20220510154429.153677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit e8161345ddbb66e449abde10d2fdce93f867eba9 ]

In commit 190cc82489f4 ("tcp: change source port randomizarion at
connect() time"), the table_perturb[] array was introduced and an
index was taken from the port_offset via hash_32(). But it turns
out that hash_32() performs a multiplication while the input here
comes from the output of SipHash in secure_seq, that is well
distributed enough to avoid the need for yet another hash.

Suggested-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index f76e4ac1ba3a..ee9c587031b4 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -778,7 +778,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	net_get_random_once(table_perturb,
 			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
-	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
-- 
2.35.1

