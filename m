Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62E1B86B7
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 15:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgDYNLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 09:11:10 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:40661 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbgDYNLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 09:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=AKrwUNLoUnBI4lZ8DNjrGFoqJNkvYPc2pAwVusxmZ1M=; b=3
        gwSc1PhnToVPHfPDkubDu9iFk2+7F9AVr4Yd/4NkmI4szxf0fioKGRBj3NTWYWci
        GM+k3C14ZCq6OuCy2wEtf1FHJOsBZK3bewRNFEeOtVbi/BATkNaGbneCWoaLsB5R
        1yayvqsl4B99lr65GXzsyB8iTsHhyjP3GfUe8W1xM8=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app2 (Coremail) with SMTP id XQUFCgBnF+DWNqReqbCpAA--.22753S3;
        Sat, 25 Apr 2020 21:10:47 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net/tls: Fix sk_psock refcnt leak when in tls_data_ready()
Date:   Sat, 25 Apr 2020 21:10:23 +0800
Message-Id: <1587820223-40918-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgBnF+DWNqReqbCpAA--.22753S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyktF48AryUZrWruFW8Crg_yoW8JFW3pw
        4vk3y8Ca4YyFy8Z395AF18JF18Wan5XFyIkFW8C3WxZrnxWw4rA345KF17ZF1jyr4kZFZY
        vr4j9F4FvFsxGaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW5GwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUjppB7UUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_data_ready() invokes sk_psock_get(), which returns a reference of
the specified sk_psock object to "psock" with increased refcnt.

When tls_data_ready() returns, local variable "psock" becomes invalid,
so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
tls_data_ready(). When "psock->ingress_msg" is empty but "psock" is not
NULL, the function forgets to decrease the refcnt increased by
sk_psock_get(), causing a refcnt leak.

Fix this issue by calling sk_psock_put() on all paths when "psock" is
not NULL.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/tls/tls_sw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c98e602a1a2d..4eef5617e033 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2081,8 +2081,9 @@ static void tls_data_ready(struct sock *sk)
 	strp_data_ready(&ctx->strp);
 
 	psock = sk_psock_get(sk);
-	if (psock && !list_empty(&psock->ingress_msg)) {
-		ctx->saved_data_ready(sk);
+	if (psock) {
+		if (!list_empty(&psock->ingress_msg))
+			ctx->saved_data_ready(sk);
 		sk_psock_put(sk, psock);
 	}
 }
-- 
2.7.4

