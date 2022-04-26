Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E281350FA69
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiDZK36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349313AbiDZK3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:29:46 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id B0692387A5
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:04:58 -0700 (PDT)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id SiJltADnaaqbw2diZMQAAA--.110S2;
        Tue, 26 Apr 2022 18:04:12 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net] tcp: fix F-RTO may not work correctly when receiving DSACK
Date:   Tue, 26 Apr 2022 18:03:39 +0800
Message-Id: <1650967419-2150-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: SiJltADnaaqbw2diZMQAAA--.110S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4kur1rtw43AF4rAw43Wrg_yoW8tr13pa
        1Fyryftrs5ury8Xa47XFy8W3yxWwsrC3Wfu34YkrW3KFn0gw1fZFWrtFW5CF1j9rW7KFWY
        yFyjq3yYqa98AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Yb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j6r4UM28EF7xvwVC2
        z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r1j6r4UM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxVW8
        JVWxJwAv7VCjz48v1sIEY20_Gr4lYx0Ec7CjxVAajcxG14v26r4UJVWxJr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVAFwVW8twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFV
        Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
        x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
        1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
        JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
        nIWIevJa73UjIFyTuYvjxUqxu4DUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSACK is regarded as a dupack, which may cause
F-RTO to incorrectly enter "loss was real" when receiving
DSACK.

Packetdrill to demonstrate:

// Enable F-RTO and TLP
    0 `sysctl -q net.ipv4.tcp_frto=2`
    0 `sysctl -q net.ipv4.tcp_early_retrans=3`
    0 `sysctl -q net.ipv4.tcp_congestion_control=cubic`

// Establish a connection
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

// RTT 10ms, RTO 210ms
  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
 +.01 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 2 data segments
   +0 write(4, ..., 2000) = 2000
   +0 > P. 1:2001(2000) ack 1

// TLP
+.022 > P. 1001:2001(1000) ack 1

// Continue to send 8 data segments
   +0 write(4, ..., 10000) = 10000
   +0 > P. 2001:10001(8000) ack 1

// RTO
+.188 > . 1:1001(1000) ack 1

// The original data is acked and new data is sent(F-RTO step 2.b)
   +0 < . 1:1(0) ack 2001 win 257
   +0 > P. 10001:12001(2000) ack 1

// D-SACK caused by TLP is regarded as a dupack, this results in
// the incorrect judgment of "loss was real"(F-RTO step 3.a)
+.022 < . 1:1(0) ack 2001 win 257 <sack 1001:2001,nop,nop>

// Never-retransmitted data(3001:4001) are acked and
// expect to switch to open state(F-RTO step 3.b)
   +0 < . 1:1(0) ack 4001 win 257
+0 %{ assert tcpi_ca_state == 0, tcpi_ca_state }%

Fixes: e33099f96d99 ("tcp: implement RFC5682 F-RTO")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1595b76..c54accc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3867,7 +3867,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_process_tlp_ack(sk, ack, flag);
 
 	if (tcp_ack_is_dubious(sk, flag)) {
-		if (!(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP))) {
+		if (!(flag & (FLAG_SND_UNA_ADVANCED |
+			      FLAG_NOT_DUP | FLAG_DSACKING_ACK))) {
 			num_dupack = 1;
 			/* Consider if pure acks were aggregated in tcp_add_backlog() */
 			if (!(flag & FLAG_DATA))
-- 
1.8.3.1

