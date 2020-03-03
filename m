Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C69C177573
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 12:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgCCLrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 06:47:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728997AbgCCLrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 06:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583236028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PVd9uRgwe7r6+HDpr5fBcN5arlnsAdAGdb87yw0btPQ=;
        b=ZWYjsOz1F3vpZYI7BqxiL3ce4TTNVclNgnMx81xI6ZLdJ005egO2TOcdMsCM4XWzUHtyGg
        VsAr0yG1/Mnh5kweeqoituT253X5v8Y/39w4h4RAssi/TLquSsJ5ysmimmWGv6LiV3a8eP
        ahxwgHT1H33kkj9npZvRE0iPXR92KGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-daFeih9LNzOhHMLqMlY59A-1; Tue, 03 Mar 2020 06:47:04 -0500
X-MC-Unique: daFeih9LNzOhHMLqMlY59A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DB50107ACC4;
        Tue,  3 Mar 2020 11:47:02 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB53C5C1D6;
        Tue,  3 Mar 2020 11:46:59 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 12C9030737E05;
        Tue,  3 Mar 2020 12:46:58 +0100 (CET)
Subject: [bpf-next PATCH] xdp: accept that XDP headroom isn't always equal
 XDP_PACKET_HEADROOM
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, gamemann@gflclan.com,
        lrizzo@google.com, netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Date:   Tue, 03 Mar 2020 12:46:58 +0100
Message-ID: <158323601793.2048441.8715862429080864020.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel based drivers (ixgbe + i40e) have implemented XDP with
headroom 192 bytes and not the recommended 256 bytes defined by
XDP_PACKET_HEADROOM.  For generic-XDP, accept that this headroom
is also a valid size.

Still for generic-XDP if headroom is less, still expand headroom to
XDP_PACKET_HEADROOM as this is the default in most XDP drivers.

Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
- Before: 4,816,430 pps
- After : 7,749,678 pps
(Note that ixgbe in native mode XDP_DROP 14,704,539 pps)

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |    1 +
 net/core/dev.c           |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 906e9f2752db..14dc4f9fb3c8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3312,6 +3312,7 @@ struct bpf_xdp_sock {
 };
 
 #define XDP_PACKET_HEADROOM 256
+#define XDP_PACKET_HEADROOM_MIN 192
 
 /* User return codes for XDP prog type.
  * A valid XDP program must return one of these defined values. All other
diff --git a/net/core/dev.c b/net/core/dev.c
index 4770dde3448d..9c941cd38b13 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4518,11 +4518,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		return XDP_PASS;
 
 	/* XDP packets must be linear and must have sufficient headroom
-	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
+	 * of XDP_PACKET_HEADROOM_MIN bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
 	 */
 	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
-	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
+	    skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
 


