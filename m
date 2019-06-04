Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0735452
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfFDXcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfFDXWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4507020883;
        Tue,  4 Jun 2019 23:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690557;
        bh=UAHsNrpJc7Yn7ahETucphdSAVbNMT6ByiyOF5Uivq8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKI4TdL/Y7AY3ALwrVPJ/Mi+D9+CpZREDHOOLBw5Ojbbq1GHkE2p1Xy7+3AhlegaO
         6o6rrnm4I6Uys0MnBywaWR7yjRzaK1y+kRhjAGvA1NijIUQuNTk4VteJaSdmlC1VF6
         qTEFtU1R89wYczPzBrkXHz9pClVw0jk2VSCaAMQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 13/60] bpf: sockmap remove duplicate queue free
Date:   Tue,  4 Jun 2019 19:21:23 -0400
Message-Id: <20190604232212.6753-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit c42253cc88206fd0e9868c8b2fd7f9e79f9e0e03 ]

In tcp bpf remove we free the cork list and purge the ingress msg
list. However we do this before the ref count reaches zero so it
could be possible some other access is in progress. In this case
(tcp close and/or tcp_unhash) we happen to also hold the sock
lock so no path exists but lets fix it otherwise it is extremely
fragile and breaks the reference counting rules. Also we already
check the cork list and ingress msg queue and free them once the
ref count reaches zero so its wasteful to check twice.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1bb7321a256d..4a619c85daed 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -528,8 +528,6 @@ static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_link *link;
 
-	sk_psock_cork_free(psock);
-	__sk_psock_purge_ingress_msg(psock);
 	while ((link = sk_psock_link_pop(psock))) {
 		sk_psock_unlink(sk, link);
 		sk_psock_free_link(link);
-- 
2.20.1

