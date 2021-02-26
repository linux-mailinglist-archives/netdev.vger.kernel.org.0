Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA5326961
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhBZVXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:23:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:55310 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhBZVXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:23:47 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFkZh-0008lF-1Q; Fri, 26 Feb 2021 22:23:01 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [PATCH net] net: Fix gro aggregation for udp encaps with zero csum
Date:   Fri, 26 Feb 2021 22:22:48 +0100
Message-Id: <20210226212248.8300-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We noticed a GRO issue for UDP-based encaps such as vxlan/geneve when the
csum for the UDP header itself is 0. In that case, GRO aggregation does
not take place on the phys dev, but instead is deferred to the vxlan/geneve
driver (see trace below).

The reason is essentially that GRO aggregation bails out in udp_gro_receive()
for such case when drivers marked the skb with CHECKSUM_UNNECESSARY (ice, i40e,
others) where for non-zero csums 2abb7cdc0dc8 ("udp: Add support for doing
checksum unnecessary conversion") promotes those skbs to CHECKSUM_COMPLETE
and napi context has csum_valid set. This is however not the case for zero
UDP csum (here: csum_cnt is still 0 and csum_valid continues to be false).

At the same time 57c67ff4bd92 ("udp: additional GRO support") added matches
on !uh->check ^ !uh2->check as part to determine candidates for aggregation,
so it certainly is expected to handle zero csums in udp_gro_receive(). The
purpose of the check added via 662880f44203 ("net: Allow GRO to use and set
levels of checksum unnecessary") seems to catch bad csum and stop aggregation
right away.

One way to fix aggregation in the zero case is to only perform the !csum_valid
check in udp_gro_receive() if uh->check is infact non-zero.

Before:

  [...]
  swapper     0 [008]   731.946506: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100400 len=1500   (1)
  swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100200 len=1500
  swapper     0 [008]   731.946507: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101100 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101700 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101b00 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100600 len=1500
  swapper     0 [008]   731.946508: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100f00 len=1500
  swapper     0 [008]   731.946509: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100a00 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100500 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100700 len=1500
  swapper     0 [008]   731.946516: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101d00 len=1500   (2)
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101000 len=1500
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101c00 len=1500
  swapper     0 [008]   731.946517: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101400 len=1500
  swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100e00 len=1500
  swapper     0 [008]   731.946518: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497101600 len=1500
  swapper     0 [008]   731.946521: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff966497100800 len=774
  swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497100400 len=14032 (1)
  swapper     0 [008]   731.946530: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff966497101d00 len=9112  (2)
  [...]

  # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
  MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
  Recv   Send    Send
  Socket Socket  Message  Elapsed
  Size   Size    Size     Time     Throughput
  bytes  bytes   bytes    secs.    10^6bits/sec

   87380  16384  16384    20.01    13129.24

After:

  [...]
  swapper     0 [026]   521.862641: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479000 len=11286 (1)
  swapper     0 [026]   521.862643: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479000 len=11236 (1)
  swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d478500 len=2898  (2)
  swapper     0 [026]   521.862650: net:netif_receive_skb: dev=enp10s0f0  skbaddr=0xffff93ab0d479f00 len=8490  (3)
  swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d478500 len=2848  (2)
  swapper     0 [026]   521.862653: net:netif_receive_skb: dev=test_vxlan skbaddr=0xffff93ab0d479f00 len=8440  (3)
  [...]

  # netperf -H 10.55.10.4 -t TCP_STREAM -l 20
  MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.55.10.4 () port 0 AF_INET : demo
  Recv   Send    Send
  Socket Socket  Message  Elapsed
  Size   Size    Size     Time     Throughput
  bytes  bytes   bytes    secs.    10^6bits/sec

   87380  16384  16384    20.01    24576.53

Fixes: 57c67ff4bd92 ("udp: additional GRO support")
Fixes: 662880f44203 ("net: Allow GRO to use and set levels of checksum unnecessary")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tom Herbert <tom@herbertland.com>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..a7f714c4b068 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -466,7 +466,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	}
 
 	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
-	    (skb->ip_summed != CHECKSUM_PARTIAL &&
+	    (uh->check && skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
 	     !NAPI_GRO_CB(skb)->csum_valid) ||
 	    !udp_sk(sk)->gro_receive)
-- 
2.27.0

