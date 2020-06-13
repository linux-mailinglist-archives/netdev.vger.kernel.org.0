Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959D51F8340
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgFMMkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 08:40:02 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:48450 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgFMMkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 08:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=orDLlwUq6Gl4ZFuFaDVaEW2IqJ0LD91Me5OLf+FAEC8=; b=r
        SW77YMq1loIYxFCKZrwu7yfjfPaheZB55hkoXsNqd9NXG7VT/zSdtiVPyU7YivR6
        hzhO20HHLN6L8bBMctIQKjA32e7BskSN+SSsSl3GEWI0tJ9H0ZZjPM8OJrZw/hcp
        wAkpYDMolQPmfPs/R1PNe8Qhs99IZVVSZCfJ7EnUdQ=
Received: from localhost.localdomain (unknown [120.229.255.202])
        by app1 (Coremail) with SMTP id XAUFCgDn7zMWyeReX8EYAA--.20920S3;
        Sat, 13 Jun 2020 20:39:52 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] sctp: Fix sk_buff leak when receiving a datagram
Date:   Sat, 13 Jun 2020 20:39:25 +0800
Message-Id: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgDn7zMWyeReX8EYAA--.20920S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr43KF1fXrWxJw43Xr4xJFb_yoWDZFg_Ja
        97CF1xX39ruFsa9aySkrs8AFZakanFqrWIgrsrK39rG345KF9rtrZ8KFZ3CryxWrWxZry5
        JFn5Krnxu39xZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
        6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
        x2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqXdUUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sctp_skb_recv_datagram(), the function fetch a sk_buff object from
the receiving queue to "skb" by calling skb_peek() or __skb_dequeue()
and return its reference to the caller.

However, when calling __skb_dequeue() successfully, the function forgets
to hold a reference count of the "skb" object and directly return it,
causing a potential memory leak in the caller function.

Fix this issue by calling refcount_inc after __skb_dequeue()
successfully executed.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sctp/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d57e1a002ffc..4c8f0b83efd0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8990,6 +8990,8 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
 				refcount_inc(&skb->users);
 		} else {
 			skb = __skb_dequeue(&sk->sk_receive_queue);
+			if (skb)
+				refcount_inc(&skb->users);
 		}
 
 		if (skb)
-- 
2.7.4

