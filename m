Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE027F200
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgI3S5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:57:51 -0400
Received: from static-71-183-126-102.nycmny.fios.verizon.net ([71.183.126.102]:37756
        "EHLO chicken.badula.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730723AbgI3S5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:57:50 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 14:57:50 EDT
Received: from moisil.badula.org (pool-71-187-225-100.nwrknj.fios.verizon.net [71.187.225.100])
        (authenticated bits=0)
        by chicken.badula.org (8.14.4/8.14.4) with ESMTP id 08UInfuK019696
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 30 Sep 2020 14:49:41 -0400
Subject: Network packet reordering with the 5.4 stable tree
References: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
To:     stable@vger.kernel.org, netdev@vger.kernel.org
From:   Ion Badulescu <ionut@badula.org>
X-Forwarded-Message-Id: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
Message-ID: <b11a3198-2d78-c90a-9586-f4752ae4fe6a@badula.org>
Date:   Wed, 30 Sep 2020 14:49:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
Content-Type: multipart/mixed;
 boundary="------------CC0861635165DEE286A4CA0C"
Content-Language: en-US
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on chicken.badula.org
X-Spam-Level: 
X-Spam-Language: en
X-Spam-Status: No, score=0.078 required=5 tests=AWL=0.595,BAYES_00=-1.9,KHOP_HELO_FCRDNS=0.399,RDNS_DYNAMIC=0.982,SPF_FAIL=0.001,URIBL_BLOCKED=0.001
X-Scanned-By: MIMEDefang 2.84
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CC0861635165DEE286A4CA0C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

[As suggested by Greg K-H, I'm reposting this to both stable and netdev. 
I'm also including a backported patch for the 5.4-stable tree, which is 
now confirmed to be working and fixing the packet reordering issue I was 
seeing.]

Hello,

I ran into some packet reordering using a plain vanilla 5.4.49 kernel 
and the Amazon AWS ena driver. The external symptom was that every now 
and again, one or more larger packets would be delivered to the UDP 
socket after some smaller packets, even though the smaller packets were 
sent after the larger packets. They were also delivered late to a packet 
socket sniffer, which initially made me suspect an RSS bug in the ena 
hardware. Eventually, I modified the ena driver to stamp each packet (by 
overwriting its ethernet source mac field) with the id of the RSS queue 
that delivered it, and with the value of a per-RSS-queue counter that 
incremented for each packet received in that queue. That hack showed RSS 
functioning properly, and also showed packets received earlier (with a 
smaller counter value) being delivered after packets with a larger 
counter value. It established that the reordering was in fact happening 
inside the kernel network core.

The breakthrough came from realizing that the ena driver defaults its 
rx_copybreak to 256, which matched perfectly the boundary between the 
delayed large packets and the smaller packets being delivered first. 
After changing ena's rx_copybreak to zero, the reordering issue disappeared.

After a lot of hair pulling, I think I figured out what the issue is -- 
and it's confined to the 5.4 stable tree. Commit 323ebb61e32b4 (present 
in 5.4) introduced queueing for GRO_NORMAL packets received via 
napi_gro_frags() -> napi_frags_finish(). Commit 6570bc79c0df (NOT 
present in 5.4) extended the same GRO_NORMAL queueing to packets 
received via napi_gro_receive() -> napi_skb_finish(). Without 
6570bc79c0df, packets received via napi_gro_receive() can get delivered 
ahead of the earlier, queued up packets received via napi_gro_frags(). 
And this is precisely what happens in the ena driver with packets 
smaller than rx_copybreak vs packets larger than rx_copybreak.

Interestingly, the 5.4 stable tree does contain a backport of the 
upstream c80794323e commit, which to fixes packet reordering issues 
introduced by 323ebb61e32b4 and 6570bc79c0df. But 6570bc79c0df itself is 
missing, which creates another avenue for packet reordering.

The patch I'm attaching is a backport of 6570bc79c0df to the 5.4 stable 
tree. It is confirmed to completely eliminate the packet reordering 
previously seen with the ena driver and rx_copybreak=256.

Thanks,
-Ion

--------------CC0861635165DEE286A4CA0C
Content-Type: text/x-patch;
 name="pkt-reord-fix-5.4.x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pkt-reord-fix-5.4.x.diff"

commit f54898541d50bb3b47085a6decbffcd06b0f72a6
Author: Alexander Lobakin <alobakin@dlink.ru>
Date:   Mon Oct 14 11:00:33 2019 +0300

    net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
    
    [ Upstream commit 6570bc79c0dfff0f228b7afd2de720fb4e84d61d ]
    
    Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
    skbs") made use of listified skb processing for the users of
    napi_gro_frags().
    The same technique can be used in a way more common napi_gro_receive()
    to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
    including gro_cells and mac80211 users.
    This slightly changes the return value in cases where skb is being
    dropped by the core stack, but it seems to have no impact on related
    drivers' functionality.
    gro_normal_batch is left untouched as it's very individual for every
    single system configuration and might be tuned in manual order to
    achieve an optimal performance.
    
    5.4-stable note: This patch is required to avoid packet reordering when
    both napi_gro_receive() and napi_gro_frags() are used. The specific case
    used to debug this involved the ena driver and its use of rx_copybreak
    to select between napi_gro_receive()/napi_gro_frags().
    
    Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
    Acked-by: Edward Cree <ecree@solarflare.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    [Ion: backported to v5.4]
    Signed-off-by: Ion Badulescu <ionut@badula.org>

diff --git a/net/core/dev.c b/net/core/dev.c
index ee5ef71..02973a4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5602,12 +5602,13 @@ static void napi_skb_free_stolen_head(struct sk_buff *skb)
 	kmem_cache_free(skbuff_head_cache, skb);
 }
 
-static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
+static gro_result_t napi_skb_finish(struct napi_struct *napi,
+				    struct sk_buff *skb,
+				    gro_result_t ret)
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		if (netif_receive_skb_internal(skb))
-			ret = GRO_DROP;
+		gro_normal_one(napi, skb);
 		break;
 
 	case GRO_DROP:
@@ -5639,7 +5640,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
 
 	skb_gro_reset_offset(skb);
 
-	ret = napi_skb_finish(dev_gro_receive(napi, skb), skb);
+	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 	trace_napi_gro_receive_exit(ret);
 
 	return ret;

--------------CC0861635165DEE286A4CA0C--
