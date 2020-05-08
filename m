Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA31CA93E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgEHLLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:11:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37836 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727950AbgEHLLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p+Jphw3DnwwM+fOe+Li9w7kFQ7bJ7QrAXq7VUFx/ePI=;
        b=BjcyuZ1+hYdOhfZdUTkFcjJAIQutMjCjKBoC0+OaO2pZbl1sZS1Y8+iJQ7xBXgMRHBB+Yd
        GFC+492P+ULVTf0mAm7wWW69e0pGPuOCAyoknYVf9SwLp1eVtCsj4fVDbRWSbWvshbIaUr
        /H8RDjba5B1qZn/LqenviZRLZTJnMrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-tVAmR5r3NFiuziBHcJ3zOQ-1; Fri, 08 May 2020 07:11:16 -0400
X-MC-Unique: tVAmR5r3NFiuziBHcJ3zOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D72C71895A36;
        Fri,  8 May 2020 11:11:14 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 833206C760;
        Fri,  8 May 2020 11:11:14 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 78E5A300020FB;
        Fri,  8 May 2020 13:11:13 +0200 (CEST)
Subject: [PATCH net-next v3 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 May 2020 13:11:13 +0200
Message-ID: <158893627340.2321140.3928694981179575420.stgit@firesoul>
In-Reply-To: <158893607924.2321140.16117992313983615627.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally, after all drivers have a frame size, allow BPF-helper
bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.

Remember that helper/macro xdp_data_hard_end have reserved some
tailroom.  Thus, this helper makes sure that the BPF-prog don't have
access to this tailroom area.

V2: Remove one chicken check and use WARN_ONCE for other

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/uapi/linux/bpf.h |    4 ++--
 net/core/filter.c        |   11 +++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 101b0c8a3784..3e44853388d8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2004,8 +2004,8 @@ union bpf_attr {
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
index dfaf5df13722..ec3ab2e2d800 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3411,12 +3411,19 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
+	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
 	void *data_end = xdp->data_end + offset;
 
-	/* only shrinking is allowed for now. */
-	if (unlikely(offset >= 0))
+	/* Notice that xdp_data_hard_end have reserved some tailroom */
+	if (unlikely(data_end > data_hard_end))
 		return -EINVAL;
 
+	/* ALL drivers MUST init xdp->frame_sz, chicken check below */
+	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
+		WARN_ONCE(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
+		return -EINVAL;
+	}
+
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 


