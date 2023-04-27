Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642A26F06D5
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbjD0Npj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243389AbjD0Nph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C9F2709
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E5561444
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D126C433D2;
        Thu, 27 Apr 2023 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682603133;
        bh=D8Vhv+XsJTd04zdSnRJn/vpNhr6R8F+gq2dhD0U+Z+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYUizYkGivNa1Wujjmt2wbMrLA0KuUndiJVFHyUJFC+v2YVYa34h2Ar0oAFwWvXIb
         Qy+ZUiJnOhAcPA0KbOQwtJfxghC96Qhvecp+TJbAQp3HiJ7Pexv73zgBv76zLq58G+
         n8A22lmqxcuFp/YxuPFtooADcitVmVzLMolh16FaHpIm4VmpDQN8FOdxfJ26zlxaWF
         2mya5JuOu+Un5X1bkve0oKVFpswT1F8kC6ZfKitRV1KtQGpGlet/SQUVKa+QGWtdox
         is2uhfBEPuLAVpOrjm32G4pgtLkYjlrFWOAP6TAkbs2J63ODouZ3QrpGrpxH+X1uu1
         IkJ4WCRc/7v3Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
Date:   Thu, 27 Apr 2023 15:45:24 +0200
Message-Id: <20230427134527.18127-2-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427134527.18127-1-atenart@kernel.org>
References: <20230427134527.18127-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c67b85558ff2 ("ipv6: tcp: send consistent autoflowlabel in
TIME_WAIT state") made the socket txhash also available in TIME_WAIT
sockets but for IPv6 only. Make it available for IPv4 too as we'll use
it in later commits.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index dac0d62120e6..04fc328727e6 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -303,6 +303,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		tcptw->tw_ts_offset	= tp->tsoffset;
 		tcptw->tw_last_oow_ack_time = 0;
 		tcptw->tw_tx_delay	= tp->tcp_tx_delay;
+		tw->tw_txhash		= sk->sk_txhash;
 #if IS_ENABLED(CONFIG_IPV6)
 		if (tw->tw_family == PF_INET6) {
 			struct ipv6_pinfo *np = inet6_sk(sk);
@@ -311,7 +312,6 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tw->tw_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
 			tw->tw_tclass = np->tclass;
 			tw->tw_flowlabel = be32_to_cpu(np->flow_label & IPV6_FLOWLABEL_MASK);
-			tw->tw_txhash = sk->sk_txhash;
 			tw->tw_ipv6only = sk->sk_ipv6only;
 		}
 #endif
-- 
2.40.0

