Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853B647B7BF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhLUCBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhLUCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B3FC06175F;
        Mon, 20 Dec 2021 18:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B483CB8110A;
        Tue, 21 Dec 2021 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC29C36AEC;
        Tue, 21 Dec 2021 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052019;
        bh=wO11K8U6S8IMK7fJrrFtgjzJSAm1SKSTfFpJX0APCqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXBQ1Hr7pAEortOOzgDBcQZldzmzD27zV/APADD6/82zSpl34k1WUQ+G82Hqa/Pd2
         S6gYUPEcAdoQJ+1V0Og+lSNssldtPHdHM4TUtIkJ7R3rh/o8McO282/Qz8JcLmMGM4
         b9a64kRwKrTsketOLaNjwEKNy82dEyq51kh4MFIQEszCi85XpLzPOJ+0TsKtjLZbCc
         sMzrulyMO4LvX1SYzUiQKZ4eXmio8SAhU1iocdMEg2nUSMEh2FrfJ1zuAoZAQQd4sH
         rDb3/ZgIuDfjKOt/ha/UY71X2HB9FaTo4EmuCUpd4ZRCHOkosujIM7NAfiTd7bLK+G
         adAiezndQq5OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/14] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 20:59:45 -0500
Message-Id: <20211221015952.117052-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit bcd0f93353326954817a4f9fa55ec57fb38acbb0 ]

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 4577e43cb7778..ea3b480ce20d9 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -868,6 +868,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.34.1

