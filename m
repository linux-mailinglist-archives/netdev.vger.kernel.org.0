Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9552B6B18FD
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCICEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCICEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:04:46 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61B4892F38
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 18:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject:
        Content-Type; bh=6yq4hURNfyZBbYcyn7SO0/aipKpw/Paasop2Oo7qa6c=;
        b=JGvaWyGSf7uASVHTMFPGRtnqwZVw/8W6Bwg0UHdpHOlm2a7BDQcwJ+4ooByV+e
        K6J0nWsZU++0ChnPitmD1AEXixLwCoeyf7rH78YBj7meJHYXcngQ2kM+sxHlzyAT
        +soNXkc2WPe+QltPuMMkpkefFzDHJ8AGfHFKQc3BlPFbQ=
Received: from [172.22.5.12] (unknown [27.148.194.72])
        by zwqz-smtp-mta-g4-1 (Coremail) with SMTP id _____wCHzR14PglkcHySCg--.60328S2;
        Thu, 09 Mar 2023 10:03:36 +0800 (CST)
Message-ID: <29865b1f-6db7-c07a-de89-949d3721ea30@163.com>
Date:   Thu, 9 Mar 2023 10:03:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     netdev <netdev@vger.kernel.org>
Cc:     "edumazet@google.com >> Eric Dumazet" <edumazet@google.com>,
        davem@davemloft.net, daniel@iogearbox.net,
        Florian Westphal <fw@strlen.de>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH net-next] ipvlan: Make skb->skb_iif track skb->dev for l3s
 mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: _____wCHzR14PglkcHySCg--.60328S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw1UWF4UWr43Jr48AryUGFg_yoW8Gry5pr
        47GFy5Kr4DX3W8Aa409a18XFyYg3WDKrySkFWvk34q93s8tFy8urW0yFZxAF4UtrZYva1Y
        vF1avw4UWwn8CwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6v35UUUUU=
X-Originating-IP: [27.148.194.72]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbB6AItkGBHLz29vwAAsg
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

For l3s mode, skb->dev is set to ipvlan interface in ipvlan_nf_input():
  skb->dev = addr->master->dev
but, skb->skb_iif remain unchanged, this will cause socket lookup failed
if a target socket is bound to a interface, like the following example:

  ip link add ipvlan0 link eth0 type ipvlan mode l3s
  ip addr add dev ipvlan0 192.168.124.111/24
  ip link set ipvlan0 up

  ping -c 1 -I ipvlan0 8.8.8.8
  100% packet loss

This is because there is no match sk in __raw_v4_lookup() as sk->sk_bound_dev_if != dif(skb->skb_iif).
Fix this by make skb->skb_iif track skb->dev in ipvlan_nf_input().

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes").

Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..71712ea25403 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;

 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
-- 
1.8.3.1

