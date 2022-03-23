Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE4E4E52EF
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbiCWNW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCWNW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:22:27 -0400
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 926C23FDA1;
        Wed, 23 Mar 2022 06:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=OnmOf
        UBdKQbwRlX1LWHo0ubJzFiPKwBtV/QjBVGq0nI=; b=hQ5acSUS4vaaav8E84Bjo
        hS8HNKbReVfH3Kv+SUXnqF9QNyEhE23KSedwffGie47O8/9Dmw+OdQWlbjVnryIm
        ShNWTsjO2UpKUSyGIBrMCwWuthlVpSahB2BdVfrNYXLSVJrM5m/GBw2yz+AkHOz4
        rJ4p2D0bkx+5WsC/1x4pRE=
Received: from [10.8.162.29] (unknown [36.111.140.141])
        by smtp12 (Coremail) with SMTP id EMCowACXTxn4Gjtity+UAg--.41S2;
        Wed, 23 Mar 2022 21:04:57 +0800 (CST)
Message-ID: <3eb95fd0-2046-c000-9c0b-c7c7e05ce04a@163.com>
Date:   Wed, 23 Mar 2022 21:04:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH net-next] tcp: make tcp_rcv_state_process() drop monitor
 friendly
To:     dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        menglong8.dong@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowACXTxn4Gjtity+UAg--.41S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4fKw4UKrW8ZFW5Cr4fGrg_yoW8GrWDpa
        1DKr4DJr4kWFWUua43KFykXr1ag395Ary3GrWqvw13uw1DKr4fKFs5tr1ayrs8GF4vkw4a
        qFyIq3Z8WF1rurDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jniSdUUUUU=
X-Originating-IP: [36.111.140.141]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbB9xbMkF2MctVChAAAsN
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

In tcp_rcv_state_process(), should not call tcp_drop() for same case,
like after process ACK packet in TCP_LAST_ACK state, it should call
consume_skb() instead of tcp_drop() to be drop monitor friendly,
otherwise every last ack will be report as dropped packet by drop monitor.

Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/ipv4/tcp_input.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2088f93..feb6f83 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6574,7 +6574,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto discard;
+			consume_skb(skb);
+			return 0;
 		}
 		break;
 	}
@@ -6582,7 +6583,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			goto discard;
+			consume_skb(skb);
+			return 0;
 		}
 		break;

@@ -6590,7 +6592,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			goto discard;
+			consume_skb(skb);
+			return 0;
 		}
 		break;
 	}
-- 
1.8.3.1

