Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E4363BE25
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiK2Klf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiK2Kl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:41:29 -0500
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 6FEE24EC3C;
        Tue, 29 Nov 2022 02:41:23 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltAAH+Ay44YVjAYkAAA--.821S5;
        Tue, 29 Nov 2022 18:41:21 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v3 3/4] bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
Date:   Tue, 29 Nov 2022 18:40:40 +0800
Message-Id: <1669718441-2654-4-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
References: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: SyJltAAH+Ay44YVjAYkAAA--.821S5
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4ftw4rGrW8Xr45CryDZFb_yoWfWwbE9r
        W0yF9xGry8WF1Ikr4Du3y5tFyIgrn2vFnagr1xJFW7t348AF1UArs5XFn3uFWkWFW2yFyq
        qrykXr1UZa42gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use apply_bytes on ingress redirect, when apply_bytes is less than
the length of msg data, some data may be skipped and lost in
bpf_tcp_ingress().
If there is still data in the scatterlist that has not been consumed,
we cannot move the msg iter.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index b3d9023..d99c3b7 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -45,8 +45,11 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 		tmp->sg.end = i;
 		if (apply) {
 			apply_bytes -= size;
-			if (!apply_bytes)
+			if (!apply_bytes) {
+				if (sge->length)
+					sk_msg_iter_var_prev(i);
 				break;
+			}
 		}
 	} while (i != msg->sg.end);
 
-- 
1.8.3.1

