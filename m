Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4734FC4F4
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbiDKTVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiDKTVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FD21033
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2976152A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4C8C385AC;
        Mon, 11 Apr 2022 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649704762;
        bh=gg7eCm2uxvD2GpX6EUaq4mV1PG98I9wtZCeS8S+3s+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8M8rQ/dnMBbpP0svfZ3Mor4aWqi1E+APCmvC3sjNN99JPrqScePeSEYGHSWuGBNW
         vhrtW6rPXzKXclUbb9CIUpbZXGBqLmrxBGP45JG9829xbacMibPfI1YrigWJnfuj7b
         cBYwwpp+EghMoUuJW0nzfV3UC0O7WplrIx6l3YFJ6WtpGvpA50hGaAnb3EXq00IMTy
         MU3MXKslfRwxT3DC/SUuaucUblDnjcHJbij5/1HnAUPJCMDn64P4tV5MAZ7msqtzjT
         /KP4Y5ok3DWwUb2PjT5ncNS0A2worK4hfUcbzO8aVE89ONNf9uCdh+JhA55ceDdq/4
         rzALn8Jbpfxpw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/10] tls: rx: reuse leave_on_list label for psock
Date:   Mon, 11 Apr 2022 12:19:09 -0700
Message-Id: <20220411191917.1240155-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220411191917.1240155-1-kuba@kernel.org>
References: <20220411191917.1240155-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code is identical, we can save a few LoC.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e176549216ac..42ac605d48bb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1778,14 +1778,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
 			if (psock) {
-				int ret = sk_msg_recvmsg(sk, psock, msg, len,
-							 flags);
-
-				if (ret > 0) {
-					decrypted += ret;
-					len -= ret;
-					continue;
-				}
+				chunk = sk_msg_recvmsg(sk, psock, msg, len,
+						       flags);
+				if (chunk > 0)
+					goto leave_on_list;
 			}
 			goto recv_end;
 		}
-- 
2.34.1

