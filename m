Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6114A31EA96
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhBRNuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:50:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhBRLvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 06:51:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613649005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmN/qpG61dQl7Mib2fiEBIcyQzt+ngYbJB93LFlBMfc=;
        b=QEMsNrJ8LX357XlfdOVmxMKsET00stklH6A+TJC/xLnbPKntQTtRrbD2gE4ugO38KoVnF6
        nKTGrJZ3N3tcwRSFKRVUV5+I8TZb7AtnH/t5TLmVH2LbvtNrwfCV+LYyTudHVPSrMoEq4h
        6mUBS4OQ0subcknB7xLvpD6kpeajnto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-uF0WZWXuO-i7MUYi1XAMhA-1; Thu, 18 Feb 2021 06:50:04 -0500
X-MC-Unique: uF0WZWXuO-i7MUYi1XAMhA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03065100CC85;
        Thu, 18 Feb 2021 11:50:03 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A76C72BFE9;
        Thu, 18 Feb 2021 11:49:59 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 99E2F30736C73;
        Thu, 18 Feb 2021 12:49:58 +0100 (CET)
Subject: [PATCH bpf-next V2 1/2] bpf: BPF-helper for MTU checking add length
 input
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Feb 2021 12:49:58 +0100
Message-ID: <161364899856.1250213.17435782167100828617.stgit@firesoul>
In-Reply-To: <161364896576.1250213.8059418482723660876.stgit@firesoul>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIB lookup example[1] show how the IP-header field tot_len
(iph->tot_len) is used as input to perform the MTU check.

This patch extend the BPF-helper bpf_check_mtu() with the same ability
to provide the length as user parameter input, via mtu_len parameter.

[1] samples/bpf/xdp_fwd_kern.c

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/uapi/linux/bpf.h |   17 +++++++++++------
 net/core/filter.c        |   12 ++++++++++--
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4c24daa43bac..4ba4ef0ff63a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3850,8 +3850,7 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-
- *		Check ctx packet size against exceeding MTU of net device (based
+ *		Check packet size against exceeding MTU of net device (based
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
  *
@@ -3868,6 +3867,14 @@ union bpf_attr {
  *		against the current net device.  This is practical if this isn't
  *		used prior to redirect.
  *
+ *		On input *mtu_len* must be a valid pointer, else verifier will
+ *		reject BPF program.  If the value *mtu_len* is initialized to
+ *		zero then the ctx packet size is use.  When value *mtu_len* is
+ *		provided as input this specify the L3 length that the MTU check
+ *		is done against. Remember XDP and TC length operate at L2, but
+ *		this value is L3 as this correlate to MTU and IP-header tot_len
+ *		values which are L3 (similar behavior as bpf_fib_lookup).
+ *
  *		The Linux kernel route table can configure MTUs on a more
  *		specific per route level, which is not provided by this helper.
  *		For route level MTU checks use the **bpf_fib_lookup**\ ()
@@ -3892,11 +3899,9 @@ union bpf_attr {
  *
  *		On return *mtu_len* pointer contains the MTU value of the net
  *		device.  Remember the net device configured MTU is the L3 size,
- *		which is returned here and XDP and TX length operate at L2.
+ *		which is returned here and XDP and TC length operate at L2.
  *		Helper take this into account for you, but remember when using
- *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
- *		pointer and be initialized (to zero), else verifier will reject
- *		BPF program.
+ *		MTU value in your BPF-code.
  *
  *	Return
  *		* 0 on success, and populate MTU value in *mtu_len* pointer.
diff --git a/net/core/filter.c b/net/core/filter.c
index 7059cf604d94..fcc3bda85960 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5660,7 +5660,7 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
 		return -EINVAL;
 
-	if (unlikely(flags & BPF_MTU_CHK_SEGS && len_diff))
+	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len)))
 		return -EINVAL;
 
 	dev = __dev_via_ifindex(dev, ifindex);
@@ -5670,7 +5670,11 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 	mtu = READ_ONCE(dev->mtu);
 
 	dev_len = mtu + dev->hard_header_len;
-	skb_len = skb->len + len_diff; /* minus result pass check */
+
+	/* If set use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
+	skb_len = *mtu_len ? *mtu_len + dev->hard_header_len : skb->len;
+
+	skb_len += len_diff; /* minus result pass check */
 	if (skb_len <= dev_len) {
 		ret = BPF_MTU_CHK_RET_SUCCESS;
 		goto out;
@@ -5715,6 +5719,10 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	/* Add L2-header as dev MTU is L3 size */
 	dev_len = mtu + dev->hard_header_len;
 
+	/* Use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
+	if (*mtu_len)
+		xdp_len = *mtu_len + dev->hard_header_len;
+
 	xdp_len += len_diff; /* minus result pass check */
 	if (xdp_len > dev_len)
 		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;


