Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3B71FE5F5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgFRC3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbgFRBQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 112C12088E;
        Thu, 18 Jun 2020 01:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442961;
        bh=kE4r/DncWHkvPGYKD8JFmPlP3Dy3jow243D+vlxfFl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTTbtMmVfHW6AZE1kOfTycl3cXcd/upOqFbR+5RpAkqnCw7xzI47h5gh9on4Rk9Dd
         PiPpzNY1BSDlt/Xma4KFUJQZOHOc8H37fb7NK5/t64N4zlWgSMmgC29tZr2x1GRcAA
         M8fGBACy8jSGmS6V1U+OduEKHLEIqQcbkjB5OBhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     dihu <anny.hu@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 367/388] bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg
Date:   Wed, 17 Jun 2020 21:07:44 -0400
Message-Id: <20200618010805.600873-367-sashal@kernel.org>
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

From: dihu <anny.hu@linux.alibaba.com>

[ Upstream commit 487082fb7bd2a32b66927d2b22e3a81b072b44f0 ]

When user application calls read() with MSG_PEEK flag to read data
of bpf sockmap socket, kernel panic happens at
__tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
queue after read out under MSG_PEEK flag is set. Because it's not
judged whether sk_msg is the last msg of ingress_msg queue, the next
sk_msg may be the head of ingress_msg queue, whose memory address of
sg page is invalid. So it's necessary to add check codes to prevent
this problem.

[20759.125457] BUG: kernel NULL pointer dereference, address:
0000000000000008
[20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
5.4.32 #1
[20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
4.1.12 06/18/2017
[20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
[20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
[20759.276099] tcp_bpf_recvmsg+0x113/0x370
[20759.281137] inet_recvmsg+0x55/0xc0
[20759.285734] __sys_recvfrom+0xc8/0x130
[20759.290566] ? __audit_syscall_entry+0x103/0x130
[20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
[20759.301700] ? __audit_syscall_exit+0x1e4/0x290
[20759.307235] __x64_sys_recvfrom+0x24/0x30
[20759.312226] do_syscall_64+0x55/0x1b0
[20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: dihu <anny.hu@linux.alibaba.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200605084625.9783-1-anny.hu@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9c5540887fbe..7aa68f4aae6c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		} while (i != msg_rx->sg.end);
 
 		if (unlikely(peek)) {
+			if (msg_rx == list_last_entry(&psock->ingress_msg,
+						      struct sk_msg, list))
+				break;
 			msg_rx = list_next_entry(msg_rx, list);
 			continue;
 		}
-- 
2.25.1

