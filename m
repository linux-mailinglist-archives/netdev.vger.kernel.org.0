Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8182C47B82E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhLUCFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhLUCEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:04:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B7AC08E83B;
        Mon, 20 Dec 2021 18:02:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B87B81117;
        Tue, 21 Dec 2021 02:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF572C36AE5;
        Tue, 21 Dec 2021 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052131;
        bh=z6ssjMNdAJA20GhGZfJcVIZfypJNkMorj3YboQtmCEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOU5anfNM0J5UDzCQ0eeNU8awyjQXjC5fbN7Q9Gm1i0n0IBsjurbTYY32L+G5JqpD
         iatfTh+daJnCVHjJLFfFzM913+IzDbaG162yrgQ9nbnMXx8RxROwtj4H/J6B+De8Tc
         xl4E4ven/EBOPdRw89lHbhyNfzVAtp/B1M62vzmocw+l3R5GyUE3Bh6sQTMbOysG3I
         pNd5O6yldZx+nE+2yqlLhP1Tv3BHXo89PXHvGvamnvCT9zwfhMa8w9fhCW53PzwiYu
         9QNzLhccuykbOkTSR4xOsSwwYhBblc25vCsOje3L2kxV/4sSZ3/M0KjSTHlj3eflxc
         6BAYyNzsEzRog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/4] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 21:02:05 -0500
Message-Id: <20211221020206.117771-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020206.117771-1-sashal@kernel.org>
References: <20211221020206.117771-1-sashal@kernel.org>
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
index f6aa532bcbf64..65883d1b9ec72 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -878,6 +878,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp)
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.34.1

