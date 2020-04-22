Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69F61B49DE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgDVQKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:10:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727105AbgDVQKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qlbd1QnsPBozydFAto0pQ72jDM2eqweXKJ2kIyHoey0=;
        b=MnxB9GBTwHiNZ8wTRn/HUrXSvozW/Kp+aNMEADQjnE049P/JlD8tRfx4qNF754XgbEMg3g
        nR6B9aXp0jpSrmGc+n64q4kbvxp4pdYVQnC1oQEtaBBXsYlBD3/uQjbeJ3Zv5LZwiHCzXX
        /RPUKqAMdz+eClWZ15pEaxf5mwqBrM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-EobKSGMBP4uIZdWaJNJnEQ-1; Wed, 22 Apr 2020 12:09:57 -0400
X-MC-Unique: EobKSGMBP4uIZdWaJNJnEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 395201005510;
        Wed, 22 Apr 2020 16:09:55 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA4565F40;
        Wed, 22 Apr 2020 16:09:49 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 752E830000272;
        Wed, 22 Apr 2020 18:09:48 +0200 (CEST)
Subject: [PATCH net-next 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Wed, 22 Apr 2020 18:09:48 +0200
Message-ID: <158757178840.1370371.13037637865133257416.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally, after all drivers have a frame size, allow BPF-helper
bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.

Remember that helper/macro xdp_data_hard_end have reserved some
tailroom.  Thus, this helper makes sure that the BPF-prog don't have
access to this tailroom area.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |    4 ++--
 net/core/filter.c        |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..0e5abe991ca3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1969,8 +1969,8 @@ union bpf_attr {
  * int bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust (move) *xdp_md*\ **->data_end** by *delta* bytes. It is
- * 		only possible to shrink the packet as of this writing,
- * 		therefore *delta* must be a negative integer.
+ * 		possible to both shrink and grow the packet tail.
+ * 		Shrink done via *delta* being a negative integer.
  *
  * 		A call to this helper is susceptible to change the underlying
  * 		packet buffer. Therefore, at load time, all checks on pointers
diff --git a/net/core/filter.c b/net/core/filter.c
index 7d6ceaa54d21..5e9c387f74eb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3422,12 +3422,23 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
+	void *data_hard_end = xdp_data_hard_end(xdp);
 	void *data_end = xdp->data_end + offset;
 
-	/* only shrinking is allowed for now. */
-	if (unlikely(offset >= 0))
+	/* Notice that xdp_data_hard_end have reserved some tailroom */
+	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
 
+	/* ALL drivers MUST init xdp->frame_sz, some chicken checks below */
+	if (unlikely(xdp->frame_sz < (xdp->data_end - xdp->data_hard_start))) {
+		WARN(1, "Too small xdp->frame_sz = %d\n", xdp->frame_sz);
+		return -EINVAL;
+	}
+	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
+		WARN(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
+		return -EINVAL;
+	}
+
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 


