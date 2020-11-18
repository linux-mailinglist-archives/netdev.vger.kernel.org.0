Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D182B8082
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKRPaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgKRPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:30:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605713410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFs5YuS+UQBHxuk28XB6kdJ0sgDe9yXGAPFUS7xIqxM=;
        b=aQyvWiHJHrTmsN9grtuRMHNwyJVJ0PIRnmHF/C904W5mJ/nzGYHSQq92eUQNC3/bqvde2r
        mYIZjXjAQV7erJRwcOGM0EVcfNU6g2+tcrMsy0SQ80vLDBIoSEy6BOBEaxaSNSEL0MZag1
        /lm7Ylu7kad/Y2FvR4fxnZMhymaWU/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-j6bb1zLsO_SuXdO9YyM51A-1; Wed, 18 Nov 2020 10:30:07 -0500
X-MC-Unique: j6bb1zLsO_SuXdO9YyM51A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76F01100C60C;
        Wed, 18 Nov 2020 15:30:05 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE0F260843;
        Wed, 18 Nov 2020 15:30:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C891232138454;
        Wed, 18 Nov 2020 16:30:00 +0100 (CET)
Subject: [PATCH bpf-next V6 7/7] selftests/bpf: use bpf_check_mtu in selftest
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
Date:   Wed, 18 Nov 2020 16:30:00 +0100
Message-ID: <160571340076.2801246.2011072453912206731.stgit@firesoul>
In-Reply-To: <160571331409.2801246.11527010115263068327.stgit@firesoul>
References: <160571331409.2801246.11527010115263068327.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This demonstrate how bpf_check_mtu() helper can easily be used together
with bpf_skb_adjust_room() helper, prior to doing size adjustment, as
delta argument is already setup.

Hint: This specific test can be selected like this:
 ./test_progs -t cls_redirect

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
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


