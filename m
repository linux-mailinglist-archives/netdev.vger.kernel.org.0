Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD156F8FAB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfKLMaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:30:08 -0500
Received: from fd.dlink.ru ([178.170.168.18]:50542 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfKLMaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 07:30:07 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id E0DDC1B2040B; Tue, 12 Nov 2019 15:30:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E0DDC1B2040B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1573561802; bh=y+poxO2Ldk6JRTijn6d4ySFca2Q5uu2iel3YyP+n0u4=;
        h=From:To:Cc:Subject:Date;
        b=fMX9kSxsirhfC5mud2Vt6+rqynMkHeHMmXMb+34I3dVkNKNIpkzQdL6jlgV2eyc/x
         zNp7kC44ndULICgJtgaSO0DYAB46RbuUMOe1BgvL0DwTEfidYroGpRRDrxKxvqMjmr
         TyvlgOI4621cRDRGJf3O84KKHzUZsOj+6rGv3kw4=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id A7EF21B2031C;
        Tue, 12 Nov 2019 15:29:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru A7EF21B2031C
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 6B2B41B2265B;
        Tue, 12 Nov 2019 15:29:51 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Tue, 12 Nov 2019 15:29:51 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alexander Lobakin <alobakin@dlink.ru>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: core: allow fast GRO for skbs with Ethernet header in head
Date:   Tue, 12 Nov 2019 15:28:43 +0300
Message-Id: <20191112122843.30636-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 78d3fd0b7de8 ("gro: Only use skb_gro_header for completely
non-linear packets") back in May'09 (2.6.31-rc1) has changed the
original condition '!skb_headlen(skb)' to the current
'skb_mac_header(skb) == skb_tail_pointer(skb)' in gro_reset_offset()
saying: "Since the drivers that need this optimisation all provide
completely non-linear packets".

For now, we have the following rough statistics for 5.4-rc7:
1) napi_gro_frags: 14
2) napi_gro_receive with skb->head containing (most of) payload: 83
3) napi_gro_receive with skb->head containing all the headers: 20
4) napi_gro_receive with skb->head containing only Ethernet header: 2

With the current condition, fast GRO with the usage of
NAPI_GRO_CB(skb)->frag0 is available only in the [1] case.
Packets pushed by [2] and [3] go through the 'slow' path, but
it's not a problem for them as they already contains all the needed
headers in skb->head, so pskb_may_pull() only moves skb->data.

The layout of skbs in the fourth [4] case at the moment of
dev_gro_receive() is identical to skbs that have come through [1],
as napi_frags_skb() pulls Ethernet header to skb->head. The only
difference is that the mentioned condition is always false for them,
because skb_put() and friends irreversibly alter the tail pointer.
They also go though the 'slow' path, but now every single
pskb_may_pull() in every single .gro_receive() will call the *really*
slow __pskb_pull_tail() to pull headers to head. This significantly
decreases the overall performance for no visible reasons.

The only two users of method [4] is:
* drivers/staging/qlge
* drivers/net/wireless/iwlwifi (all three variants: dvm, mvm, mvm-mq)

Note that in case with wireless drivers we can't use [1]
(napi_gro_frags()) at least for now and mac80211 stack always
performs pushes and pulls anyways, so performance hit is inavoidable.

We can simply change the condition in gro_reset_offset() to allow
skbs from [4] go through 'fast' path just like in case [1].

This was tested on a custom driver and this patch gave boosts up to
40 Mbps to method [4] in both directions comparing to net-next, which
made overall performance relatively close to [1] (without it, [4] is
the slowest).

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/core/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1c799d486623..da78a433c10c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5611,8 +5611,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->frag0 = NULL;
 	NAPI_GRO_CB(skb)->frag0_len = 0;
 
-	if (skb_mac_header(skb) == skb_tail_pointer(skb) &&
-	    pinfo->nr_frags &&
+	if (!skb_headlen(skb) && pinfo->nr_frags &&
 	    !PageHighMem(skb_frag_page(frag0))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
-- 
2.24.0

