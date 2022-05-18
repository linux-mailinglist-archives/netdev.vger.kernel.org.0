Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC8252BA1C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbiERM1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbiERM10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9503FD35E;
        Wed, 18 May 2022 05:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 316F5615FE;
        Wed, 18 May 2022 12:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA0FC36AE3;
        Wed, 18 May 2022 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876843;
        bh=kxOZ5QqWCnpmv5KQaoJ4TOsadG16Vztf+q4rTiMkJ3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Umit11Mac3n7EFrWi5vz93Vy/DmAFIE5ZX28dqxdFCNvpjmxYi3gtyh6q+ZMFG3Hy
         WHVb6G1689lubJcoCxpjyvC1YyBfvtv2doUxNJw85CgqF+06CQm/dzDzsNgzYdn9QZ
         6DOqopQyvO0HwZAkCOUGfQ6cWa2gUQ7B/lw0BYpylWX914Iz4OVgUhthM6GdtbkWhP
         BrvsdpTg2xO5f446fEsxAGYSyoeRaSIEq1FvsK/qBz/NtaSz2XByyW4/3ZwWZJgZ8N
         PacclyS9foGpKN5di0JCbXuMBMhN0HvlzOXHejsqq9FrE9pipf5pZ24faJVkjBetgY
         CaeMm1ZRSq4Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ilias.apalodimas@linaro.org, vasily.averin@linux.dev,
        luiz.von.dentz@intel.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 14/23] net: fix wrong network header length
Date:   Wed, 18 May 2022 08:26:27 -0400
Message-Id: <20220518122641.342120-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lina Wang <lina.wang@mediatek.com>

[ Upstream commit cf3ab8d4a797960b4be20565abb3bcd227b18a68 ]

When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is enable,
several skbs are gathered in skb_shinfo(skb)->frag_list. The first skb's
ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
network_header\transport_header\mac_header have been updated as ipv4 acts,
but other skbs in frag_list didnot update anything, just ipv6 packets.

udp_queue_rcv_skb will call skb_segment_list to traverse other skbs in
frag_list and make sure right udp payload is delivered to user space.
Unfortunately, other skbs in frag_list who are still ipv6 packets are
updated like the first skb and will have wrong transport header length.

e.g.before bpf_skb_proto_6_to_4,the first skb and other skbs in frag_list
has the same network_header(24)& transport_header(64), after
bpf_skb_proto_6_to_4, ipv6 protocol has been changed to ipv4, the first
skb's network_header is 44,transport_header is 64, other skbs in frag_list
didnot change.After skb_segment_list, the other skbs in frag_list has
different network_header(24) and transport_header(44), so there will be 20
bytes different from original,that is difference between ipv6 header and
ipv4 header. Just change transport_header to be the same with original.

Actually, there are two solutions to fix it, one is traversing all skbs
and changing every skb header in bpf_skb_proto_6_to_4, the other is
modifying frag_list skb's header in skb_segment_list. Considering
efficiency, adopt the second one--- when the first skb and other skbs in
frag_list has different network_header length, restore them to make sure
right udp payload is delivered to user space.

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 180fa6a26ad4..708cc9b1b176 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3896,7 +3896,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 	unsigned int delta_len = 0;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *nskb, *tmp;
-	int err;
+	int len_diff, err;
 
 	skb_push(skb, -skb_network_offset(skb) + offset);
 
@@ -3936,9 +3936,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
 		skb_release_head_state(nskb);
+		len_diff = skb_network_header_len(nskb) - skb_network_header_len(skb);
 		__copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
+		nskb->transport_header += len_diff;
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
-- 
2.35.1

