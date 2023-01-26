Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F567C489
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjAZGqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZGqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:46:10 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA1A3CE01
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:46:05 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 56F062009D; Thu, 26 Jan 2023 14:45:59 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674715559;
        bh=ub51EFFMrlwNUAT6+NdU+EBcexy1Hu8Ktz0Ifsn1Sj8=;
        h=From:To:Cc:Subject:Date;
        b=as6xIS4CimUVY0KCiSsFTiosEYm012w6TrzmKV0NMCknPILbmy4HiAnAE63TkguKT
         z6UHAVCYMcR8ZaEZcqqFy2DzwoGMxdyC5iT8Fvr3JflFfyHtCp9k2RjUUsY21ciZ1R
         yW+I6C7MFi5vLGBRFDfv/PR4RcNQsSaWbLO/OSaFvU7sLq64eZke81SUJFroXiTOZV
         YxAfVGycfMCVEgshOUxwSVDEJh597F12d1+j/iniLCqAfKvJ/9KmJBI7mHRdK3MRvH
         UEQ65IOazJXxEoqtQWNGO0oE6X2V101JFWPi4DTurh1x7mfICoCHgJMM2pcrmpc2PF
         tFvFPb/h/beBw==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: mctp: purge receive queues on sk destruction
Date:   Thu, 26 Jan 2023 14:45:51 +0800
Message-Id: <20230126064551.464468-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may have pending skbs in the receive queue when the sk is being
destroyed; add a destructor to purge the queue.

MCTP doesn't use the error queue, so only the receive_queue is purged.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/af_mctp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 45bbe3e54cc2..3150f3f0c872 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -587,6 +587,11 @@ static void mctp_sk_unhash(struct sock *sk)
 	del_timer_sync(&msk->key_expiry);
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -623,6 +628,7 @@ static int mctp_pf_create(struct net *net, struct socket *sock,
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)
-- 
2.35.1

