Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6091E6A3D8F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 09:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjB0I4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 03:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjB0Izv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 03:55:51 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C8C24C9A
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 00:47:48 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id dm13-20020a05620a1d4d00b00742a22c4239so1797174qkb.1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 00:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gna1tUQYFW7zRTE4gcawgARSxL9rzP2DoPN5c6INbs0=;
        b=S8Tf6CjdX/Ad5uPyod0miF6R9QdMiEceIj7UiH/kzm0zFsbgBShEN2pJXo5ylJfazW
         ZIK+VJ+TCp0N8T4Yu6k0kiDcto65vKW7AsCVB4c5ZHxAKtm1REZk+i75yTOF62ot98Oo
         qQNKWaBymcptNGLG3YfqpRrut6D3YN/3dRiLW/TkwyDR39k7zNbJofbr73qVHnC3/Xhs
         Gs1QSfmskITaMa16XWCGgWE0k7cIsCEIjHA7sQd+DHT2ej1sS0teFrku9vbUpUGyTOOU
         TYMDEbpODCNpxLtRa9qCZb3gL6WBYCtl1yYe/62FVshg1xp0vNZphXF6s89DhmmsEV4U
         NN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gna1tUQYFW7zRTE4gcawgARSxL9rzP2DoPN5c6INbs0=;
        b=EwWZGf3LcZMjAiveEzNhuazP14LksS+D5ipgXa/+xmH8qazaY6dHIdrRHQxl9Lg6ei
         8NeVfzjPMC6+GV2av7PbhCS9W60rELSCeyxZeSobxbq97BBvrHWQgJyKd1RI7eeEixfC
         LNiNOuc4u0EoFk1nRKBDtUwHeC88wYBHDOAA5lSifjGQafh1nJ7Pjwm05m2+YyyOYDAO
         8pr0w/siW3sfN+b78jy52/YpvQX86SQkk52CeEEpsCTDD9FC4XUccPz7kKJDWmgPWy3X
         t5Prg4cgHY39O3jXR4MHmZYLu2z08PTdPGf+Nvp6G6QRS8FG0q72fc4u1lABgGo5XwxC
         AF+Q==
X-Gm-Message-State: AO0yUKXvY6S1TfsRqYVier0ETLmTSkAOXJicvWj9eoErSrFbLLXa1aBp
        PsJKLo+A0bXAZ65elU9J/oeZQd4TEMcAMA==
X-Google-Smtp-Source: AK7set9Xci0mFglDfsocvIwb0GH4RljlWRpoIESBYFHFCvpvuSDWcQUw5Xn7Ep3k8ghVzP2u0xCWcUznGmEllw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:cc:0:b0:966:1e3e:5259 with SMTP id
 d12-20020a5b00cc000000b009661e3e5259mr7002739ybp.4.1677486818974; Mon, 27 Feb
 2023 00:33:38 -0800 (PST)
Date:   Mon, 27 Feb 2023 08:33:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230227083336.4153089-1-edumazet@google.com>
Subject: [PATCH net] tcp: tcp_check_req() can be called from process context
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Frederick Lawler <fred@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of commit 0a375c822497 ("tcp: tcp_rtx_synack()
can be called from process context").

Frederick Lawler reported another "__this_cpu_add() in preemptible"
warning caused by the same reason.

In my former patch I took care of tcp_rtx_synack()
but forgot that tcp_check_req() also contained some SNMP updates.

Note that some parts of tcp_check_req() always run in BH context,
I added a comment to clarify this.

Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
Link: https://lore.kernel.org/netdev/8cd33923-a21d-397c-e46b-2a068c287b03@cloudflare.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Frederick Lawler <fred@cloudflare.com>
Tested-by: Frederick Lawler <fred@cloudflare.com>
---
 net/ipv4/tcp_minisocks.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index e002f2e1d4f2de0397f2cc7ec0a14a05efbd802b..9a7ef7732c24c94d4a01d5911ebe51f21371a457 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -597,6 +597,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -748,7 +751,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -767,7 +770,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
-- 
2.39.2.637.g21b0678d19-goog

