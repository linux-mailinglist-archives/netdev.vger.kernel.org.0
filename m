Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A879377
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfG2S4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:56:25 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:60961 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727622AbfG2S4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:56:25 -0400
Received: from orion.localdomain ([77.4.29.213]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mi2BV-1iMqmk0KkT-00e1bO; Mon, 29 Jul 2019 20:55:27 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Date:   Mon, 29 Jul 2019 20:55:21 +0200
Message-Id: <1564426521-22525-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:i9VAZizxx+eH8r0jwuYwZQDbCo18h5YiuaRZbO0+UbEQvlijxZa
 4TveSmdAeApi9mrr/px0U9CQPkq3sLPwuV2Rb1xKRWxqo2AdQno8XpFbBoc6hMoYT6dSUsn
 OWIGdKV5RpVjVTathxOV2wmrAjZZAJ1xBL4NyAqv7NeK7fPnrx8RrfYwDAWJKb7r2TjEiCq
 JOQAYvEkfylVdH2zi9oNQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0j1dMNDXM08=:FybE/YAxvCSouvkrzuAsmd
 k1GAFLXyDu5cQv0anbTKgEchzCv2F0aj9ayLyVpjzWNGEpveANpicYw+G9TmLyQiTo1mUZQ+3
 L8l6wNaw992W3j1ZQI9bOwliX4Gi8l0PlCatTfmeh4eikkBjBLnasWCuqlXpBUkxN4FAV4Fc1
 NvAa+9qqBSlH4k9BbaDDODabvW8z9WW4EJ7gBIlPqOUc3x8d3eTBokXAKoMXpF8/kkGCIOQBC
 BbBLT2WL4QKpBK6zpCOIBJaxOAN0RAnHsU4kXuiR3DUSKSMyOCGE5riZ+YgA125tWMYb20kdh
 izhPh+Db3ixIHZumSDpCOv4achqWesxNNxkXXjhRVCg3OtoiIo8IKywy0jGpun5/vt4Vz8or6
 oXjHW37IK/WtQsthbiMwlQPdnyBt/D/+FaU8J4YnyFiTB7ITg3XKRtaocQi4ngkoooFpxK3Sq
 ASv+DivmloXQLgwptXEmdNZNhLOm4p+LRPrgaTE7eAqGvygir2NUyXzmR9eNDoEj9Yg0EQjjr
 B4PUKlRPou3IQCp9zC0BZtnOULbM0ovS3mGAjOXqFY9Gg/AEDc07cMcEyRjh+wT57vvn1AQHD
 Xe7tVEAeSNBvWykttSwAaq4f9Pdap7wO1mz+Wi3rMgTgvp9wFnAQQdfodYjWlnhFdAVtKRQo+
 vEt9fSwdnaQUlmkjhZ/9nmt2iVvDptA6R/wNOT7L91WsYhyw2L6n2HLm/fg73gx766L16vpcR
 E1E0OPiQBfbsgchSBjaeQVfwbCxoVW0cvOi9Bg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..9d1f83b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Walk through the addrs buffer and count the number of addresses. */
@@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Allow security module to validate connectx addresses. */
-- 
1.9.1

