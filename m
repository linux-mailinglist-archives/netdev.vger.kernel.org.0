Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB9260CDA5
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiJYNgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiJYNgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:36:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D934718A038;
        Tue, 25 Oct 2022 06:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=uXjEVyiJz1NN6rY5kzCX1caYcoY8Gfm0LKkyWDK0U+M=; b=PYdgyx1AlotXNX1znmEsf4VWTm
        HMr/ssTvFvn/oXGVwfAjpEu13Rb9Hon/t5VCSKAukEuP+c9CG9TgjyPeGgY5lt40sGhGeZjaSqkML
        bGuk1Hms6KKulaz0jzFFeOVRxxYHDvyqDvz3lpLvSCvMmJmgbvZB3K/K8wy5z3uYvU7KsZlB4lRkh
        MBM5mUyL9OaD2m5TcgaOOf5+/beQ+2xPuiL4O+D9/6FkCbLAeKaAj9FqIWYr66sIsM/kfhF1dUoOs
        8/2TJQkzn/PWBmf9vur13TlYWEHhTL/1yOSU5Js8miY3G6nYEAgftI6aWZesCP+FEttEtyUL4LX6t
        KghQ+fwx17RJchpnLFYAWeabxauET4wmLVaPfRFFa2VWsmHhc2xgkZWKJ1oE0l2daikr1ufTMZ8wb
        up3aiNXG8mKJ0CDXOwx+cd2eg1RwYISDv8BuZojMIsAfBSeL5bC/OBMOBkGzXSiIbLZcu91/7bthn
        foNOeHTrtrLlvbHraZwj8egM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1onK6i-005jmK-3S; Tue, 25 Oct 2022 13:36:40 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] net: also flag accepted sockets supporting msghdr originated zerocopy
Date:   Tue, 25 Oct 2022 15:36:23 +0200
Message-Id: <8c1ce5e77d3ec52c94d8bd1269ea1bb900c42019.1666704904.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1666704904.git.metze@samba.org>
References: <cover.1666704904.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this only the client initiated tcp sockets have SOCK_SUPPORT_ZC.
The listening socket on the server also has it, but the accepted
connections didn't, which meant IORING_OP_SEND[MSG]_ZC will always
fails with -EOPNOTSUPP.

Fixes: e993ffe3da4b ("net: flag sockets supporting msghdr originated zerocopy")
Cc: <stable@vger.kernel.org> # 6.0
CC: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/io-uring/20221024141503.22b4e251@kernel.org/T/#m38aa19b0b825758fb97860a38ad13122051f9dda
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 net/ipv4/af_inet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3dd02396517d..4728087c42a5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -754,6 +754,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
 		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
 
+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
 	sock_graft(sk2, newsock);
 
 	newsock->state = SS_CONNECTED;
-- 
2.34.1

