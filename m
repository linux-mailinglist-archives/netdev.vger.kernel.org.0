Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1076835438
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFDXWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfFDXWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B8520859;
        Tue,  4 Jun 2019 23:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690558;
        bh=mIl1qkLw6ixFkw961ZXi8NjSN8yh49bdoYo0oKYcreE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=og9rgRypUkY8bkK+WmJpvzoZqJa4It4V+Z2MD1UxPMvhds255BdAkFTzD1PomUgIG
         M/hS7+aMkkVFM1W13sLNv7t8FIpAe73ADPnRMDNdMTsiG8WcXGd6DvQrgF+Cj6B2zx
         BHlf2QQCVYi2rP+xVK3Z6kTeI4vE1JGVJXTLbZpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 14/60] bpf: sockmap fix msg->sg.size account on ingress skb
Date:   Tue,  4 Jun 2019 19:21:24 -0400
Message-Id: <20190604232212.6753-14-sashal@kernel.org>
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

[ Upstream commit cabede8b4f2b746232aa25730a0b752de1cb82ca ]

When converting a skb to msg->sg we forget to set the size after the
latest ktls/tls code conversion. This patch can be reached by doing
a redir into ingress path from BPF skb sock recv hook. Then trying to
read the size fails.

Fix this by setting the size.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 49d1efa329d7..93bffaad2135 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -411,6 +411,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	sk_mem_charge(sk, skb->len);
 	copied = skb->len;
 	msg->sg.start = 0;
+	msg->sg.size = copied;
 	msg->sg.end = num_sge == MAX_MSG_FRAGS ? 0 : num_sge;
 	msg->skb = skb;
 
-- 
2.20.1

