Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA4188C13
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCQRaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:53799 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgCQRaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xV8+EDBHRqVwSckpJwc2UUAHmVFdfl6/DmYv+cI16LU=;
        b=SxT2Quli8WXtzJLaiSDAkTUzYuWpQg2dX6S9cD0pXWQ8agFN3fxdlj1aDXkie5fNhAGvdA
        +gMWFAOCTz/B2ovGkCabhRp0Xom2MVepJBc6CcOZssdt/UKPI+wEuFXjLfPEB7zMauNK73
        0kabbhpwJZgVmyt80Olhtkn7+0VkWug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-aJbI5kJGPAyYKPulzcYGpA-1; Tue, 17 Mar 2020 13:30:04 -0400
X-MC-Unique: aJbI5kJGPAyYKPulzcYGpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3365A899F6;
        Tue, 17 Mar 2020 17:29:49 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2721001DC0;
        Tue, 17 Mar 2020 17:29:49 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6521730721A66;
        Tue, 17 Mar 2020 18:29:48 +0100 (CET)
Subject: [PATCH RFC v1 08/15] xdp: allow bpf_xdp_adjust_tail() to grow packet
 size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:48 +0100
Message-ID: <158446618833.702578.690455723873770827.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FIXME: This patch MUST be LAST after all drivers have been updated!!!

Finally, after all drivers have a frame size, allow BPF-helper
bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.

Remember that helper/macro xdp_data_hard_end have reserved some
tailroom.  Thus, this helper makes sure that the BPF-prog don't have
access to this tailroom area.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |    4 ++--
 net/core/filter.c        |   18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 14dc4f9fb3c8..1fa6ab616ec3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1942,8 +1942,8 @@ union bpf_attr {
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
index 4a08c9fb2be7..0ceddee0c678 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3409,12 +3409,26 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
+	void *data_hard_end = xdp_data_hard_end(xdp);
 	void *data_end = xdp->data_end + offset;
 
-	/* only shrinking is allowed for now. */
-	if (unlikely(offset >= 0))
+	/* Notice that xdp_data_hard_end have reserved some tailroom */
+	if (unlikely(data_end >= data_hard_end))
 		return -EINVAL;
 
+	/* DANGER: ALL drivers MUST be converted to init xdp->frame_sz
+	 * - Adding some chicken checks below
+	 * - Will (likely) not be for upstream
+	 */
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
 


