Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6641315094
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBINm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:42:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhBINkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:40:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612877921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPsXKq3MBc72TMyoHXE9bs0JaNOP8fvh/6LSsztDC8w=;
        b=hRKBub9QbGAHM+mv6jN/7Quumpd/4vNe1C3qnTvjQp9GTDGtEN98t6gO0BNTOrWN+zV0Vh
        jbV/2ySImimGpZuGhVJ4awwoNbRN5jyEXZNjytPI4vIihr7DVipOkDzcDlWD+plO0pfus7
        L5UrkH0S7H3NJDtjT7nDWQ7NJB2DKSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Iho-xMopO8GRQwdO8fuNbA-1; Tue, 09 Feb 2021 08:38:38 -0500
X-MC-Unique: Iho-xMopO8GRQwdO8fuNbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4087F83DCD2;
        Tue,  9 Feb 2021 13:38:36 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C58E460C4D;
        Tue,  9 Feb 2021 13:38:35 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D81BD30736C74;
        Tue,  9 Feb 2021 14:38:34 +0100 (CET)
Subject: [PATCH bpf-next V16 6/7] selftests/bpf: use bpf_check_mtu in selftest
 test_cls_redirect
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Tue, 09 Feb 2021 14:38:34 +0100
Message-ID: <161287791481.790810.4444271170546646080.stgit@firesoul>
In-Reply-To: <161287779408.790810.15631860742170694244.stgit@firesoul>
References: <161287779408.790810.15631860742170694244.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This demonstrate how bpf_check_mtu() helper can easily be used together
with bpf_skb_adjust_room() helper, prior to doing size adjustment, as
delta argument is already setup.

Hint: This specific test can be selected like this:
 ./test_progs -t cls_redirect

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_cls_redirect.c        |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
index c9f8464996ea..3c1e042962e6 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -70,6 +70,7 @@ typedef struct {
 	uint64_t errors_total_encap_adjust_failed;
 	uint64_t errors_total_encap_buffer_too_small;
 	uint64_t errors_total_redirect_loop;
+	uint64_t errors_total_encap_mtu_violate;
 } metrics_t;
 
 typedef enum {
@@ -407,6 +408,7 @@ static INLINING ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *e
 		payload_off - sizeof(struct ethhdr) - sizeof(struct iphdr);
 	int32_t delta = sizeof(struct gre_base_hdr) - encap_overhead;
 	uint16_t proto = ETH_P_IP;
+	uint32_t mtu_len = 0;
 
 	/* Loop protection: the inner packet's TTL is decremented as a safeguard
 	 * against any forwarding loop. As the only interesting field is the TTL
@@ -479,6 +481,11 @@ static INLINING ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *e
 		}
 	}
 
+	if (bpf_check_mtu(skb, skb->ifindex, &mtu_len, delta, 0)) {
+		metrics->errors_total_encap_mtu_violate++;
+		return TC_ACT_SHOT;
+	}
+
 	if (bpf_skb_adjust_room(skb, delta, BPF_ADJ_ROOM_NET,
 				BPF_F_ADJ_ROOM_FIXED_GSO |
 				BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||


