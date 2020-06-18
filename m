Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF81FE826
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbgFRCqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgFRBKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C937F21927;
        Thu, 18 Jun 2020 01:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442634;
        bh=gQ+2o7PW7t3IXq8X3hPmf/IAe1h0el2iVacA1Qw7i/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqFPd0j8aOkawlakcLEhBUJqAcOj2a3Xhyv2gfE6ameoYTk3XKGAZgwpx1ZuV4+J5
         xEOxF4UjVIAcbt1b0yxdYSOx3WJYMAiRbbV7dOjoST+GGCgf4nxKnrE0hmfJ4RT2k7
         fSq7ZWTfkbxtcKjtJ7jl8bkNdBBv9DR/zJcQTAbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 111/388] bpf: tcp: Recv() should return 0 when the peer socket is closed
Date:   Wed, 17 Jun 2020 21:03:28 -0400
Message-Id: <20200618010805.600873-111-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 2c7269b231194aae23fb90ab65842573a91acbc9 ]

If the peer is closed, we will never get more data, so
tcp_bpf_wait_data will get stuck forever. In case we passed
MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
0.

>From man 2 recv:

    RETURN VALUE

    When a stream socket peer has performed an orderly shutdown, the
    return value will be 0 (the traditional "end-of-file" return).

This patch makes tcp_bpf_wait_data always return 1 when the peer
socket has been shutdown. Either we have data available, and it would
have returned 1 anyway, or there isn't, in which case we'll call
tcp_recvmsg which does the right thing in this situation.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 629aaa9a1eb9..9c5540887fbe 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -242,6 +242,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int ret = 0;
 
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
 	if (!timeo)
 		return ret;
 
-- 
2.25.1

