Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF8284F5E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJFQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgJFQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602000179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znkGMQbCqPPIKuCPzeEbbRwLIioe5osJVYMyGwLpydA=;
        b=WPF8EZ47GKZN99tTedxELkzlok763hpC0SUkKat6UQKqORb26bMfVK3cOAesOsD+UxYgYS
        LT3zQPdjxysKPglgrFAWUsNQ0Up3NgUsImtyeV3I5n+CcVbkWgkDNxCrMQNylLBJzE2ZbW
        5dcBVc5Oejjkx5ZmVkWfnAy9XQslfnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-gFVjBbV2OZqmKB3n7JSCTg-1; Tue, 06 Oct 2020 12:02:55 -0400
X-MC-Unique: gFVjBbV2OZqmKB3n7JSCTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9C49ADC20;
        Tue,  6 Oct 2020 16:02:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CFC973676;
        Tue,  6 Oct 2020 16:02:52 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 84D0B30736C93;
        Tue,  6 Oct 2020 18:02:51 +0200 (CEST)
Subject: [PATCH bpf-next V1 1/6] bpf: Remove MTU check in __bpf_skb_max_len
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 06 Oct 2020 18:02:51 +0200
Message-ID: <160200017146.719143.8604341963140667595.stgit@firesoul>
In-Reply-To: <160200013701.719143.12665708317930272219.stgit@firesoul>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
__bpf_skb_max_len() as the max-length. This function limit size against
the current net_device MTU (skb->dev->mtu).

When a BPF-prog grow the packet size, then it should not be limited to the
MTU. The MTU is a transmit limitation, and software receiving this packet
should be allowed to increase the size. Further more, current MTU check in
__bpf_skb_max_len uses the MTU from ingress/current net_device, which in
case of redirects uses the wrong net_device.

Keep a sanity max limit of IP_MAX_MTU which is 64KiB.

In later patches we will enforce the MTU limitation when transmitting
packets.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
(imported from commit 37f8552786cf46588af52b77829b730dd14524d3)
---
 net/core/filter.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 05df73780dd3..fed239e77bdc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3476,8 +3476,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	return IP_MAX_MTU;
 }
 
 BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,


