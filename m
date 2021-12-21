Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3D47B780
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhLUCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhLUB7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D2BC061D7E;
        Mon, 20 Dec 2021 17:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5394CB81109;
        Tue, 21 Dec 2021 01:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBA3C36AE5;
        Tue, 21 Dec 2021 01:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051966;
        bh=tJH4H5zTzNrqnjrO2Tw50hPNLhCg4XrsktNjPT8WKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAGRW2yzjWWU0Q5yinxTAZwMyaDJ1YYU/FdDj3h+U2XM7yRspuM5IBFgFbDQyA6/q
         CYKxtqHxIwrBOJdVxi4wHn+V/PXyDVNjWTdaviDFhk5uO9wxv+uAQ5FV2zIjw/y915
         SqeaJIqvuChzRfFjn44lz5BQo4m6ZCqwEOE0doUD+KBjSJ1kNFEJ7qfp/HFN6njVp8
         MdYhChHeDAfvmf9hUKrahjdmrm9QCZ+dgZUfgSfiS4XMV45appB9BoLY2qOx+yerCJ
         QOalk12HfnPSjTzmWZixkFeLjHMWGxMQ7gvUUNXTZNmmgtqkz9cLG8ApTJJzg6HOn0
         tD5JORgE5mVUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/19] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 20:59:02 -0500
Message-Id: <20211221015914.116767-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
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
index a1525916885ae..b4f90afb0638b 100644
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

