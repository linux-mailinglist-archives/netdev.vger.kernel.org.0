Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0D47B807
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhLUCDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhLUCCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36EC061374;
        Mon, 20 Dec 2021 18:01:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D15B8110F;
        Tue, 21 Dec 2021 02:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C618C36AE9;
        Tue, 21 Dec 2021 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052072;
        bh=xVglEMQGAP8jvcmpc+qCPJEsRebh0igtaqbt3OwJFQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDHmdig7VksqfX9+tUb6WcycG1o3rOxQzWCe+JGV4ZGcSMqmz59UUwy+s9YGQfwhy
         NUVVdL3qxAoOSQM6WqqigatPVFNfeOMKB0/QirWGc/1JohX2PJbdYy1iuezmVmztAB
         tJcZXQcrtkob296pgFJrqSTPxNqhJBdc3kG8JmH4xFQ6xoxO1l+3p23Gbo5vvB+hGh
         TgmqlIMmOFs+h2bUwZtuFmzONqxWXHnsOR/5K+IT/1lj5fcasI6F2ak4gonHhJnBfU
         ZiMXCYmDGMgn3oeHX4wiR1eOJqMfKqmXiXBtud2K2BYcFTolvVXlXKw3Zm9Ya+5bOj
         U4b5YZhRZzFPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/11] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 21:00:23 -0500
Message-Id: <20211221020030.117225-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
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
index db34735403035..63d34e702df52 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -881,6 +881,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.34.1

