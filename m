Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626D047B717
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhLUB6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53084 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbhLUB6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5D9661348;
        Tue, 21 Dec 2021 01:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FE7C36AE8;
        Tue, 21 Dec 2021 01:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051886;
        bh=tJH4H5zTzNrqnjrO2Tw50hPNLhCg4XrsktNjPT8WKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLRHLU8M76niNd+4VTu5f2DjZLRclQMkKyRendqEyzAiWS29Eubwd+DvjEdOv3llH
         OPqQCj462Xj8gC+ScqXxm5NT0xhqM59Y0Iff0mods3TTPAeUbV3mM0WaMKeGqUs71Z
         o5ZVW/j+boPmSoxeQ6TEABiJe2lKQA9N1+tVTgSirVMOQMfOHi9a2ilKZDH7wBb8iM
         VLxb2fz7lIKWPRnt5lThBOxxmGc4bWfIQpc9kNNI8xojuH5JEzi5nYSiR6aekc3yZr
         UTvRM3FKUoZxdA4+CdbUILWk70QjvtvJflNjc4SVPz9gIVjS7oKrz+6pGaRLTU31v/
         bqZiAGoxJlvRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/29] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 20:57:30 -0500
Message-Id: <20211221015751.116328-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
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

