Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017CB25D50D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgIDJan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:30:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728099AbgIDJal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:30:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-R-LpmBUaOPWhtLJBzQNE5w-1; Fri, 04 Sep 2020 05:30:36 -0400
X-MC-Unique: R-LpmBUaOPWhtLJBzQNE5w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2BF86408E;
        Fri,  4 Sep 2020 09:30:35 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8F6574E33;
        Fri,  4 Sep 2020 09:30:29 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 895DC30736C8B;
        Fri,  4 Sep 2020 11:30:28 +0200 (CEST)
Subject: [PATCH bpf-next] bpf: don't check against device MTU in
 __bpf_skb_max_len
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Date:   Fri, 04 Sep 2020 11:30:28 +0200
Message-ID: <159921182827.1260200.9699352760916903781.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
__bpf_skb_max_len() as the max-length. This function limit size against the
current net_device MTU (skb->dev->mtu).

Often packets gets redirected to another net_device, that can have a larger
MTU, and this is the MTU that should count. The MTU limiting at this stage
seems wrong and redundant as the netstack will handle MTU checking
elsewhere.

Redirecting into sockmap by sk_skb programs already skip this MTU check.
Keep what commit 0c6bc6e531a6 ("bpf: fix sk_skb programs without skb->dev
assigned") did, and limit the max_len to SKB_MAX_ALLOC.

Also notice that the max_len MTU check is already skipped for GRO SKBs
(skb_is_gso), in both bpf_skb_adjust_room() and bpf_skb_change_head().
Thus, it is clearly safe to remove this check.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 47eef9a0be6a..ec0ed107fa37 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3211,8 +3211,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	return SKB_MAX_ALLOC;
 }
 
 BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,


