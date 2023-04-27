Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507976F034D
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243273AbjD0JWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243169AbjD0JWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEC0E5
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2B763BBC
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C726C433D2;
        Thu, 27 Apr 2023 09:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682587322;
        bh=Hc+prgqyI6U8bh6ADnvx72jWuMRELapBY2kvEdJN3HI=;
        h=From:To:Cc:Subject:Date:From;
        b=mdXT4uO7QT6UXMXw0DjjOP5X1nwMmYLNbpavPkFOuPHkEHa4X6ma1DVxMPJJo22hR
         6EzKccmvGSh7x+ASsYqFULCMLYtffYEc8Zi+DRgITtwNsoxfRk8mCeb+DZa+TJYutH
         nY2Hxl3uiJU8nYTSXtsVH72ns1n8jq13I0LEaxQ6TT7Cgcb2/owkokfsd3FrnKG8oA
         IlJzyY1cyoK/7H/n2a+rQrYCLKeXJwsgJmQy9s6z4EwW8s5EylBWzr290kKn241Az9
         4ugxv2uxokhVfx6mSQwBLWfHL3WAn3lidYDAFlo4j1NRR8TN42Yjz7ciUx12cW1eL/
         94sQCf0T1u1xg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net] net: ipv6: fix skb hash for some RST packets
Date:   Thu, 27 Apr 2023 11:21:59 +0200
Message-Id: <20230427092159.44998-1-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb hash comes from sk->sk_txhash when using TCP, except for some
IPv6 RST packets. This is because in tcp_v6_send_reset when not in
TIME_WAIT the hash is taken from sk->sk_hash, while it should come from
sk->sk_txhash as those two hashes are not computed the same way.

Packetdrill script to test the above,

   0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
  +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
  +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)

  +0 > (flowlabel 0x1) S 0:0(0) <...>

  // Wrong ack seq, trigger a rst.
  +0 < S. 0:0(0) ack 0 win 4000

  // Check the flowlabel matches prior one from SYN.
  +0 > (flowlabel 0x1) R 0:0(0) <...>

Fixes: 9258b8b1be2e ("ipv6: tcp: send consistent autoflowlabel in RST packets")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1bf93b61aa06..e2898912c90c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1064,7 +1064,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			if (np->repflow)
 				label = ip6_flowlabel(ipv6h);
 			priority = sk->sk_priority;
-			txhash = sk->sk_hash;
+			txhash = sk->sk_txhash;
 		}
 		if (sk->sk_state == TCP_TIME_WAIT) {
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
-- 
2.40.0

